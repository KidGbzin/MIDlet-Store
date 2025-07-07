create function get_top_3_reviews_for_game (p_game_key INT2) RETURNS table (
  key UUID,
  user_key UUID,
  user_name TEXT,
  rating INT2,
  comment TEXT,
  locale TEXT,
  updated_at TIMESTAMPTZ,
  score INTEGER
)
set
  search_path = public as $$
BEGIN
  RETURN QUERY
  SELECT
    r.key,
    r.user_key,
    p.name AS user_name,
    r.rating,
    r.comment,
    r.locale,
    r.updated_at,
    COALESCE(SUM(rv.vote), 0)::INTEGER AS score
  FROM reviews r
  JOIN profiles p ON p.key = r.user_key
  LEFT JOIN review_votes rv ON r.key = rv.review_key
  WHERE r.game_key = p_game_key
  GROUP BY r.key, p.name
  ORDER BY score DESC
  LIMIT 3;
END;
$$ LANGUAGE plpgsql;

create function upsert_firebase_cloud_messaging_token (p_token text, p_locale text) returns void language plpgsql security invoker
set
  search_path = public as $$
begin
  insert into tokens (user_key, token, locale)
  values (auth.uid(), p_token, p_locale)
  on conflict (token) do update
  set
    user_key = excluded.user_key,
    locale = excluded.locale;
end;
$$;

create function delete_firebase_cloud_messaging_token (p_token text) returns void language plpgsql security definer
set
  search_path = public as $$
begin
  delete from tokens
  where token = p_token;
end;
$$;

create function get_reviews_for_game (p_game_key INT) RETURNS table (
  key UUID,
  user_key UUID,
  user_name TEXT,
  game_key INT2,
  rating INT2,
  comment TEXT,
  locale TEXT,
  updated_at TIMESTAMPTZ
) LANGUAGE sql SECURITY INVOKER
set
  search_path = public as $$
  SELECT
    r.key,
    r.user_key,
    p.name AS user_name,
    r.game_key,
    r.rating,
    r.comment,
    r.locale,
    r.updated_at
  FROM reviews r
  JOIN profiles p ON p.key = r.user_key
  WHERE r.game_key = p_game_key;
$$;

create function get_or_insert_downloads_for_game (p_game_key int2) returns integer language plpgsql security invoker
set
  search_path = public as $$
declare
  v_downloads integer;
begin
  select downloads into v_downloads
  from game_metadata
  where game_key = p_game_key;

  if not found then
    insert into game_metadata (game_key, downloads)
    values (p_game_key, 0)
    returning downloads into v_downloads;
  end if;

  return v_downloads;
end;
$$;

create function get_user_review_for_game (p_game_key int2) returns table (
  key uuid,
  user_key uuid,
  user_name text,
  game_key int2,
  rating int2,
  comment text,
  locale text,
  updated_at timestamptz
) language sql security invoker
set
  search_path = public as $$
  select
    r.key,
    r.user_key,
    p.name as user_name,
    r.game_key,
    r.rating,
    r.comment,
    r.locale,
    r.updated_at
  from reviews r
  join profiles p on p.key = r.user_key
  where r.user_key = auth.uid()
    and r.game_key = p_game_key
  limit 1;
$$;

create function count_reviews_for_game (p_game_key int2) returns integer language sql security invoker
set
  search_path = public as $$
  select count(*)
  from reviews
  where game_key = p_game_key;
$$;

create function get_average_rating_for_game (p_game_key int2) returns numeric language sql security invoker
set
  search_path = public as $$
  select coalesce(round(avg(rating)::numeric, 2), 0.00)
  from reviews
  where game_key = p_game_key;
$$;

create function count_ratings_by_star_for_game (p_game_key int2) returns table (star int2, count int) language sql security invoker
set
  search_path = public as $$
  select stars.star, coalesce(r.count, 0) as count
  from (values (1), (2), (3), (4), (5)) as stars(star)
  left join (
    select rating, count(*) as count
    from reviews
    where game_key = p_game_key
    group by rating
  )
  r on r.rating = stars.star
  order by stars.star desc;
$$;

create function upsert_review_for_game (
  p_game_key INT2,
  p_rating INT2,
  p_comment TEXT,
  p_locale TEXT
) RETURNS table (
  key UUID,
  user_key UUID,
  user_name TEXT,
  game_key INT2,
  rating INT2,
  comment TEXT,
  locale TEXT,
  updated_at TIMESTAMPTZ
) LANGUAGE plpgsql SECURITY INVOKER
set
  search_path = public as $$
DECLARE
  v_review_key UUID;
BEGIN
  INSERT INTO reviews (user_key, game_key, rating, comment, locale, updated_at)
  VALUES (auth.uid(), p_game_key, p_rating, p_comment, p_locale, now())
  ON CONFLICT ON CONSTRAINT unique_user_game_review DO UPDATE
  SET
    rating = EXCLUDED.rating,
    comment = EXCLUDED.comment,
    locale = EXCLUDED.locale,
    updated_at = now()
  RETURNING reviews.key INTO v_review_key;

  RETURN QUERY
  SELECT
    r.key,
    r.user_key,
    p.name AS user_name,
    r.game_key,
    r.rating,
    r.comment,
    r.locale,
    r.updated_at
  FROM reviews r
  JOIN profiles p ON p.key = r.user_key
  WHERE r.key = v_review_key;
END;
$$;

create function increment_downloads_for_game (p_game_key INT2) RETURNS INTEGER LANGUAGE plpgsql SECURITY INVOKER
set
  search_path = public as $$
DECLARE
  new_downloads INTEGER;
BEGIN
  UPDATE game_metadata
  SET downloads = downloads + 1
  WHERE game_key = p_game_key
  RETURNING downloads INTO new_downloads;

  IF NOT FOUND THEN
    INSERT INTO game_metadata (game_key, downloads)
    VALUES (p_game_key, 1)
    RETURNING downloads INTO new_downloads;
  END IF;

  RETURN new_downloads;
END;
$$;

create function upsert_vote_for_review (p_review_key uuid, p_vote smallint) returns table (total_score integer, user_vote integer) language plpgsql security invoker
set
  search_path = public as $$
begin
  insert into review_votes (user_key, review_key, vote)
  values (
    auth.uid(),
    p_review_key,
    p_vote
  )
  on conflict (user_key, review_key)
  do update set vote = excluded.vote;

  return query
  select
    coalesce(sum(v.vote), 0)::integer as total_score,
    coalesce((
      select vote
      from review_votes
      where review_key = p_review_key
        and user_key = auth.uid()
      limit 1
    ), 0) as user_vote
  from review_votes v
  where v.review_key = p_review_key;
end;
$$;