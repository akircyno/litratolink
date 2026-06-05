-- Add thumbnail URL columns that were created outside of migrations.
-- Both are nullable text columns populated by the complete-upload edge function.

alter table public.media_files
  add column if not exists thumbnail_url text;

alter table public.albums
  add column if not exists cover_thumbnail_url text;
