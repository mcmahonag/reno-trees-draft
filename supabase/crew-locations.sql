-- Reno Tree Inventory: crew location sharing (run once in Supabase → SQL Editor; safe to re-run)
-- Requires crew-mode.sql to have been run first (it creates profiles and is_admin()).
-- Keeps only each person's latest position while they are on shift; no history is stored.

create table if not exists public.crew_locations (
  user_id uuid primary key default auth.uid() references auth.users on delete cascade,
  email text,
  name text,
  crew_code text,
  lat double precision,
  lng double precision,
  accuracy integer,
  on_shift boolean not null default false,
  shift_start timestamptz,
  updated_at timestamptz not null default now()
);

create or replace function public.touch_crew_location() returns trigger
language plpgsql as $$
begin
  new.updated_at := now();
  return new;
end $$;
drop trigger if exists crew_locations_touch on public.crew_locations;
create trigger crew_locations_touch before insert or update on public.crew_locations
  for each row execute function public.touch_crew_location();

alter table public.crew_locations enable row level security;
drop policy if exists "loc read"   on public.crew_locations;
drop policy if exists "loc insert" on public.crew_locations;
drop policy if exists "loc update" on public.crew_locations;
-- Admins see everyone on shift; each person can see and write only their own row
create policy "loc read"   on public.crew_locations for select to authenticated
  using (user_id = auth.uid() or (select public.is_admin()));
create policy "loc insert" on public.crew_locations for insert to authenticated
  with check (user_id = auth.uid());
create policy "loc update" on public.crew_locations for update to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());
