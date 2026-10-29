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

### Home redesign (2026-10-28)

- Member and guest home now follow the app redesign frames, preserving the existing tabs and live fund/hotel lists. Old home sections are detached from this page; external implementations remain.
- Service introduction and rank details now have public pages at `/home/service` and `/home/ranks`, with localized Figma content, back navigation and registration/fund actions. Rank values remain provisional display content, not eligibility rules. Simulation/miles features remain pending.
- Later user-confirmed home composition hides hotels and the miles card and shows simulation for both auth states; external implementations are retained.
- See [Home redesign](home-redesign.md) for scope, assets and validation.

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

### 2026-10-28 酒店首页范围

普通酒店首页及卡片按 Figma 更新，搜索/分页/刷新继续用现有接口。新增 `/hotel-booking/host-miles` 设计预览页（明确示例标记，按钮禁用），不复用旧住宿优待作为里程资格，不实现后续预约。实现边界与验证见 `docs/hotel-booking-roadmap.md` 的本日记录。

### 2026-10-29 新功能数据层

已新增宿主マイル权益和资产收益统计的11个SDK读取接口及App领域/data层，详见 [StellaVia 数据接入](stellavia-data-integration.md)。余额、过期提醒与等级规则已从最新Swagger补齐。仅依赖注入，不触发页面请求；UI由用户后续逐页指派。10-15讨论已确认stayBenefit=true可用于宿主マイル、多晚查询，修正上面的10-28预览时期判断；旧单晚UI尚待后续改版。

### 2026-10-29 首页数据接入

登录首页现有里程卡已绑定availablePoints，公开等级预览已绑定listRules；只接现有首页可展示数据，详情页/试算/预约由后续指派。账户隔离、错误保留旧值和重试、下拉/Tab/页面返回/前台刷新已补齐，见 [Home redesign](home-redesign.md) 的本日数据接入记录。

### 2026-10-29 首页试算器

已实现 Figma 13 的 `/home/simulation` 公共页面及首页入口。输入金额/年利率/期限/分红类型实时计算税前单利；里程使用公开 listRules 的月 pointRate。用户授权晚数先使用 10,000 mile/晚示例参数，页面明确说明。具体公式、边界与验证见 `docs/home-redesign.md` 的同日试算器章节。后续真实兑换标准明确后替换参数，不将此假设用于预约提交。

### 2026-10-29 本期 UI 基础能力收敛

首页/服务/等级/酒店首页文字样式已集中到 feature support；SDK AppCard 增加可选表面与几何配置，并新增 AppSlider、AppTwoLineSegmentedControl，已回接本期页面。业务组合仍归 feature。维护路径和兼容边界见 `docs/stellavia-shared-components.md` 的同日章节。

### 2026-10-29 试算器 Web 规则对齐

试算器结果改为 FINANCIAL RETURN 配当 / EXPERIENCE RETURN 宿主優待；展示实际期间累计配当、领取时机、等级月率/月里程/累计里程。删除之前每晚10,000里程假设及晚数，用户确认不加入示例酒店。App仍实时计算。Web算法来源与边界见 `docs/home-redesign.md` 最新章节。

### 2026-10-29 宿主マイル酒店首页

酒店里程首页已接真实余额/等级/剩余室数与stayBenefit=true酒店列表，支持多晚查询和分页。保留未确认所需里程为未知，预定入口禁用。数据隔离/刷新/错误边界见hotel-booking-roadmap.md最新章节。

### 2026-10-29 My Page 图表接入

My Page资产区已替换为运用残高、累计配当、累计宿主マイル三张真实数据图表，默认近5年，可分别切换1/3/5年。使用既有历史基金资产、累计收益和累计里程接口；保留刷新失败缓存、账号隔离及根Tab刷新。旧走势图实现保留，其他My Page内容本轮不改。字段口径与验证见 [StellaVia 数据接入](stellavia-data-integration.md) 最新章节。

### 2026-10-29 My Page 等级卡

My Page新增真实等级/可用里程/月获得率/升级差额/室数/过期摘要，复用现有等级说明页并提供过期明细弹层。最高等级采用接口MAX标记。过期汇总未确认一个月口径，文案暂为“即将失效”。字段、进度与验证见StellaVia数据接入文档最新章节。

### 2026-10-29 TabBar 设计与入口调整

用户确认同时调整外观及Tab内容。可见顺序为首页、基金、酒店、住宿管理、My Page；图标使用Figma 01 ホーム（サマリー）的原SVG。SDK通用AppBottomTabBar负责外观与SafeArea，App负责映射。住宿管理使用/bookings复用现有酒店订单列表，旧/hotel-booking/orders及详情路径重定向兼容。KIZUNARK保留第6个不可见分支及原/discussion-board路由，以保留旧功能/深链接，不出现在可见Tab中。原先“Tab不动”的范围限制由本次明确授权更新。

### 2026-10-29 My Page summary design
- My Page uses the white asset summary header from Figma `8038:31937`, with existing verification status semantics (4 verified, 2/5 pending, otherwise unverified), notifications/settings, amount visibility, and guarded withdrawal/deposit actions.
- Feature widgets `MyPageAssetSummary` and `MyPageHoldingCard` reuse SDK primitives/tokens. Legacy asset overview and active-fund card implementations remain available; My Page switches to the new compositions.
- Holding cards use real project photos, status, invested amount/units, dividends and scheduled period. Missing period displays a dash; no fabricated hotel subtitle. Existing record selection and detail routing remain unchanged.
- Transaction history is unchanged; membership card and three charts remain integrated. Four locales updated.
