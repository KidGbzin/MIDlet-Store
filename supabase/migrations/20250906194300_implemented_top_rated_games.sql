create materialized view top_rated_games as
with
  review_stats as (
    select
      game_key,
      count(*) as reviews_count,
      avg(rating)::numeric as average_rating
    from
      reviews
    group by
      game_key
  ),
  global_avg as (
    select
      avg(rating)::numeric as value
    from
      reviews
  ),
  percentile_m as (
    select
      percentile_cont(0.6) within group (
        order by
          reviews_count
      ) as value
    from
      review_stats
  ),
  weighted_scores as (
    select
      r.game_key,
      r.average_rating,
      (
        (
          r.reviews_count::numeric / (r.reviews_count + m.value)
        ) * r.average_rating + (m.value / (r.reviews_count + m.value)) * ga.value
      ) as weighted_score
    from
      review_stats r
      cross join global_avg ga
      cross join percentile_m m
  )
select
  game_key,
  average_rating,
  weighted_score
from
  weighted_scores
order by
  weighted_score desc;

create or replace function get_top_rated_games_limited (p_elements int) returns table (
  game_key int2,
  average_rating numeric,
  weighted_score numeric
) language sql
set
  search_path = public as $$
  select
    game_key,
    average_rating,
    weighted_score
  from
    top_rated_games
  limit p_elements;
$$;

create or replace function trigger_refresh_top_rated_games () returns trigger language plpgsql as $$
begin
  refresh materialized view top_rated_games;
  return null;
end;
$$;

create trigger refresh_top_rated_games_aiud
after insert
or
update
or delete on reviews for each statement
execute function trigger_refresh_top_rated_games ();