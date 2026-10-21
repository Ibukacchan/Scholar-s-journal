-- THE SCHOLAR'S LEDGER: Supabase setup
-- Run this entire file in Supabase Dashboard > SQL Editor > New query.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default 'Scholar',
  approved boolean not null default false,
  is_admin boolean not null default false,
  leaderboard_opt_in boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.scholar_state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.scholar_state enable row level security;
revoke all on public.profiles from anon, authenticated;
grant select on public.profiles to authenticated;
revoke all on public.scholar_state from anon, authenticated;
grant select, insert, update, delete on public.scholar_state to authenticated;

create or replace function public.create_scholar_profile()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  insert into public.profiles (id, display_name, approved, is_admin)
  values (new.id,
    coalesce(nullif(new.raw_user_meta_data->>'display_name',''), split_part(coalesce(new.email,'Scholar'),'@',1)),
    false, false)
  on conflict (id) do nothing;
  return new;
end;
$$;
drop trigger if exists on_auth_user_created_scholar on auth.users;
create trigger on_auth_user_created_scholar after insert on auth.users
for each row execute procedure public.create_scholar_profile();

create or replace function public.is_scholar_admin()
returns boolean language sql stable security definer set search_path = '' as $$
  select exists (select 1 from public.profiles p
    where p.id = (select auth.uid()) and p.is_admin = true and p.approved = true);
$$;
revoke all on function public.is_scholar_admin() from public;
grant execute on function public.is_scholar_admin() to authenticated;

drop policy if exists "read own profile or admin" on public.profiles;
create policy "read own profile or admin" on public.profiles for select to authenticated
using (id = (select auth.uid()) or public.is_scholar_admin());

drop policy if exists "read own state" on public.scholar_state;
create policy "read own state" on public.scholar_state for select to authenticated
using (user_id = (select auth.uid()) and exists (select 1 from public.profiles p where p.id=(select auth.uid()) and p.approved=true));
drop policy if exists "insert own state" on public.scholar_state;
create policy "insert own state" on public.scholar_state for insert to authenticated
with check (user_id = (select auth.uid()) and exists (select 1 from public.profiles p where p.id=(select auth.uid()) and p.approved=true));
drop policy if exists "update own state" on public.scholar_state;
create policy "update own state" on public.scholar_state for update to authenticated
using (user_id = (select auth.uid()) and exists (select 1 from public.profiles p where p.id=(select auth.uid()) and p.approved=true))
with check (user_id = (select auth.uid()) and exists (select 1 from public.profiles p where p.id=(select auth.uid()) and p.approved=true));
drop policy if exists "delete own state" on public.scholar_state;
create policy "delete own state" on public.scholar_state for delete to authenticated
using (user_id = (select auth.uid()) and exists (select 1 from public.profiles p where p.id=(select auth.uid()) and p.approved=true));

-- After creating/inviting your own Auth user, replace the email below and run this separately:
-- update public.profiles p set is_admin=true, approved=true from auth.users u
-- where p.id=u.id and lower(u.email)=lower('YOUR_ADMIN_EMAIL');
