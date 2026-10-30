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

## 2026-10-29 本期 UI 收敛

- 固定实现路径：设计 → SDK 主题/语义样式 → 通用基础控件 → feature 专属组合 → 页面。无业务含义的交互/容器在 SDK；等级、酒店、收益等组合与规则仍在 feature。
- AppCard 新增 filled（无边框、无阴影）及可选 backgroundColor、borderColor、borderWidth、borderRadius；原有默认16圆角、outlined边框与padding不变。业务传入主题色，不传原始色值。新能力已用于酒店卡/里程入口/里程摘要、首页试算入口、收益结果及服务回报卡。
- AppSlider 统一轨道、描边圆点和原生 Slider 交互；调用方提供值、范围、步数、回调及本地化无障碍文案。
- AppTwoLineSegmentedControl<T> 提供两个带说明的选项，支持 selected 语义、键盘/焦点原生 InkWell 行为及 onChanged=null 禁用；不引用分红类型。现有 AppDualSegmentedControl 不改，避免影响旧页面。双行控件文字样式在 SDK app_control_styles.dart。
- 本期首页/服务/等级的文字角色集中在 home_text_styles.dart，计算器在 home_simulation_theme.dart；酒店首页在 hotel_home_text_styles.dart。保留原有视觉数值与字体继承，组件不再内联定义字号/字重。页面特有排版留在 feature，不把业务样式加入 SDK。
- 后续修改：通用卡片外壳/滑块/分段行为改 SDK；功能标题/说明/数值排版改 feature 样式；业务内容改 feature widgets；页面负责组合与事件。设计所需的圆角覆盖仍可独立设置，不承诺所有卡片统一为一个尺寸。
- 验证：10 项 App 定向回归、3 项 SDK 控件测试通过；覆盖多语言小屏交互、旧卡片默认样式、内外点击隔离、明暗主题及禁用行为。定向 analyze 通过，计算器渲染截图已检查。未进行真机回归。

### 分段切换动画

采用登录页邮件/电话切换的实现方案：复用 SDK AppDualSegmentedControl，轨道容器180ms、独立选中块240ms easeOutCubic滑动、文字颜色180ms渐变。为 AppDualSegmentItem 增加可选caption，AppTwoLineSegmentedControl仅作为双行参数适配器；移除重复的AppSegmentedSurface。双行高度随字号适配，支持禁用回调与减少选中块动画。登录页本身保持原样。

计算器通过 HomeSimulationTheme.segments 传入 AppSegmentedControlStyle：浅色轨道、白色选中块、无边框/阴影、12/10圆角及独立文字样式。通用控件样式参数为空时保留旧默认外观，切换动画共用。

## 2026-10-29 底部导航

- SDK新增AppBottomTabBar / AppBottomTabItem：等宽布局、图标builder、选中态语义、主题着色、底部SafeArea；默认内容高54，34底部安全区时合计88，大字号允许文字区增高。AppShellNavigationTheme浅色未选中灰按Figma #999CAB，深色沿用主题适配。
- App main_shell持有五项文案、24×24本地SVG和路由索引；SDK不依赖具体Tab/路由。Figma来源8190:760/8190:967「01 ホーム（サマリー）」。iOS home indicator由系统提供，不在App重复绘制。
- 移除旧导航圆形底座、中间凸起与金色动效，主壳滚动显隐、讨论发送队列仍保留。

## 2026-10-30 下拉选择按钮

SDK新增 `AppDropdownSelector<T>` / `AppDropdownOption<T>`：圆角描边、粗体当前值、向下箭头及锚定下拉菜单；48逻辑像素点击区域，支持禁用及主题/文字/边框参数。业务层提供本地化选项和值。My Page三块图表复用该控件，保留各自1/3/5年选择、请求和刷新逻辑。

SP校准：Figma「02-1 · サマリー（SP）」`6500:16325` 为88×26、12px Bold、1px边框、6px文字箭头间距，文字使用Zen Kaku Gothic Antique；箭头采用原SVG（4×7含描边，旋转后布局槽6×3）。Flutter以12px行高及6px上下内边距补偿Figma cap-trim（8px文本+8px内边距），保留48px透明点击范围。通用控件增加icon、iconGap、borderWidth参数。

TabBar点击反馈：`AppBottomTabBar`使用圆形InkResponse和CircleBorder裁剪，保留整项点击范围、语义与原布局，避免矩形高亮。

## 2026-10-30 普通子页面导航栏

- 普通子页面沿用 App 已有 `AppNavigationBar` + `AppNavigationIconButton`：默认高度、surface 背景、textPrimary 前景、标准 arrow_back_rounded 返回按钮。
- Figma 页面内容改版不应自行覆盖导航栏高度、按钮结构或颜色；只有用户明确要求调整导航栏时才变更。酒店详情与宿主マイル首页已恢复这一规范。

### 导航栏／底部栏滚动显隐

- `core_ui_kit` 的 `AppScrollChromeController` 统一承载主壳原有规则：96 px 渐变距离、18 px 反向触发阈值、160 ms easeOutCubic 收尾动画，以及顶部恢复／底部防抖。
- `AppScrollChromeVisibility` 负责滑动、透明度、折叠高度及隐藏时禁用点击；不改变栏本身样式。
- 酒店详情页为顶部标准导航栏和底部预约操作栏使用同一个页面独立 controller；只响应主列表纵向滚动，不影响父级 Tab 显隐状态。主壳复用同一 controller 实现。

- 顶部 `Scaffold.appBar` 必须使用 `AppScrollNavigationBar`：独立保留状态栏安全区，通过 OverflowBox 给内部导航栏完整固定高度，仅收缩外层视口并整体平移。不能同时缩小 PreferredSize 并直接约束内部 AppNavigationBar，否则会压缩其 Column，导致动画中间帧溢出。底部操作栏仍使用原 AppScrollChromeVisibility。

- 根 Tab 页（App 首页、酒店首页、宿泊管理、My Page）顶部栏统一读取 `mainShellChromeRevealProvider`，通过 `AppScrollNavigationBar` 与底部 Tab 栏同步显隐。不要为根 Tab 新建独立显隐状态。酒店品牌导航已移至列表外；搜索、筛选与宿主マイル入口仍属于滚动内容。新增三个实际页面测试，覆盖 47 px 顶部安全区、0/中间/1 reveal 和内部固定高度。

- 首页子页面（计算器、服务介绍、等级介绍）统一使用 AppNavigationBar + AppNavigationIconButton，去除原生 AppBar 与计算器页独立的居中标题／图文返回／导航背景覆盖，保留原有返回与首页兜底路由。

- My Page 的运用余额、累计配当、累计宿主マイル三个图表默认时间范围统一为最近 1 年；1／3／5 年手动切换保持独立，刷新不重置当前选择。

- My Page“最近 1 年”按当前月份向前滚动 12 个月（含当月），例如 2026-10 对应 2025-11 至 2026-10。三个图表请求起点均使用首月 1 日；月柱按跨年月份偏移定位，横轴标签和折线范围随当前月份滚动。3／5 年范围保持原有行为。

- 主壳显隐边界修正：真实拖动即使本帧到达列表底部，也必须更新 reveal；仅非拖动的底部运动保留防抖。栏收起导致视口增大时，列表向旧边界回弹不得被当成用户反向滚动，内容恰好可容纳时也不因 offset 回零自动展开。用户主动反向拖动仍恢复显示。根 Tab 回归现使用真实 StatefulShellRoute/MainShellPage，并验证短首页实际拖动及恢复，避免只手动修改 provider 的验证盲区。
