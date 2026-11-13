-- Reno Tree Inventory: crew mode (run once in Supabase → SQL Editor; safe to re-run)

-- 1. One profile per user: role (admin or crew) and crew code
create table if not exists public.profiles (
  user_id uuid primary key references auth.users on delete cascade,
  email text,
  name text,
  role text not null default 'crew' check (role in ('admin','crew')),
  crew_code text
);

-- Everyone who already has an account starts as an admin (change crews in the app)
insert into public.profiles (user_id, email, role)
  select id, email, 'admin' from auth.users
  on conflict (user_id) do nothing;

-- New users added later get a crew profile automatically
create or replace function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (user_id, email) values (new.id, new.email)
  on conflict (user_id) do nothing;
  return new;
end $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
  for each row execute function public.handle_new_user();

-- 2. Helpers used by the access rules
create or replace function public.is_admin() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from profiles where user_id = auth.uid() and role = 'admin')
$$;
create or replace function public.my_crew() returns text
language sql stable security definer set search_path = public as $$
  select coalesce(nullif(trim(crew_code), ''), '#none#') from profiles where user_id = auth.uid()
$$;

-- 3. Profiles: you see your own; admins see and edit everyone
alter table public.profiles enable row level security;
drop policy if exists "profiles read" on public.profiles;
drop policy if exists "profiles admin update" on public.profiles;
create policy "profiles read" on public.profiles for select to authenticated
  using (user_id = auth.uid() or (select public.is_admin()));
create policy "profiles admin update" on public.profiles for update to authenticated
  using ((select public.is_admin())) with check ((select public.is_admin()));

-- 4. App data: admins see everything; crews see trees, inspections and photos,
--    plus work records / work orders that name their crew code, and records they created.
drop policy if exists "team read"   on public.items;
drop policy if exists "team insert" on public.items;
drop policy if exists "team update" on public.items;
drop policy if exists "items read"   on public.items;
drop policy if exists "items insert" on public.items;
drop policy if exists "items update" on public.items;

create policy "items read" on public.items for select to authenticated using (
  (select public.is_admin())
  or store in ('trees', 'inspections', 'photos')
  or (store = 'records' and (
        coalesce(data->>'crew', '') ~* ('(^|[^a-z0-9])' || (select public.my_crew()) || '([^a-z0-9]|$)')
        or data->>'createdById' = auth.uid()::text))
  or (store = 'orders' and
        coalesce(data->>'assignee', '') ~* ('(^|[^a-z0-9])' || (select public.my_crew()) || '([^a-z0-9]|$)'))
);
create policy "items insert" on public.items for insert to authenticated with check (
  (select public.is_admin()) or store in ('trees', 'inspections', 'photos', 'records')
);
create policy "items update" on public.items for update to authenticated using (
  (select public.is_admin())
  or store in ('trees', 'inspections', 'photos')
  or (store = 'records' and (
        coalesce(data->>'crew', '') ~* ('(^|[^a-z0-9])' || (select public.my_crew()) || '([^a-z0-9]|$)')
        or data->>'createdById' = auth.uid()::text))
) with check (
  (select public.is_admin()) or store in ('trees', 'inspections', 'photos', 'records')
);
