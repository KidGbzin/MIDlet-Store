create table if not exists reviews (
  key uuid primary key default gen_random_uuid (),
  user_key uuid not null references auth.users on delete cascade,
  game_key int2 not null,
  updated_at timestamptz not null default now(),
  locale text not null,
  rating int2 not null check (rating between 1 and 5),
  score int2 not null default 0,
  comment text not null default ''
);

alter table reviews enable row level security;

alter table reviews
add constraint unique_user_for_game_review unique (user_key, game_key);

create policy "Anyone can read reviews!" on reviews for
select
  using (true);

create policy "Users can insert their own reviews!" on reviews for insert
with
  check (
    (
      select
        auth.uid ()
    ) = user_key
  );

create policy "Users can update their own reviews!" on reviews
for update
  using (
    (
      select
        auth.uid ()
    ) = user_key
  )
with
  check (
    (
      select
        auth.uid ()
    ) = user_key
  );

create table if not exists review_votes (
  key uuid primary key default gen_random_uuid (),
  user_key uuid not null references auth.users on delete cascade,
  review_key uuid not null references reviews (key) on delete cascade,
  vote smallint not null check (vote in (1, -1))
);

alter table review_votes enable row level security;

alter table review_votes
add constraint unique_user_vote_for_review unique (user_key, review_key);

create policy "Anyone can read votes!" on review_votes for
select
  using (true);

create policy "Users can insert their own votes!" on review_votes for insert
with
  check (
    (
      select
        auth.uid ()
    ) = user_key
  );

create policy "Users can update their own votes!" on review_votes
for update
  using (
    (
      select
        auth.uid ()
    ) = user_key
  )
with
  check (
    (
      select
        auth.uid ()
    ) = user_key
  );

create or replace function get_top_3_reviews_for_game (p_game_key integer) returns table (
  key uuid,
  game_key int2,
  user_key uuid,
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
    r.rating,
    r.comment,
    r.updated_at,
    r.score,
    r.locale,
    coalesce(rv.vote, 0) as user_vote
  from reviews r
  left join review_votes rv
    on rv.review_key = r.key
   and rv.user_key = auth.uid()
  where r.game_key = p_game_key
  order by r.score desc, r.updated_at desc
  limit 3;
$$;

create or replace function get_reviews_for_game (p_game_key integer) returns table (
  key uuid,
  game_key int2,
  user_key uuid,
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
    r.rating,
    r.comment,
    r.updated_at,
    r.score,
    r.locale,
    coalesce(rv.vote, 0) as user_vote
  from reviews r
  left join review_votes rv
    on rv.review_key = r.key
   and rv.user_key = auth.uid()
  where r.game_key = p_game_key
  order by r.updated_at desc;
$$;

create or replace function get_recent_reviews_limited (p_limit integer) returns table (
  key uuid,
  game_key int2,
  user_key uuid,
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
    r.rating,
    r.comment,
    r.updated_at,
    r.score,
    coalesce(rv.vote, 0) as user_vote
  from reviews r
  left join review_votes rv
    on rv.review_key = r.key
   and rv.user_key = auth.uid()
  order by r.updated_at desc
  limit p_limit;
$$;

create or replace function get_rating_distribution_for_game (p_game_key integer) returns table (
  stars_1 int,
  stars_2 int,
  stars_3 int,
  stars_4 int,
  stars_5 int
) language sql
set
  search_path = public as $$
  select
    count(*) filter (where rating = 1) as stars_1,
    count(*) filter (where rating = 2) as stars_2,
    count(*) filter (where rating = 3) as stars_3,
    count(*) filter (where rating = 4) as stars_4,
    count(*) filter (where rating = 5) as stars_5
  from reviews
  where game_key = p_game_key;
$$;

create or replace function get_user_review_for_game (p_game_key integer) returns table (
  key uuid,
  user_key uuid,
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
    r.game_key,
    r.rating,
    r.comment,
    r.locale,
    r.updated_at,
    coalesce(rv.vote, 0) as user_vote
  from reviews r
  left join review_votes rv
    on rv.review_key = r.key
   and rv.user_key = auth.uid()
  where r.user_key = auth.uid()
    and r.game_key = p_game_key
  limit 1;
$$;

create or replace function upsert_review_for_game (
  p_game_key integer,
  p_rating integer,
  p_comment text,
  p_locale text
) returns table (
  key uuid,
  user_key uuid,
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
    r.game_key,
    r.rating,
    r.comment,
    r.locale,
    r.score,
    r.updated_at,
    coalesce(rv.vote, 0) as user_vote
  from reviews r
  left join review_votes rv
    on rv.review_key = r.key
   and rv.user_key = auth.uid()
  where r.key = v_review_key;
end;
$$;

create or replace function upsert_vote_for_review (p_review_key uuid, p_vote integer) returns table (
  key uuid,
  game_key int2,
  user_key uuid,
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
    r.rating,
    r.comment,
    r.updated_at,
    r.score,
    r.locale,
    coalesce(rv.vote, 0) as user_vote
  from reviews r
  left join review_votes rv
    on rv.review_key = r.key
   and rv.user_key = auth.uid()
  where r.key = p_review_key;
end;
$$;

create or replace function trigger_update_review_score () returns trigger language plpgsql as $$
begin
  update reviews
  set score = (
    select coalesce(sum(vote), 0)
    from review_votes
    where review_key = coalesce(new.review_key, old.review_key)
  )
  where key = coalesce(new.review_key, old.review_key);

  return null;
end;
$$;

create trigger trigger_update_review_score_aiud
after insert
or
update
or delete on review_votes for each row
execute function trigger_update_review_score ();