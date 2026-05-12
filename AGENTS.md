@/Users/aaronhou/.codex/RTK.md

# Project Rules For Codex

This repository is a long-running Flutter app project. Do not rely on chat history as the only source of truth. Before major work, read the relevant docs and update them when decisions change.

## Required Reading

For any non-trivial task:

1. `docs/ai-project-control.md`
2. `ARCHITECTURE_IMPLEMENTATION.md` when architecture/API layering is involved
3. Module roadmap, when present:
   - `docs/hotel-booking-roadmap.md` for hotel booking
   - `docs/github-actions-release-flow.md` for CI/release/signing/upload work

## Repository Shape

- App: `fundex/`
- Shared SDK: `mobile_core_sdk/`
- App features use Clean Architecture: `data / domain / presentation`.
- Shared UI and visual tokens belong in `mobile_core_sdk/packages/core_ui_kit` when reusable.
- Shared API clients, DTOs, envelope parsing, and cross-app service logic belong in `mobile_core_sdk/packages/company_api_runtime` when reusable.

## Thread Model

Use a control-thread plus task-thread workflow:

- Control thread: direction, planning, module memory, roadmap/docs.
- Task thread: one concrete implementation ticket.
- End every task with changed files, behavior summary, validation results, and doc updates if needed.

## Command Rules

- Prefix shell commands with `rtk`.
- Use `fvm` for Flutter/Dart commands.
- Run targeted validation for touched files before final response.
- For l10n changes, run from `fundex`:

```bash
rtk fvm flutter gen-l10n
```

## Architecture Rules

- Keep dependency direction clean: `presentation -> domain <- data`.
- Domain must not depend on Flutter/Dio/UI packages.
- Remote data sources should be thin adapters over SDK clients when possible.
- Do not duplicate envelope parsing in app feature code if `company_api_runtime` can own it.
- Keep view files focused on layout and event binding. Move display mapping/formatting into `presentation/support`, state into controllers/providers, and reusable logic into domain/utils or SDK.
- Avoid broad refactors in task threads unless the user explicitly asks.

## UI Rules

- Reuse `core_ui_kit` tokens/components before creating page-local styles.
- Do not hardcode colors/fonts/shadows in business pages unless there is a scoped reason.
- Shared controls such as dialogs, bottom sheets, copy buttons, avatar, cards, PDF/image viewers should live in SDK if reused.
- For frontend/design work, preserve the established StellaVia visual language unless the user asks for a new direction.
- Root tab pages should support refresh behavior and should not clear useful old content on transient network failure unless explicitly intended.

## Localization Rules

- User-facing text must be localized in ARB files.
- Edit `fundex/lib/l10n/app_*.arb`; then run `fvm flutter gen-l10n`.
- Do not manually edit generated `app_localizations*.dart` unless generation is blocked.

## Current Business Rules To Preserve

- Phone verification: `/member/login/index` `phone` non-empty means verified. `mobileAuth` is not used, and there is no fallback to `mobile` for verification.
- Fund detail distribution section: use `periodType` with `SEASON` and `YEAR`; render under basic info with `FundDetailInfoTable(columns: 1)`.
- Auth/token refresh: 401 should attempt refresh when refresh token exists; failed refresh should route through centralized auth failure handling.
- Push token sync: account changes should force backend sync even if the device token did not change.
- Member profile protected actions should reuse existing guard providers instead of duplicating checks.

## Hotel Booking Rules

- Start hotel work from `docs/hotel-booking-roadmap.md`.
- Current hotel module is only a placeholder tab with profile guard demonstration.
- Hotel API contract source of truth is the hotel Swagger:
  - Swagger UI: `https://hotel-sit.gutingjun.com/api/swagger-ui/index.html#/`
  - OpenAPI JSON: `https://hotel-sit.gutingjun.com/api/v3/api-docs`
- Legacy feature behavior can reference the old app:
  - API paths: `/Users/aaronhou/Documents/financing-flutter-getx/lib/app/config/http_conf.dart`
  - Legacy feature flow: `/Users/aaronhou/Documents/financing-flutter-getx/lib/app/modules/hotel`
- Use the old app for flow order and behavior only when Swagger does not explain product behavior.
- Do not copy the old app's GetX architecture, untyped map parsing, route structure, or UI implementation style.
- New hotel code must use current app architecture: Clean Architecture, Riverpod, typed DTO/entity mapping, SDK API clients where reusable, and `core_ui_kit` UI primitives.
- Confirm hotel API cluster, envelope success code, pagination, auth requirement, and payment model before implementing booking submission.
- Browsing, booking draft, booking submit, payment, and order management should be split into separate task threads.

## Git / Safety

- The worktree may contain user edits. Do not revert unrelated changes.
- Do not run destructive git commands unless explicitly requested.
- Do not amend commits unless explicitly requested.
- If unexpected changes appear in files you are editing, stop and ask how to proceed.
