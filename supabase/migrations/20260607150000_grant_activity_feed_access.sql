-- Allow authenticated clients to use the activity feed tables.
-- RLS policies still decide which rows each user can see or modify.

GRANT SELECT ON public.activity_events TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.user_activity_reads TO authenticated;

GRANT ALL PRIVILEGES ON public.activity_events TO service_role;
GRANT ALL PRIVILEGES ON public.user_activity_reads TO service_role;
