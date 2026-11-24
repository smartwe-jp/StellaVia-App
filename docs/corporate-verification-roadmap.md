# 法人认证：需求分析与页面方案

更新：2026-11-19。当前阶段：会员信息入口、法人详情只读接入与 C03–C11 表单及提交、C12 成功页、C13–C16 进度页及 C21/C22 寄件和收件操作，以及 C18 申请详情与 C19 自行修正。App 进入会员信息时刷新 index-new，个人未提交时选择个人资料录入或法人材料准备，已标记法人时展示公司名与审核状态。类型与状态优先读取根字段，缺失时兼容 baseInfo。只有明确 personal 且 status=1 才展示两种认证选项。基金申购及二级市场购买在入口和提交前重新读取 index-new，法人仅在详情为 CONFIRMED 时放行，未完成可前往会员资料查看进度。个人申购沿用状态 4/5，个人二级市场购买沿用原有交易检查。

材料准备页的「入力を始める」依次进入法人信息、代表者和取引担当者。每步校验后前进，返回可修改。法人本店、代表者及受任者住所复用个人认证的日本邮编查询，输入完整邮编后仅点击「住所検索」才查询并回填地址，回填地址可手动编辑。选择其他交易目的需要补充说明；代表者本人办理复用代表者资料，受任者办理时独立填写部门、联系方式等。第三步继续进入第 4 步实质支配者。选择 YES 时至少登记一人，可逐人新增、编辑、确认删除。NO 或 UNKNOWN 只在会话草稿中保留此前人员，核对时有效名单为空。初回申请从第四步进入出金口座。国内口座按银行名核对本地 ZenginCode 名录。支店名手动填写，支店番号须为三位半角数字，两者均不与名录比对；「其他银行」保留手填并执行同样校验。口座名义与法人名カナ统一全半角、空格及常见法人简称后须一致。名录资产取自 [zengin-code/source-data](https://github.com/zengin-code/source-data/tree/658711c701f40189d5a4fb131a7ccb57fb7d04ba) 的 2026-08-24 快照，新增及改名支店需同步更新。支店番号和口座番号按字符串保留前导零。自行修正跳过银行页及核对页中的银行栏目。当前以法人详情 bank 的 id 或非空账号识别已登记账户，空/DRAFT 且无账户时按初回处理，仍需联调确认。初回从银行页、自行修正从支配者页进入第 6 步。两张书类页依次收集法人材料和身份证件，上传成功后才计入必填校验。附件留在本次申请草稿中，返回可替换，失败可重试；客户端每份限制 10 MiB。第 6 步完成后进入第 7 步，分区核对并可返回原步骤修改。两项声明均勾选才开放提交。初回提交成功后保留 C12 成功页，自行修正成功后刷新法人详情并回到会员资料。仅在最新详情 userOps 含 CUSTOMER_MAILED 时显示完整邮寄地址与原本清单（代表者本人寄謄本，受任者另附填写盖章的委任状原本；待寄件进度页也显示），刷新法人详情。点击「申請状況を確認」进入 C13–C16 共用进度页；详情失败时只重试查询。已有可修正申请从材料准备页开始时，复用「修正を始める」的回填和提交逻辑。

C17 在会员信息或进度页刷新取得 CONFIRMED 后展示。完成页提供已登记资料、基金列表和 My Page 入口，自行修正从已登记资料进入。

C18 以紫色细边框突出只读状态，各组按左侧字段名、右侧加粗资料值两列对齐展示资料和附件。银行账号仅显示末四位，点击附件即可预览。C19 从最新详情复制修正草稿，沿用已有附件。取消不会改动原申请。修正提交前复查申请 ID 和状态。修正提交结果不明时保留本页草稿与声明，仅允许查询详情；须同一申请出现晚于提交前日志的新 SUBMITTED 记录，且已受理资料与本次提交一致，才返回会员资料。缺少可比较日志或资料时继续待确认。

2026-11-20：认证流程右上角使用无背景关闭按钮，材料说明、进度、提交成功及修正说明页直接退出；填写、上传、申报及寄收件操作页确认退出后返回入口页：首页可直接弹出独立的全屏法人认证流程；从会员类型选择页弹出时，关闭后回到选择页。从设置页打开会员资料或进度时，关闭后返回原设置页。首次申请确认 X 退出后，按账号在本机安全存储保存表单、支配者及附件（含待重试文件）；重新进入从第一步回填，确认受理后删除本地草稿。自行修正仍从已提交详情回填；已提交的资料保留。表单隐藏三阶段栏，七步进度固定在独立滚动区上方。会员信息和进度使用状态说明、当前操作和详情/修正列表行。

首页认证提醒按点击时刷新得到的 index-new 类型分流。已是 corporate 的用户进入会员情报，差戻し时在既有申请下查看状态和修正资料；仍可选择投资者类型的用户选择法人后进入首次申请准备页。

2026-11-20 设置入口导航修正：打开会员情报前刷新入口状态。普通个人资料与 CONFIRMED 法人资料使用 push；类型选择及未完成法人认证仍使用全屏 present。个人认证录入和法人填写/修正流程保持原有全屏呈现。查询失败进入可重试的普通入口页。

## 来源与范围

- 用户说明：登录后，在个人类型且 `status=1` 的会员信息入口选择个人/法人；`applicantType=corporate` 时读取法人详情。
- 用户提供 `corporate-investor-app-guide.md`、`corporate-investor-submit-payload.md`（位于 Downloads）：本文的接口、枚举、表单规则均来自这两份文档，已对照 SIT crowdfunding Swagger 确认 index-new 与法人详情 GET 路径，详情为 CorporateDetailVO，documents 和 beneficialOwners 为数组；未用账号验证真实数据。文档中的 App 建议属于待评估需求，不是自动扩展本任务的授权。
- 本轮不改注册流程。文档建议注册时持久化 applicantType，但未提供对应接口；当前按用户要求从登录后的会员信息入口选择。
- 设计沿用现有 StellaVia 文件、日文、Purple/Navy/白色及 Zen Kaku Gothic Antique；全部示例资料为虚构，不保存用户提供的账号密码。
- [Figma 法人认证设计区域](https://www.figma.com/design/I9xMTxYMyek9AvMWtDvkFi?node-id=8414-1069)。页面位于 `Stellavia app new`，与既有画面分开。

登录后的首页另有认证提醒。个人 status=1 点击后弹出个人／法人选择，已是法人的账户直接打开发人认证，其余个人账户直接进入个人认证。选择后复查若已确定类型，按最新类型进入。首页点击后始终从材料准备页（法人）或个人认证第一步开始。会员资料入口按法人详情展示：草稿进入准备页，已提交但未完成直接弹出进度，CONFIRMED 展示已完成资料入口。

## 入口及资格

1. 登录/恢复会话后刷新 `/crowdfunding/user/index-new`，读取根部 applicantType，兼容 baseInfo.applicantType。根字段优先。
2. `corporate`：请求法人 detail，不显示个人/法人选择。
3. `individual` / `personal` / 空且 `status=1`：会员信息入口显示双选；个人继续既有流程，法人进入准备页/法人表单。未识别的新类型不应直接按个人未选类型处理。
4. 个人非 1 状态继续既有个人入口。仅在法人 submit 成功后刷新服务端类型；不要假设点击选择卡即可持久化类型。
5. 法人认证状态独立于个人 status。法人仅 `CONFIRMED` 可申请/购买；交易前刷新 index-new，再按最新类型读取 detail。失败或未知状态不放行，提供重试，不伪装成 DRAFT。
6. 法人空/DRAFT/REJECTED/EXPIRED：可引导完成/修正认证；审核中不弹通用“重新完成认证”提示，可查看进度。
7. 已登录会员的基金、二级市场、酒店里程预约等受保护动作应复用集中资格策略，避免页面各自判断。具体业务权限仍由服务端决定。

### 现有代码差异

- `fundex/lib/features/member_profile/presentation/providers/member_profile_providers.dart`：`isMemberProfileCompletedProvider` 当前使用 `status != 0 && status != 1 && status != 3`；`isFundApplyVerifiedProvider` 当前允许 `4 || 5`。
- `presentation/support/member_profile_action_guard.dart` 已刷新远端并使用集中 provider，但失败也落到未完成提示。需要区分未认证、审核中、请求失败。
- 新指南个人交易仅写 `status=4`，与既有 `5` 有冲突。实施前确认 `5` 含义及适用业务，不顺手删除旧资格。
- 入口接入后，SDK AuthUserDto 与 App AuthUser 已包含 applicantType。会员信息分流直接使用本次 index-new 响应。

## 接口拆解

路径统一 `/crowdfunding`，按项目架构使用 OA client / 200 envelope 策略；该选择基于项目规范与文档样例，待实际联调核实。

| 方法 | 路径（不含前缀） | 用途/约束 |
| --- | --- | --- |
| GET | `/user/index-new` | 类型及个人状态；兼容根/baseInfo 类型 |
| GET | `/corporate-verification/detail` | 仅法人请求；资料、状态、userOps、auditLogs、申请 ID |
| POST | `/corporate-verification/upload/photo` | multipart，字段 file；成功取得 url 后方可进入提交 payload |
| POST | `/corporate-verification/submit` | 初回含 bank；自行修正完全省略 bank（不是 null） |
| POST | `/corporate-verification/review` | id + reviewOp + customerMessage；只开放 userOps 允许的操作 |

- `CUSTOMER_MAILED` 必须填写 customerMessage；追踪号码是可用的说明，不应把“有追踪号码”本身强制为唯一方式。`RECEIVED` 备注可选。成功后重新 GET detail。
- 不使用废弃的 `/mail-sent`。不调用管理员审核操作。
- 提交及 review 防重复点击；超时结果不明先刷新详情核实，避免无条件重复新增申请/银行口座。
- 账号切换清空法人详情、临时选择和表单缓存；根页面保持旧展示可提升体验，但过期缓存不能作为交易放行依据。

## 状态与交互

| verificationStatus | 会员信息入口/页面 | 修正 |
| --- | --- | --- |
| 空 / DRAFT | 法人表单；已 corporate 时不提供切回个人 | DRAFT 可修正，初回银行判定见待确认 |
| SUBMITTED | 详情/进度；userOps 决定是否需要寄原件 | 可修正 |
| CUSTOMER_MAILED | 进度：已申报原件寄出 | 不开放 |
| APPROVED | 进度：资料审查通过，非认证完了 | 不开放 |
| ADMIN_MAILED / MAILED | 进度：公司已邮寄；userOps 决定收件按钮 | 不开放 |
| RECEIVED | 已收件，等待最终确认，不可投资 | 不开放 |
| CONFIRMED | 认证完成及法人资料详情，无单独进度入口 | 可修正，重审影响待确认 |
| REJECTED | 原因、进度及修正入口 | 可修正 |
| EXPIRED | 会员资料直接显示过期提示；点「内容を修正する」回填上次资料并进入修正表单，跳过进度页与出金口座 | 可修正 |
| 未识别/读取失败 | 信息不可用/重试 | 不猜测权限 |

进度六节点：提出完了 → 原本邮寄 → 资料审查 → 公司寄出 → 用户收件 → 最终确认。

- SUBMITTED + userOps 含 CUSTOMER_MAILED：第 2 节点为“待用户操作”，不是邮寄已完成。
- APPROVED 映射第 3 节点 REVIEW。
- REJECTED 若 auditLogs 存在此前 APPROVED，差戻し在第 6 节点；否则在第 3 节点。应按审核时间序列判定，日志不足不得凭空推断。
- 状态不等于按钮权限；仅 userOps 控制邮寄/收件按钮。

## 表单及条件字段

采用 7 个逻辑步骤；资料上传拆为法人资料/自然人证件两页。新增实质支配者为子页，不增加主步骤。

1. **法人信息与目的**：法人信息页只读显示当前登录账号的注册邮箱，不写入法人提交资料；代表者邮箱仍独立选填。name/nameKana/legalForm/corporateNumber/postalCode/address/establishedDate/phone/businessDescription；transaction.purpose/purposeOther。法人番号 13 位、邮编 7 位、日期 YYYY-MM-DD；法人名カナ全角片假名；other 时补充目的必填。
   法人、代表者及受任者的邮编输入框与实心检索按钮同排，查询期间按钮显示转圈并禁用。无匹配地址时，弹框提示核对邮编，点击重新输入后聚焦邮编栏。
   法人认证中代表者、受任担当者和实质支配者填写的出生日期按日本当地日期校验，须已满 18 周岁。
2. **代表者**：name/nameKana/role/postalCode/address/birthdate/phone 必填，email 可选。
3. **担当者**：representative 时仅 `{type: representative}`；delegate 时 name/nameKana/department/postalCode/address/birthdate/phone 必填，email 选填，填写时校验邮箱格式。切回本人后清除或忽略隐藏的 delegate 提交数据。
4. **实质支配者**：YES/NO/UNKNOWN；YES 至少一人，NO/UNKNOWN 提交 people=[]。每人 name/birthdate/country/address/controlType 必填，percentage 可选。支持新增、编辑、删除；ownership_over_25/material_influence。
5. **出金口座（初回）**：bankType=0、liveType="0"；bankName/branchBankName/branchBankNumber/bankNumber/bankAccountType/bankAccountOwnerName 必填；普通1/当座2/储蓄3；其余文档字段空字符串。修正不重新编辑/提交 bank，已存口座可在资料详情只读展示。
6. **资料上传**：registry 必填；sealCertificate、beneficialOwnerEvidence 可选；delegate 才有 delegation 及 handlerId 必填。representativeId_front 必填；驾驶证11/在留卡13需背面，My Number12只收正面。法人文档没有斜拍字段，不照搬个人流程新增必填斜拍。
7. **确认与声明**：完整回显分区，可返回编辑；antiSocial/mail 均须 true。正式声明原文需要业务提供。

证件文件特殊编码：representativeId_* / handlerId_* 的 fileId 是类型码字符串 11/12/13，name 为字段名，url 为上传响应。其他文件 fileId 使用上传 ID。未上传/不适用 documents 字段为 null。切换证件类型时不能沿用错误背面或类型码。

上传需展示选择/上传中/成功/失败/重试/替换，必需文件未完成上传时禁用下一步或提交。10MB 为文档建议而非已证实后端限制；文件类型和限制须联调确认。PDF/图片预览复用 SDK 能力。

## Figma 页面目录

| 编号 | 页面/状态 | 作用 |
| --- | --- | --- |
| C01 | 投资家类型选择 | 个人/法人入口，个人接原流程 |
| C02 | 法人认证准备 | 材料清单及邮寄流程 |
| C03–C05 | 法人、代表者、担当者信息 | 条件表单 |
| C06–C07 | 实质支配者列表/新增编辑 | 多人维护 |
| C08 | 法人出金口座 | 仅初回 |
| C09–C10 | 法人资料/本人证件 | 条件上传、证件正背面 |
| C11–C12 | 提交确认/提交成功 | 声明与提交后下一步 |
| C13–C16 | 待邮寄/审核中/待收件/差戻し | 同一进度页的不同状态 |
| C17–C20 | 认证完成/资料详情/修正提示/详情失败 | 完成、回看、再提交及异常 |
| C21–C24 | 邮寄申报/收件确认/上传失败/离开确认 | 辅助交互状态 |

这些画板是页面与状态设计，不代表必须实现 24 个独立路由。C13–C16 共用进度页，C21/C22/C24 可用 bottom sheet/dialog；EXPIRED/最终确认中等复用现有状态容器和文案映射。图中正式声明、邮寄地址、审核时间不作产品承诺。

## 实现分工与票据建议

1. **合同及 DTO**：确认真实响应；SDK 增加 corporate client、typed request/response、documents mapper；auth DTO/entity 增加 applicantType。统一 envelope，不在 App 重复拆包。
2. **资格与入口**：domain 的个人/法人资格模型；集中 guard；类型选择、法人详情路由、刷新/错误/账户隔离。先修正门禁差异再开放入口。
3. **申请表单**：feature `corporate_verification` 的 data/domain/presentation、Riverpod controller、条件校验、分步回退保留输入、上传队列、确认和 submit。
4. **状态与会员操作**：详情、六节点进度、auditLogs 原因、userOps、review、重试与再提交（省略 bank）。
5. **联调与回归**：真实资料仅在用户确认的测试流程下提交；个人历史资格、My Page 提示、基金/二级市场/酒店 guard 及缓存一致性回归。

通用 UI 用 core_ui_kit 控件；法人业务组合留在 feature/presentation/widgets，映射在 support，领域规则不依赖 Flutter/Dio。日中英等用户文案使用 ARB；此轮只设计日文，未修改 l10n 或生成文件。

## 开发前必须补齐的合同问题

1. 未知 applicantType 的业务含义，以及个人 status=5 的真实业务含义。
2. detail 的 documents 是对象还是数组，beneficialOwners 的实际路径与 status；上传响应包裹层和 ID 字段。不能以“可能在这里”写多层猜测解析。
3. review ID 文档为数字，submit 样例为 `cv_123` 字符串：确认主键类型及两者映射；不要把参考 applicationId 直接当 review.id。
4. 已 corporate + 空/DRAFT 时，如何可靠区分初回与修正；bank 是否已有记录，后端如何防重复银行/申请。
5. 未提供草稿保存接口。不要宣称云端自动保存；首次申请支持本机按账号恢复，未同步到其他设备。
6. 邮寄地址/收件人/联系方式、委任状模板、书类有效期、邮寄方式、审核耗时的正式来源。设计不虚构地址或时效。
7. CONFIRMED 修正提交后是否重审、是否暂停交易、既有权限何时改变。必须有明确告知后才能完成该分支实现。
8. NO/UNKNOWN 实质支配者是否均允许后端提交；country 国籍与居住国是否真的共用一个字段。
9. 文件限制/上传鉴权/访问有效期，个人斜拍是否对法人另有要求（当前文档无此字段）。
10. 正式声明全文；最终审核拒绝的日志排序与轮次区分；EXPIRED 的原因/重提规则。

## 验收清单

- 类型/status 组合、根/baseInfo 回退与未知值；法人永不借用个人 status 放行。
- 各法人状态资格和 CTA；无 userOps 不生成 review 操作；REJECTED 第3/第6节点分别覆盖。
- delegate 切换清理、YES 至少一人、other 目的、证件类型正背面；My Number 无背面、无未约定斜拍。
- 初回 bank 完整，自行修正 payload 不存在 bank 键；上传后类型 fileId 正确。
- 重复点击、超时结果不明、401/403、网络失败、账户切换、页面返回刷新。
- 草稿返回保留、无保存接口不显示“已保存”；错误字段定位；无障碍字号、长文本滚动、底部 CTA、PDF/图片预览。
- 本轮验证仅限文档/设计结构与视觉检查，不代表后端集成通过。

### Figma 设计阶段验证记录

- 法人表单视觉以[个人认证 SP 基本信息](https://www.figma.com/design/z1bib2K5PrvUyOSzLjaGwp?node-id=12400-68322)和[SP 书类上传](https://www.figma.com/design/z1bib2K5PrvUyOSzLjaGwp?node-id=12400-69982)为参考。390 点画板两侧留 20 点，输入与选择框至少 52 点高，标签旁显示「必須」，主次按钮分别采用紫底和紫边胶囊样式。表单顶部增加「会員登録 → 法人情報 → 法人認証」阶段栏，保留日文化的法人七步进度及虚线上传卡。

- 步骤指示器随 App 所选语言显示，当前 Figma 为日文，如「ステップ 6 / 7 ・ 必要書類」。完成节点和同意项使用 Cupertino checkmark，选择框右侧使用 Cupertino chevron_down，上传完成用「添付済み」标记。

- iOS 设计检查覆盖 C01–C24。390 点画板中返回控件调整为 112 × 44，主按钮高 55、次按钮高 47、输入框高 47，默认选择卡高 86、上传卡高 118。次要文字加深。实现时让整张上传卡、选择卡和带编辑操作的确认行响应点击，按设备安全区布局底部操作，并用 Dynamic Type 和 VoiceOver 在实机复核。

- C03–C11 与上传重试 C23 使用个人认证风格的顶部七段进度条，依次用浅紫、深紫、灰色表示已完成、当前、后续步骤。支配者子页沿用第 4 步，两张书类页共用第 6 步。书类选择卡采用浅紫底、虚线圆角边框，居中展示资料名、要求和文件操作。

- 2026-11-19 设计修订：按用户参考图，将 C13–C16 的六步进度统一改为连续的纵向圆点/连接线。完成节点为紫色实心勾选，当前节点为紫色圆环和中心点，未来节点为灰色空心圆；已走过的连接线为紫色，后续为灰色，末尾不延长。节点间距收紧至 80，状态与权限规则不变。四个画板已截图检查。

- Figma 已创建 C01–C24 共 24 个页面/状态画板，使用 8 个本地复用控件和既有 StellaVia 变量；结构检查确认 191 个控件实例、无整页图片，所有文字使用 Zen Kaku Gothic Antique。
- 整体截图已检查；随后修正选择卡选中边框、上传未完成的禁用按钮及审核记录日期展示，并检查修正后的截图。
- 仓库只新增本 roadmap，并在 ai-project-control 加入索引；`rtk git diff --check` 通过。未修改 Dart/ARB，未运行 Flutter 测试，未验证真实接口。
