import groovy.json.JsonSlurper
import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use { keystoreProperties.load(it) }
}

val androidLocalPropertiesFile = rootProject.file("local.properties")
val androidLocalProperties = Properties()
if (androidLocalPropertiesFile.exists()) {
    FileInputStream(androidLocalPropertiesFile).use {
        androidLocalProperties.load(it)
    }
}

val requestedTaskNames = gradle.startParameter.taskNames.joinToString(" ").lowercase()
val activeFlavor = when {
    "staging" in requestedTaskNames -> "staging"
    "prod" in requestedTaskNames -> "prod"
    else -> "dev"
}

fun readDartDefineValue(flavor: String, key: String): String? {
    val defineFile = rootDir.parentFile.resolve(".vscode/dart_define.$flavor.local.json")
    if (!defineFile.exists()) {
        return null
    }
    val parsed = JsonSlurper().parse(defineFile)
    val map = parsed as? Map<*, *> ?: return null
    return map[key]?.toString()
}

fun resolveBuildConfigValue(key: String, defaultValue: String = ""): String {
    val localValue = androidLocalProperties.getProperty(key)?.trim()
    if (!localValue.isNullOrEmpty()) {
        return localValue
    }
    val envValue = System.getenv(key)?.trim()
    if (!envValue.isNullOrEmpty()) {
        return envValue
    }
    val defineValue = readDartDefineValue(activeFlavor, key)?.trim()
    if (!defineValue.isNullOrEmpty()) {
        return defineValue
    }
    return defaultValue
}

val aliyunPushAndroidAppKey = resolveBuildConfigValue("ALIYUN_PUSH_ANDROID_APP_KEY")
val aliyunPushAndroidAppSecret = resolveBuildConfigValue("ALIYUN_PUSH_ANDROID_APP_SECRET")
val honorPushAppId = resolveBuildConfigValue("HONOR_PUSH_APP_ID")

val hasReleaseSigning = listOf("storeFile", "storePassword", "keyAlias", "keyPassword").all {
    !keystoreProperties.getProperty(it).isNullOrBlank()
}

android {
    namespace = "com.fund.stellavia"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Update as needed for organization-level signing/release policy.
        applicationId = "com.fund.stellavia"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["aliyunPushAppKey"] = aliyunPushAndroidAppKey
        manifestPlaceholders["aliyunPushAppSecret"] = aliyunPushAndroidAppSecret
        manifestPlaceholders["honorPushAppId"] = honorPushAppId
    }

    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "StellaVia Dev")
        }
        create("staging") {
            dimension = "environment"
            versionNameSuffix = "-staging"
            resValue("string", "app_name", "StellaVia Staging")
        }
        create("prod") {
            dimension = "environment"
            resValue("string", "app_name", "StellaVia")
        }
    }

    signingConfigs {
        create("release") {
            keystoreProperties.getProperty("storeFile")
                ?.takeIf { it.isNotBlank() }
                ?.let { storeFile = file(it) }
            storePassword = keystoreProperties.getProperty("storePassword")
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseSigning) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
