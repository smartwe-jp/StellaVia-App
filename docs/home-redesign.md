# Home redesign — 2026-10-28

## Scope and reference

- Member: [首页 · 会员首屏](https://www.figma.com/design/I9xMTxYMyek9AvMWtDvkFi?node-id=8093-578).
- Guest: [12 見つける（ゲストホーム）](https://www.figma.com/design/I9xMTxYMyek9AvMWtDvkFi?node-id=8190-1917).
- Keep the existing root tabs, latest-fund carousel and featured-hotel carousel, their live data and navigation. These explicitly retained lists take precedence over the sample fund layout and absence of hotels in Figma.
- Member home: brand header with notification badge, localized personal greeting, bundled Figma hero photo, fund/hotel quick actions, existing lists, miles summary and rank teaser.
- Guest home: brand/login header, service teaser, existing lists, simulation teaser, rank teaser and a fixed registration action above the existing tab bar.
- Remove the old hero, registration campaign, verification reminder feed, attraction section, investment flow and license/footer from this page only. Their external widgets, routes, verification guards and other feature implementations remain available.

## Pending features

Miles booking remains a localized “coming soon” action. Miles balance, public rank rules and simulation are now integrated as recorded in the dated sections below; booking eligibility is not implemented.

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

## 2026-10-29 首页可用数据接入

- 以本轮开始时的实际首页代码为基准：登录态里程卡已在首页恢复，酒店列表仍隐藏，试算卡仍对两种登录状态显示。本轮不恢复隐藏酒店、不调整Tab。
- 登录态里程卡通过 host_miles usecase/repository 请求 `/crowdfunding/points/user-account-summary`，只将 availablePoints 用作可用余额；零值显示0，未知显示破折号，不使用totalEarnedPoints替代余额。
- 首页等级预览通过 `/crowdfunding/offline/listRules` 请求公开等级列表，按minAum排序显示tierCode，不假定用户当前等级。详情页和服务介绍页仍保留原有内容，待另行指派。
- 用户称呼、通知和最新基金沿用既有数据。试算与里程预约操作仍提示准备中；本轮不启动预约、支付或资产统计页。
- 数据加载/重试/金额格式化独立在home的controller、providers、support与widgets中，页面只绑定。首次错误提供重试；刷新中与刷新失败保留同一账号的旧值；登录身份变化重建账户状态，丢弃旧请求的迟到结果，游客不请求私有余额。
- autoDispose controller仅在首页被监听期间保存结果；下拉、Tab返回、子页面返回和App前台恢复触发刷新，网络不可用时沿用既有跳过策略；并发刷新复用在途请求。
- 新文案覆盖ja/en/zh/zh_Hant。小屏320px、1.3字号覆盖余额与错误状态；重试不会误触预约。
- 验证：首页状态、账号切换、刷新失败/重试、返回/前台刷新及四语言布局测试；定向analyze只保留原有隐藏酒店featuredHotelCards未使用警告。未进行登录账户/真机联调。

## 2026-10-29 等级说明页数据接入

- 等级详情与服务介绍共用HomeRankDetailsSection，均已从公开listRules读取规则，移除固定五级数值。独立autoDispose信息页provider避免首页常驻缓存影响再次进入。
- tierCode映射名称；minAum/maxAum映射日元门槛（按minAum排序，缺失下限显示未知，maxAum=null显示下限及以上）；pointRate乘100显示百分比；expireMonths/leadTimeMonths/maxRooms分别映射有效期/提前预约月数/最大室数。区间仅呈现接口上下限，不额外推断边界资格。
- null字段显示破折号，不使用设计稿默认值。可支持新增等级与变化后的数值，配色索引不会因等级数超过五个越界。
- 原有介绍文案和版式保留，移除“内部草案/获得率未公开”段落与“暂定”等级标签，避免与当前读取的规则数据矛盾。
- 首次加载显示进度，失败提供重试，空列表显示本地化空状态；重试失败保留已有规则。ja/en/zh/zh_Hant均已生成。

## 2026-10-29 首页试算器

- 按 [13 シミュレーション](https://www.figma.com/design/I9xMTxYMyek9AvMWtDvkFi?node-id=8190-2037) 实现公开路由 `/home/simulation`，首页两种登录状态均可进入。游客 CTA 注册，会员 CTA 浏览基金。Tab 不变。
- 金额 1–5000 万日元（步长 1 万）、年利率 3–10%（步长 0.1%）、期限 1–36 月；默认 100 万、6%、12 月。支持每月分红 / 到期分红切换。
- 税前单利：月分红 = 本金 × 年利率 / 12；期间分红 = 本金 × 年利率 × 月数 / 12；总额 = 本金 + 期间分红，日元向下取整。每月分红模式总额包含期间已发放分红，并非最后一笔到账金额；页面说明该口径。
- 用输入金额独立匹配公开 listRules（minAum 包含、maxAum 不包含），不叠加登录用户资产；估算里程 = 本金 × 等级 pointRate × 月数，向下取整。不模拟到期失效或未来等级变化。规则缺失/加载失败时里程及晚数显示未知，支持重试。
- 用户同意先假定每晚兑换值：集中在可替换的 calculator 参数 exampleMilesPerNight，默认 10,000 mile/晚；页面明确标记假设与酒店/日期差异，晚数取完整晚数。该数值不是后端兑换政策。
- 输入状态由 controller 管理，纯 Dart domain 负责计算，布局拆分为输入与结果 widgets；四语言 ARB 已生成。返回箭头使用 Figma 本地 PNG，系统状态栏使用原生状态栏，不绘制设计稿的固定时间/电量。
- 验证：24 项定向计算/交互/游客路由测试通过，包含四语言、会员/游客和 320px、1.3 倍字号布局；截图已人工查看。定向静态分析及 git diff --check 通过，页面/widgets 无硬编码颜色。未进行真机或登录账户后端联调。

## 2026-10-29 样式与控件收敛

本期首页、信息页文字排版集中到 HomeTextStyles，试算排版保留在 HomeSimulationTheme。计算器使用 SDK AppSlider/AppTwoLineSegmentedControl，输入及结果仍为 home 专属组合；服务回报卡/试算入口/结果卡使用扩展后的 AppCard。保留视觉尺寸、文案和计算数据规则。验证及基础控件维护路径见 `stellavia-shared-components.md`。

## 2026-10-29 按 Web MILE SIMULATION 对齐

- 参考用户提供的 `http://192.168.5.120:5175/`，读取 HomeMileSim.vue 的 calc/pickRank 与四语言文案。保留 App 滑块实时计算，不复制网页点击计算/弹窗交互。
- FINANCIAL RETURN／配当：每月配当（或满期一次性配当）、累计配当、总领取额及领取时机；累计配当按输入月数计算，替代原来的固定年度分红。
- EXPERIENCE RETURN／宿主優待：等级、月获得率、每月里程及累计里程。默认100万、6%、12个月：每月5,000日元、累计60,000日元、总额1,060,000日元；BRONZE月率0.525%，每月5,250里程、累计63,000里程。
- 算法：月配当=P×年率/12；累计配当=P×年率×月数/12；总额=P+累计配当；月里程=P×月pointRate；累计里程=P×月pointRate×月数。每个结果最终向下取整，累计不使用已截断月值。
- 等级按 Web 的最高已达到 minAum 门槛匹配，取代之前 maxAum 区间筛选；继续使用公开接口的小数月率，不复制网页的硬编码等级fallback。规则未加载/错误仍显示未知并可重试。
- 删除每晚10,000里程假设、晚数计算、相关说明及文案；用户明确本次不加入网页固定示例酒店列表。以上取代本页前文的晚数假设与年度分红展示说明。
- 本轮验证：计算与四语言/会员游客/320px及1.3倍字号交互测试通过；定向 analyze 与 diff 检查通过；结果上下两部分截图已复核。未进行真机或真实账户联调。
