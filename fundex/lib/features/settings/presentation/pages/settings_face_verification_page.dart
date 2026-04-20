import 'package:core_identity_auth/core_identity_auth.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/support/app_permission_dialogs.dart';
import '../../../auth/presentation/providers/identity_auth_sdk_providers.dart';
import '../../../auth/presentation/support/identity_auth_message_resolver.dart';
import '../../../member_profile/domain/constants/member_profile_upload_markers.dart';
import '../../../member_profile/presentation/providers/member_profile_providers.dart';
import '../../../member_profile/presentation/support/profile_document_image_picker.dart';
import '../providers/settings_two_factor_providers.dart';

class SettingsFaceVerificationPage extends ConsumerStatefulWidget {
  const SettingsFaceVerificationPage({super.key});

  @override
  ConsumerState<SettingsFaceVerificationPage> createState() =>
      _SettingsFaceVerificationPageState();
}

class _SettingsFaceVerificationPageState
    extends ConsumerState<SettingsFaceVerificationPage> {
  String? _selfiePhotoPath;
  String? _statusMessage;
  bool _isUploadingPhoto = false;
  bool _isRunningVerification = false;
  bool _isVerified = false;

  bool _isSelfieUploaded(String? path) {
    final normalized = path?.trim() ?? '';
    //return normalized.isNotEmpty;
    if (normalized.isEmpty) {
      return false;
    }
    if (normalized == selfieUploadCompletedMarker) {
      return true;
    }
    return normalized.startsWith('http://') ||
        normalized.startsWith('https://');
  }

  Future<String?> _pickImagePath(ProfileDocumentImageSource source) async {
    final result = await ref
        .read(profileDocumentImagePickerProvider)
        .pick(source);
    if (!mounted) {
      return null;
    }

    switch (result.status) {
      case ProfileDocumentImagePickStatus.success:
        return result.path!.trim();
      case ProfileDocumentImagePickStatus.canceled:
        return null;
      case ProfileDocumentImagePickStatus.permissionDenied:
        AppNotice.show(
          context,
          message: source == ProfileDocumentImageSource.camera
              ? context.l10n.profileDocumentCameraPermissionRequired
              : context.l10n.profileDocumentPhotoLibraryPermissionRequired,
        );
        return null;
      case ProfileDocumentImagePickStatus.permissionSettingsRequired:
        await showAppPermissionSettingsDialog(
          context,
          permission: source == ProfileDocumentImageSource.camera
              ? AppPermissionKind.camera
              : AppPermissionKind.photos,
        );
        return null;
      case ProfileDocumentImagePickStatus.failed:
        AppNotice.show(
          context,
          message: context.l10n.profileDocumentPickFailed,
        );
        return null;
    }
  }

  Future<void> _pickAndUploadSelfie() async {
    if (_isUploadingPhoto || _isRunningVerification) {
      return;
    }

    final source = await showModalBottomSheet<ProfileDocumentImageSource>(
      context: context,
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(context.l10n.profileDocumentTakePhoto),
                onTap: () {
                  Navigator.of(
                    sheetContext,
                  ).pop(ProfileDocumentImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(context.l10n.profileDocumentPickFromGallery),
                onTap: () {
                  Navigator.of(
                    sheetContext,
                  ).pop(ProfileDocumentImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
    if (source == null) {
      return;
    }

    final path = await _pickImagePath(source);
    if (!mounted || path == null || path.trim().isEmpty) {
      return;
    }

    setState(() {
      _isUploadingPhoto = true;
      _statusMessage = null;
    });

    try {
      final uploadedUrl = await ref
          .read(uploadMemberProfilePhotoUseCaseProvider)
          .call(filePath: path.trim(), isSelfie: true);
      if (!mounted) {
        return;
      }
      setState(() {
        _selfiePhotoPath = uploadedUrl.trim();
      });
      AppNotice.show(
        context,
        message: context.l10n.memberProfilePhotoUploadSuccess,
      );
      await _startVerification(forceLiveness: true);
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _selfiePhotoPath = selfieUploadCompletedMarker;
      });
      AppNotice.show(
        context,
        message: context.l10n.memberProfileSelfieUploadBypassedNotice,
      );
      await _startVerification(forceLiveness: true);
      return;
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingPhoto = false;
        });
      }
    }
  }

  Future<void> _startVerification({bool forceLiveness = false}) async {
    if (_isRunningVerification) {
      return;
    }

    final l10n = context.l10n;
    setState(() {
      _isRunningVerification = true;
      _statusMessage = null;
    });

    try {
      final collector = ref.read(identityAuthLivenessCollectorProvider);
      final coordinator = ref.read(identityAuthCoordinatorProvider);
      if (!forceLiveness) {
        final decision = await coordinator.evaluate(
          entryPoint: IdentityAuthEntryPoint.securityCenterRealPerson,
        );
        if (!mounted) {
          return;
        }

        if (decision.action == IdentityAuthAction.none) {
          setState(() {
            _isVerified = true;
          });
          ref.invalidate(settingsRemoteVerificationStatusProvider);
          ref.invalidate(settingsRealPersonVerifiedProvider);
          ref.invalidate(settingsRealPersonVerificationUpdatedAtProvider);
          AppNotice.show(context, message: l10n.identityAuthAlreadyVerified);
          return;
        }
      }

      if (collector == null) {
        final message = resolveIdentityAuthMessage(
          l10n,
          reasonCode: 'liveness_collector_not_configured',
          fallbackMessage: l10n.identityAuthLivenessNotConfigured,
        );
        setState(() {
          _statusMessage = message;
        });
        AppNotice.show(context, message: message);
        return;
      }

      final collected = await collector.collect();
      if (!mounted) {
        return;
      }
      if (!collected.isSuccess) {
        final message = resolveIdentityAuthMessage(
          l10n,
          reasonCode: 'liveness_collect_failed',
          errorMessage: collected.errorMessage,
          fallbackMessage: l10n.identityAuthCollectFailed,
        );
        setState(() {
          _statusMessage = message;
        });
        if (isIdentityAuthPermissionSettingsRequired(collected.errorMessage)) {
          await showAppPermissionSettingsDialog(
            context,
            permission: AppPermissionKind.camera,
          );
        } else {
          AppNotice.show(context, message: message);
        }
        return;
      }

      final result = await coordinator.verifyWithPhotoBase64(
        photoBase64: collected.photoBase64,
        entryPoint: IdentityAuthEntryPoint.securityCenterRealPerson,
      );
      if (!mounted) {
        return;
      }
      if (result.verified) {
        setState(() {
          _isVerified = true;
        });
        ref.invalidate(settingsRemoteVerificationStatusProvider);
        ref.invalidate(settingsRealPersonVerifiedProvider);
        ref.invalidate(settingsRealPersonVerificationUpdatedAtProvider);
        AppNotice.show(context, message: l10n.identityAuthVerifySuccess);
        return;
      }

      final message = resolveIdentityAuthMessage(
        l10n,
        reasonCode: result.reasonCode,
        errorMessage: result.errorMessage,
        fallbackMessage: l10n.identityAuthVerifyFailed,
      );
      setState(() {
        _statusMessage = message;
      });
      AppNotice.show(context, message: message);
    } catch (error) {
      if (!mounted) {
        return;
      }
      final message = resolveIdentityAuthMessage(
        l10n,
        errorMessage: error.toString(),
        fallbackMessage: l10n.identityAuthVerifyFailed,
      );
      setState(() {
        _statusMessage = message;
      });
      AppNotice.show(context, message: message);
    } finally {
      if (mounted) {
        setState(() {
          _isRunningVerification = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final verifiedAsync = ref.watch(settingsRealPersonVerifiedProvider);
    final selfieUploaded = _isSelfieUploaded(_selfiePhotoPath);
    final verified = _isVerified || (verifiedAsync.asData?.value == true);
    final showUploadSection = !verified;
    final canStartVerification =
        selfieUploaded && !_isUploadingPhoto && !_isRunningVerification;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: l10n.settingsFaceVerificationTitle,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: verified ? colors.primarySubtle : colors.surfaceAlt,
              borderRadius: BorderRadius.circular(UiTokens.radius16),
              border: Border.all(
                color: verified
                    ? colors.primary.withValues(alpha: 0.22)
                    : colors.border,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: verified ? colors.primary : colors.primarySubtle,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    verified
                        ? Icons.verified_rounded
                        : Icons.face_retouching_natural_rounded,
                    color: verified ? colors.onDark : colors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        verified
                            ? l10n.settingsVerificationStatusVerified
                            : l10n.settingsFaceVerificationTitle,
                        style: appText.cardTitle.copyWith(
                          color: verified ? colors.primary : colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.settingsFaceVerificationDescription,
                        style: appText.body.copyWith(
                          color: colors.textSecondary,
                          height: 1.55,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (showUploadSection) ...<Widget>[
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(UiTokens.radius16),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    l10n.settingsFaceVerificationUploadTitle,
                    style: appText.sectionTitle.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.settingsFaceVerificationUploadDescription,
                    style: appText.body.copyWith(
                      color: colors.textSecondary,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 16),
                  MemberProfileUploadTile(
                    icon: Icons.person_outline_rounded,
                    title: l10n.settingsFaceVerificationSelfieTitle,
                    description: l10n.settingsFaceVerificationSelfieDescription,
                    isCompleted: selfieUploaded,
                    onTap: (_isUploadingPhoto || _isRunningVerification)
                        ? null
                        : _pickAndUploadSelfie,
                  ),
                ],
              ),
            ),
          ],
          if (_statusMessage != null) ...<Widget>[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.dangerSubtle,
                borderRadius: BorderRadius.circular(UiTokens.radius14),
                border: Border.all(color: colors.dangerBorder),
              ),
              child: Text(
                _statusMessage!,
                style: appText.bodyStrong.copyWith(
                  color: colors.dangerForeground,
                  height: 1.5,
                ),
              ),
            ),
          ],
          if (_isUploadingPhoto || _isRunningVerification) ...<Widget>[
            const SizedBox(height: 16),
            const LinearProgressIndicator(minHeight: 2),
          ],
          if (showUploadSection) ...<Widget>[
            const SizedBox(height: 20),
            PrimaryCtaButton(
              label: l10n.identityAuthStartAction,
              onPressed: canStartVerification
                  ? () => _startVerification()
                  : null,
              isLoading: _isRunningVerification,
            ),
          ],
        ],
      ),
    );
  }
}
