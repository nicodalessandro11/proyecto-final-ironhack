create table tasks (
  id bigint generated by default as identity primary key,
  user_id uuid references auth.users not null,
  task text check (char_length(task) > 3),
  is_complete boolean default false,
  inserted_at timestamp with time zone default timezone('utc'::text, now()) not null
);
alter table tasks enable row level security;
create policy "Individuals can create tasks." on tasks for
    insert with check (auth.uid() = user_id);
create policy "Individuals can view their own tasks. " on tasks for
    select using (auth.uid() = user_id);
create policy "Individuals can update their own tasks." on tasks for
    update using (auth.uid() = user_id);
create policy "Individuals can delete their own tasks." on tasks for
    delete using (auth.uid() = user_id);