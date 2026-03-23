import 'package:core_identity_auth/core_identity_auth.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
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
    return normalized.isNotEmpty;
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

    final path = await ref
        .read(profileDocumentImagePickerProvider)
        .pick(source);
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
      ref.invalidate(memberProfileDetailsProvider);
      AppNotice.show(
        context,
        message: context.l10n.memberProfilePhotoUploadSuccess,
      );
      await _startVerification();
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
      await _startVerification();
      return;
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingPhoto = false;
        });
      }
    }
  }

  Future<void> _startVerification() async {
    if (_isRunningVerification) {
      return;
    }

    final l10n = context.l10n;
    setState(() {
      _isRunningVerification = true;
      _statusMessage = null;
    });

    try {
      final coordinator = ref.read(identityAuthCoordinatorProvider);
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

      final collector = ref.read(identityAuthLivenessCollectorProvider);
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
        AppNotice.show(context, message: message);
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
    final profileAsync = ref.watch(memberProfileDetailsProvider);
    final verifiedAsync = ref.watch(settingsRealPersonVerifiedProvider);

    final profile = profileAsync.asData?.value;
    final selfieUploaded =
        _isSelfieUploaded(_selfiePhotoPath) ||
        _isSelfieUploaded(profile?.selfiePhotoPath);
    final verified = _isVerified || (verifiedAsync.asData?.value == true);

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
              color: verified ? colors.successSubtle : colors.surfaceAlt,
              borderRadius: BorderRadius.circular(UiTokens.radius16),
              border: Border.all(
                color: verified ? colors.successBorder : colors.border,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: verified ? colors.success : colors.primarySubtle,
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
                          color: verified ? colors.success : colors.textPrimary,
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
          const SizedBox(height: 20),
          PrimaryCtaButton(
            label: l10n.identityAuthStartAction,
            onPressed: _isUploadingPhoto || _isRunningVerification
                ? null
                : _startVerification,
            isLoading: _isRunningVerification,
          ),
        ],
      ),
    );
  }
}
