import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/support/app_request_error_message_resolver.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/support/code_send_cooldown.dart';
import '../../../auth/presentation/support/intl_code_picker_field.dart';
import '../../../member_profile/domain/entities/member_profile_details.dart';
import '../../../member_profile/presentation/providers/member_profile_providers.dart';
import '../providers/settings_two_factor_providers.dart';

class SettingsPhoneVerificationPage extends ConsumerStatefulWidget {
  const SettingsPhoneVerificationPage({super.key});

  @override
  ConsumerState<SettingsPhoneVerificationPage> createState() =>
      _SettingsPhoneVerificationPageState();
}

class _SettingsPhoneVerificationPageState
    extends ConsumerState<SettingsPhoneVerificationPage> {
  static final RegExp _mobileRegExp = RegExp(r'^[0-9+\-()\s]{6,20}$');

  late final TextEditingController _phoneController;
  late final TextEditingController _codeController;
  late final CodeSendCooldown _sendCodeCooldown;

  String _selectedIntlCode = '81';
  bool _isEditingPhone = false;
  bool _isSendingCode = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
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
    _phoneController.dispose();
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

  bool _looksLikeMobile(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty || normalized.contains('@')) {
      return false;
    }
    return _mobileRegExp.hasMatch(normalized);
  }

  bool _ensureValidPhoneInput(String phone) {
    if (_looksLikeMobile(phone)) {
      return true;
    }
    AppNotice.show(context, message: context.l10n.loginMobileAccountInvalid);
    return false;
  }

  String _maskPhone(String phone) {
    final trimmed = phone.trim();
    if (trimmed.length <= 4) {
      return trimmed;
    }
    final maskedCount = trimmed.length - 4;
    return '${'•' * maskedCount}${trimmed.substring(trimmed.length - 4)}';
  }

  void _beginPhoneEdit({
    required String phone,
    required String intlCode,
  }) {
    _sendCodeCooldown.reset();
    _codeController.clear();
    setState(() {
      _isEditingPhone = true;
      _phoneController.text = phone;
      _selectedIntlCode = intlCode.trim().isEmpty ? '81' : intlCode.trim();
    });
  }

  Future<void> _sendCode({
    required String phone,
    required String intlCode,
  }) async {
    if (_isSendingCode || _sendCodeCooldown.isActive) {
      return;
    }
    if (!_ensureValidPhoneInput(phone)) {
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
    if (!_ensureValidPhoneInput(phone)) {
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
      Navigator.of(context).pop(true);
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
    final verifiedPhoneAsync = ref.watch(settingsVerifiedPhoneNumberProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: l10n.settingsPhoneVerificationTitle,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => Navigator.of(context).maybePop(),
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
          final verifiedPhone = verifiedPhoneAsync.asData?.value?.trim() ?? '';
          final currentPhone = verifiedPhone.isNotEmpty
              ? verifiedPhone
              : _resolvePhone(user, profile);
          final currentIntlCode = _resolveIntlCode(user, profile);
          final hasPhone = currentPhone.isNotEmpty;
          final showPhoneInput = !hasPhone || _isEditingPhone;
          final activePhone = showPhoneInput
              ? _phoneController.text.trim()
              : currentPhone;
          final activeIntlCode = showPhoneInput
              ? _selectedIntlCode
              : currentIntlCode;
          final canSendCode =
              !_isSendingCode &&
              !_sendCodeCooldown.isActive &&
              _looksLikeMobile(activePhone);
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
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              hasPhone && !showPhoneInput
                                  ? '+$currentIntlCode ${_maskPhone(currentPhone)}'
                                  : l10n.settingsPhoneUnavailable,
                              style: appText.sectionTitle.copyWith(
                                color: hasPhone
                                    ? colors.textPrimary
                                    : colors.textSecondary,
                              ),
                            ),
                          ),
                          if (hasPhone && !showPhoneInput)
                            TextButton(
                              onPressed: () => _beginPhoneEdit(
                                phone: currentPhone,
                                intlCode: currentIntlCode,
                              ),
                              child: Text(l10n.commonEditText),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                if (showPhoneInput) ...<Widget>[
                  IntlCodePickerField(
                    selectedIntlCode: activeIntlCode,
                    onChanged: (String value) {
                      setState(() {
                        _selectedIntlCode = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  PhoneTextField(
                    controller: _phoneController,
                    inputKey: const Key('settings_phone_input'),
                    labelText: l10n.memberProfilePhoneLabel,
                    hintText: l10n.memberProfilePhoneLabel,
                    textInputAction: TextInputAction.next,
                    enabled: !_isSubmitting,
                    trailing: Tooltip(
                      message: sendButtonLabel,
                      child: AppNavigationIconButton(
                        key: const Key('settings_phone_send_code_button'),
                        icon: Icons.send_rounded,
                        size: 34,
                        borderRadius: 10,
                        backgroundColor: colors.primary.withValues(
                          alpha: canSendCode ? 0.12 : 0.06,
                        ),
                        foregroundColor: canSendCode
                            ? colors.primary
                            : colors.primary.withValues(alpha: 0.4),
                        onTap: canSendCode
                            ? () => _sendCode(
                                phone: activePhone,
                                intlCode: activeIntlCode,
                              )
                            : null,
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.settingsPhoneVerificationInputDescription,
                    style: appText.helper.copyWith(
                      color: colors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
                VerificationCodeField(
                  controller: _codeController,
                  labelText: l10n.loginCodeLabel,
                  sendCodeLabel: sendButtonLabel,
                  enabled: !_isSubmitting,
                  isSendingCode: _isSendingCode,
                  onChanged: (_) => setState(() {}),
                  onSendCode: canSendCode
                      ? () =>
                            _sendCode(phone: activePhone, intlCode: activeIntlCode)
                      : null,
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
                      ? () => _verifyPhone(
                          phone: activePhone,
                          intlCode: activeIntlCode,
                        )
                      : null,
                  isLoading: _isSubmitting,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
