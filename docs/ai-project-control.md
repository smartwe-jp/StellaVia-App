# AI Project Control Playbook

Last updated: 2026-08-14

This document is the control-plane memory for long-running AI-assisted work in this repository. It should be read at the start of any major new thread, especially when starting a new feature module such as hotel booking.

## Operating Model

Use three layers of coordination:

1. Control thread
   - Owns product direction, architecture decisions, module boundaries, and memory updates.
   - Produces or updates docs under `docs/`.
   - Does not try to implement every small UI/API task in the same thread.

2. Task thread
   - Owns one concrete ticket: one API slice, one page, one bug, one UI refinement, or one test/CI improvement.
   - Starts by reading this file, `AGENTS.md`, and any module-specific doc such as `docs/hotel-booking-roadmap.md`.
   - Ends with implemented changes, targeted validation, and doc updates if behavior or architecture changed.

3. `AGENTS.md`
   - Acts as the team rulebook for every Codex run in this repo.
   - Stores stable engineering rules, not temporary product brainstorming.

## Current Repository Shape

- App: `fundex/`
- Shared SDK: `mobile_core_sdk/`
- Main architecture: Clean Architecture + Riverpod.
- Main feature layout: `data / domain / presentation` inside each feature.
- Shared UI, tokens, dialogs, cards, avatar, PDF/image/video helpers live in `mobile_core_sdk/packages/core_ui_kit`.
- Shared API clients, DTOs, envelope parsing, push sync, auth, investment, wallet, member profile and contact clients live in `mobile_core_sdk/packages/company_api_runtime`.
- Release/CI documentation lives in `docs/github-actions-release-flow.md`.

## Current Implemented Areas

### StellaVia Theme Foundation (2026-10-23)

- The shared theme now follows the Figma StellaVia guideline: Purple `#4C0679` actions, Navy `#070E2B` text, Violet `#9652C2` accents, white pages/cards, and Cream `#EEE9E1` alternate surfaces.
- Japanese uses bundled Zen Kaku Gothic Antique; English and numeric styles use bundled Jost. Chinese keeps Noto Sans SC/TC and existing glyph fallbacks.
- Dark mode is an app adaptation, not a supplied Figma design: layered navy surfaces, violet filled actions with white text, and lilac links.
- Material ColorScheme, Cupertino accent, semantic text/color extensions, auth and hotel theme adapters use the updated palette. Legacy token names remain compatible.
- Scope is theme foundation only. Component geometry, individual page layouts, fund status rules, rank/mileage features and registration steps remain separate tasks. Semantic success/warning/error colors remain functional exceptions to the brand palette.
- See [StellaVia theme foundation](stellavia-theme-foundation.md) for mappings, font sources, validation, and remaining visual migration boundaries.

### StellaVia Shared Primitives (2026-10-23)

- `core_ui_kit` now exports `AppButton`, `AppTextField` / `AppFieldLabel`, `AppCard`, `AppStatusBadge`, `AppProgressBar`, `AppSectionHeader` / `AppBrandHeading`; existing `AppStepProgressBar` remains the generic segmented progress control.
- Native Material button/input themes and compatible legacy CTA, input, panel and section-heading adapters share these styles. Labels, validation and actions are supplied by callers; no app routes or domain status codes enter the primitives.
- Page/feature-specific secondary compositions stay in the owning feature's `presentation/widgets`, with mappings in `presentation/support`. Do not grow the legacy business-specific SDK widget files. Existing business compositions are migrated with their owning module, not by an unrelated bulk refactor.
- Component API, scope and validation are recorded in [StellaVia shared components](stellavia-shared-components.md).

### App Infrastructure

- Flavor/config/router/bootstrap structure exists in `fundex/lib/app`.
- Routing uses `go_router` with `StatefulShellRoute.indexedStack` for root tabs.
- Global auth redirect is centralized in `fundex/lib/app/router/app_router.dart`.
- Network cluster selection and auth failure handling live under `fundex/lib/app/network` and `core_network`.
- Push runtime supports Aliyun/Firebase abstraction; current runtime selection and token sync are under `fundex/lib/app/firebase` and `fundex/lib/app/push`.
- L10n uses ARB files in `fundex/lib/l10n` and generated `app_localizations*.dart`.

### Auth / Member Profile / Guarding

- Active login/register flow uses email registration and unified `/login` flow.
- OAuth client authorization uses the StellaVia Basic authorization value in SDK auth client.
- Token refresh is implemented in `core_network`; 401 retry requests carry `token_retry_attempt`. Endpoints affected by stale JWT permission claims may explicitly opt into one 403 refresh/retry with `refreshOnForbidden`; ordinary 403 responses remain permission failures, and this compatibility retry never clears the session on failure.
- Phone verification rule is strict: `/member/login/index` `phone` non-empty means verified. `mobileAuth` is not used for phone verification.
- Member profile completion and protected action guards are reused by booking-like flows through `memberProfileActionGuardProvider`.
- Face verification and legacy profile steps have been reduced according to recent product decisions.

### Fund / Investment

- Fund list, fund detail, lottery apply, deposit flow, my page investment status, active fund detail, benefit report, secondary market, and related wallet flows are implemented.
- Fund detail uses `FundProjectDetailViewData` to convert project/entity data into display items.
- Fund detail basic info uses `FundDetailInfoTable`; one-column detail sections should reuse `FundDetailInfoTable(columns: 1)` instead of custom table styles.
- `periodType` in project detail drives distribution calculation period display:
  - `SEASON`: natural-quarter text.
  - `YEAR`: natural-year text.
- Fund detail video behavior:
  - Direct video resources use in-app playback.
  - YouTube links use `youtube_player_flutter`.
  - Non-resource external links use a reference-video row with a browser action.
- Fund image display uses cached image provider patterns to reduce placeholder flicker.
- Fund detail and lottery-application initial loading states retain a back action. Their full-page load failures show both retry and back actions, with direct-entry fallbacks to the funds flow.

### Wallet / Deposit / Withdraw

- Wallet/deposit/withdraw feature has domain/data/presentation layers.
- Deposit transfer notice and copy support are shared through wallet support/widgets.
- Standby-fund purchase uses `api/member/wx/account/auto-fund-dudection` with `processId`.
- Withdraw requires verified profile/identity status according to current guard rules.
- Bank-account name matching tolerates kanji/English/katakana, surname order, spaces, case, and kana differences according to the implemented matcher.

### Discussion / KIZUNARK

- Discussion board has remote/local data source, repository, controller, state, and UI list/composer structures.
- Avatar display uses shared SDK user-avatar UI and default avatar assets.
- Associated fund selection should follow mypage/investment list data and card patterns where practical.

### Stay Benefit Lottery

- The home lottery entry bar is implemented and currently defaults to visible; its visibility provider is the future API integration seam.
- Reusable presentation-layer lottery models, draw controller, mock draw source, and animated wheel live under `fundex/lib/features/benefit_lottery`.
- The dialog and status-page draw actions share `BenefitLotteryDrawButton`, including the loading spinner, disabled state, sizing, and StellaVia button styling.
- The wheel supports 2 to 8 segments and requires exactly one zero-price no-win segment.
- When a no-win result finishes spinning, the reusable wheel shows a localized toast over the wheel surface using fade, upward-slide, and scale animation; it automatically fades out after a short display period and also clears immediately when the next draw begins.
- When a prize result finishes spinning, both lottery hosts play the global network `.lottie` celebration once, then show the localized design-matched winning dialog. Confirming closes the lottery dialog when applicable and navigates to `/hotel-booking/coupons`.
- The draw controller never selects a prize locally. It animates to the prize ID returned by the injected draw request; only the temporary mock source performs random selection.
- Tapping the home lottery entry opens the content-sized lottery dialog with 16-point horizontal insets. The dialog currently uses a six-segment mock catalog; after each wheel animation the primary action returns to the draw state so another draw can start without closing the dialog.
- The dialog details action opens `/home/benefit-lottery/status`, whose page title is `優待ステータス` in Japanese.
- The status page currently derives eligibility from `myPageInvestmentListProvider` and checks whether the authenticated user has at least one operating investment record (`MyPageInvestmentRecord.projectStatus == 4`). This is a temporary adapter until the lottery eligibility API exists.
- Eligible users see the reusable wheel, evaluation factors, the mock prize catalog, mock winning history, and usage rules. Ineligible users see the locked wheel and investment CTA design.
- Tapping an available winning-history voucher switches to the Hotel tab and opens `/hotel-booking/stay-benefits`; used and expired entries remain non-interactive.
- The benefit-lottery status loading state retains its page header and back action. Its full-page load failure shows both retry and back actions, with a direct-entry fallback to `/home`.
- Evaluation copy, usage rules, prize notices, locked-state copy, and temporary winning-history data are localized in `fundex/assets/content/benefit_lottery_status_content.json`; headings and UI actions remain in ARB localization.
- Prize-list and winning-history backend integration plus final result presentation are not implemented yet.

### Settings / Documents / Contact

- Settings contains FAQ, company information, contract documents, contact form, phone/email verification, and face verification pages.
- Static documents should use localized URL suffixes where available.
- Contact form has confirmation and success flow.
- Company info includes email link behavior.

### Release / CI

- GitHub Actions flow is documented in `docs/github-actions-release-flow.md`.
- CI runs `flutter pub get`, `flutter gen-l10n`, `flutter analyze`, and `flutter test` under `fundex`.
- Release workflow builds Android AAB and iOS IPA from prod flavor with signing/upload secrets.

## Current Hotel Booking State

- Existing module path: `fundex/lib/features/hotel_booking`.
- Current placeholder page file is `presentation/pages/hotel_booking_tab_page.dart`, but it is not wired into the active root tab shell.
- Current `/hotel-booking` route redirects to `/funds`.
- The placeholder page demonstrates use of `memberProfileActionGuardProvider` for protected booking actions.
- SDK-level hotel API client/DTO foundation is implemented under `mobile_core_sdk/packages/company_api_runtime/lib/src/hotel`.
- No app-side hotel entities, repository, providers, or booking flow pages are implemented yet.
- Hotel API contract source of truth is the hotel Swagger:
  - Swagger UI: `https://hotel-sit.gutingjun.com/api/swagger-ui/index.html#/`
  - OpenAPI JSON: `https://hotel-sit.gutingjun.com/api/v3/api-docs`
- Legacy hotel behavior can be checked from the old app references:
  - API paths: `/Users/aaronhou/Documents/financing-flutter-getx/lib/app/config/http_conf.dart`
  - Legacy hotel module: `/Users/aaronhou/Documents/financing-flutter-getx/lib/app/modules/hotel`
- The old app is only a functional/behavior reference. Do not copy its GetX architecture, untyped map parsing, route structure, or UI implementation style.

## Architecture Rules To Preserve

1. Keep feature boundaries clear.
   - `presentation`: UI, controllers, providers, display state.
   - `domain`: entities, repositories, use cases, pure business rules.
   - `data`: DTOs, remote/local data sources, repository implementations.

2. Push reusable platform/company concerns into SDK.
   - API client, DTO, envelope parsing, pagination parsing, shared UI component, shared formatter, shared copy/avatar/dialog behavior belong in `mobile_core_sdk` when reusable.
   - App feature keeps use cases, orchestration, screen state, and product-specific presentation mapping.

3. Prefer thin remote data sources.
   - App data source should delegate to `company_api_runtime` clients when an SDK client exists.
   - Avoid duplicating envelope parsing in feature data sources.

4. Keep UI design-system driven.
   - Reuse `core_ui_kit` tokens/components first.
   - Add shared components to SDK if they will be reused across areas.
   - Business feature pages must not hardcode colors. Use `Theme.of(context)`, `core_ui_kit` tokens/components, or an existing feature theme/helper. Raw `Color(0x...)`, `Colors.*`, and page-local hex constants are exceptions only inside theme/token definitions or when explicitly documented.
   - Avoid hardcoding fonts, shadows, and button styles in business pages unless there is a scoped visual reason.
   - Keep page files focused on screen composition, route argument binding, provider watching, and event wiring. Extract non-trivial child UI into separate files under `presentation/widgets/`, and move display mapping/formatting into `presentation/support`.

5. Always localize user-facing text.
   - Edit ARB files first.
   - Run `fvm flutter gen-l10n` from `fundex`.
   - Never edit generated localization files manually unless generation is impossible.

6. Refresh and cache deliberately.
   - Financial/account/root-tab data should avoid stale state.
   - If preserving old content during network failure, document the cache/refresh behavior.
   - Root tab data should support pull refresh and lifecycle/return refresh where needed.

7. Do not rely on chat history as project memory.
   - Important decisions must be written into `docs/` or `AGENTS.md`.
   - Task-specific implementation notes should be added to the module roadmap or current-state section when they affect future work.

## Task Thread Start Checklist

At the start of a new task thread, provide these inputs or let Codex inspect them:

```text
Repo: /Users/aaronhou/Documents/GitHub/HanjouFinace
Docs to read:
- AGENTS.md
- docs/ai-project-control.md
- docs/hotel-booking-roadmap.md when working on hotel booking
Task goal:
- <one concrete outcome>
Scope:
- <feature/files expected to change>
Validation:
- <targeted analyze/test/build command>
Constraints:
- <business rules, UI reference, API contract, no-go areas>
- UI implementation must use theme/token colors and split non-trivial child widgets into separate files.
```

## Task Thread End Checklist

Each implementation thread should end with:

- Changed files summary.
- Business behavior summary.
- Validation commands and results.
- UI self-check for touched pages: no unintended hardcoded `Color(` / `Colors.` usage, and non-trivial child widgets split into `presentation/widgets/`.
- Any remaining assumptions or backend/API gaps.
- Documentation update if the implementation changed module direction, API contract, shared components, or business rules.

## Documentation Update Rules

Update these files by scope:

- Cross-project AI workflow or engineering rules: `AGENTS.md` and this file.
- Hotel booking module plan/status: `docs/hotel-booking-roadmap.md`.
- Release/CI/signing/upload: `docs/github-actions-release-flow.md`.
- API client/DTO scaffolding pattern: `MANUAL_API_CLIENT_DTO_SCAFFOLD_TEMPLATE.md`.
- Historical architecture baseline: `ARCHITECTURE_IMPLEMENTATION.md` only when changing foundational architecture decisions.
