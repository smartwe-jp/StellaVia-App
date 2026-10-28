# StellaVia theme foundation

Implemented: 2026-10-23. Scope: colors, typography and light/dark semantic mappings.

## Design reference

- [Brand palette](https://www.figma.com/design/I9xMTxYMyek9AvMWtDvkFi?node-id=6443-29514)
- [Typography](https://www.figma.com/design/I9xMTxYMyek9AvMWtDvkFi?node-id=6443-29624)
- The guideline supplies light-mode colors. Dark mode below is an app adaptation.

## Semantic mapping

| Role | Light | Dark |
| --- | --- | --- |
| Page | White `#FFFFFF` | Navy `#070E2B` |
| Card/dialog surface | White `#FFFFFF` | `#10162E` |
| Alternate surface | Cream `#EEE9E1` | `#1B2038` |
| Primary action fill | Purple `#4C0679` | Violet `#9652C2` |
| Action foreground | White | White |
| Body | Navy `#070E2B` | `#F6F4F8` |
| Secondary/tertiary text | Muted `#5C6070` | `#B9B6C8` |
| Semantic link / text button | Purple | Lilac `#C8ABE2` |
| Border / soft border | Navy 14% / 10% | `#45465A` / `#33364C` |

`#6B6F80` remains available as the guideline's specialized gray token. Generic small text uses Muted because gray on Cream is only approximately 4.13:1. Body, helper and semantic link colors are tested at >=4.5:1 across the three surface roles, as are primary/secondary filled-action foregrounds.

Use `context.appColors` / semantic theme extensions for adaptive surfaces and text. Raw brand tokens are invariant. `primary` is a fill/accent role; use the semantic `link` text style for readable dark-mode links rather than overriding it with the fill color.

Material container/outline/inverse colors and Cupertino accents are mapped explicitly. Default status bars are white with dark icons in light mode and navy with light icons in dark mode; immersive pages retain their own overlay behavior. Existing extension APIs and legacy token aliases remain compatible.

Success, warning and error palettes remain functional exceptions. Rank gold and legacy decorative/travel tokens remain available; page-by-page migration is outside this stage. Auth background gradients now resolve to solid surfaces and decorative orbs are transparent. Hotel theme action colors use the brand palette.

## Typography and assets

- Japanese: Zen Kaku Gothic Antique (400, 500, 700).
- English and numeric styles: Jost (variable font). Numeric emphasis uses 600 instead of the previous 800/900.
- Simplified/traditional Chinese: retain Noto Sans SC/TC. Noto Sans JP remains a fallback.
- Preserve existing type sizes and layout dimensions in this stage.
- `core_ui_kit` owns family selection and text semantics. `fundex/pubspec.yaml` bundles font binaries locally so no runtime font download is required. Other SDK consumers must bundle the named families or rely on fallbacks.
- Font sources: [Google Fonts Jost](https://github.com/google/fonts/tree/main/ofl/jost), [Zen Kaku Gothic Antique](https://github.com/google/fonts/tree/main/ofl/zenkakugothicantique). Corresponding SIL OFL files are stored beside the fonts and included as app assets. New binaries total approximately 7.2 MB before packaging compression.

## Validation

- SDK theme tests cover locale selection, numeric fallback, light/dark contrast, Material mapping, and status-bar icon brightness.
- App theme tests cover saved preferences plus font manifest entries, asset loading, bundled licenses, and rendering a mixed-script sample in both themes.
- Optional local samples: run `rtk proxy env STELLAVIA_THEME_PREVIEW_DIR=/tmp/stellavia-theme-preview fvm flutter test test/app/theme` from `fundex`.
- Theme samples do not constitute a full device or full-page regression. Existing business pages that override colors/fonts directly need separate visual review.

Validation result (2026-10-23): all 11 SDK UI-kit tests and 3 app theme tests passed; targeted analysis and `git diff --check` passed. Both light/dark sample renders were inspected. No physical-device regression was performed.

## Follow-up

Shared primitives and component geometry are now covered by [stage 2](stellavia-shared-components.md). Fund status/progress business rules, page layouts, and member registration/business flows remain separate. Do not infer completed page redesign from these foundation updates.
