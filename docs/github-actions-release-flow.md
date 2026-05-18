# GitHub Actions 配置与发布流程

最后核对日期：2026-05-11

本文档记录当前工程 GitHub Actions 的 CI、Android 发布、iOS 发布流程，以及各参数、Secret、脚本和平台配置的来源。当前移动应用主体位于 `fundex/`，共享 SDK 位于 `mobile_core_sdk/`。

## Workflow 总览

| Workflow | 文件 | 触发方式 | 主要用途 |
| --- | --- | --- | --- |
| CI | `.github/workflows/ci.yml` | PR、推送 `main`、手动触发 | 安装依赖、生成多语言、静态分析、测试 |
| Release Build | `.github/workflows/release.yml` | 手动触发 `workflow_dispatch` | 构建 Android AAB、iOS IPA，并可上传到 Google Play / App Store Connect |

两个 workflow 都设置了：

```yaml
permissions:
  contents: read

env:
  FORCE_JAVASCRIPT_ACTIONS_TO_NODE24: "true"
```

`FORCE_JAVASCRIPT_ACTIONS_TO_NODE24` 用于强制 JavaScript Action 使用 Node 24 运行环境。

## CI 流程

来源文件：`.github/workflows/ci.yml`

### 触发条件

PR 或 `main` 分支 push 时，只有以下路径变化才触发：

```text
.github/workflows/**
fundex/**
mobile_core_sdk/**
```

也支持手动触发：

```yaml
workflow_dispatch:
```

### 执行环境

| 项目 | 值 |
| --- | --- |
| Runner | `ubuntu-latest` |
| 工作目录 | `fundex` |
| Java | Temurin 17 |
| Flutter | `3.41.4` |
| 超时 | 30 分钟 |

### 执行步骤

实际命令顺序：

```bash
flutter --version
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
```

含义：

1. `flutter pub get` 安装 `fundex/pubspec.yaml` 中的依赖。
2. `flutter gen-l10n` 根据 `fundex/l10n.yaml` 和 `fundex/lib/l10n/*.arb` 生成本地化代码。
3. `flutter analyze` 做静态检查。
4. `flutter test` 运行 Flutter 测试。

## Release Build 入口

来源文件：`.github/workflows/release.yml`

### 手动触发参数

在 GitHub Actions 页面选择 `Release Build` -> `Run workflow`。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `platform` | choice | `all` | `all` / `android` / `ios` |
| `build_name` | string | 空 | 可覆盖 App 版本名，例如 `1.0.11` |
| `build_number` | string | 空 | 可覆盖 build number，例如 `43` |
| `upload_android` | boolean | `false` | 是否上传 Android AAB 到 Google Play |
| `android_track` | choice | `internal` | `internal` / `production` |
| `upload_ios` | boolean | `false` | 是否上传 iOS IPA 到 App Store Connect |

如果 `build_name` 或 `build_number` 为空，workflow 会从 `fundex/pubspec.yaml` 的 `version` 读取。当前格式示例：

```yaml
version: 1.0.11+43
```

解析规则：

```text
build_name = 1.0.11
build_number = 43
```

## Android 发布流程

来源文件：

```text
.github/workflows/release.yml
fundex/android/app/build.gradle.kts
fundex/tool/validate_prod_dart_defines.dart
fundex/pubspec.yaml
```

### 执行条件

当手动触发参数满足以下条件时执行：

```text
platform = all 或 android
```

### 执行环境

| 项目 | 值 |
| --- | --- |
| Runner | `ubuntu-latest` |
| 工作目录 | `fundex` |
| Java | Temurin 17 |
| Flutter | `3.41.4` |
| 超时 | 45 分钟 |

### Android 包名与 flavor

Android 包名来源：`fundex/android/app/build.gradle.kts`

```kotlin
namespace = "com.fund.stellavia"
applicationId = "com.fund.stellavia"
```

发布使用 prod flavor：

```bash
flutter build appbundle \
  --flavor prod \
  -t lib/main_prod.dart \
  --dart-define-from-file=.vscode/dart_define.prod.local.json
```

### Android Secret 清单

| Secret | 用途 | 何时必需 | 来源 |
| --- | --- | --- | --- |
| `STELLAVIA_DART_DEFINE_PROD_JSON` | 生产环境 Dart Define JSON | 构建必需 | 生产环境配置 |
| `STELLAVIA_ANDROID_KEYSTORE_BASE64` | Android upload keystore 的 base64 | 构建必需 | Android 签名 keystore |
| `STELLAVIA_ANDROID_STORE_PASSWORD` | keystore 密码 | 构建必需 | Android 签名配置 |
| `STELLAVIA_ANDROID_KEY_ALIAS` | key alias | 构建必需 | Android 签名配置 |
| `STELLAVIA_ANDROID_KEY_PASSWORD` | key 密码 | 构建必需 | Android 签名配置 |
| `STELLAVIA_GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` | Google Play service account JSON 原文 | 仅 `upload_android=true` 时必需 | Google Cloud service account key；还需要在 Play Console 授权 |

### Dart Define 来源与校验

workflow 将 `STELLAVIA_DART_DEFINE_PROD_JSON` 写入：

```text
fundex/.vscode/dart_define.prod.local.json
```

随后执行：

```bash
dart tool/validate_prod_dart_defines.dart .vscode/dart_define.prod.local.json
```

当前校验规则来源：`fundex/tool/validate_prod_dart_defines.dart`

生产包要求：

```text
ENABLE_IDENTITY_AUTH=true
```

### Android 签名文件生成

workflow 将 `STELLAVIA_ANDROID_KEYSTORE_BASE64` 解码为：

```text
fundex/android/upload-keystore.jks
```

并生成：

```text
fundex/android/key.properties
```

内容格式：

```properties
storeFile=/path/to/fundex/android/upload-keystore.jks
storePassword=...
keyAlias=...
keyPassword=...
```

Gradle 读取来源：`fundex/android/app/build.gradle.kts`

```kotlin
val keystorePropertiesFile = rootProject.file("key.properties")
```

release 构建优先使用 release signing；如果没有签名配置，会 fallback 到 debug signing，但 CD 的 Secret 校验会阻止生产发布缺少签名配置。

### Android native 配置来源

`build.gradle.kts` 会从以下顺序解析部分 native 配置：

1. `fundex/android/local.properties`
2. 环境变量
3. `.vscode/dart_define.<flavor>.local.json`
4. 默认空字符串

当前使用的 key：

```text
ALIYUN_PUSH_ANDROID_APP_KEY
ALIYUN_PUSH_ANDROID_APP_SECRET
HONOR_PUSH_APP_ID
GOOGLE_MAPS_API_KEY
GOOGLE_MAPS_ANDROID_API_KEY
```

它们写入 Android manifest placeholders：

```kotlin
manifestPlaceholders["aliyunPushAppKey"]
manifestPlaceholders["aliyunPushAppSecret"]
manifestPlaceholders["honorPushAppId"]
manifestPlaceholders["googleMapsApiKey"]
```

Google Maps Android key 使用 `GOOGLE_MAPS_ANDROID_API_KEY`，为空时 fallback 到共享的
`GOOGLE_MAPS_API_KEY`。

### iOS native 配置来源

`Runner/Info.plist` 会把 Flutter 生成的 `DART_DEFINES` 注入到 App bundle。
`AppDelegate.swift` 解析其中的 Google Maps key：

```text
GOOGLE_MAPS_IOS_API_KEY
GOOGLE_MAPS_API_KEY
```

Google Maps iOS key 优先使用 `GOOGLE_MAPS_IOS_API_KEY`，为空时 fallback 到共享的
`GOOGLE_MAPS_API_KEY`。

### AAB 输出与 artifact

默认构建输出目录：

```text
fundex/build/app/outputs/bundle/prodRelease/
```

workflow 会重命名 AAB：

```text
StellaVia-prod-release-{build_name}({build_number}).aab
```

Artifact 名称：

```text
StellaVia-android-prod-{build_name}({build_number})
```

上传 artifact 包含：

```text
fundex/build/app/outputs/bundle/prodRelease/*.aab
fundex/build/app/outputs/mapping/prodRelease/
```

保留时间：14 天。

### Google Play 上传

Action：

```yaml
uses: r0adkll/upload-google-play@v1.1.3
```

参数：

```yaml
serviceAccountJsonPlainText: ${{ secrets.STELLAVIA_GOOGLE_PLAY_SERVICE_ACCOUNT_JSON }}
packageName: com.fund.stellavia
releaseFiles: fundex/build/app/outputs/bundle/prodRelease/*.aab
track: ${{ inputs.android_track }}
status: completed
```

如果存在 mapping 文件，会同时上传：

```yaml
mappingFile: fundex/build/app/outputs/mapping/prodRelease/mapping.txt
```

Google Play service account 注意事项：

1. JSON key 在 Google Cloud 的 Service Account 页面创建。
2. 旧 key 不能再次下载，只能创建新 key。
3. 仅有 JSON 不够，必须在 Play Console 的 Users and permissions 中给该 service account 授权。
4. App 迁移 Google Play 账号后，旧账号的 API 权限不会自动保证可用，需要在新账号重新授权。
5. 如果失败在 `Creating a new Edit for this release` 且报 `The caller does not have permission`，通常是 service account 没有新 Play Console 应用的发布权限。

## iOS 发布流程

来源文件：

```text
.github/workflows/release.yml
fundex/scripts/build_ios_appstore.sh
fundex/ios/Runner.xcodeproj/project.pbxproj
fundex/ios/Runner/RunnerProd.entitlements
fundex/tool/validate_prod_dart_defines.dart
```

### 执行条件

当手动触发参数满足以下条件时执行：

```text
platform = all 或 ios
```

### 执行环境

| 项目 | 值 |
| --- | --- |
| Runner | `macos-26` |
| 工作目录 | `fundex` |
| Flutter | `3.41.4` |
| 超时 | 75 分钟 |

### iOS SDK 校验

workflow 会执行：

```bash
xcodebuild -version
xcrun --sdk iphoneos --show-sdk-version
```

当前规则：

```text
iPhoneOS SDK 必须是 26.x 或更高
```

否则中断：

```text
App Store Connect requires iOS 26 SDK or later.
```

### iOS Secret 清单

| Secret | 用途 | 何时必需 | 来源 |
| --- | --- | --- | --- |
| `STELLAVIA_DART_DEFINE_PROD_JSON` | 生产环境 Dart Define JSON | 构建必需 | 生产环境配置 |
| `STELLAVIA_IOS_DIST_CERT_P12_BASE64` | Apple Distribution 证书 p12 的 base64 | 构建必需 | Apple Developer 证书 |
| `STELLAVIA_IOS_DIST_CERT_PASSWORD` | p12 密码 | 构建必需 | Apple Developer 证书密码 |
| `STELLAVIA_IOS_PROVISIONING_PROFILE_BASE64` | App Store provisioning profile 的 base64 | 构建必需 | Apple Developer profile |
| `STELLAVIA_APP_STORE_CONNECT_API_KEY_ID` | App Store Connect API Key ID | 仅 `upload_ios=true` 时必需 | App Store Connect API key |
| `STELLAVIA_APP_STORE_CONNECT_ISSUER_ID` | Issuer ID | 仅 `upload_ios=true` 时必需 | App Store Connect API key |
| `STELLAVIA_APP_STORE_CONNECT_API_KEY_P8_BASE64` | `.p8` API key base64 | 仅 `upload_ios=true` 时必需 | App Store Connect API key |

### Dart Define 来源与校验

iOS 与 Android 共用同一个 Secret：

```text
STELLAVIA_DART_DEFINE_PROD_JSON
```

写入：

```text
fundex/.vscode/dart_define.prod.local.json
```

执行：

```bash
dart tool/validate_prod_dart_defines.dart .vscode/dart_define.prod.local.json
```

生产包同样要求：

```text
ENABLE_IDENTITY_AUTH=true
```

### iOS 签名配置

workflow 使用：

```yaml
apple-actions/import-codesign-certs@v3
```

导入 p12 证书。

Provisioning profile 安装流程：

```bash
PROFILE_PATH="$RUNNER_TEMP/fundex.mobileprovision"
printf '%s' "$IOS_PROVISIONING_PROFILE_BASE64" | openssl base64 -d -A -out "$PROFILE_PATH"
security cms -D -i "$PROFILE_PATH" > "$PROFILE_PLIST"
PROFILE_UUID=$(/usr/libexec/PlistBuddy -c 'Print UUID' "$PROFILE_PLIST")
cp "$PROFILE_PATH" "$HOME/Library/MobileDevice/Provisioning Profiles/$PROFILE_UUID.mobileprovision"
```

workflow 传给脚本的 prod 签名参数：

```text
IOS_TEAM_ID=AY756KKKWF
IOS_BUNDLE_ID=com.fund.stellavia
IOS_PROVISIONING_PROFILE_NAME=Stellavia_prod_Profile
```

Xcode 工程中 prod 相关配置也指向：

```text
PRODUCT_BUNDLE_IDENTIFIER = com.fund.stellavia
PROVISIONING_PROFILE_SPECIFIER = Stellavia_prod_Profile
```

prod entitlement 来源：

```text
fundex/ios/Runner/RunnerProd.entitlements
```

其中 APNs 环境为：

```xml
<key>aps-environment</key>
<string>production</string>
```

### iOS IPA 构建脚本

workflow 最终调用：

```bash
bash scripts/build_ios_appstore.sh
```

脚本来源：`fundex/scripts/build_ios_appstore.sh`

脚本生成临时 `ExportOptions.plist`：

```xml
<key>method</key>
<string>app-store</string>
<key>signingStyle</key>
<string>manual</string>
<key>teamID</key>
<string>${IOS_TEAM_ID}</string>
<key>signingCertificate</key>
<string>Apple Distribution</string>
```

然后执行：

```bash
flutter build ipa \
  --flavor prod \
  -t lib/main_prod.dart \
  --dart-define-from-file="$DEFINE_FILE" \
  --export-options-plist="$EXPORT_OPTIONS_PLIST"
```

如果 workflow 输入了 `build_name` / `build_number`，会追加：

```bash
--build-name "$BUILD_NAME"
--build-number "$BUILD_NUMBER"
```

### iOS IPA 输出与 artifact

默认输出目录：

```text
fundex/build/ios/ipa/
```

workflow 重命名 IPA：

```text
StellaVia-{build_name}({build_number}).ipa
```

Artifact 名称：

```text
StellaVia-ios-prod-{build_name}({build_number})
```

上传 artifact 路径：

```text
fundex/build/ios/ipa/
```

保留时间：14 天。

### App Store Connect 上传

当 `upload_ios=true` 时，workflow 会：

1. 将 `STELLAVIA_APP_STORE_CONNECT_API_KEY_P8_BASE64` 解码到：

   ```text
   $RUNNER_TEMP/AuthKey_{KEY_ID}.p8
   ```

2. 设置：

   ```text
   APP_STORE_CONNECT_API_KEY_PATH
   ```

3. 构建脚本在 GitHub Actions 环境中使用 `xcrun altool` 上传：

   ```bash
   xcrun altool \
     --upload-app \
     --type ios \
     --file "$IPA_PATH" \
     --apiKey "$KEY_ID" \
     --apiIssuer "$ISSUER_ID" \
     --verbose
   ```

如果本地执行脚本且不是 GitHub Actions，脚本会优先尝试 `iTMSTransporter`，失败后 fallback 到 `altool`。

## 本地复现参考

### CI 本地近似执行

```bash
cd fundex
fvm flutter pub get
fvm flutter gen-l10n
fvm flutter analyze
fvm flutter test
```

### Android prod AAB 本地构建

前提：

1. 准备 `.vscode/dart_define.prod.local.json`
2. 准备 `fundex/android/key.properties`
3. `ENABLE_IDENTITY_AUTH=true`

执行：

```bash
cd fundex
dart tool/validate_prod_dart_defines.dart .vscode/dart_define.prod.local.json
fvm flutter build appbundle \
  --flavor prod \
  -t lib/main_prod.dart \
  --dart-define-from-file=.vscode/dart_define.prod.local.json
```

### iOS prod IPA 本地构建

前提：

1. 安装正确的 Apple Distribution 证书。
2. 安装 `Stellavia_prod_Profile` provisioning profile。
3. 准备 `.vscode/dart_define.prod.local.json`。
4. Xcode / iPhoneOS SDK 满足当前 App Store 要求。

执行：

```bash
cd fundex
DART_DEFINE_FILE=.vscode/dart_define.prod.local.json \
BUILD_NAME=1.0.11 \
BUILD_NUMBER=43 \
SKIP_UPLOAD=1 \
IOS_TEAM_ID=AY756KKKWF \
IOS_BUNDLE_ID=com.fund.stellavia \
IOS_PROVISIONING_PROFILE_NAME=Stellavia_prod_Profile \
bash scripts/build_ios_appstore.sh
```

## 常见问题定位

### Android 上传失败：`The caller does not have permission`

如果日志停在：

```text
Creating a new Edit for this release
Error: The caller does not have permission
```

说明 AAB 通常已经构建完成，失败发生在 Google Play Developer API 创建 edit 阶段。优先检查：

1. `STELLAVIA_GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` 的 `client_email` 是否是当前 Play Console 授权的 service account。
2. service account 是否对 `com.fund.stellavia` 有对应 track 的发布权限。
3. App 迁移 Google 账号后，是否在新 Play Console 中重新授权了该 service account。
4. Google Play Developer API 是否在对应 Google Cloud Project 中启用。

### Android 构建失败：缺少签名或 Dart Define

workflow 会在 `Validate Android Release Secrets` 阶段提前失败，并打印缺少的 Secret 名称。常见缺失：

```text
STELLAVIA_DART_DEFINE_PROD_JSON
STELLAVIA_ANDROID_KEYSTORE_BASE64
STELLAVIA_ANDROID_STORE_PASSWORD
STELLAVIA_ANDROID_KEY_ALIAS
STELLAVIA_ANDROID_KEY_PASSWORD
```

### iOS 构建失败：SDK 版本不足

如果日志显示：

```text
App Store Connect requires iOS 26 SDK or later.
```

需要升级 GitHub Actions runner / Xcode 环境。当前 workflow 使用：

```text
runs-on: macos-26
```

### iOS 签名失败

优先检查：

1. `STELLAVIA_IOS_DIST_CERT_P12_BASE64` 和 `STELLAVIA_IOS_DIST_CERT_PASSWORD` 是否匹配。
2. `STELLAVIA_IOS_PROVISIONING_PROFILE_BASE64` 是否是 `com.fund.stellavia` 的 App Store profile。
3. profile 名称是否匹配 `Stellavia_prod_Profile`。
4. Team ID 是否匹配 `AY756KKKWF`。
5. `RunnerProd.entitlements` 是否保持 production APNs。

### iOS 上传失败

当 `upload_ios=true` 时，确认：

```text
STELLAVIA_APP_STORE_CONNECT_API_KEY_ID
STELLAVIA_APP_STORE_CONNECT_ISSUER_ID
STELLAVIA_APP_STORE_CONNECT_API_KEY_P8_BASE64
```

都存在，且 API key 在 App Store Connect 中有上传构建所需权限。

## 修改发布流程时的注意点

1. 改 Android 包名时，需要同步修改：
   - `fundex/android/app/build.gradle.kts`
   - `.github/workflows/release.yml` 中的 `packageName`
   - Google Play Console 应用包名不可随意变更
2. 改 iOS bundle id 时，需要同步修改：
   - `fundex/ios/Runner.xcodeproj/project.pbxproj`
   - `.github/workflows/release.yml` 中的 `IOS_BUNDLE_ID`
   - Apple Developer profile
   - App Store Connect App
3. 改 prod profile 名称时，需要同步修改：
   - Xcode project 的 `PROVISIONING_PROFILE_SPECIFIER`
   - `.github/workflows/release.yml` 的 `IOS_PROVISIONING_PROFILE_NAME`
4. 更新 Flutter 版本时，需要同步检查：
   - `.github/workflows/ci.yml`
   - `.github/workflows/release.yml`
   - 本地 FVM 版本
5. 更新生产 Dart Define 时，至少保证：
   - JSON 是对象
   - `ENABLE_IDENTITY_AUTH=true`
   - Android 推送相关 key 可被 `build.gradle.kts` 读取
