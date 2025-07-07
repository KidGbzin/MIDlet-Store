create view public.profiles as
select
  users.id as key,
  users.raw_user_meta_data ->> 'name'::text as name
from
  auth.users;

revoke
select
  on public.profiles
from
  public;

revoke
select
  on public.profiles
from
  anon;

grant
select
  on public.profiles to authenticated;

GRANT SELECT (id, raw_user_meta_data) ON auth.users TO authenticated;