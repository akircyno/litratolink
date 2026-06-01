-- Require current upload permission before clients can update pending media rows.

drop policy if exists "Uploaders can update own pending media files"
on public.media_files;

create policy "Uploaders can update own pending media files"
on public.media_files
for update
to authenticated
using (
  uploader_id = (select auth.uid())
  and public.can_upload_to_album(album_id, (select auth.uid()))
  and upload_status in ('pending', 'uploading', 'failed')
)
with check (
  uploader_id = (select auth.uid())
  and public.can_upload_to_album(album_id, (select auth.uid()))
  and upload_status in ('pending', 'uploading', 'failed')
);
