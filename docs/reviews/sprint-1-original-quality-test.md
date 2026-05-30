# Sprint 1 Original Quality Test

Status: pending live upload/download test files.

## Files To Test

- iPhone photo
- Android photo
- Screenshot
- Short video only after video upload is enabled in Sprint scope

## Data To Compare

- Original filename
- Downloaded filename
- Original file size
- Downloaded file size
- Original MIME type
- Downloaded MIME type
- Original resolution
- Downloaded resolution
- Video duration, if video
- SHA-256 checksum, if added later

## Instrumentation Added

Debug-only quality logging records:

- original filename
- original size
- original MIME type
- original local path
- downloaded filename
- downloaded size
- expected stored size
- downloaded MIME type
- downloaded local path
- warning when expected and downloaded sizes differ

## Pass Condition

Downloaded file size and MIME type should match the original metadata. Best case later is checksum equality.
