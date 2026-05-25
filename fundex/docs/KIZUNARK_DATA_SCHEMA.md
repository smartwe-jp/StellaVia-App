# KIZUNARK Data Schema Draft

## Core Tables

### `kizunark_threads`
- `id` (string, PK)
- `author_id` (string, FK -> users)
- `body` (text)
- `image_urls` (string array)
- `fund_reference_id` (string, nullable)
- `fund_reference_label` (string, nullable)
- `comment_count` (int)
- `created_at` (datetime)
- `updated_at` (datetime)
- `deleted_at` (datetime, nullable)

### `kizunark_replies`
- `id` (string, PK)
- `thread_id` (string, FK -> kizunark_threads)
- `author_id` (string, FK -> users)
- `body` (text)
- `image_urls` (string array)
- `quote_source_text` (string, nullable)
- `quote_body` (text, nullable)
- `quote_image_urls` (string array, nullable)
- `created_at` (datetime)
- `updated_at` (datetime)
- `deleted_at` (datetime, nullable)

### `kizunark_users` (projection from member/account system)
- `id` (string, PK)
- `display_name_masked` (string)
- `account_handle_masked` (string)
- `avatar_text` (string)
- `avatar_gradient_start` (int color)
- `avatar_gradient_end` (int color)
- `badge_label` (string)
- `badge_bg_color` (int color)
- `badge_fg_color` (int color)

## Read/Write Flow (Current App)
1. Load feed request.
2. Read local cache (`discussion_board.threads.<user_scope>`).
3. If cache empty, load static seed (design draft data), save to local cache first, then read back.
4. Update UI from persisted local snapshot.
5. Post/Reply operation writes merged list to local cache first, then UI refreshes from saved snapshot.

## Current Local Mapping
- `DiscussionThread` -> remote root comment row + embedded replies.
- `DiscussionReply` -> remote child comment row.
- `DiscussionQuote` -> quoted comment snapshot, including quoted `imageUrls`.
- `DiscussionAuthor` / `DiscussionAuthorBadge` -> user projection used by UI layer.

## Current API Contract
- Page: `POST /crowdfunding/offline/comment-page`.
- Send: `POST /crowdfunding/comment/send`.
- Send payload uses `content`, optional `projectId`, optional `parentId`, and `imageUrls` as an array of uploaded image URL strings.
- Page rows and nested `quote` rows may include `imageUrls`; `null` maps to an empty list.
- Image send flow: when local image files are attached, compress each file with the shared upload image optimizer until it is under the existing 10MB upload limit, upload the optimized files in one multipart request to `POST /crowdfunding/comment/add-comment-photos` using repeated `files` parts, collect the returned URL array, then pass those URLs as `imageUrls` to `comment/send`.

## Future API Sync Plan
- Pull remote diff by `updated_at`.
- Merge remote -> local (upsert thread/reply).
- Push optimistic local post/reply with temp ids; replace ids after server ack.
- Keep `comment_count` server-authoritative, local increment only as optimistic UI fallback.
