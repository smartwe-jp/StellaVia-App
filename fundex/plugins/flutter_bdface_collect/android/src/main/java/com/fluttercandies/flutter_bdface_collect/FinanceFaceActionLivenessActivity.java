package com.fluttercandies.flutter_bdface_collect;

import android.content.Context;
import android.os.Bundle;
import android.widget.TextView;

import com.baidu.idl.face.platform.FaceStatusNewEnum;
import com.baidu.idl.face.platform.model.ImageInfo;
import com.baidu.idl.face.platform.ui.FaceActionLivenessActivity;
import com.baidu.idl.face.platform.ui.R;

import java.util.HashMap;
import java.util.Map;

public class FinanceFaceActionLivenessActivity extends FaceActionLivenessActivity {
    @Override
    protected void attachBaseContext(Context newBase) {
        super.attachBaseContext(FlutterBdfaceCollectPlugin.wrapContextWithPreferredLocale(newBase));
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FlutterBdfaceCollectPlugin.reapplyPreferredLocale(this);
        refreshLocalizedTexts();
    }

    @Override
    public void onCollectCompletion(
            FaceStatusNewEnum status,
            String message,
            HashMap<String, ImageInfo> imageCropMap,
            HashMap<String, ImageInfo> imageSrcMap,
            int currentLivenessCount
    ) {
        if (status == FaceStatusNewEnum.OK) {
            if (mIsCompletion) {
                return;
            }
            mIsCompletion = true;
            boolean secureBase64 = mFaceConfig != null && mFaceConfig.getSecType() != 0;
            FlutterBdfaceCollectPlugin.imageCropBase64 = FlutterBdfaceCollectPlugin.selectBestImage(imageCropMap, secureBase64);
            FlutterBdfaceCollectPlugin.imageSrcBase64 = FlutterBdfaceCollectPlugin.selectBestImage(imageSrcMap, secureBase64);
            if (isEmpty(FlutterBdfaceCollectPlugin.imageSrcBase64)) {
                FlutterBdfaceCollectPlugin.imageSrcBase64 = FlutterBdfaceCollectPlugin.imageCropBase64;
            }
            if (isEmpty(FlutterBdfaceCollectPlugin.imageCropBase64)) {
                FlutterBdfaceCollectPlugin.imageCropBase64 = FlutterBdfaceCollectPlugin.imageSrcBase64;
            }
            setResult(FlutterBdfaceCollectPlugin.COLLECT_OK_CODE);
            finish();
            return;
        }
        super.onCollectCompletion(status, message, imageCropMap, imageSrcMap, currentLivenessCount);
    }

    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    private void refreshLocalizedTexts() {
        TextView topTips = findViewById(R.id.liveness_top_tips);
        if (topTips != null) {
            topTips.setText(getString(R.string.faceLivenessMovetoFrameText));
        }
    }
}
