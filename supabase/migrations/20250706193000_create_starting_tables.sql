create table game_metadata (
  game_key int2 primary key,
  downloads integer not null
);

alter table game_metadata enable row level security;

create policy "Anyone can read game_metadata." on game_metadata for
select
  using (true);

create policy "Anyone can insert game_metadata." on game_metadata for insert
with
  check (true);

create policy "Anyone can update game_metadata." on game_metadata
for update
  using (true)
with
  check (true);

create table tokens (
  key uuid primary key default gen_random_uuid (),
  user_key uuid not null references auth.users on delete cascade,
  token text unique not null,
  locale text not null
);

create index index_tokens_user_key on tokens (user_key);

alter table tokens enable row level security;

create policy "Allow all users to select their tokens." on tokens for
select
  using (true);

create policy "Users can insert their own tokens." on tokens for insert
with
  check (
    (
      select
        auth.uid ()
    ) = user_key
  );

create policy "Users can update their own tokens." on tokens
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

create table reviews (
  key uuid primary key default gen_random_uuid (),
  user_key uuid not null references auth.users on delete cascade,
  game_key int2 not null,
  rating int2 not null check (rating between 1 and 5),
  locale text not null,
  comment text not null default '',
  updated_at timestamptz not null default now()
);

alter table reviews enable row level security;

alter table reviews
add constraint unique_user_game_review unique (user_key, game_key);

create policy "Anyone can read reviews." on reviews for
select
  using (true);

create policy "Users can insert their own reviews." on reviews for insert
with
  check (
    (
      select
        auth.uid ()
    ) = user_key
  );

create policy "Users can update their own reviews." on reviews
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

create table review_votes (
  key uuid primary key default gen_random_uuid (),
  user_key uuid not null references auth.users on delete cascade,
  review_key uuid not null references reviews (key) on delete cascade,
  vote smallint not null check (vote in (1, -1))
);

alter table review_votes enable row level security;

alter table review_votes
add constraint unique_user_vote_per_review unique (user_key, review_key);

create policy "Anyone can read review_votes." on review_votes for
select
  using (true);

create policy "Users can insert their own review_votes." on review_votes for insert
with
  check (
    (
      select
        auth.uid ()
    ) = user_key
  );

create policy "Users can update their own review_votes." on review_votes
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