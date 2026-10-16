-- Run this in Supabase Dashboard -> SQL Editor.
create table if not exists public.game_saves (
  user_id uuid not null references auth.users(id) on delete cascade,
  game_id text not null check (game_id in ('game-hub','aquasub-go','jet-rush','fluxr')),
  save_data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (user_id, game_id)
);
alter table public.game_saves enable row level security;
drop policy if exists "Players can read their own saves" on public.game_saves;
create policy "Players can read their own saves" on public.game_saves for select to authenticated using (auth.uid() = user_id);
drop policy if exists "Players can create their own saves" on public.game_saves;
create policy "Players can create their own saves" on public.game_saves for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "Players can update their own saves" on public.game_saves;
create policy "Players can update their own saves" on public.game_saves for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
