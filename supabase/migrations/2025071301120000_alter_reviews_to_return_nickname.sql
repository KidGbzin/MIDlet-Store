drop function if exists get_top_3_reviews_for_game;

create or replace function get_top_3_reviews_for_game (p_game_key integer) returns table (
  key uuid,
  game_key int2,
  user_key uuid,
  nickname text,
  rating int2,
  comment text,
  updated_at timestamptz,
  score int,
  locale text,
  user_vote int
) language sql security invoker
set
  search_path = public as $$
select
  r.key,
  r.game_key,
  r.user_key,
  p.nickname,
  r.rating,
  r.comment,
  r.updated_at,
  r.score,
  r.locale,
  coalesce(rv.vote, 0) as user_vote
from reviews r
left join profiles p on p.user_key = r.user_key
left join review_votes rv on rv.review_key = r.key and rv.user_key = auth.uid()
where r.game_key = p_game_key
order by r.score desc, r.updated_at desc
limit 3;
$$;

drop function if exists get_reviews_for_game;

create or replace function get_reviews_for_game (p_game_key integer) returns table (
  key uuid,
  game_key int2,
  user_key uuid,
  nickname text,
  rating int2,
  comment text,
  updated_at timestamptz,
  score int,
  locale text,
  user_vote int
) language sql security invoker
set
  search_path = public as $$
select
  r.key,
  r.game_key,
  r.user_key,
  p.nickname,
  r.rating,
  r.comment,
  r.updated_at,
  r.score,
  r.locale,
  coalesce(rv.vote, 0) as user_vote
from reviews r
left join profiles p on p.user_key = r.user_key
left join review_votes rv on rv.review_key = r.key and rv.user_key = auth.uid()
where r.game_key = p_game_key
order by r.updated_at desc;
$$;

drop function if exists get_recent_reviews_limited;

create or replace function get_recent_reviews_limited (p_limit integer) returns table (
  key uuid,
  game_key int2,
  user_key uuid,
  nickname text,
  rating int2,
  comment text,
  updated_at timestamptz,
  score int,
  user_vote int
) language sql security invoker
set
  search_path = public as $$
select
  r.key,
  r.game_key,
  r.user_key,
  p.nickname,
  r.rating,
  r.comment,
  r.updated_at,
  r.score,
  coalesce(rv.vote, 0) as user_vote
from reviews r
left join profiles p on p.user_key = r.user_key
left join review_votes rv on rv.review_key = r.key and rv.user_key = auth.uid()
order by r.updated_at desc
limit p_limit;
$$;

drop function if exists get_user_review_for_game;

create or replace function get_user_review_for_game (p_game_key integer) returns table (
  key uuid,
  user_key uuid,
  nickname text,
  game_key int2,
  rating int2,
  comment text,
  locale text,
  updated_at timestamptz,
  user_vote int
) language sql security invoker
set
  search_path = public as $$
select
  r.key,
  r.user_key,
  p.nickname,
  r.game_key,
  r.rating,
  r.comment,
  r.locale,
  r.updated_at,
  coalesce(rv.vote, 0) as user_vote
from reviews r
left join profiles p on p.user_key = r.user_key
left join review_votes rv on rv.review_key = r.key and rv.user_key = auth.uid()
where r.user_key = auth.uid()
  and r.game_key = p_game_key
limit 1;
$$;

drop function if exists upsert_review_for_game;

create or replace function upsert_review_for_game (
  p_game_key integer,
  p_rating integer,
  p_comment text,
  p_locale text
) returns table (
  key uuid,
  user_key uuid,
  nickname text,
  game_key int2,
  rating int2,
  comment text,
  locale text,
  score smallint,
  updated_at timestamptz,
  user_vote int
) language plpgsql security invoker
set
  search_path = public as $$
declare
  v_review_key uuid;
begin
  insert into reviews (user_key, game_key, rating, comment, locale, updated_at)
  values (auth.uid(), p_game_key, p_rating, p_comment, p_locale, now())
  on conflict on constraint unique_user_for_game_review do update
  set
    rating = excluded.rating,
    comment = excluded.comment,
    locale = excluded.locale,
    updated_at = now()
  returning reviews.key into v_review_key;

  return query
  select
    r.key,
    r.user_key,
    p.nickname,
    r.game_key,
    r.rating,
    r.comment,
    r.locale,
    r.score,
    r.updated_at,
    coalesce(rv.vote, 0) as user_vote
  from reviews r
  left join profiles p on p.user_key = r.user_key
  left join review_votes rv on rv.review_key = r.key and rv.user_key = auth.uid()
  where r.key = v_review_key;
end;
$$;

drop function if exists upsert_vote_for_review;

create or replace function upsert_vote_for_review (p_review_key uuid, p_vote integer) returns table (
  key uuid,
  game_key int2,
  user_key uuid,
  nickname text,
  rating int2,
  comment text,
  updated_at timestamptz,
  score int,
  locale text,
  user_vote int
) language plpgsql security invoker
set
  search_path = public as $$
begin
  insert into review_votes (user_key, review_key, vote)
  values (auth.uid(), p_review_key, p_vote)
  on conflict (user_key, review_key)
  do update set vote = excluded.vote;

  return query
  select
    r.key,
    r.game_key,
    r.user_key,
    p.nickname,
    r.rating,
    r.comment,
    r.updated_at,
    r.score,
    r.locale,
    coalesce(rv.vote, 0) as user_vote
  from reviews r
  left join profiles p on p.user_key = r.user_key
  left join review_votes rv on rv.review_key = r.key and rv.user_key = auth.uid()
  where r.key = p_review_key;
end;
$$;