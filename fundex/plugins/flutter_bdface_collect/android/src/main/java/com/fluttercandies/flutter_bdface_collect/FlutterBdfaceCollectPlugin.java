package com.fluttercandies.flutter_bdface_collect;

import android.app.Activity;
import android.content.Intent;

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
        if (activity == null) {
            result.success(formatInitError("NO_ACTIVITY", "activity is null"));
            return;
        }
        String licenseId = arguments instanceof String ? ((String) arguments).trim() : "";
        if (licenseId.isEmpty()) {
            result.success(formatInitError("INVALID_ARGUMENT", "licenseId is empty"));
            return;
        }

        InitOption option = new InitOption();
        option.licenseKey = licenseId;
        option.licenseFileName = LICENSE_FILE_NAME;
        FaceLiveManager.getInstance().init(activity.getApplicationContext(), option, new InitCallback() {
            @Override
            public void onSuccess(int resultCode, String resultMsg) {
                if (activity == null) {
                    result.success(formatInitError(resultCode, resultMsg));
                    return;
                }
                activity.runOnUiThread(() -> result.success(null));
            }

            @Override
            public void onError(int resultCode, String resultMsg) {
                if (activity == null) {
                    result.success(formatInitError(resultCode, resultMsg));
                    return;
                }
                activity.runOnUiThread(() -> result.success(formatInitError(resultCode, resultMsg)));
            }
        });
    }

    private void collect(Object arguments, final Result result) {
        if (activity == null) {
            result.success(errorResult("activity is null"));
            return;
        }
        if (pendingResult != null) {
            result.success(errorResult("collect already in progress"));
            return;
        }
        if (!FaceSDKManager.getInstance().getInitFlag()) {
            result.success(errorResult("SDK not initialized"));
            return;
        }
        if (!(arguments instanceof Map)) {
            result.success(errorResult("invalid collect arguments"));
            return;
        }

        @SuppressWarnings("unchecked")
        Map<String, Object> argumentsMap = (Map<String, Object>) arguments;
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
}
