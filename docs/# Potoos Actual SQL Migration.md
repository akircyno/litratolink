# Potoos Actual SQL Migration Draft v1.0

## 1. Document Purpose

This document contains the first actual SQL migration draft for Potoos Sprint 1.

This SQL is for the first proof of concept only.

Sprint 1 goal:

* Google Login
* User profile creation
* Create album
* Add album creator as Admin
* Upload one original photo
* Store file metadata
* Download original file
* Block non-member access

This SQL is not yet the full production database.

It only includes the minimum tables and rules needed for Sprint 1.

---

## 2. Important Warning

Use this first in a development Supabase project.

Recommended project:

`potoos-dev`

Do not run this directly in production without testing.

---

## 3. Sprint 1 Tables Included

This migration creates:

1. `user_profiles`
2. `storage_providers`
3. `albums`
4. `album_members`
5. `storage_objects`
6. `media_files`

This migration does not yet create:

* `album_invites`
* `media_thumbnails`
* `device_tokens`
* `notifications`
* `activity_logs`
* `plans`
* `subscriptions`
* `billing_history`
* `storage_usage`

Those will be added later.

---

## 4. Sprint 1 SQL Migration

```sql
-- =========================================================
-- Potoos Sprint 1 SQL Migration Draft v1.0
-- Purpose:
-- Core Original Quality Proof
-- =========================================================

-- =========================================================
-- 1. Enable Required Extension
-- =========================================================

create extension if not exists "pgcrypto";

-- =========================================================
-- 2. Create Enum Types
-- =========================================================

do $$
begin
  if not exists (select 1 from pg_type where typname = 'album_role') then
    create type public.album_role as enum ('admin', 'contributor', 'viewer');
  end if;

  if not exists (select 1 from pg_type where typname = 'media_file_type') then
    create type public.media_file_type as enum ('photo', 'video');
  end if;

  if not exists (select 1 from pg_type where typname = 'upload_status') then
    create type public.upload_status as enum ('pending', 'uploading', 'completed', 'failed');
  end if;

  if not exists (select 1 from pg_type where typname = 'storage_provider_type') then
    create type public.storage_provider_type as enum (
      'google_drive',
      'cloudflare_r2',
      'google_cloud_storage',
      'supabase_storage'
    );
  end if;
end $$;

-- =========================================================
-- 3. Create user_profiles Table
-- =========================================================

create table if not exists public.user_profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null,
  display_name text,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  last_active_at timestamptz,
  is_active boolean not null default true,
  is_banned boolean not null default false
);

-- =========================================================
-- 4. Create storage_providers Table
-- =========================================================

create table if not exists public.storage_providers (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  type public.storage_provider_type not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

-- =========================================================
-- 5. Create albums Table
-- =========================================================

create table if not exists public.albums (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.user_profiles(id) on delete cascade,
  name text not null,
  description text,
  storage_provider_id uuid references public.storage_providers(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  is_deleted boolean not null default false,
  deleted_at timestamptz,
  delete_expires_at timestamptz,
  is_archived boolean not null default false,

  constraint albums_name_length_check check (char_length(name) between 1 and 100)
);

-- =========================================================
-- 6. Create album_members Table
-- =========================================================

create table if not exists public.album_members (
  id uuid primary key default gen_random_uuid(),
  album_id uuid not null references public.albums(id) on delete cascade,
  user_id uuid not null references public.user_profiles(id) on delete cascade,
  role public.album_role not null,
  invited_by uuid references public.user_profiles(id),
  joined_at timestamptz not null default now(),
  removed_at timestamptz,
  is_active boolean not null default true,

  constraint album_members_unique_album_user unique (album_id, user_id)
);

-- =========================================================
-- 7. Create storage_objects Table
-- =========================================================

create table if not exists public.storage_objects (
  id uuid primary key default gen_random_uuid(),
  provider_id uuid not null references public.storage_providers(id),
  provider_file_id text,
  provider_folder_id text,
  storage_path text,
  file_size_bytes bigint not null,
  mime_type text not null,
  checksum text,
  created_at timestamptz not null default now(),
  is_deleted boolean not null default false,
  deleted_at timestamptz,

  constraint storage_objects_file_size_check check (file_size_bytes >= 0)
);

-- =========================================================
-- 8. Create media_files Table
-- =========================================================

create table if not exists public.media_files (
  id uuid primary key default gen_random_uuid(),
  album_id uuid not null references public.albums(id) on delete cascade,
  uploader_id uuid not null references public.user_profiles(id) on delete cascade,
  storage_object_id uuid references public.storage_objects(id),
  original_filename text not null,
  file_type public.media_file_type not null,
  mime_type text not null,
  file_size_bytes bigint not null,
  width integer,
  height integer,
  duration_seconds numeric,
  upload_status public.upload_status not null default 'pending',
  created_at timestamptz not null default now(),
  uploaded_at timestamptz,
  updated_at timestamptz not null default now(),
  is_deleted boolean not null default false,
  deleted_at timestamptz,
  delete_expires_at timestamptz,
  deleted_by uuid references public.user_profiles(id),
  restored_at timestamptz,
  permanently_deleted_at timestamptz,

  constraint media_files_file_size_check check (file_size_bytes > 0)
);

-- =========================================================
-- 9. Indexes
-- =========================================================

create index if not exists user_profiles_email_idx
on public.user_profiles (email);

create index if not exists albums_owner_id_idx
on public.albums (owner_id);

create index if not exists albums_is_deleted_idx
on public.albums (is_deleted);

create index if not exists albums_updated_at_idx
on public.albums (updated_at);

create index if not exists album_members_album_id_idx
on public.album_members (album_id);

create index if not exists album_members_user_id_idx
on public.album_members (user_id);

create index if not exists album_members_album_user_idx
on public.album_members (album_id, user_id);

create index if not exists album_members_album_role_idx
on public.album_members (album_id, role);

create index if not exists storage_objects_provider_id_idx
on public.storage_objects (provider_id);

create index if not exists media_files_album_id_idx
on public.media_files (album_id);

create index if not exists media_files_uploader_id_idx
on public.media_files (uploader_id);

create index if not exists media_files_album_deleted_idx
on public.media_files (album_id, is_deleted);

create index if not exists media_files_upload_status_idx
on public.media_files (upload_status);

create index if not exists media_files_delete_expires_at_idx
on public.media_files (delete_expires_at);

-- =========================================================
-- 10. Helper Function: update updated_at
-- =========================================================

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- =========================================================
-- 11. updated_at Triggers
-- =========================================================

drop trigger if exists set_user_profiles_updated_at on public.user_profiles;
create trigger set_user_profiles_updated_at
before update on public.user_profiles
for each row
execute function public.set_updated_at();

drop trigger if exists set_albums_updated_at on public.albums;
create trigger set_albums_updated_at
before update on public.albums
for each row
execute function public.set_updated_at();

drop trigger if exists set_media_files_updated_at on public.media_files;
create trigger set_media_files_updated_at
before update on public.media_files
for each row
execute function public.set_updated_at();

-- =========================================================
-- 12. Helper Function: is_album_member
-- =========================================================

create or replace function public.is_album_member(
  target_album_id uuid,
  target_user_id uuid
)
returns boolean
language sql
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.album_members am
    join public.albums a on a.id = am.album_id
    where am.album_id = target_album_id
      and am.user_id = target_user_id
      and am.is_active = true
      and a.is_deleted = false
  );
$$;

-- =========================================================
-- 13. Helper Function: get_album_role
-- =========================================================

create or replace function public.get_album_role(
  target_album_id uuid,
  target_user_id uuid
)
returns public.album_role
language sql
security definer
set search_path = public
as $$
  select am.role
  from public.album_members am
  join public.albums a on a.id = am.album_id
  where am.album_id = target_album_id
    and am.user_id = target_user_id
    and am.is_active = true
    and a.is_deleted = false
  limit 1;
$$;

-- =========================================================
-- 14. Helper Function: is_album_admin
-- =========================================================

create or replace function public.is_album_admin(
  target_album_id uuid,
  target_user_id uuid
)
returns boolean
language sql
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.album_members am
    join public.albums a on a.id = am.album_id
    where am.album_id = target_album_id
      and am.user_id = target_user_id
      and am.role = 'admin'
      and am.is_active = true
      and a.is_deleted = false
  );
$$;

-- =========================================================
-- 15. Helper Function: can_upload_to_album
-- =========================================================

create or replace function public.can_upload_to_album(
  target_album_id uuid,
  target_user_id uuid
)
returns boolean
language sql
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.album_members am
    join public.albums a on a.id = am.album_id
    where am.album_id = target_album_id
      and am.user_id = target_user_id
      and am.role in ('admin', 'contributor')
      and am.is_active = true
      and a.is_deleted = false
  );
$$;

-- =========================================================
-- 16. Helper Function: is_file_uploader
-- =========================================================

create or replace function public.is_file_uploader(
  target_media_file_id uuid,
  target_user_id uuid
)
returns boolean
language sql
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.media_files mf
    where mf.id = target_media_file_id
      and mf.uploader_id = target_user_id
  );
$$;

-- =========================================================
-- 17. Helper Function: album_has_other_admin
-- =========================================================

create or replace function public.album_has_other_admin(
  target_album_id uuid,
  target_user_id uuid
)
returns boolean
language sql
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.album_members am
    where am.album_id = target_album_id
      and am.user_id <> target_user_id
      and am.role = 'admin'
      and am.is_active = true
  );
$$;

-- =========================================================
-- 18. Enable Row Level Security
-- =========================================================

alter table public.user_profiles enable row level security;
alter table public.storage_providers enable row level security;
alter table public.albums enable row level security;
alter table public.album_members enable row level security;
alter table public.storage_objects enable row level security;
alter table public.media_files enable row level security;

-- =========================================================
-- 19. Drop Existing Policies For Safe Re-Run
-- =========================================================

drop policy if exists "Users can read own profile" on public.user_profiles;
drop policy if exists "Users can insert own profile" on public.user_profiles;
drop policy if exists "Users can update own profile" on public.user_profiles;

drop policy if exists "Users can read active storage providers" on public.storage_providers;

drop policy if exists "Members can read albums" on public.albums;
drop policy if exists "Users can create own albums" on public.albums;
drop policy if exists "Admins can update albums" on public.albums;

drop policy if exists "Members can read album members" on public.album_members;
drop policy if exists "Admins can insert album members" on public.album_members;
drop policy if exists "Admins can update album members" on public.album_members;

drop policy if exists "Members can read storage objects through media files" on public.storage_objects;
drop policy if exists "Uploaders can insert storage objects" on public.storage_objects;

drop policy if exists "Members can read active media files" on public.media_files;
drop policy if exists "Uploaders can read own deleted media files" on public.media_files;
drop policy if exists "Uploaders can insert media files" on public.media_files;
drop policy if exists "Uploaders can update own media files" on public.media_files;

-- =========================================================
-- 20. RLS Policies: user_profiles
-- =========================================================

create policy "Users can read own profile"
on public.user_profiles
for select
to authenticated
using (id = auth.uid());

create policy "Users can insert own profile"
on public.user_profiles
for insert
to authenticated
with check (id = auth.uid());

create policy "Users can update own profile"
on public.user_profiles
for update
to authenticated
using (id = auth.uid())
with check (id = auth.uid());

-- =========================================================
-- 21. RLS Policies: storage_providers
-- =========================================================

create policy "Users can read active storage providers"
on public.storage_providers
for select
to authenticated
using (is_active = true);

-- Inserts and updates for storage_providers should be service-role only.

-- =========================================================
-- 22. RLS Policies: albums
-- =========================================================

create policy "Members can read albums"
on public.albums
for select
to authenticated
using (
  public.is_album_member(id, auth.uid()) = true
);

create policy "Users can create own albums"
on public.albums
for insert
to authenticated
with check (
  owner_id = auth.uid()
);

create policy "Admins can update albums"
on public.albums
for update
to authenticated
using (
  public.is_album_admin(id, auth.uid()) = true
)
with check (
  public.is_album_admin(id, auth.uid()) = true
);

-- =========================================================
-- 23. RLS Policies: album_members
-- =========================================================

create policy "Members can read album members"
on public.album_members
for select
to authenticated
using (
  public.is_album_member(album_id, auth.uid()) = true
);

create policy "Admins can insert album members"
on public.album_members
for insert
to authenticated
with check (
  public.is_album_admin(album_id, auth.uid()) = true
);

create policy "Admins can update album members"
on public.album_members
for update
to authenticated
using (
  public.is_album_admin(album_id, auth.uid()) = true
)
with check (
  public.is_album_admin(album_id, auth.uid()) = true
);

-- Important:
-- During album creation, creator membership may be inserted by an Edge Function
-- using the service role key.
-- This is why service role is needed for create-album.

-- =========================================================
-- 24. RLS Policies: storage_objects
-- =========================================================

create policy "Members can read storage objects through media files"
on public.storage_objects
for select
to authenticated
using (
  exists (
    select 1
    from public.media_files mf
    where mf.storage_object_id = storage_objects.id
      and public.is_album_member(mf.album_id, auth.uid()) = true
      and mf.upload_status = 'completed'
      and mf.is_deleted = false
      and mf.permanently_deleted_at is null
  )
);

create policy "Uploaders can insert storage objects"
on public.storage_objects
for insert
to authenticated
with check (
  file_size_bytes >= 0
);

-- Important:
-- In final implementation, storage object inserts should preferably happen
-- through Edge Functions using service role.
-- This policy is permissive for Sprint 1 testing only if direct insert is needed.

-- =========================================================
-- 25. RLS Policies: media_files
-- =========================================================

create policy "Members can read active media files"
on public.media_files
for select
to authenticated
using (
  public.is_album_member(album_id, auth.uid()) = true
  and upload_status = 'completed'
  and is_deleted = false
  and permanently_deleted_at is null
);

create policy "Uploaders can read own deleted media files"
on public.media_files
for select
to authenticated
using (
  uploader_id = auth.uid()
  and is_deleted = true
  and permanently_deleted_at is null
);

create policy "Uploaders can insert media files"
on public.media_files
for insert
to authenticated
with check (
  uploader_id = auth.uid()
  and public.can_upload_to_album(album_id, auth.uid()) = true
);

create policy "Uploaders can update own media files"
on public.media_files
for update
to authenticated
using (
  uploader_id = auth.uid()
)
with check (
  uploader_id = auth.uid()
);

-- =========================================================
-- 26. Seed Storage Provider
-- =========================================================

insert into public.storage_providers (name, type, is_active)
select 'Google Drive Main', 'google_drive', true
where not exists (
  select 1
  from public.storage_providers
  where type = 'google_drive'
    and name = 'Google Drive Main'
);

-- =========================================================
-- 27. End of Migration
-- =========================================================
```

---

## 5. Important Notes About This SQL

### 5.1 This Is for Sprint 1 Only

This migration is enough for the first proof:

* Login
* Profile
* Albums
* Album membership
* Storage object records
* Media file records

It does not yet include full app features.

---

### 5.2 Edge Functions Still Needed

This SQL does not replace Edge Functions.

Sprint 1 still needs these Edge Functions:

1. `create-user-profile`
2. `create-album`
3. `test-google-drive-connection`
4. `create-upload-session`
5. `complete-upload`
6. `get-download-access`

---

### 5.3 Service Role Still Needed

Some actions are better done through Edge Functions using the Supabase service role key.

Examples:

* Create album and creator membership together
* Insert storage object safely
* Create upload session
* Complete upload
* Generate download access

Never put the service role key in Flutter.

---

### 5.4 Storage Object Insert Policy Is Temporary

This SQL includes:

```sql
create policy "Uploaders can insert storage objects"
```

This is useful for early Sprint 1 testing.

But for production, storage object creation should happen through Edge Functions only.

Later, we may remove or tighten this policy.

---

## 6. Minimum Test Data Flow

After running the migration:

### Step 1

User logs in with Google.

### Step 2

Create `user_profiles` record.

### Step 3

Create album.

### Step 4

Add creator to `album_members` as:

```text
admin
```

### Step 5

Upload file to Google Drive.

### Step 6

Create `storage_objects` record.

### Step 7

Create `media_files` record.

### Step 8

Download original file through backend.

---

## 7. Sprint 1 RLS Test Checklist

Test these after running migration.

### 7.1 User Profile

* User can read own profile.
* User can update own profile.
* User cannot update another profile.

### 7.2 Albums

* User can create own album.
* User can read album where they are member.
* Non-member cannot read album.

### 7.3 Album Members

* Member can read member list.
* Non-member cannot read member list.
* Admin can update album members.
* Non-admin cannot manage members.

### 7.4 Media Files

* Admin can insert media file.
* Contributor can insert media file later if role exists.
* Viewer cannot insert media file.
* Album member can read completed active file.
* Non-member cannot read media file.
* Uploader can read own deleted files.

### 7.5 Storage Objects

* Album member can read storage object only through accessible media file.
* Non-member cannot read storage object.
* Storage object does not expose secret credentials.

---

## 8. Sprint 1 Done Criteria for Database

The database setup is done when:

* All Sprint 1 tables exist.
* Enums exist.
* Indexes exist.
* Helper functions exist.
* RLS is enabled.
* RLS policies work.
* Google Drive Main storage provider is seeded.
* Non-member access is blocked.
* User can create album through Edge Function.
* User can upload file metadata through Edge Function.
* User can read completed media files in their album.

---

## 9. Next Recommended Document

The next recommended document is:

**Potoos Edge Functions Implementation Plan v1.0**

This document should define the exact implementation plan for Sprint 1 Edge Functions:

* `create-user-profile`
* `create-album`
* `test-google-drive-connection`
* `create-upload-session`
* `complete-upload`
* `get-download-access`

It should also include:

* Folder structure
* Required environment variables
* Request validation
* Permission checks
* Google Drive helper structure
* Error handling
