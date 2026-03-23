import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/support/app_request_error_message_resolver.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/support/code_send_cooldown.dart';
import '../../../member_profile/domain/entities/member_profile_details.dart';
import '../../../member_profile/presentation/providers/member_profile_providers.dart';
import '../../../member_profile/presentation/support/member_profile_edit_step.dart';
import '../providers/settings_two_factor_providers.dart';

class SettingsPhoneVerificationPage extends ConsumerStatefulWidget {
  const SettingsPhoneVerificationPage({super.key});

  @override
  ConsumerState<SettingsPhoneVerificationPage> createState() =>
      _SettingsPhoneVerificationPageState();
}

class _SettingsPhoneVerificationPageState
    extends ConsumerState<SettingsPhoneVerificationPage> {
  late final TextEditingController _codeController;
  late final CodeSendCooldown _sendCodeCooldown;

  bool _isSendingCode = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
    _sendCodeCooldown = CodeSendCooldown(
      onChanged: () {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _sendCodeCooldown.dispose();
    super.dispose();
  }

  String _resolvePhone(AuthUser? user, MemberProfileDetails? profile) {
    final profilePhone = profile?.phone.trim() ?? '';
    if (profilePhone.isNotEmpty) {
      return profilePhone;
    }
    final mobile = user?.mobile?.trim() ?? '';
    if (mobile.isNotEmpty) {
      return mobile;
    }
    return user?.phone?.trim() ?? '';
  }

  String _resolveIntlCode(AuthUser? user, MemberProfileDetails? profile) {
    final profileIntlCode = profile?.phoneIntlCode.trim() ?? '';
    if (profileIntlCode.isNotEmpty) {
      return profileIntlCode;
    }
    final userIntlCode = user?.intlTelCode?.trim() ?? '';
    if (userIntlCode.isNotEmpty) {
      return userIntlCode;
    }
    return '81';
  }

  String _maskPhone(String phone) {
    final trimmed = phone.trim();
    if (trimmed.length <= 4) {
      return trimmed;
    }
    final maskedCount = trimmed.length - 4;
    return '${'•' * maskedCount}${trimmed.substring(trimmed.length - 4)}';
  }

  Future<void> _sendCode({
    required String phone,
    required String intlCode,
  }) async {
    if (_isSendingCode || _sendCodeCooldown.isActive) {
      return;
    }

    setState(() {
      _isSendingCode = true;
    });

    try {
      await ref
          .read(settingsTwoFactorRemoteDataSourceProvider)
          .sendOnlinePhoneChangeCode(mobile: phone, bizId: intlCode);
      if (!mounted) {
        return;
      }
      _sendCodeCooldown.start();
      AppNotice.show(context, message: context.l10n.settingsPhoneCodeSent);
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: resolveAppRequestErrorMessage(
          error,
          context.l10n.loginErrorSendCodeFailed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSendingCode = false;
        });
      }
    }
  }

  Future<void> _verifyPhone({
    required String phone,
    required String intlCode,
  }) async {
    if (_isSubmitting) {
      return;
    }

    final code = _codeController.text.trim();
    if (code.length < 4) {
      AppNotice.show(context, message: context.l10n.settingsPhoneCodeRequired);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref
          .read(settingsTwoFactorRemoteDataSourceProvider)
          .verifyOnlinePhoneChangeCode(
            mobile: phone,
            bizId: intlCode,
            code: code,
          );
      await ref
          .read(settingsTwoFactorLocalDataSourceProvider)
          .writePhoneVerificationSnapshot(phone: phone);
      ref.invalidate(settingsRemoteVerificationStatusProvider);
      ref.invalidate(settingsPhoneVerificationSnapshotProvider);
      ref.invalidate(settingsPhoneVerifiedProvider);
      ref.invalidate(settingsVerifiedPhoneNumberProvider);
      ref.invalidate(settingsPhoneVerificationUpdatedAtProvider);
      TextInput.finishAutofillContext();
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: context.l10n.settingsPhoneVerificationSuccess,
      );
      context.pop(true);
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: resolveAppRequestErrorMessage(
          error,
          context.l10n.uiErrorRequestFailed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
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
    final userAsync = ref.watch(currentAuthUserProvider);
    final profileAsync = ref.watch(memberProfileDetailsProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: l10n.settingsPhoneVerificationTitle,
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Text(
            l10n.uiErrorRequestFailed,
            style: appText.body.copyWith(color: colors.textSecondary),
          ),
        ),
        data: (user) {
          final profile = profileAsync.asData?.value;
          final phone = _resolvePhone(user, profile);
          final intlCode = _resolveIntlCode(user, profile);
          final hasPhone = phone.isNotEmpty;
          final sendButtonLabel = _sendCodeCooldown.isActive
              ? '${_sendCodeCooldown.remainingSeconds}s'
              : l10n.loginSendCode;

          return AutofillGroup(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: colors.surfaceAlt,
                    borderRadius: BorderRadius.circular(UiTokens.radius16),
                    border: Border.all(color: colors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: colors.infoSubtle,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.sms_rounded,
                              color: colors.info,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.settingsPhoneVerificationDescription,
                              style: appText.body.copyWith(
                                color: colors.textSecondary,
                                height: 1.55,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        l10n.settingsCurrentPhoneLabel,
                        style: appText.meta.copyWith(
                          color: colors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        hasPhone
                            ? '+$intlCode ${_maskPhone(phone)}'
                            : l10n.settingsPhoneUnavailable,
                        style: appText.sectionTitle.copyWith(
                          color: hasPhone
                              ? colors.textPrimary
                              : colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                if (!hasPhone) ...<Widget>[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.warningSubtle,
                      borderRadius: BorderRadius.circular(UiTokens.radius14),
                      border: Border.all(color: colors.warningBorder),
                    ),
                    child: Text(
                      l10n.settingsPhoneVerificationPhoneMissing,
                      style: appText.bodyStrong.copyWith(
                        color: colors.warningForeground,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => context.push(
                      '/member-profile/edit/section/${MemberProfileEditStep.basicInfo.routeValue}',
                    ),
                    child: Text(l10n.menuItemEditProfile),
                  ),
                ] else ...<Widget>[
                  VerificationCodeField(
                    controller: _codeController,
                    labelText: l10n.loginCodeLabel,
                    sendCodeLabel: sendButtonLabel,
                    enabled: !_isSubmitting,
                    isSendingCode: _isSendingCode,
                    onChanged: (_) => setState(() {}),
                    onSendCode: () =>
                        _sendCode(phone: phone, intlCode: intlCode),
                    autofillHints: const <String>[AutofillHints.oneTimeCode],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.settingsPhoneAutoFillHint,
                    style: appText.helper.copyWith(
                      color: colors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  PrimaryCtaButton(
                    label: l10n.settingsPhoneVerifyAction,
                    onPressed:
                        _codeController.text.trim().length >= 4 &&
                            !_isSubmitting
                        ? () => _verifyPhone(phone: phone, intlCode: intlCode)
                        : null,
                    isLoading: _isSubmitting,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
