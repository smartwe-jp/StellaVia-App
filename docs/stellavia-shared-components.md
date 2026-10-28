# StellaVia shared components

Implemented: 2026-10-23. Builds on [theme foundation](stellavia-theme-foundation.md).

## Ownership

`mobile_core_sdk/packages/core_ui_kit` owns visual primitives with generic inputs. Features own business compositions, API-status-to-tone mappings, progress thresholds, localized text and navigation. For example, a fund funding card, hotel reservation summary or investor-registration section belongs under its feature's `presentation/widgets`, not SDK. Cross-page reuse alone does not make a business composition generic.

Historical business widgets in SDK are retained for compatibility in this stage. New business UI must not be added there. Move existing compositions when the corresponding module's layout is changed; this task does not claim a complete migration of all legacy SDK business widgets.

## Public primitives

| Family | Public API | Behavior |
| --- | --- | --- |
| Buttons | `AppButton` | Primary / secondary / text; pill shape, 48 minimum height, native keyboard/focus/disabled behavior, loading blocks repeat submission |
| Inputs | `AppTextField`, `AppFieldLabel` | Native editing, external controller/focus support, caller validation and formatting, optional localized required badge, neutral border and violet focus |
| Cards | `AppCard` | Outlined / elevated / subtle surface; 16 radius; optional tap; content supplied by feature |
| Status | `AppStatusBadge` | Generic visual tones, optional dot; contains no business statuses or local text |
| Progress | `AppProgressBar`, `AppStepProgressBar` | Normalized continuous or segmented progress; accessible values; step pulse opt-in and respects reduced motion |
| Headings | `AppSectionHeader`, `AppBrandHeading` | Compact heading/action or centered bilingual editorial heading; actions and copy supplied by feature |

`AppTextField` uses a native TextField for ordinary editing and a TextFormField when a validator/onSaved is supplied. This retains legacy input-key behavior while supporting Form validation. All textual labels, errors and announcements are caller-provided and should come from ARB localization in production.

Progress drawing clamps to 0..1, with nonfinite values drawn as zero. Null is indeterminate. A caller-provided `semanticValue`, such as a localized percentage above 100%, is announced separately from the native numeric progress-bar semantics. No fundraising color threshold is implemented in SDK; features pass explicit theme-derived fill/track colors when their business rules require them.

## Existing entry points

- `PrimaryCtaButton` and `CompactActionButton` delegate to `AppButton`; caller callbacks, busy state, size/color overrides and primary-button outer inset remain supported. Old decorative shadow arguments are retained as compatibility parameters; new controls use flat styling.
- Existing email/phone/password/code input adapters delegate to `AppTextField`. Field keys and input formatting are preserved.
- `SurfacePanelCard` uses `AppCard`; `FundSectionHeader` is a compatibility adapter over `AppSectionHeader`.
- Native FilledButton, ElevatedButton, OutlinedButton, TextButton and inputs inherit updated theme geometry/state styling. Existing page-local style overrides are not swept away in this task.
- No business workflow, backend contract, registration step count or fund status mapping changed.

## Validation

This stage does not add or run UI tests. Run static analysis and `git diff --check` for the SDK changes before merging. Full device and page-level visual review remains a separate activity.
