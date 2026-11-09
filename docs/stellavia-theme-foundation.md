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

Success, warning and error palettes remain functional exceptions. Gold is reserved for membership rank surfaces. The general UI migration is recorded below. Auth background gradients now resolve to solid surfaces and decorative orbs are transparent. Hotel theme action colors use the brand palette.

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

## 2026-10-30 默认页面背景统一

- `AppColorTokens.fundexBackground`（`lightBackground`别名）统一为首页浅灰 `#F5F5F2`；`surface`仍为白色，`surfaceAlt`仍为奶油色，深色主题色值不变。
- 首页移除独立浅色背景常量，直接读取`appColors.background`。My Page、酒店Tab的根ColoredBox也改用background。
- 普通设置、会员、资金、交易及酒店页面移除Scaffold的surface/surfaceAlt覆盖，继承全局scaffoldBackgroundColor。卡片、导航栏、底部操作栏及弹窗的surface不改。
- 登录/注册品牌布局、邀请页、地图及头像编辑属于独立背景场景，保留其显式设置。基金详情的白色内容面板及酒店详情的独立容器保留。新增普通页面默认不设置Scaffold背景；仅有明确特殊设计时覆盖。

## 2026-11-09 通用界面移除金色

- 按 [02｜カラー](https://www.figma.com/design/I9xMTxYMyek9AvMWtDvkFi?node-id=6443-29514) 分配颜色。浅色主题中，CTA 和选中态使用 Purple，正文和普通金额使用 Navy，图表线、进度和装饰强调使用 Violet；文字强调使用随明暗模式调整的 infoForeground。
- Gold 等级标题使用 `#9C6A10`，浅色卡面使用 `#F4EDE1`。首页、等级说明、酒店里程和 My Page 共用 Gold 等级颜色。保留 SDK 旧金色 API 的紫色兼容映射，业务组件使用语义色。
- 抽奖转盘和图例共用 Purple / Violet 奖项与 Cream 未中奖扇区。基金募集前标签使用浅色表面；二级市场步骤、筛选和交易金额不使用警告色。真正的警告（如到期、风险和验证提醒）继续使用功能色。
- 默认浅色页面背景继续使用 `#F5F5F2`。

## 2026-11-09 基金状态标签

[06｜ステータス・ランク表示ルール](https://www.figma.com/design/I9xMTxYMyek9AvMWtDvkFi?node-id=6443-30129) 的标签底色／文字色由投资模块统一提供，首页、基金列表、基金详情、My Page 持仓及详情共用。标准标签在明暗模式使用同一对不透明颜色。

| 接口状态 | 标签 | 底色 | 文字 |
| --- | --- | --- | --- |
| 0 | 募集前 | #EEE9E1 | #4C0679 |
| 1 | 募集中 | #4C0679 | #FFFFFF |
| 3 | 募集終了 | #979797 | #FFFFFF |
| 4 | 運用中 | #070E2B | #FFFFFF |
| 5 | 運用終了 | #979797 | #FFFFFF |

App 扩展：7（募集完成）沿用募集结束的灰底白字，保留独立文案。2（募集失败）使用错误色；未知状态以及 My Page 已赎回使用中性色。已赎回优先于基金项目状态。

## 宿主等级卡（Figma 06）

首页等级预览、等级说明、酒店宿主マイル摘要和 My Page 等级卡按接口等级代码共享配色。标题／卡面分别为 REGULAR `#E6E1D8 / #F6F4F0`、BRONZE `#A85A2A / #F6ECE5`、SILVER `#8D9096 / #EFF0F2`、GOLD `#9C6A10 / #F4EDE1`。MASTER 标题从 `#1E0533` 渐变至 `#3A0A5C`，下缘带 2 px Violet 线，卡面为 `#EFE8F4`。浅色等级卡面在两种主题下均使用 Navy 数值和 Muted 辅助文字。未知等级使用中性色，不按数组位置推断等级。

My Page 会员卡沿用原有着色区域：等级主色覆盖整张外卡，两个指标块保留半透明叠层，升级进度区使用主题表面色。文字按实际底色选用白色或 Navy。MASTER 在该卡使用纯色深紫。
