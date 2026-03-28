package com.fluttercandies.flutter_bdface_collect;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.os.Build;

import androidx.annotation.NonNull;

import com.baidu.idl.face.platform.FaceSDKManager;
import com.baidu.idl.face.platform.LivenessTypeEnum;
import com.baidu.idl.face.platform.model.ImageInfo;
import com.baidu.idl.facelive.api.FaceLiveManager;
import com.baidu.idl.facelive.api.callback.InitCallback;
import com.baidu.idl.facelive.api.entity.FaceLiveConfig;
import com.baidu.idl.facelive.api.entity.InitOption;
import com.baidu.idl.facelive.api.entity.LivenessValueModel;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class FlutterBdfaceCollectPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    static final int COLLECT_REQ_CODE = 19491001;
    public static final int COLLECT_OK_CODE = 10011949;
    private static final String CHANNEL_NAME = "com.fluttercandies.bdface_collect";
    private static final String LICENSE_FILE_NAME = "idl-license.face-android";
    private static String preferredLocaleTag;

    private MethodChannel channel;
    private Activity activity;
    private Result pendingResult;

    static String imageCropBase64;
    static String imageSrcBase64;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getBinaryMessenger(), CHANNEL_NAME);
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case MethodConstants.GetPlatformVersion:
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case MethodConstants.Init:
                init(call.arguments, result);
                break;
            case MethodConstants.Collect:
                collect(call.arguments, result);
                break;
            case MethodConstants.UnInit:
                unInit(result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        if (channel != null) {
            channel.setMethodCallHandler(null);
        }
        pendingResult = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        binding.addActivityResultListener((requestCode, resultCode, data) -> {
            if (requestCode != COLLECT_REQ_CODE) {
                return false;
            }
            if (pendingResult != null) {
                HashMap<String, String> response = null;
                if (resultCode == COLLECT_OK_CODE) {
                    response = new HashMap<>();
                    response.put("imageCropBase64", imageCropBase64);
                    response.put("imageSrcBase64", imageSrcBase64);
                }
                pendingResult.success(response);
            }
            imageCropBase64 = null;
            imageSrcBase64 = null;
            pendingResult = null;
            return true;
        });
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
        pendingResult = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        pendingResult = null;
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
        pendingResult = null;
    }

    private void init(Object arguments, final Result result) {
        String localeTag = "";
        String licenseId = "";
        if (arguments instanceof String) {
            licenseId = ((String) arguments).trim();
        } else if (arguments instanceof Map) {
            @SuppressWarnings("unchecked")
            Map<String, Object> argumentsMap = (Map<String, Object>) arguments;
            licenseId = getString(argumentsMap, "licenseId");
            localeTag = getString(argumentsMap, "localeTag");
        }
        setPreferredLocaleTag(localeTag);
        if (activity == null) {
            result.success(formatInitError("NO_ACTIVITY", localizedPluginMessage(null, PluginMessageKey.NO_ACTIVITY)));
            return;
        }
        if (licenseId.isEmpty()) {
            result.success(formatInitError("INVALID_ARGUMENT", localizedPluginMessage(activity, PluginMessageKey.LICENSE_ID_EMPTY)));
            return;
        }

        InitOption option = new InitOption();
        option.licenseKey = licenseId;
        option.licenseFileName = LICENSE_FILE_NAME;
        final Context appContext = activity.getApplicationContext();
        FaceLiveManager.getInstance().init(appContext, option, new InitCallback() {
            @Override
            public void onSuccess(int resultCode, String resultMsg) {
                if (activity == null) {
                    result.success(formatInitError(resultCode, localizeInitErrorMessage(appContext, resultCode, resultMsg)));
                    return;
                }
                activity.runOnUiThread(() -> result.success(null));
            }

            @Override
            public void onError(int resultCode, String resultMsg) {
                if (activity == null) {
                    result.success(formatInitError(resultCode, localizeInitErrorMessage(appContext, resultCode, resultMsg)));
                    return;
                }
                activity.runOnUiThread(() -> result.success(
                        formatInitError(resultCode, localizeInitErrorMessage(activity, resultCode, resultMsg))
                ));
            }
        });
    }

    private void collect(Object arguments, final Result result) {
        if (activity == null) {
            result.success(errorResult(localizedPluginMessage(null, PluginMessageKey.NO_ACTIVITY)));
            return;
        }
        if (pendingResult != null) {
            result.success(errorResult(localizedPluginMessage(activity, PluginMessageKey.COLLECT_IN_PROGRESS)));
            return;
        }
        if (!FaceSDKManager.getInstance().getInitFlag()) {
            result.success(errorResult(localizedPluginMessage(activity, PluginMessageKey.SDK_NOT_INITIALIZED)));
            return;
        }
        if (!(arguments instanceof Map)) {
            result.success(errorResult(localizedPluginMessage(activity, PluginMessageKey.INVALID_COLLECT_ARGUMENTS)));
            return;
        }

        @SuppressWarnings("unchecked")
        Map<String, Object> argumentsMap = (Map<String, Object>) arguments;
        setPreferredLocaleTag(getString(argumentsMap, "localeTag"));
        boolean useActionLiveness = setFaceConfig(argumentsMap);

        Intent intent = new Intent(
                activity,
                useActionLiveness ? FinanceFaceActionLivenessActivity.class : FinanceFaceSilenceLivenessActivity.class
        );
        imageCropBase64 = null;
        imageSrcBase64 = null;
        pendingResult = result;
        activity.startActivityForResult(intent, COLLECT_REQ_CODE);
    }

    private void unInit(final Result result) {
        FaceLiveManager.getInstance().release();
        result.success(null);
    }

    private boolean setFaceConfig(Map<String, Object> argumentsMap) {
        FaceLiveConfig config = FaceLiveManager.getInstance().getFaceConfig();
        if (config == null) {
            config = new FaceLiveConfig();
        }

        config.setMinFaceSize(getInt(argumentsMap, "minFaceSize", 200));
        config.setNotFaceValue((float) getDouble(argumentsMap, "notFace", 0.6d));
        config.setBrightnessValue((float) getDouble(argumentsMap, "brightness", 40d));
        config.setBrightnessMaxValue((float) getDouble(argumentsMap, "brightnessMax", 220d));
        config.setBlurnessValue((float) getDouble(argumentsMap, "blurness", 0.6d));
        config.setOcclusionLeftEyeValue((float) getDouble(argumentsMap, "occlusionLeftEye", 0.8d));
        config.setOcclusionRightEyeValue((float) getDouble(argumentsMap, "occlusionRightEye", 0.8d));
        config.setOcclusionNoseValue((float) getDouble(argumentsMap, "occlusionNose", 0.8d));
        config.setOcclusionMouthValue((float) getDouble(argumentsMap, "occlusionMouth", 0.8d));
        config.setOcclusionLeftContourValue((float) getDouble(argumentsMap, "occlusionLeftContour", 0.8d));
        config.setOcclusionRightContourValue((float) getDouble(argumentsMap, "occlusionRightContour", 0.8d));
        config.setOcclusionChinValue((float) getDouble(argumentsMap, "occlusionChin", 0.8d));
        config.setHeadPitchValue(getInt(argumentsMap, "headPitch", 20));
        config.setHeadYawValue(getInt(argumentsMap, "headYaw", 18));
        config.setHeadRollValue(getInt(argumentsMap, "headRoll", 20));
        config.setEyeClosedValue((float) getDouble(argumentsMap, "eyeClosed", 0.7d));
        config.setCacheImageNum(3);
        config.setScale((float) getDouble(argumentsMap, "scale", 1d));
        config.setCropHeight(getInt(argumentsMap, "cropHeight", 640));
        config.setCropWidth(getInt(argumentsMap, "cropWidth", 480));
        config.setEnlargeRatio((float) getDouble(argumentsMap, "enlargeRatio", 1.5d));
        config.setFaceFarRatio((float) getDouble(argumentsMap, "faceFarRatio", 0.4d));
        config.setFaceClosedRatio((float) getDouble(argumentsMap, "faceClosedRatio", 1d));
        config.setSound(getBoolean(argumentsMap, "sound", true));
        config.setLivenessRandom(getBoolean(argumentsMap, "livenessRandom", true));
        config.setShowResultView(false);
        config.setOpenRecord(false);
        config.setIgnoreRecordError(true);
        config.setSaveVideoWhenError(false);
        config.setIsShowTimeoutDialog(true);
        config.setIsOpenColorLive(false);
        config.setIsOpenDistanceLive(false);
        config.setShowLanguageSwitch(false);
        config.setLivenessLanguage(resolveSdkLanguageTag(getString(argumentsMap, "localeTag")));
        setSecTypeIfPossible(config, getInt(argumentsMap, "secType", 0));

        List<LivenessTypeEnum> livenessTypeEnums = mapLivenessTypes(getStringList(argumentsMap, "livenessTypes"));
        boolean useActionLiveness = !livenessTypeEnums.isEmpty();
        config.setIsOpenActionLive(useActionLiveness);
        if (useActionLiveness) {
            LivenessValueModel model = config.getLivenessValueModel();
            if (model == null) {
                model = new LivenessValueModel();
            }
            model.actionList.clear();
            model.actionList.addAll(livenessTypeEnums);
            model.actionRandomNumber = livenessTypeEnums.size();
            try {
                config.setLivenessValueModel(model);
            } catch (Exception ignored) {
                // Fall back to the mutated model already attached to the config.
            }
        }

        FaceLiveManager.getInstance().setFaceConfig(config);
        return useActionLiveness;
    }

    private static void setSecTypeIfPossible(FaceLiveConfig config, int secType) {
        try {
            Method method = FaceLiveConfig.class.getSuperclass().getDeclaredMethod("setSecType", int.class);
            method.setAccessible(true);
            method.invoke(config, secType);
        } catch (Exception ignored) {
            // Ignore because secType is not a public API on the new Android SDK.
        }
    }

    private static int getInt(Map<String, Object> argumentsMap, String key, int defaultValue) {
        Object value = argumentsMap.get(key);
        return value instanceof Number ? ((Number) value).intValue() : defaultValue;
    }

    private static double getDouble(Map<String, Object> argumentsMap, String key, double defaultValue) {
        Object value = argumentsMap.get(key);
        return value instanceof Number ? ((Number) value).doubleValue() : defaultValue;
    }

    private static boolean getBoolean(Map<String, Object> argumentsMap, String key, boolean defaultValue) {
        Object value = argumentsMap.get(key);
        return value instanceof Boolean ? (Boolean) value : defaultValue;
    }

    private static List<String> getStringList(Map<String, Object> argumentsMap, String key) {
        Object value = argumentsMap.get(key);
        if (!(value instanceof List)) {
            return Collections.emptyList();
        }
        List<?> rawList = (List<?>) value;
        List<String> stringList = new ArrayList<>();
        for (Object item : rawList) {
            if (item instanceof String) {
                stringList.add((String) item);
            }
        }
        return stringList;
    }

    private static String getString(Map<String, Object> argumentsMap, String key) {
        Object value = argumentsMap.get(key);
        return value instanceof String ? ((String) value).trim() : "";
    }

    private static List<LivenessTypeEnum> mapLivenessTypes(List<String> livenessTypes) {
        List<LivenessTypeEnum> enums = new ArrayList<>();
        for (String type : livenessTypes) {
            switch (type) {
                case "Eye":
                    enums.add(LivenessTypeEnum.Eye);
                    break;
                case "Mouth":
                    enums.add(LivenessTypeEnum.Mouth);
                    break;
                case "HeadLeft":
                    enums.add(LivenessTypeEnum.HeadLeft);
                    break;
                case "HeadRight":
                    enums.add(LivenessTypeEnum.HeadRight);
                    break;
                case "HeadUp":
                    enums.add(LivenessTypeEnum.HeadUp);
                    break;
                case "HeadDown":
                    enums.add(LivenessTypeEnum.HeadDown);
                    break;
                case "HeadShake":
                    enums.add(LivenessTypeEnum.HeadShake);
                    break;
                case "HeadUpDown":
                    enums.add(LivenessTypeEnum.HeadUpDown);
                    break;
                default:
                    break;
            }
        }
        return enums;
    }

    static String selectBestImage(Map<String, ImageInfo> imageMap, boolean secureBase64) {
        if (imageMap == null || imageMap.isEmpty()) {
            return null;
        }
        List<Map.Entry<String, ImageInfo>> entries = new ArrayList<>(imageMap.entrySet());
        Collections.sort(entries, (left, right) -> Float.compare(extractScore(right.getKey()), extractScore(left.getKey())));
        ImageInfo imageInfo = entries.get(0).getValue();
        if (imageInfo == null) {
            return null;
        }
        String value = secureBase64 ? imageInfo.getSecBase64() : imageInfo.getBase64();
        if (value == null || value.trim().isEmpty()) {
            value = imageInfo.getBase64();
        }
        return value;
    }

    private static float extractScore(String key) {
        if (key == null || key.trim().isEmpty()) {
            return Float.MIN_VALUE;
        }
        String[] parts = key.split("_");
        if (parts.length < 3) {
            return Float.MIN_VALUE;
        }
        try {
            return Float.parseFloat(parts[2]);
        } catch (NumberFormatException ignored) {
            return Float.MIN_VALUE;
        }
    }

    private static HashMap<String, String> errorResult(String error) {
        HashMap<String, String> response = new HashMap<>();
        response.put("imageCropBase64", "");
        response.put("imageSrcBase64", "");
        response.put("error", error == null ? "" : error);
        return response;
    }

    private static String formatInitError(int resultCode, String resultMsg) {
        return "errCode: " + resultCode + ", errMsg: " + resultMsg;
    }

    private static String formatInitError(String resultCode, String resultMsg) {
        return "errCode: " + resultCode + ", errMsg: " + resultMsg;
    }

    private static String localizeInitErrorMessage(Context context, int resultCode, String resultMsg) {
        final String normalized = resultMsg == null ? "" : resultMsg.trim().toUpperCase(Locale.ROOT);
        if (normalized.contains("LICENSE_LOCAL_FILE_ERROR") || normalized.contains("LOCAL_FILE_ERROR")) {
            return localizedString(
                    context,
                    "license文件读取失败",
                    "Failed to read the license file",
                    "讀取 license 檔案失敗",
                    "license ファイルの読み込みに失敗しました"
            );
        }
        if (normalized.contains("LICENSE_KEY_CHECK_ERROR") || normalized.contains("KEY_CHECK_ERROR")) {
            return localizedString(
                    context,
                    "licenseId校验失败",
                    "licenseId verification failed",
                    "licenseId 驗證失敗",
                    "licenseId の検証に失敗しました"
            );
        }
        if (normalized.contains("LICENSE_FUNCTION_CHECK_ERROR") || normalized.contains("FUNCTION_CHECK_ERROR")) {
            return localizedString(
                    context,
                    "当前license未开通采集能力",
                    "The current license does not include collection capability",
                    "目前 license 未開通採集能力",
                    "現在の license では収集機能が有効になっていません"
            );
        }
        if (normalized.contains("LICENSE_TIME_EXPIRED") || normalized.contains("TIME_EXPIRED")) {
            return localizedString(
                    context,
                    "license已过期",
                    "The license has expired",
                    "license 已過期",
                    "license の有効期限が切れています"
            );
        }
        if (normalized.contains("DECRYPT_ERROR")) {
            return localizedString(
                    context,
                    "license文件解密失败",
                    "Failed to decrypt the license file",
                    "license 檔案解密失敗",
                    "license ファイルの復号に失敗しました"
            );
        }
        if (normalized.contains("REMOTE_DATA_ERROR")) {
            return localizedString(
                    context,
                    "远端license数据校验失败",
                    "Failed to verify remote license data",
                    "遠端 license 資料驗證失敗",
                    "リモート license データの検証に失敗しました"
            );
        }
        if (normalized.contains("SUCH APP NOT EXISTS") || normalized.contains("APP NOT EXISTS")) {
            return localizedString(
                    context,
                    "当前应用包名或签名与license不匹配",
                    "The app package name or signing certificate does not match the license",
                    "目前應用的套件名稱或簽章與 license 不匹配",
                    "現在のアプリのパッケージ名または署名証明書が license と一致しません"
            );
        }
        return String.format(
                localeForContext(context),
                localizedString(
                        context,
                        "初始化失败(%1$d)",
                        "Initialization failed (%1$d)",
                        "初始化失敗（%1$d）",
                        "初期化に失敗しました（%1$d）"
                ),
                resultCode
        );
    }

    private enum PluginMessageKey {
        NO_ACTIVITY,
        LICENSE_ID_EMPTY,
        COLLECT_IN_PROGRESS,
        SDK_NOT_INITIALIZED,
        INVALID_COLLECT_ARGUMENTS
    }

    private static String localizedPluginMessage(Context context, PluginMessageKey key) {
        switch (key) {
            case NO_ACTIVITY:
                return localizedString(
                        context,
                        "当前页面不可用",
                        "The current screen is unavailable",
                        "目前頁面不可用",
                        "現在の画面は利用できません"
                );
            case LICENSE_ID_EMPTY:
                return localizedString(
                        context,
                        "licenseId不能为空",
                        "licenseId cannot be empty",
                        "licenseId 不可為空",
                        "licenseId は必須です"
                );
            case COLLECT_IN_PROGRESS:
                return localizedString(
                        context,
                        "正在采集中，请稍候",
                        "Face collection is already in progress",
                        "正在採集中，請稍候",
                        "顔の収集中です。しばらくお待ちください"
                );
            case SDK_NOT_INITIALIZED:
                return localizedString(
                        context,
                        "SDK未初始化",
                        "SDK not initialized",
                        "SDK 尚未初始化",
                        "SDK が初期化されていません"
                );
            case INVALID_COLLECT_ARGUMENTS:
                return localizedString(
                        context,
                        "采集参数无效",
                        "Invalid collection arguments",
                        "採集參數無效",
                        "収集パラメータが無効です"
                );
            default:
                return "";
        }
    }

    private static String localizedString(
            Context context,
            String chinese,
            String english,
            String traditionalChinese,
            String japanese
    ) {
        String localeCode = currentLocaleCode(context);
        switch (localeCode) {
            case "ja":
                return japanese;
            case "zh-Hant":
                return traditionalChinese;
            case "en":
                return english;
            default:
                return chinese;
        }
    }

    private static String currentLocaleCode(Context context) {
        Locale locale = localeForContext(context);
        String language = locale.getLanguage();
        String script = Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP ? locale.getScript() : "";
        String country = locale.getCountry();
        if ("ja".equals(language)) {
            return "ja";
        }
        if ("en".equals(language)) {
            return "en";
        }
        if ("zh".equals(language) && (
                "Hant".equalsIgnoreCase(script) ||
                "TW".equalsIgnoreCase(country) ||
                "HK".equalsIgnoreCase(country) ||
                "MO".equalsIgnoreCase(country))) {
            return "zh-Hant";
        }
        return "zh-Hans";
    }

    private static Locale localeForContext(Context context) {
        Locale preferredLocale = localeFromTag(preferredLocaleTag);
        if (preferredLocale != null) {
            return preferredLocale;
        }
        if (context == null) {
            return Locale.getDefault();
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            if (!context.getResources().getConfiguration().getLocales().isEmpty()) {
                return context.getResources().getConfiguration().getLocales().get(0);
            }
        }
        Locale locale = context.getResources().getConfiguration().locale;
        return locale == null ? Locale.getDefault() : locale;
    }

    static Context wrapContextWithPreferredLocale(Context base) {
        Locale preferredLocale = localeFromTag(preferredLocaleTag);
        if (base == null || preferredLocale == null) {
            return base;
        }
        Locale.setDefault(preferredLocale);
        Configuration configuration = new Configuration(base.getResources().getConfiguration());
        configuration.setLocale(preferredLocale);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            configuration.setLocales(new android.os.LocaleList(preferredLocale));
        }
        return base.createConfigurationContext(configuration);
    }

    static void reapplyPreferredLocale(Activity activity) {
        Locale preferredLocale = localeFromTag(preferredLocaleTag);
        if (activity == null || preferredLocale == null) {
            return;
        }
        Locale.setDefault(preferredLocale);
        updateResourcesLocale(activity.getApplicationContext().getResources(), preferredLocale);
        updateResourcesLocale(activity.getResources(), preferredLocale);
    }

    private static void updateResourcesLocale(Resources resources, Locale locale) {
        if (resources == null || locale == null) {
            return;
        }
        Configuration configuration = new Configuration(resources.getConfiguration());
        configuration.setLocale(locale);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            configuration.setLocales(new android.os.LocaleList(locale));
        }
        resources.updateConfiguration(configuration, resources.getDisplayMetrics());
    }

    private static void setPreferredLocaleTag(String localeTag) {
        preferredLocaleTag = sanitizeLocaleTag(localeTag);
    }

    private static String sanitizeLocaleTag(String localeTag) {
        if (localeTag == null) {
            return null;
        }
        String normalized = localeTag.trim();
        return normalized.isEmpty() ? null : normalized;
    }

    private static Locale localeFromTag(String localeTag) {
        String normalized = sanitizeLocaleTag(localeTag);
        if (normalized == null) {
            return null;
        }
        return Locale.forLanguageTag(normalized);
    }

    private static String resolveSdkLanguageTag(String localeTag) {
        Locale locale = localeFromTag(localeTag);
        if (locale == null) {
            locale = localeForContext(null);
        }
        String language = locale.getLanguage();
        if ("en".equalsIgnoreCase(language)) {
            return "EN";
        }
        return "ZH_CN";
    }
}
