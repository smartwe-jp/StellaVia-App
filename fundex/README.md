# FUNDEX

Flutter business template repository for membership investment + hotel booking style apps.

## Principles

- Clean Architecture in each feature: `presentation/domain/data`
- Riverpod as single state-management model
- UI and business logic both testable
- Core capabilities imported from `mobile_core_sdk`

## Logging & Error Infrastructure

- Uses `core_tool_kit` `FileAppLogger` (`logging` package based) as unified log entry.
- Logs are persisted to local files (daily rotation by date).
- Supports log export API: `ref.read(appLoggerProvider).exportLogs()`.
- Global UI error messages are shown via root `ScaffoldMessenger`.

## Suggested modules

- `feature_auth`
- `feature_hotel`
- `feature_financial`
- `feature_notice_contract`
- `feature_identity_legal`
- `feature_profile`

## Structure

```text
lib/
  app/
    app.dart
    bootstrap.dart
    router/
  features/
    auth/
      data/
      domain/
      presentation/
```

## Commands (FVM)

```bash
fvm use 3.35.1
fvm flutter pub get
fvm flutter run
fvm flutter test
```

## Flavor & Environment

The template provides three runtime flavors via separate entrypoints:

- `lib/main_dev.dart`
- `lib/main_staging.dart`
- `lib/main_prod.dart`

Native alignment:

- Android `productFlavors`: `dev`, `staging`, `prod`
- iOS schemes: `dev`, `staging`, `prod`

Default environment values are defined in `lib/app/config/app_environment.dart`.

Current default environment values:

- `dev/staging`
  - `API_BASE_URL=https://sit-new.gutingjun.com/api`
  - `HOTEL_API_BASE_URL=https://hotel-sit.gutingjun.com/api`
  - `OA_API_BASE_URL=https://testoa.gutingjun.com/api`
- `prod`
  - `API_BASE_URL=https://new.gutingjun.com/api`
  - `HOTEL_API_BASE_URL=https://hotel.gutingjun.com/api`
  - `OA_API_BASE_URL=https://oa.gutingjun.com/api`

## Funding API Source Of Truth (Auth/User)

For funding/member-related APIs (including login/register/user profile), the
source of truth is the funding Swagger docs, not the legacy GetX project:

- Swagger UI: `https://sit-admin.gutingjun.com/api/swagger-ui.html#/`
- OpenAPI JSON: `https://sit-admin.gutingjun.com/api/crowdfunding/v2/api-docs`
- Main modules for user-related work:
  - `user-rest`
  - `off-rest`

Implementation rules and source governance are documented in:

- `docs/api_source_of_truth.md`
- `README_API.md` (captured request/response samples supplementing Swagger)

Current implemented auth paths (transitional, pending Swagger-by-module cleanup):

- `mss/smsCode`
- `member/user/emailLoginCode`
- `uaa/oauth/token` (login + refresh token)

Run examples:

```bash
# dev
fvm flutter run --flavor dev -t lib/main_dev.dart

# staging
fvm flutter run --flavor staging -t lib/main_staging.dart

# prod
fvm flutter run --flavor prod -t lib/main_prod.dart
```

Override API endpoints with `--dart-define`:

```bash
fvm flutter run --flavor staging -t lib/main_staging.dart \
  --dart-define=API_BASE_URL=https://sit-new.gutingjun.com/api \
  --dart-define=HOTEL_API_BASE_URL=https://hotel-sit.gutingjun.com/api \
  --dart-define=OA_API_BASE_URL=https://testoa.gutingjun.com/api \
  --dart-define=ENABLE_HTTP_LOG=true
```

## Quick Run Scripts (Aliyun Push)

To avoid long `--dart-define` commands, this repo provides scripts:

```bash
./scripts/run_dev.sh
./scripts/run_staging.sh
./scripts/run_prod.sh
```

If local define file is missing, create it once:

```bash
cp .vscode/dart_define.dev.example.json .vscode/dart_define.dev.local.json
cp .vscode/dart_define.staging.example.json .vscode/dart_define.staging.local.json
cp .vscode/dart_define.prod.example.json .vscode/dart_define.prod.local.json
```

强制阻止使用：
{
  "PUSH_ACTION": "app_block",
  "PUSH_ID": "block-20260425",
  "TITLE": "アプリの切り替えが必要です",
  "BODY": "指定されたアプリをご利用ください。",
  "IOS_URL": "https://apps.apple.com/...",
  "ANDROID_URL": "https://play.google.com/store/apps/details?id=...",
  "DISMISSIBLE": "false",
  "SHOW_ONCE": "false"
}
版本更新：
{
  "PUSH_ACTION": "app_update",
  "PUSH_ID": "update-1.0.70",
  "TITLE": "新しいバージョンがあります",
  "BODY": "更新内容...",
  "IOS_URL": "https://apps.apple.com/...",
  "ANDROID_URL": "https://play.google.com/store/apps/details?id=...",
  "DISMISSIBLE": "true"
}
活动弹框：
{
  "PUSH_ACTION": "campaign_dialog",
  "PUSH_ID": "campaign-001",
  "TITLE": "キャンペーンのお知らせ",
  "BODY": "活動内容...",
  "IMAGE_URL": "https://example.com/campaign.jpg"
}
奖励动画

{
  TARGET_PAGE:"homeCelebration"
  LOTTIE_URL:"https://stellavia.co.jp/Gift_box_with_coupon.json"
}