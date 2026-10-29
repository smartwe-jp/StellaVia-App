# Home redesign — 2026-10-28

## Scope and reference

- Member: [首页 · 会员首屏](https://www.figma.com/design/I9xMTxYMyek9AvMWtDvkFi?node-id=8093-578).
- Guest: [12 見つける（ゲストホーム）](https://www.figma.com/design/I9xMTxYMyek9AvMWtDvkFi?node-id=8190-1917).
- Keep the existing root tabs, latest-fund carousel and featured-hotel carousel, their live data and navigation. These explicitly retained lists take precedence over the sample fund layout and absence of hotels in Figma.
- Member home: brand header with notification badge, localized personal greeting, bundled Figma hero photo, fund/hotel quick actions, existing lists, miles summary and rank teaser.
- Guest home: brand/login header, service teaser, existing lists, simulation teaser, rank teaser and a fixed registration action above the existing tab bar.
- Remove the old hero, registration campaign, verification reminder feed, attraction section, investment flow and license/footer from this page only. Their external widgets, routes, verification guards and other feature implementations remain available.

## Pending features

Miles booking and simulation actions still show a localized “coming soon” notice. Miles balance remains unavailable; no account-rank calculation or eligibility policy is implemented.

## Service and rank information pages (2026-10-28)

- [14 宿主優待について（内容紹介）](https://www.figma.com/design/I9xMTxYMyek9AvMWtDvkFi?node-id=8201-760) is implemented at `/home/service`: ABOUT, TWO RETURNS, the five membership tiers and HOW TO START. The Figma photograph (8221:765) is bundled as `assets/images/home_service_about.png`, displayed at 220-point height with cover cropping.
- [15 ランク制度を詳しく見る](https://www.figma.com/design/I9xMTxYMyek9AvMWtDvkFi?node-id=8224-919) is implemented at `/home/ranks`, reusing the feature-owned rank section/cards.
- Both routes are explicitly public and open above the root tab shell. Home entry points use push; the service-page rank button pushes the rank page. Back pops the prior page, retaining service scroll position; direct entry falls back to `/home`.
- Guest service CTA opens `/login?openRegister=1`. For authenticated users it becomes the existing fund-browsing CTA at `/funds`, avoiding an unnecessary registration route.
- Rank thresholds, rates, validity, advance windows and room counts reproduce the design's provisional information. The design's internal-draft/change notice remains visible. These values are presentation content only, not an account state or booking policy. Investment-return copy also follows the supplied design; no live financial calculations or backend contracts are added.
- All copy is localized in the four ARB files. `home_rank_content.dart` maps display content; `home_rank_detail_card.dart`, `home_rank_details_section.dart` and `home_service_sections.dart` own feature UI. Generic cards/buttons/headings continue to use `core_ui_kit`.
- User-confirmed subsequent home changes are preserved: featured hotels are hidden, the miles card is removed from the composition, and simulation is shown in both auth states. Existing hotel construction remains and currently produces an unused-local warning; it was not changed as part of these two pages.


## Implementation

- Page composition: `fundex/lib/features/home/presentation/pages/home_overview_tab_page.dart`.
- Feature widgets: `home_redesign_header`, `home_brand_intro`, `home_quick_actions`, `home_miles_card`, `home_simulation_card`, `home_rank_teaser`.
- Generic buttons/cards and typography use `core_ui_kit`; feature-only background, guest gradient and decorative rank colors are in `presentation/support/home_design_theme.dart`.
- Hero image is the Figma brand photograph (8093:618), bundled as `assets/images/home_member_hero.png` and cropped with BoxFit.cover in the 166-point hero. Guest arrows and calculator are local Figma PNG exports at their design geometry (6×10, 22×22 and 8×14); no temporary Figma URLs are used at runtime.
- Japanese, English, simplified and traditional Chinese strings live in ARB; localization Dart is regenerated.
- Existing pull-refresh/lifecycle-refresh scope and cached-list behavior are preserved. A transient error does not intentionally clear existing fund/hotel content. Tab shell implementation is unchanged.

## Validation

Targeted home analysis, localized small-screen widget rendering, asset rendering, action callback checks and `git diff --check`. Optional section-preview export: `HOME_PREVIEW_DIR=/tmp/stellavia-home-preview fvm flutter test test/features/home/presentation/widgets/home_redesign_test.dart` from `fundex`. Preview renders cover the changed sections; retained network-fed lists and full device/backend behavior need runtime regression.

Results: home and new-test static analysis passed; widget rendering passed for all supported locales at 390 points and 320 points (1.3× text), with the member hero decoded before screenshot export. Member/guest section previews were visually inspected. No raw colors were added to page/widget files; decorative colors are confined to the feature theme. `git diff --check` passed. No physical-device or authenticated backend regression was performed.

Information-page validation: 24 targeted tests passed (auth redirects plus navigation, registration/member CTA, scroll restoration, direct-entry back fallback and four-language narrow-screen rendering at 1.3× text). Full-length service/rank render previews were inspected. New pages/widgets/content and router analysis passed; whole-home analysis retains the user-hidden hotel's unused-variable warning. No physical-device regression was performed.
