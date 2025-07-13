create table if not exists notification_tokens (
  key uuid primary key default gen_random_uuid (),
  user_key uuid not null references auth.users on delete cascade,
  locale text not null,
  token text unique not null
);

create index index_notification_tokens_for_user_key on notification_tokens (user_key);

alter table notification_tokens enable row level security;

create policy "Allow all users to select their notification tokens!" on notification_tokens for
select
  using (true);

create policy "Users can insert their own notification tokens!" on notification_tokens for insert
with
  check (
    (
      select
        auth.uid ()
    ) = user_key
  );

create policy "Users can update their own notification tokens!" on notification_tokens
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

create function upsert_notification_token (p_token text, p_locale text) returns void language plpgsql security invoker
set
  search_path = public as $$
begin
  insert into notification_tokens (user_key, token, locale)
  values (auth.uid(), p_token, p_locale)
  on conflict (token) do update
  set
    user_key = excluded.user_key,
    locale = excluded.locale;
end;
$$;

create function delete_notification_token (p_token text) returns void language plpgsql security definer
set
  search_path = public as $$
begin
  delete from notification_tokens
  where token = p_token;
end;
$$;