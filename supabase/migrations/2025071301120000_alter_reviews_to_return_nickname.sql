alter table reviews
add column difficulty int2 not null check (difficulty between 1 and 5),
add column time_spent int2 not null check (time_spent in (1, 3, 5, 10, 20)),
add column completion_level int2 not null check (completion_level in (0, 1, 2));

comment on column reviews.completion_level is
  '0 = Played It, 1 = Beat It, 2 = Conquered It';

comment on column reviews.time_spent is
  'Estimated time spent in hours: 1, 3, 5, 10, 20';

comment on column reviews.difficulty is
  'Perceived difficulty level from 1 (very easy) to 5 (very hard)';

drop function if exists get_top_3_reviews_for_game;

create or replace function get_top_3_reviews_for_game (p_game_key integer) returns table (
  r_key uuid,
  r_game_key int2,
  r_user_key uuid,
  r_nickname text,
  r_rating int2,
  r_comment text,
  r_updated_at timestamptz,
  r_score int,
  r_locale text,
  r_user_vote int,
  r_difficulty int2,
  r_time_spent int2,
  r_completion_level int2
) language sql security invoker
set search_path = public as $$
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
  coalesce(rv.vote, 0),
  r.difficulty,
  r.time_spent,
  r.completion_level
from reviews r
left join profiles p on p.user_key = r.user_key
left join review_votes rv on rv.review_key = r.key and rv.user_key = auth.uid()
where r.game_key = p_game_key
order by r.score desc, r.updated_at desc
limit 3;
$$;

drop function if exists get_reviews_for_game;

create or replace function get_reviews_for_game (p_game_key integer) returns table (
  r_key uuid,
  r_game_key int2,
  r_user_key uuid,
  r_nickname text,
  r_rating int2,
  r_comment text,
  r_updated_at timestamptz,
  r_score int,
  r_locale text,
  r_user_vote int,
  r_difficulty int2,
  r_time_spent int2,
  r_completion_level int2
) language sql security invoker
set search_path = public as $$
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
  coalesce(rv.vote, 0),
  r.difficulty,
  r.time_spent,
  r.completion_level
from reviews r
left join profiles p on p.user_key = r.user_key
left join review_votes rv on rv.review_key = r.key and rv.user_key = auth.uid()
where r.game_key = p_game_key
order by r.updated_at desc;
$$;

drop function if exists get_recent_reviews_limited;

create or replace function get_recent_reviews_limited (p_limit integer) returns table (
  r_key uuid,
  r_game_key int2,
  r_user_key uuid,
  r_nickname text,
  r_rating int2,
  r_comment text,
  r_updated_at timestamptz,
  r_score int,
  r_user_vote int,
  r_difficulty int2,
  r_time_spent int2,
  r_completion_level int2
) language sql security invoker
set search_path = public as $$
select
  r.key,
  r.game_key,
  r.user_key,
  p.nickname,
  r.rating,
  r.comment,
  r.updated_at,
  r.score,
  coalesce(rv.vote, 0),
  r.difficulty,
  r.time_spent,
  r.completion_level
from reviews r
left join profiles p on p.user_key = r.user_key
left join review_votes rv on rv.review_key = r.key and rv.user_key = auth.uid()
order by r.updated_at desc
limit p_limit;
$$;

drop function if exists get_user_review_for_game;

create or replace function get_user_review_for_game (p_game_key integer) returns table (
  r_key uuid,
  r_user_key uuid,
  r_nickname text,
  r_game_key int2,
  r_rating int2,
  r_comment text,
  r_locale text,
  r_updated_at timestamptz,
  r_user_vote int,
  r_score int,
  r_difficulty int2,
  r_time_spent int2,
  r_completion_level int2
) language sql security invoker
set search_path = public as $$
select
  r.key,
  r.user_key,
  p.nickname,
  r.game_key,
  r.rating,
  r.comment,
  r.locale,
  r.updated_at,
  r.score,
  coalesce(rv.vote, 0),
  r.difficulty,
  r.time_spent,
  r.completion_level
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
  p_locale text,
  p_difficulty integer,
  p_time_spent integer,
  p_completion_level integer
) returns table (
  r_key uuid,
  r_user_key uuid,
  r_nickname text,
  r_game_key int2,
  r_rating int2,
  r_comment text,
  r_locale text,
  r_score smallint,
  r_updated_at timestamptz,
  r_user_vote int,
  r_difficulty int2,
  r_time_spent int2,
  r_completion_level int2
) language plpgsql security invoker
set search_path = public as $$
declare
  v_review_key uuid;
begin
  insert into reviews (user_key, game_key, rating, comment, locale, updated_at, difficulty, time_spent, completion_level)
  values (auth.uid(), p_game_key, p_rating, p_comment, p_locale, now(), p_difficulty, p_time_spent, p_completion_level)
  on conflict on constraint unique_user_for_game_review do update
  set
    rating = excluded.rating,
    comment = excluded.comment,
    locale = excluded.locale,
    difficulty = excluded.difficulty,
    time_spent = excluded.time_spent,
    completion_level = excluded.completion_level,
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
    coalesce(rv.vote, 0),
    r.difficulty,
    r.time_spent,
    r.completion_level
  from reviews r
  left join profiles p on p.user_key = r.user_key
  left join review_votes rv on rv.review_key = r.key and rv.user_key = auth.uid()
  where r.key = v_review_key;
end;
$$;


drop function if exists upsert_vote_for_review;

create or replace function upsert_vote_for_review (p_review_key uuid, p_vote integer) returns table (
  r_key uuid,
  r_game_key int2,
  r_user_key uuid,
  r_nickname text,
  r_rating int2,
  r_comment text,
  r_updated_at timestamptz,
  r_score smallint,
  r_locale text,
  r_user_vote int,
  r_difficulty int2,
  r_time_spent int2,
  r_completion_level int2
) language plpgsql security invoker
set search_path = public as $$
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
    coalesce(rv.vote, 0),
    r.difficulty,
    r.time_spent,
    r.completion_level
  from reviews r
  left join profiles p on p.user_key = r.user_key
  left join review_votes rv on rv.review_key = r.key and rv.user_key = auth.uid()
  where r.key = p_review_key;
end;
$$;


create or replace function get_reviews_for_user_limited(
  p_user_key uuid,
  p_limit integer
)
returns table (
  r_key uuid,
  r_game_key int2,
  r_user_key uuid,
  r_nickname text,
  r_rating int2,
  r_comment text,
  r_updated_at timestamptz,
  r_score int,
  r_locale text,
  r_user_vote int,
  r_difficulty int2,
  r_time_spent int2,
  r_completion_level int2
)
language sql
security invoker
set search_path = public
as $$
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
  coalesce(rv.vote, 0),
  r.difficulty,
  r.time_spent,
  r.completion_level
from reviews r
left join profiles p on p.user_key = r.user_key
left join review_votes rv on rv.review_key = r.key and rv.user_key = auth.uid()
where r.user_key = p_user_key
order by r.updated_at desc
limit case when p_limit > 0 then p_limit else null end;
$$;

drop function if exists get_recent_reviews_limited;

create or replace function get_recent_reviews_limited(p_limit integer)
returns table (
  r_key uuid,
  r_game_key int2,
  r_user_key uuid,
  r_nickname text,
  r_rating int2,
  r_comment text,
  r_updated_at timestamptz,
  r_score int,
  r_locale text,
  r_user_vote int,
  r_difficulty int2,
  r_time_spent int2,
  r_completion_level int2
)
language sql
security invoker
set search_path = public
as $$
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
  coalesce(rv.vote, 0),
  r.difficulty,
  r.time_spent,
  r.completion_level
from reviews r
left join profiles p on p.user_key = r.user_key
left join review_votes rv on rv.review_key = r.key and rv.user_key = auth.uid()
order by r.updated_at desc
limit case when p_limit > 0 then p_limit else null end;
$$;

create or replace function get_global_stats()
returns table (
  r_total_downloads int,
  r_total_reviews int
)
language sql
set search_path = public
as $$
  select
    sum(downloads)::int as total_downloads,
    sum(total_reviews)::int as total_reviews
  from game_metadata;
$$;