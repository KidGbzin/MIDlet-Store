create table if not exists profiles (
  user_key uuid primary key references auth.users(id) on delete cascade,
  nickname text not null unique,
  downloads integer not null default 0
);

alter table profiles enable row level security;

create policy "Public can read profiles!"
on profiles
for select
using (true);

create policy "Users can manage own profile!"
on profiles
for all
to authenticated
using (auth.uid() = user_key)
with check (auth.uid() = user_key);

create or replace function get_profile_for_user(p_user_key uuid)
returns table (
  r_user_key uuid,
  r_nickname text,
  r_downloads int
)
language sql
security invoker
set search_path = public
as $$
select
  user_key,
  nickname,
  downloads
from profiles
where user_key = p_user_key
limit 1;
$$;

create or replace function upsert_profile(p_nickname text)
returns table (
  profile_user_key uuid,
  profile_nickname text
)
language plpgsql
security invoker
set search_path = public
as $$
declare
  v_user_id uuid := auth.uid();
begin
  -- Verifica se o nickname já está em uso por outro usuário
  if exists (
    select 1 from profiles
    where nickname = p_nickname
      and user_key <> v_user_id
  ) then
    raise exception 'Nickname "%" já está em uso.', p_nickname
      using errcode = 'unique_violation';
  end if;

  -- Upsert no perfil
  insert into profiles (user_key, nickname)
  values (v_user_id, p_nickname)
  on conflict (user_key) do update
  set nickname = excluded.nickname;

  -- Retorna o perfil atualizado com nomes diferentes no retorno
  return query
  select p.user_key as profile_user_key,
         p.nickname  as profile_nickname
  from profiles p
  where p.user_key = v_user_id;
end;
$$;


drop function if exists increment_downloads_for_game;

create or replace function increment_downloads_for_game (p_game_key integer)
returns table (
  r_game_key int2,
  r_downloads integer,
  r_average_rating numeric(5, 2),
  r_score numeric(18, 8),
  r_total_reviews int2
)
language plpgsql
security invoker
set search_path = public
as $$
declare
  v_exists boolean;
  v_user_id uuid := auth.uid();
begin
  -- Atualiza os downloads do jogo
  update game_metadata
  set downloads = downloads + 1
  where game_key = p_game_key
  returning true into v_exists;

  -- Se não existir, cria o metadata do jogo
  if not found then
    insert into game_metadata (game_key, downloads, average_rating, score, total_reviews)
    values (p_game_key, 1, 0.0, 0.0, 0);
  end if;

  -- Atualiza os downloads do perfil do usuário
  update profiles
  set downloads = downloads + 1
  where user_key = v_user_id;

  -- Retorno com nomes de coluna padrão
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
  r_user_vote int
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
  coalesce(rv.vote, 0) as r_user_vote
from reviews r
left join profiles p on p.user_key = r.user_key
left join review_votes rv on rv.review_key = r.key and rv.user_key = auth.uid()
where r.user_key = p_user_key
order by r.updated_at desc
limit case when p_limit > 0 then p_limit else null end;
$$;
