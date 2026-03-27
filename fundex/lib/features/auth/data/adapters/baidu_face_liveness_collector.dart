import 'package:core_identity_auth/core_identity_auth.dart';
import 'package:flutter_bdface_collect/flutter_bdface_collect.dart'
    as bd_collect;
import 'package:flutter_bdface_collect/model.dart' as bd_model;

class BaiduFaceLivenessCollector implements LivenessCollector {
  BaiduFaceLivenessCollector({
    required String licenseId,
    Set<bd_model.LivenessType>? livenessTypes,
    bool randomAction = true,
  }) : _licenseId = licenseId.trim(),
       _livenessTypes = livenessTypes,
       _randomAction = randomAction;

  final String _licenseId;
  final Set<bd_model.LivenessType>? _livenessTypes;
  final bool _randomAction;

  @override
  Future<LivenessCollectResult> collect() async {
    final plugin = bd_collect.FlutterBdfaceCollect.instance;
    try {
      if (_licenseId.isEmpty) {
        return const LivenessCollectResult(
          photoBase64: '',
          errorMessage: 'baidu_face_license_missing',
        );
      }

      final initError = await plugin.init(_licenseId);
      if (initError != null && initError.trim().isNotEmpty) {
        return LivenessCollectResult(
          photoBase64: '',
          errorMessage: initError.trim(),
        );
      }

      final config = bd_model.FaceConfig(
        livenessTypes:
            _livenessTypes ??
            Set<bd_model.LivenessType>.from(
              bd_model.LivenessType.all.sublist(1, 4),
            ),
        livenessRandom: _randomAction,
      );
      final result = await plugin.collect(config);
      final sourcePhoto = result.imageSrcBase64.trim();
      final cropPhoto = result.imageCropBase64.trim();
      final photo = sourcePhoto.isNotEmpty ? sourcePhoto : cropPhoto;
      if (photo.isEmpty) {
        return LivenessCollectResult(
          photoBase64: '',
          errorMessage: result.error.trim().isEmpty
              ? 'baidu_face_collect_empty'
              : result.error.trim(),
        );
      }
      return LivenessCollectResult(
        photoBase64: photo,
        errorMessage: result.error.trim().isEmpty ? null : result.error.trim(),
      );
    } catch (error) {
      return LivenessCollectResult(
        photoBase64: '',
        errorMessage: error.toString(),
      );
    } finally {
      try {
        await plugin.unInit();
      } catch (_) {
        // Do not fail flow teardown because SDK release failed.
      }
    }
  }
}
