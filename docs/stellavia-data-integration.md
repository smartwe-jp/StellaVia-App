# StellaVia 新功能接口与数据层

更新：2026-10-29。范围：读取接口、DTO、领域模型、repository 与依赖注入；UI、页面请求状态、预约提交和支付由后续任务逐页指派。

## 来源和完成口径

- Funding Swagger： https://sit-admin.gutingjun.com/api/crowdfunding/v2/api-docs （本日核对）
- Hotel Swagger： https://hotel-sit.gutingjun.com/api/v3/api-docs
- 用户提供的《stellavia 新页面 1023.docx》及《stellavia 新页面 (1).docx》。
- Google Chat 谷町君开发小组，2026-10-14 至 10-28： https://chat.google.com/app/chat/AAAABZOnvbQ
- 讨论中“已发测试 / 已部署 SIT”视为后端已完成；App 数据层实现、UI 接入和联调状态单独记录。

## 已实现读取接口

下表路径均加 `/crowdfunding` 前缀，OA 集群，成功码 200；除公开等级规则外均要求登录。通过既有 apiClusterRouterProvider 注入客户端，不硬编码测试域名、不传 framework_user_id。

| 模块 / SDK 方法 | 方法与路径 | 参数 | 返回 |
| --- | --- | --- | --- |
| HostMiles.fetchTier | GET /points/user-tier-info | 无 | 等级、比例、预约窗口、室数、有效资产、下一等级 |
| HostMiles.fetchAccount | GET /points/user-account-summary | 无 | availablePoints / frozenPoints / expiringSoonPoints / totalEarnedPoints |
| HostMiles.fetchExpiryAlerts | GET /points/user-expire-alert | 无 | amount / expireDate 列表 |
| HostMiles.fetchTierRules | GET /offline/listRules | 无，公开 | tierCode / minAum / maxAum / pointRate / expireMonths / leadTimeMonths / maxRooms |
| HostMiles.fetchChart | POST /points/chart | startDate / endDate，yyyy-MM-dd | date / points 列表，暂不赋予未确认的统计口径 |
| HostMiles.fetchCumulativeChart | GET /points/cumulative-chart | startMonth，yyyy-MM | xaxis / yaxis |
| HostMiles.fetchTransactions | POST /points/user-transactions | bizType 可选，startPage / limit | total / limit / currentPage / rows |
| AssetStatistics.fetchInvestments | GET /user/invest/chart | 无 | investTotal / investList（含 projectStatus） |
| AssetStatistics.fetchCumulativeBenefit | POST /benefit/chart/cumulative | startDate / endDate | total / dates / values |
| AssetStatistics.fetchForecast | GET /benefit/expect | endYearMonth，yyyy-MM | expectBenefitList / expectPrincipalList |
| AssetStatistics.fetchYearlyBenefits | GET /benefit/year-statistic | startYear | year / totalBenefit / totalTax / actualBenefit 列表 |

余额、过期提醒、等级规则最初不在所给文档中，但最新 Swagger 已定义，故纳入本轮。等级规则匿名实测成功：REGULAR、BRONZE、SILVER、GOLD、MASTER；MASTER pointRate=0.006、maxAum=null。代码不硬编码等级阈值。

## 分层与数据语义

- SDK：company_api_runtime/src/host_miles 与 src/asset_statistics；复用 LegacyEnvelopeCodec，使用手写 DTO 模板。
- App：features/host_miles 与 features/asset_statistics 各自 domain/entities、domain/repositories、data/datasources、data/mappers、data/repositories。
- presentation/providers 仅注入无状态客户端和 repository，不主动请求、不缓存账户结果。后续 UI 按项目短缓存、登录和刷新规范接入 usecase/controller。
- 未知额度保持 null：currentBookingRooms=null 时 remainingBookingRooms=null；已订超过上限则剩余额度为 0。
- 累计获得总数取 yaxis 最后一个值；空图返回未知 null，不与 availablePoints 混用、不求和。轴长度不一致或数组含无效点报格式错误，避免错误配对。
- 保留积分正负号和返回的 bizType，不因文档 ISSUE 请求示例返回 CONSUME 而本地改写或过滤。分页元数据完整保留。
- 流水时间兼容示例毫秒时间戳和 Swagger 日期字符串；epoch 转 UTC，不在数据层做日本时区展示。
- 收益预测保留 floatBenefit 及本金独立月份，yearMonth 兼容文档字符串与 Swagger YearMonth 对象。
- 数字字符串兼容解析；未知数值不伪造为 0。大项目 ID 保留 String。
- 失败不转成成功空账户；沿用网络层鉴权刷新与失败传播。

## 现有接口增量

- HotelSummaryDto.detail -> HotelSummary.description：酒店列表本地化介绍。
- HotelRoomExtraPersonResultDto.pointTotal -> HotelBookingPreparation / HotelBookingQuote.pointTotal：报价所需积分，null 表示不支持积分支付；金额与现金报价分开。
- pointTotal 来源为 10-14 开发讨论，最新 Hotel Swagger 尚未定义。详情 roomTypeDTO4APPs 与 assign/occupancy 的同名字段只见追加请求，未猜测加入。
- 投资列表 SDK / MyPage datasource / repository / usecase 增加可选 projectStatus；不传时请求保持原样，不解释为二级市场专属过滤。

## 后续页面接入与边界

- 10-15 讨论已确认 hotelSearch(stayBenefit=true) 用于宿主マイル/Point 特典，支持多晚；整段日期判断 stayBenefitParticipate，不适用酒店仍可能返回。此结论修正 10-28 预览记录中的旧判断。
- 现有特典 UI 单晚限制本轮未改；宿主マイル首页仍为已获确认的设计预览。后续 UI 任务需按新语义处理，不直接沿用旧券校验。
- 有效预约室数含未入住和入住中，退房日12点释放；时区需在预约实现时确认。App 不调用 server-to-server 加密 roomCount 或 admin tier 接口。
- brandStr=stella_asset、fundmile 支付代码14、积分消费/冻结/退款属于后续预约流程。注意旧隐藏 WeChat 路径也使用14，启用新支付前必须核对，不能直接替换或复用。
- 不实现后台兑换比例配置、不迁入管理端接口。适合性资料新字段截图尚未完整辨认，本轮不猜测字段。
- 酒店列表所需里程字段/口径、points/chart 指标定义、二级市场可售持仓与挂单区别仍需后续明确。

## 验证

- SDK 契约测试覆盖11接口方法/路径/参数/鉴权/响应/业务失败，以及空值、分页、日期、网络错误。
- App 数据映射测试覆盖未知室数、累计总数、轴对齐、分页、带符号积分与收益本金分离。
- Hotel DTO 和投资列表筛选增量测试；已有投资、酒店和 MyPage 数据源回归。
- 仅公开等级规则做了在线请求；用户私有接口尚未用登录账户联调。这不改变已发测试接口的后端完成状态。

本轮执行结果：SDK新接口/增量/现有投资测试35项通过；App数据映射与MyPage数据源10项通过；SDK和App定向analyze无问题；git diff --check通过。额外酒店回归27项通过、1项既有失败：fetchBuildingCodes测试断言auth_required=true，但当前实现为false；该客户端方法和旧测试本轮未改。

## 2026-10-29 首个UI接入：首页

首页已消费fetchAccount（availablePoints）和fetchTierRules（等级预览名称/排序）。新增LoadHostMilesHomeUseCase与首页短生命周期controller；其余接口仍只有数据层，待逐页指派。见 [首页记录](home-redesign.md)。

等级详情和服务介绍的等级区域现已接入fetchTierRules全部展示字段；门槛、获得率、有效期、预约窗口、室数由接口提供，静态介绍文案保留。详情见首页记录的“等级说明页数据接入”。

## 2026-10-29 酒店宿主里程首页

宿主里程首页已消费fetchAccount/fetchTier及hotelSearch(stayBenefit=true)，替换示例余额、等级、室数与酒店。支持多晚查询、地区/价格排序、分页、刷新和错误保留。列表所需里程字段仍未确认，显示未知；不调用报价接口拼凑列表金额，不接后续预约。

## 2026-10-29 My Page 三块图表

- 设计：Figma `I9xMTxYMyek9AvMWtDvkFi` / `8038:31937`「01 My Page｜ホーム（サマリー）統合」，本轮仅资产区三张图表；顶部摘要、等级卡、图标与其他内容保持原状，不新增资产详情页。
- 现有 My Page 单张资产趋势从页面移出，旧组件/provider仍保留。新业务组件位于 member_profile/presentation/widgets，格式化/样式在 support，controller/provider持有独立请求状态，domain usecase组合已完成的数据层。
- 运用残高：已有 fetchAssetTrend 的 totalFundAccount；不使用含待机资金的 totalAccount，不将缺失基金资产转为0；标题数值为期间内最新有效历史点（不是实时账户余额）。
- 累計配当額：fetchCumulativeBenefit 的 total、dates/values。柱状图按年取最后一个实际累计值，近一年时按月取最后值；累计值不能相加，缺失月份/年份不补造0。
- 宿主マイル：fetchCumulativeChart(startMonth)；曲线来自 xaxis/yaxis，标题数值严格取 yaxis最后值，空数组为未知；不与 availablePoints 混用。
- 默认近5个自然年（当年及前4年），每卡独立选择1/3/5年；请求到今天，横轴覆盖所选自然年。图形动态绘制；Figma示例曲线SVG不作数据资产。时间入口使用原设计8×14 SVG，新增flutter_svg用于渲染，资产已本地化。
- 缓存：根Tab常驻期间保留数据；下拉、切回Tab、从/profile子页返回、前台恢复刷新。接口独立失败/重试，刷新失败保留旧数据，变更期间清空旧曲线并拒绝迟到请求；仅登录且用户身份已解析时调用私有接口，换号/退出清空，刷新同一用户资料不重置期间。
- 四语言文案；AppCard和主题颜色复用，业务图表与文字样式留在member_profile。资产详情入口不属于本轮图表范围，未创建无目标跳转。
- 验证：新增测试5项（口径/轴数据、异步竞态与失败缓存、账号隔离和同账号刷新、四语言320px/1.3字号与深色模式、截图），既有MyPage数据源5项回归通过；新增文件定向analyze通过。页面已有3处未使用的分享相关声明警告未修改。已查看390px截图、确认本地SVG尺寸/引用；尚未以登录设备联调私有接口。

## 2026-10-29 My Page 等级与权益摘要

- 用户追加截图对应同一Figma的等级卡和三栏权益摘要，置于资产图表上方。新增member_profile业务组件、显示映射和等级主题；复用AppCard、AppProgressBar、AppBottomSheet。Figma原始6×10/8×14箭头SVG本地化，业务组件无硬编码颜色。
- 真实字段：user-tier-info.currentTier/pointRate/currentAum/nextTierGap/maxRooms/currentBookingRooms；user-account-summary.availablePoints/expiringSoonPoints。获得率乘100展示百分比，数据口径为月次；上限与已预约室数独立，不将上限误作剩余室数。
- 2026-10-29复核Funding Swagger：nextTier的最高等级标记为MAX；只有明确MAX才展示最高等级。进度为currentAum/(currentAum+nextTierGap)，表示距下一绝对运用余额门槛的进度，不写死等级金额，数据缺失/无效不画假进度。
- Swagger对expiringSoonPoints只写“快过期积分”，未明确一个月。故界面将截图“1ヶ月以内に失効”暂改为“まもなく失効”；不能据此声称一个月统计。点击使用user-expire-alert展示实际到期日/里程，不自行猜测汇总窗口；UTC时间戳按日本日期显示，日期字符串保持返回日期语义。
- 「ランクについて」进入既有/home/ranks。到期明细使用SDK底部弹层，打开时读取、失败可重试；未拓展预约或兑换流程。
- 等级/余额独立加载和失败重试，同账号刷新保留旧值，身份变更丢弃旧结果。与图表共用页面前台/返回刷新，页面下拉与Tab切回同步刷新；保留旧页面其他内容。
- 验证：等级摘要与图表共11项测试通过（含四语言320px/1.3字号、真实字段映射、MAX/未知值、账户隔离、失败缓存、迟到响应、等级说明跳转、到期弹层）；新增/修改组件定向analyze通过，截图已检查，变更范围diff --check通过。未进行登录设备真实接口联调，currentBookingRooms未返回时仍显示未知。
