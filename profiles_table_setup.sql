-- Run this SQL in Supabase SQL Editor.
-- This creates the profiles table used by the React role-based login.

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null,
  role text not null check (role in ('manager', 'tenant')),
  full_name text,
  building_id text
);

-- Enable Row Level Security.
alter table public.profiles enable row level security;

-- Users can read their own profile.
create policy "Users can read own profile"
on public.profiles
for select
to authenticated
using (auth.uid() = id);

-- Optional: users can update their own basic profile details.
create policy "Users can update own profile"
on public.profiles
for update
to authenticated
using (auth.uid() = id)
with check (auth.uid() = id);

-- Example profile insert after creating a user in Supabase Auth:
-- insert into public.profiles (id, email, role, full_name, building_id)
-- values (
--   'PASTE_AUTH_USER_ID_HERE',
--   'manager@example.com',
--   'manager',
--   'Manager Name',
--   null
-- );
