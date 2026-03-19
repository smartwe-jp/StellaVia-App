# V2 架构实现说明

本文对应你的 3 个落地项：

1. 双仓目录骨架
2. `feature_auth` Clean + Riverpod 示例
3. `core_network` 鉴权/刷新 token 插件实现草案

## 1. 双仓目录骨架

```text
template_v2/
  fundex/  (pub name: fundex)
  mobile_core_sdk/
```

- `fundex`：公司业务模板 App 仓。
- `mobile_core_sdk`：独立 Git 管理的核心插件仓。

> 真正落地时建议拆成两个独立远端仓库：
> - `fundex`
> - `fundex-mobile-core-sdk`

## 2. 业务仓关键规则（Clean + Riverpod）

- 每个 feature 内部强制三层：`presentation/domain/data`
- `domain` 不依赖 Flutter/Dio
- `presentation` 仅通过 usecase 调用 domain
- `data` 实现 domain repository 接口
- 依赖方向：`presentation -> domain <- data`

## 3. core 插件仓关键规则

- `core_network`：网络协议、鉴权、刷新 token、错误规约
- `core_storage`：统一存储协议（secure + kv + cache）
- `core_ui_kit`：主题 token + 通用组件
- `core_foundation`：Result/Failure 等基础类型
- `core_testkit`：测试工具集

## 4. 迁移顺序（从旧 GetX 到新模板）

1. 先完成 app shell + auth feature + core_network
2. 再迁移 hotel（最复杂）
3. 再迁移 financial + notice_contract
4. 最后迁移 identity/tax/profile

## 5. 工具链约束

- Flutter 固定：`3.35.1`
- Dart 固定：`3.9.0`
- 全部命令使用 `fvm` 前缀（如 `fvm flutter test`、`fvm dart test`）

## 6. UI 基准（后续所有页面统一遵循）

- UI 风格：遵循 iOS 交互与视觉标准，面向日本及国际市场审美。
- 必须支持 Light / Dark 模式。
- 字体、颜色、间距、圆角统一沉淀在 `mobile_core_sdk/packages/core_ui_kit`。
- 以后实现 UI 时，样式选择路径必须固定为：先对照设计要求，检查 `core_ui_kit` 现有主题语义与样式是否已覆盖；若已有合适的颜色和字体样式，必须直接复用；若没有，再先补充到主题/样式定义后再使用；禁止在业务页面或组件内直接硬编码颜色、字号、字重等视觉样式。
- 通用控件（弹框、底部弹框等）统一由 `core_ui_kit` 提供，不在业务侧重复实现。
- 业务页面优先复用 SDK 组件，再做业务差异化皮肤。
- View（page/widget）默认只负责布局、样式与事件绑定，不承载可复用业务逻辑。
- 若 View 中出现“未来可能复用”或“会随 UI 变更而复用”的逻辑，必须抽离到可共享位置：
  - 状态流转与数据加载：`presentation/controllers`
  - 展示态转换、文案映射、格式化：`presentation/support`
  - 跨 feature 通用逻辑（如用户字段解析）：`domain/utils` 或公共 util
- 当 UI 改版时，优先只替换 View 层，`controller/support/utils` 应保持可复用和稳定，避免重复实现。

## 7. API 来源与实现规范（Funding / Hotel 分离）

- 酒店业务接口与基金/会员业务接口分开治理，不混用来源。
- 基金/会员业务（含登录、注册、用户资料）接口来源以 funding Swagger 为准（双分支）：
  - Swagger UI：`https://sit-admin.gutingjun.com/api/swagger-ui.html#/`
  - OpenAPI（crowdfunding）：`https://sit-admin.gutingjun.com/api/crowdfunding/v2/api-docs`
  - OpenAPI（member）：`https://sit-admin.gutingjun.com/api/member/v2/api-docs`
- 选型规则：
  - `/crowdfunding/**` 路径优先以 `crowdfunding/v2/api-docs` 定义为准。
  - `/member/**` 路径优先以 `member/v2/api-docs` 定义为准。
  - 若同一接口仅在某一分支存在，以该分支定义落地，并在 `api_paths.dart` 注释标注来源。
- 用户相关实现优先查阅 funding Swagger 中的用户相关分组（如 `user-rest` / `off-rest`）及 member 分支对应定义。
- 除酒店业务外，不再以老工程 `http_conf.dart` 作为新接口实现来源。
- 若 Swagger 暂缺某接口，允许短期使用真实抓包/线上样例报文作为补充，但必须：
  - 在 `fundex/README_API.md`（FUNDEX API 文档）记录请求/响应样例
  - 在代码常量/数据源注释标记“临时来源”
  - 后续拿到 Swagger 定义后及时回收
- `api_paths.dart` 中的接口常量命名应体现业务来源（如 funding auth/user），避免继续使用 `legacy` 命名。

## 8. 跨工程参考标记

- 参考工程路径（本机）：`/Users/aaronhou/Documents/financing-flutter-getx`
- 后续如需补齐历史流程、字段含义或交互细节，先到该工程对照确认，再在 FUNDEX 落地实现。
- 落地优先级：当前 FUNDEX 设计稿与 funding Swagger（crowdfunding + member）> 参考工程实现；参考工程仅作行为参考，不直接复用旧接口命名。

## 9. 多 App 组合优化建议（2026-03-14）

- 网络层依赖反转：`coreHttpClient/tokenStore/tokenRefresher` 统一收敛到 `fundex/lib/app/network/app_network_providers.dart`，业务 feature 不再依赖 `feature_auth` 才能发起请求。
- 多集群注入统一入口：新增 `AppApiCluster`（`oa/member/hotel`）和 `coreHttpClientByClusterProvider`，后续新 App 仅需替换环境配置或 provider override，不需要改各 feature data 层。
- 鉴权失效统一信号：网络层通过 `appNetworkAuthFailureSignalProvider` 发出失效事件，App 层统一处理登出状态，避免网络层反向依赖 auth feature。
- 数据源按集群声明：每个 remote datasource 必须显式选择集群 client（例如 `oaCoreHttpClientProvider`），禁止隐式共享单一 client。
- 后续建议：新增 `ApiEnvelopeParser`（统一处理 `code/msg/data` 兼容 `0/200`）与 `ApiDomainTag`（fund/member/comment/identity）以降低多后端差异成本。

## 10. Envelope 与分页统一策略（阶段二）

- 统一解析器：`LegacyEnvelopeCodec`（`company_api_runtime`）
- App 侧策略常量：`fundex/lib/app/network/app_api_response_profiles.dart`
- 集群成功码策略：
  - OA（crowdfunding/auth）：`code == 200`
  - Member：`code == 0 或 200`
  - Hotel：`code == 0`
- 分页结构策略：
  - 标准结构：`data.rows`
  - 兼容直出：`rows`（无 envelope 时）

## 11. 跨 App 的 API/DTO 下沉规则（必须执行）

- 判定条件：接口来源相同、字段结构稳定，且会被两个及以上 App 复用时，必须下沉到 SDK。
- 下沉范围（放到 `mobile_core_sdk/packages/company_api_runtime` 或后续 `company_api_*`）：
  - API client（按 path/cluster 发起请求）
  - Request/Response DTO
  - envelope 与分页解析
  - 通用错误码与失败消息规范
- 保留范围（留在 App feature）：
  - UseCase 业务编排
  - 页面状态机与交互逻辑（controller/state）
  - UI 展示模型与文案映射
- 结构约束：feature 的 remote datasource 作为薄适配层，优先委托 SDK client，禁止在各 feature 重复实现请求组装与 envelope 解析。
- 迁移顺序：优先迁移读多写少且接口稳定的模块（例如 `discussion_board`），每迁移一个模块必须补 SDK 侧测试并回收 App 侧重复 DTO/解析逻辑。

## 12. 手写 API Client / DTO 脚手架标准（当前执行）

- 鉴于上游 Swagger 质量不稳定，当前阶段默认采用“手写 client + DTO”。
- 标准模板与未来 Skill 自动化流程定义见：
  - `MANUAL_API_CLIENT_DTO_SCAFFOLD_TEMPLATE.md`
  - `skills/manual-api-client-dto-scaffold/SKILL.md`
- 新增接口必须先按模板补齐输入（cluster/path/method/request/response/success code），再落地代码。



## 阶段一任务：

1. 先把 Core SDK 做到“可发布可复用”
    .完成 core_storage 真正实现（flutter_secure_storage + shared_preferences 适配器），替换内存 TokenStore。
    .补齐 core_network 错误模型与并发刷新测试（401 并发、多次重试、刷新失败统一登出）。
    .给 mobile_core_sdk 增加版本发布规范（melos + changelog + tag 流程）。
    .关键文件起点：token_refresh_interceptor.dart、storage_contract.dart。
2. 完成 App 基础设施（模板必须具备）
    .环境与 Flavor：dev/staging/prod 配置、baseUrl 注入。
    .路由守卫：未登录跳 /login，已登录跳 /home。
    .统一错误展示、日志埋点入口。
    .关键文件起点：bootstrap.dart、app_router.dart。
3. 把 feature_auth 做成第一个完整闭环（可上线质量）
    .接入真实接口（验证码发送、登录、refresh、登出）。
    .启动恢复登录态（冷启动自动判定路由）。
    .补 Widget/集成测试（不仅是 controller 单测）。
    .关键文件起点：auth_providers.dart。
4. 再迁移第一个业务纵切片（建议先“首页只读”）
    .推荐顺序：home(会议+待办数) -> hotel list/detail(只读) -> booking+payment。
    .理财和合同放在酒店下单链路后迁移，风险更低。
5. 立刻补 CI（防止模板失控）
