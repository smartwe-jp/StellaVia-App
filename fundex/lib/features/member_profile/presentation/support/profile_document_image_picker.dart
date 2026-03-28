import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

enum ProfileDocumentImageSource { camera, gallery }

enum ProfileDocumentImagePickStatus {
  success,
  canceled,
  permissionDenied,
  permissionSettingsRequired,
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

abstract class ProfileDocumentImagePicker {
  Future<ProfileDocumentImagePickResult> pick(
    ProfileDocumentImageSource source,
  );
}

class DeviceProfileDocumentImagePicker implements ProfileDocumentImagePicker {
  DeviceProfileDocumentImagePicker([ImagePicker? imagePicker])
    : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

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
      return ProfileDocumentImagePickResult.success(path);
    } catch (error) {
      return ProfileDocumentImagePickResult.failed(error.toString());
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
