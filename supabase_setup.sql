-- RPS secure database setup
-- Run this in Supabase SQL Editor.

create table if not exists public.members (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  mobile text not null,
  city text,
  referral_id text,
  interest text,
  created_at timestamptz not null default now()
);

alter table public.members enable row level security;

-- Public visitors may submit a registration, but cannot read member records.
drop policy if exists "public_can_register" on public.members;
create policy "public_can_register"
on public.members
for insert
to anon, authenticated
with check (true);

-- Admin allow-list. Add only your own authenticated admin user ID.
create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);
alter table public.admin_users enable row level security;

-- Admins can see the allow-list; normal visitors cannot.
drop policy if exists "admins_read_admin_users" on public.admin_users;
create policy "admins_read_admin_users"
on public.admin_users
for select
to authenticated
using (user_id = auth.uid());

-- Members are visible only to authenticated users listed as admins.
drop policy if exists "admins_read_members" on public.members;
create policy "admins_read_members"
on public.members
for select
to authenticated
using (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));

-- Optional: admins can update member records.
drop policy if exists "admins_update_members" on public.members;
create policy "admins_update_members"
on public.members
for update
to authenticated
using (exists (select 1 from public.admin_users a where a.user_id = auth.uid()))
with check (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));

-- After creating your Admin user in Authentication > Users,
-- run this command with the Admin user's UUID:
-- insert into public.admin_users(user_id) values ('YOUR-ADMIN-USER-UUID');
