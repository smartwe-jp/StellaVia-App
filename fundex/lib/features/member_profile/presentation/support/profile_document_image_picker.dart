import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'profile_image_upload_optimizer.dart';

enum ProfileDocumentImageSource { camera, gallery }

enum ProfileDocumentImagePickStatus {
  success,
  canceled,
  permissionDenied,
  permissionSettingsRequired,
  sizeLimitExceeded,
  failed,
}

class ProfileDocumentImagePickResult {
  const ProfileDocumentImagePickResult._({
    required this.status,
    this.path,
    this.errorMessage,
  });

  const ProfileDocumentImagePickResult.success(String path)
    : this._(status: ProfileDocumentImagePickStatus.success, path: path);

  const ProfileDocumentImagePickResult.canceled()
    : this._(status: ProfileDocumentImagePickStatus.canceled);

  const ProfileDocumentImagePickResult.permissionDenied()
    : this._(status: ProfileDocumentImagePickStatus.permissionDenied);

  const ProfileDocumentImagePickResult.permissionSettingsRequired()
    : this._(status: ProfileDocumentImagePickStatus.permissionSettingsRequired);

  const ProfileDocumentImagePickResult.sizeLimitExceeded([String? errorMessage])
    : this._(
        status: ProfileDocumentImagePickStatus.sizeLimitExceeded,
        errorMessage: errorMessage,
      );

  const ProfileDocumentImagePickResult.failed([String? errorMessage])
    : this._(
        status: ProfileDocumentImagePickStatus.failed,
        errorMessage: errorMessage,
      );

  final ProfileDocumentImagePickStatus status;
  final String? path;
  final String? errorMessage;

  bool get isSuccess => status == ProfileDocumentImagePickStatus.success;
}

class ProfileDocumentImageMultiPickResult {
  const ProfileDocumentImageMultiPickResult._({
    required this.status,
    this.paths = const <String>[],
    this.errorMessage,
  });

  const ProfileDocumentImageMultiPickResult.success(List<String> paths)
    : this._(status: ProfileDocumentImagePickStatus.success, paths: paths);

  const ProfileDocumentImageMultiPickResult.canceled()
    : this._(status: ProfileDocumentImagePickStatus.canceled);

  const ProfileDocumentImageMultiPickResult.permissionDenied()
    : this._(status: ProfileDocumentImagePickStatus.permissionDenied);

  const ProfileDocumentImageMultiPickResult.permissionSettingsRequired()
    : this._(status: ProfileDocumentImagePickStatus.permissionSettingsRequired);

  const ProfileDocumentImageMultiPickResult.sizeLimitExceeded([
    String? errorMessage,
  ]) : this._(
         status: ProfileDocumentImagePickStatus.sizeLimitExceeded,
         errorMessage: errorMessage,
       );

  const ProfileDocumentImageMultiPickResult.failed([String? errorMessage])
    : this._(
        status: ProfileDocumentImagePickStatus.failed,
        errorMessage: errorMessage,
      );

  final ProfileDocumentImagePickStatus status;
  final List<String> paths;
  final String? errorMessage;

  bool get isSuccess => status == ProfileDocumentImagePickStatus.success;
}

abstract class ProfileDocumentImagePicker {
  Future<ProfileDocumentImagePickResult> pick(
    ProfileDocumentImageSource source,
  );

  Future<ProfileDocumentImageMultiPickResult> pickMultipleFromGallery({
    required int limit,
  });
}

class DeviceProfileDocumentImagePicker implements ProfileDocumentImagePicker {
  DeviceProfileDocumentImagePicker([
    ImagePicker? imagePicker,
    ProfileImageUploadOptimizer? imageOptimizer,
  ]) : _imagePicker = imagePicker ?? ImagePicker(),
       _imageOptimizer = imageOptimizer ?? const ProfileImageUploadOptimizer();

  final ImagePicker _imagePicker;
  final ProfileImageUploadOptimizer _imageOptimizer;

  @override
  Future<ProfileDocumentImagePickResult> pick(
    ProfileDocumentImageSource source,
  ) async {
    final permissionFailure = await _ensurePermission(source);
    if (permissionFailure != null) {
      return permissionFailure;
    }

    try {
      final xFile = await _imagePicker.pickImage(
        source: source == ProfileDocumentImageSource.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        imageQuality: 88,
        maxWidth: 1800,
      );
      final path = xFile?.path.trim() ?? '';
      if (path.isEmpty) {
        return const ProfileDocumentImagePickResult.canceled();
      }
      final optimizedPath = await _imageOptimizer.ensureWithinUploadLimit(path);
      return ProfileDocumentImagePickResult.success(optimizedPath);
    } on ProfileImageSizeLimitException catch (error) {
      return ProfileDocumentImagePickResult.sizeLimitExceeded(error.toString());
    } catch (error) {
      return ProfileDocumentImagePickResult.failed(error.toString());
    }
  }

  @override
  Future<ProfileDocumentImageMultiPickResult> pickMultipleFromGallery({
    required int limit,
  }) async {
    if (limit <= 0) {
      return const ProfileDocumentImageMultiPickResult.canceled();
    }

    final permissionFailure = await _ensurePermission(
      ProfileDocumentImageSource.gallery,
    );
    if (permissionFailure != null) {
      return _toMultiPickFailure(permissionFailure);
    }

    try {
      final xFiles = await _pickMultiImageOrFallback(limit);
      if (xFiles.isEmpty) {
        return const ProfileDocumentImageMultiPickResult.canceled();
      }
      final optimizedPaths = <String>[];
      for (final xFile in xFiles.take(limit)) {
        final path = xFile.path.trim();
        if (path.isEmpty) {
          continue;
        }
        optimizedPaths.add(await _imageOptimizer.ensureWithinUploadLimit(path));
      }
      if (optimizedPaths.isEmpty) {
        return const ProfileDocumentImageMultiPickResult.canceled();
      }
      return ProfileDocumentImageMultiPickResult.success(optimizedPaths);
    } on ProfileImageSizeLimitException catch (error) {
      return ProfileDocumentImageMultiPickResult.sizeLimitExceeded(
        error.toString(),
      );
    } catch (error) {
      return ProfileDocumentImageMultiPickResult.failed(error.toString());
    }
  }

  Future<List<XFile>> _pickMultiImageOrFallback(int limit) async {
    try {
      return _imagePicker.pickMultiImage(
        imageQuality: 88,
        maxWidth: 1800,
        limit: limit,
      );
    } on UnimplementedError {
      final fallback = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 88,
        maxWidth: 1800,
      );
      return fallback == null ? <XFile>[] : <XFile>[fallback];
    } on UnsupportedError {
      final fallback = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 88,
        maxWidth: 1800,
      );
      return fallback == null ? <XFile>[] : <XFile>[fallback];
    }
  }

  ProfileDocumentImageMultiPickResult _toMultiPickFailure(
    ProfileDocumentImagePickResult result,
  ) {
    switch (result.status) {
      case ProfileDocumentImagePickStatus.success:
        final path = result.path?.trim() ?? '';
        return path.isEmpty
            ? const ProfileDocumentImageMultiPickResult.canceled()
            : ProfileDocumentImageMultiPickResult.success(<String>[path]);
      case ProfileDocumentImagePickStatus.canceled:
        return const ProfileDocumentImageMultiPickResult.canceled();
      case ProfileDocumentImagePickStatus.permissionDenied:
        return const ProfileDocumentImageMultiPickResult.permissionDenied();
      case ProfileDocumentImagePickStatus.permissionSettingsRequired:
        return const ProfileDocumentImageMultiPickResult.permissionSettingsRequired();
      case ProfileDocumentImagePickStatus.sizeLimitExceeded:
        return ProfileDocumentImageMultiPickResult.sizeLimitExceeded(
          result.errorMessage,
        );
      case ProfileDocumentImagePickStatus.failed:
        return ProfileDocumentImageMultiPickResult.failed(result.errorMessage);
    }
  }

  Future<ProfileDocumentImagePickResult?> _ensurePermission(
    ProfileDocumentImageSource source,
  ) async {
    if (kIsWeb) {
      return null;
    }

    final permission = _resolvePermission(source);
    if (permission == null) {
      return null;
    }

    final currentStatus = await permission.status;
    if (currentStatus.isGranted || currentStatus.isLimited) {
      return null;
    }
    if (_needsSettings(currentStatus)) {
      return const ProfileDocumentImagePickResult.permissionSettingsRequired();
    }

    final status = await permission.request();
    if (status.isGranted || status.isLimited) {
      return null;
    }

    if (_needsSettings(status)) {
      return const ProfileDocumentImagePickResult.permissionSettingsRequired();
    }
    return const ProfileDocumentImagePickResult.permissionDenied();
  }

  Permission? _resolvePermission(ProfileDocumentImageSource source) {
    switch (source) {
      case ProfileDocumentImageSource.camera:
        return Permission.camera;
      case ProfileDocumentImageSource.gallery:
        return switch (defaultTargetPlatform) {
          TargetPlatform.iOS || TargetPlatform.macOS => Permission.photos,
          _ => null,
        };
    }
  }

  bool _needsSettings(PermissionStatus status) {
    return status.isPermanentlyDenied || status.isRestricted;
  }
}
