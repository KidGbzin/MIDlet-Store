create table if not exists game_metadata (
  game_key int2 primary key,
  downloads integer not null,
  average_rating numeric(5, 2) not null default 0,
  score numeric(18, 8) not null default 0,
  total_reviews int2 not null default 0
);

alter table game_metadata enable row level security;

create policy "Anyone can read metadata!" on game_metadata for
select
  using (true);

create policy "Anyone can insert metadata!" on game_metadata for insert
with
  check (true);

create policy "Anyone can update metadata!" on game_metadata
for update
  using (true)
with
  check (true);

create or replace function insert_empty_game_metadata (p_game_key integer) returns void language plpgsql as $$
begin
  insert into game_metadata (game_key, downloads, average_rating, score, total_reviews)
  values (p_game_key, 0, 0.0, 0.0, 0)
  on conflict do nothing;
end;
$$;

create or replace function get_game_metadata_for_game (p_game_key integer) returns table (
  game_key int2,
  downloads integer,
  average_rating numeric(5, 2),
  score numeric(18, 8),
  total_reviews int2
) language plpgsql security invoker
set
  search_path = public as $$
begin
  perform insert_empty_game_metadata(p_game_key::int2);

  return query
  select
    gm.game_key,
    gm.downloads,
    gm.average_rating,
    gm.score,
    gm.total_reviews
  from game_metadata gm
  where gm.game_key = p_game_key;
end;
$$;

create or replace function increment_downloads_for_game (p_game_key integer) returns table (
  game_key int2,
  downloads integer,
  average_rating numeric(5, 2),
  score numeric(18, 8),
  total_reviews int2
) language plpgsql security invoker
set
  search_path = public as $$
declare
  v_exists boolean;
begin
  update game_metadata
  set downloads = downloads + 1
  where game_key = p_game_key
  returning true into v_exists;

  if not found then
    insert into game_metadata (game_key, downloads, average_rating, score, total_reviews)
    values (p_game_key, 1, 0.0, 0.0, 0);
  end if;

  return query
  select
    game_key,
    downloads,
    average_rating,
    score,
    total_reviews
  from game_metadata
  where game_key = p_game_key;
end;
$$;

create or replace function refresh_game_metadata_from_reviews () returns void language plpgsql as $$
declare
  v_global_avg numeric(5,2);
  v_m numeric;
begin
  select round(avg(rating)::numeric, 2) into v_global_avg from reviews;

  select percentile_cont(0.6) within group (order by count)::numeric into v_m
  from (
    select count(*) as count from reviews group by game_key
  ) sub;

  update game_metadata gm
  set
    average_rating = round(sub.avg_rating, 2),
    score = round(
      (sub.review_count::numeric / (sub.review_count + v_m)) * sub.avg_rating +
      (v_m / (sub.review_count + v_m)) * v_global_avg, 4),
    total_reviews = sub.review_count
  from (
    select
      game_key,
      count(*) as review_count,
      avg(rating)::numeric as avg_rating
    from reviews
    group by game_key
  ) sub
  where gm.game_key = sub.game_key;
end;
$$;

create or replace function get_top_rated_games_limited (p_limit integer) returns table (
  game_key int2,
  downloads integer,
  average_rating numeric(5, 2),
  score numeric(18, 8),
  total_reviews int2
) language sql security invoker
set
  search_path = public as $$
  select
    game_key,
    downloads,
    average_rating,
    score,
    total_reviews
  from game_metadata
  order by score desc
  limit p_limit;
$$;

create or replace function trigger_refresh_game_metadata_after_review_aiud () returns trigger language plpgsql as $$
begin
  perform refresh_game_metadata_from_reviews();
  return null;
end;
$$;

create trigger refresh_game_metadata_after_review_change_aiud
after insert
or
update
or delete on reviews for each statement
execute function trigger_refresh_game_metadata_after_review_aiud ();