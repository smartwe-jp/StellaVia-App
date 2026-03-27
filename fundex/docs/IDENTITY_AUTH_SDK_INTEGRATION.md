# FUNDEX 认证 SDK 接入说明

本文档对应 `core_identity_auth` 在 `fundex` 的落地接入，覆盖：

- 路由时序
- 错误码/原因码对照
- `dart-define` 配置

## 1. 路由与入口

### 1.1 实人认证入口（Security Center 路径）

- 设置页入口：`/settings` -> `二段階認証` 菜单
- 跳转页面：`/auth/real-person`
- 页面文件：`lib/features/auth/presentation/pages/real_person_auth_page.dart`

执行逻辑：

1. `identityAuthCoordinatorProvider.evaluate(entryPoint: securityCenterRealPerson)`
2. 若已认证，直接返回成功
3. 未认证时调用 `identityAuthLivenessCollectorProvider.collect()`
4. 成功后调用 `verifyWithPhotoBase64(entryPoint: securityCenterRealPerson)`
5. 认证成功 `pop(true)` 返回上一页

### 1.2 敏感操作入口（Sensitive Action 路径）

当前已接入：

- 基金详情底部申购按钮（进入抽选申込）
- 我的页面「提现」快捷按钮

统一守卫：

- `lib/features/auth/presentation/support/identity_auth_guard.dart`
- 核心方法：`ensureSensitiveActionAuthorized(context, ref, identifyGroupId: ...)`

执行逻辑：

1. `authenticateSensitiveAction()`
2. 若 `allowTargetAction`，放行目标操作
3. 若 `startRealPersonEnrollment`，跳转 `/auth/real-person`
4. 返回成功后再执行一次 `authenticateSensitiveAction()`
5. 二次通过才放行

## 2. Provider 组合

文件：`lib/features/auth/presentation/providers/identity_auth_sdk_providers.dart`

- `realPersonApiGatewayProvider`：`RealPersonApiClient`
- `identityAuthStateStoreProvider`：按用户隔离的本地状态存储
- `identityAuthBiometricAuthenticatorProvider`：系统 FaceID/TouchID 适配器
- `identityAuthLivenessCollectorProvider`：百度活体采集适配器
- `identityAuthCoordinatorProvider`：统一流程编排入口

## 3. 错误码/原因码对照

解析入口：

- `lib/features/auth/presentation/support/identity_auth_message_resolver.dart`

| reasonCode / error | 显示文案来源 |
|---|---|
| `security_center_already_verified` | `identityAuthAlreadyVerified` |
| `biometric_authenticator_not_configured` | `identityAuthBiometricNotConfigured` |
| `liveness_collector_not_configured` | `identityAuthLivenessNotConfigured` |
| `real_person_identify_failed` | `identityAuthVerifyFailed` |
| `real_person_identify_error` | 服务端错误文本或 `identityAuthVerifyFailed` |
| `liveness_collect_failed` | 细分映射见下 |
| `empty_liveness_photo` | `identityAuthCollectFailed` |
| `device_biometric_failed_blocked` | `identityAuthSensitiveBlocked` |

`liveness_collect_failed` 的细分：

- `baidu_face_license_missing` -> `identityAuthBaiduLicenseMissing`
- `baidu_face_collect_empty` -> `identityAuthCollectFailed`
- 其他 -> 直接显示 SDK 返回错误文本

## 4. dart-define 配置

### 4.1 百度活体验证 License

`identityAuthLivenessCollectorProvider` 读取：

- Android: `BAIDU_FACE_LICENSE_ID_ANDROID`
- Android 兼容旧配置：`BAIDU_FACE_LICENSE_ID`
- iOS: `BAIDU_FACE_LICENSE_ID_IOS`
- iOS 兼容旧配置：`BAIDU_FACE_LICENSE_ID`

示例：

```bash
fvm flutter run \
  --flavor dev \
  -t lib/main_dev.dart \
  --dart-define=BAIDU_FACE_LICENSE_ID_ANDROID=demo-face-android \
  --dart-define=BAIDU_FACE_LICENSE_ID_IOS=demo-face-ios
```

> Android/iOS 都需要 `licenseId`。仅放置授权文件不够。
> 推荐分别配置 `BAIDU_FACE_LICENSE_ID_ANDROID` 与 `BAIDU_FACE_LICENSE_ID_IOS`，共享旧配置 `BAIDU_FACE_LICENSE_ID` 仅作为兼容回退。

## 5. 平台配置

### iOS

- `Info.plist` 新增 `NSFaceIDUsageDescription`
- 百度活体插件需按其 README 放置 iOS 资源与授权文件

### Android

- 生物识别由 `local_auth` 插件处理
- 百度活体插件依赖内置 `aar` 与 `jniLibs`

## 6. 后续建议

1. 在敏感业务（出金、解约、关键资料变更）统一调用 `ensureSensitiveActionAuthorized`
2. 对 `identityAuthStateStore` 增加服务端状态回填（与用户资料接口打通）
3. 将 `reasonCode` 上报埋点，便于分析认证失败分布
