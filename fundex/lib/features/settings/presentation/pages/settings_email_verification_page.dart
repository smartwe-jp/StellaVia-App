import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/support/app_request_error_message_resolver.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/support/code_send_cooldown.dart';
import '../providers/settings_two_factor_providers.dart';

class SettingsEmailVerificationPage extends ConsumerStatefulWidget {
  const SettingsEmailVerificationPage({super.key});

  @override
  ConsumerState<SettingsEmailVerificationPage> createState() =>
      _SettingsEmailVerificationPageState();
}

class _SettingsEmailVerificationPageState
    extends ConsumerState<SettingsEmailVerificationPage> {
  static final RegExp _emailRegExp = RegExp(r'^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$');

  late final TextEditingController _emailController;
  late final TextEditingController _codeController;
  late final CodeSendCooldown _sendCodeCooldown;

  bool _isSendingCode = false;
  bool _isSubmitting = false;
  bool _didSeedInitialEmail = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
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
    _emailController.dispose();
    _codeController.dispose();
    _sendCodeCooldown.dispose();
    super.dispose();
  }

  bool _looksLikeEmail(String value) {
    final normalized = value.trim();
    return normalized.isNotEmpty && _emailRegExp.hasMatch(normalized);
  }

  bool _ensureValidEmailInput(String email) {
    if (_looksLikeEmail(email)) {
      return true;
    }
    AppNotice.show(context, message: context.l10n.loginEmailAccountInvalid);
    return false;
  }

  Future<void> _sendCode(String email) async {
    if (_isSendingCode || _sendCodeCooldown.isActive) {
      return;
    }
    if (!_ensureValidEmailInput(email)) {
      return;
    }

    setState(() {
      _isSendingCode = true;
    });

    try {
      await ref
          .read(settingsTwoFactorRemoteDataSourceProvider)
          .sendEmailVerificationCode(email: email);
      if (!mounted) {
        return;
      }
      _sendCodeCooldown.start();
      AppNotice.show(context, message: context.l10n.settingsEmailCodeSent);
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

  Future<void> _syncVerifiedEmailLocally(String email) async {
    try {
      final remoteUser = await ref.read(authRemoteDataSourceProvider)
          .fetchCurrentUser();
      if (remoteUser != null) {
        await ref.read(authLocalDataSourceProvider).saveCurrentUser(remoteUser);
        return;
      }
    } catch (_) {
      // Fall back to updating the local cached user below.
    }

    final localUser = await ref.read(authLocalDataSourceProvider)
        .readCurrentUser();
    if (localUser == null) {
      return;
    }
    await ref.read(authLocalDataSourceProvider).saveCurrentUser(
      localUser.copyWith(
        email: email.trim(),
        checkEmailTime: DateTime.now().toIso8601String(),
      ),
    );
  }

  Future<void> _verifyEmail(String email) async {
    if (_isSubmitting) {
      return;
    }
    if (!_ensureValidEmailInput(email)) {
      return;
    }

    final code = _codeController.text.trim();
    if (code.length < 4) {
      AppNotice.show(context, message: context.l10n.settingsEmailCodeRequired);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref
          .read(settingsTwoFactorRemoteDataSourceProvider)
          .verifyEmailVerificationCode(email: email, code: code);
      await _syncVerifiedEmailLocally(email);
      ref.invalidate(currentAuthUserProvider);
      ref.invalidate(settingsRemoteVerificationStatusProvider);
      ref.invalidate(settingsEmailVerifiedProvider);
      ref.invalidate(settingsVerifiedEmailProvider);
      ref.invalidate(settingsEmailVerificationUpdatedAtProvider);
      TextInput.finishAutofillContext();
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: context.l10n.settingsEmailVerificationSuccess,
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
    final emailVerifiedAsync = ref.watch(settingsEmailVerifiedProvider);
    final verifiedEmailAsync = ref.watch(settingsVerifiedEmailProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: l10n.settingsEmailVerificationTitle,
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
          final verifiedEmail = verifiedEmailAsync.asData?.value?.trim() ?? '';
          final seededEmail = verifiedEmail.isNotEmpty
              ? verifiedEmail
              : user?.email?.trim() ?? '';
          if (!_didSeedInitialEmail) {
            _emailController.text = seededEmail;
            _didSeedInitialEmail = true;
          }

          final isVerified = emailVerifiedAsync.asData?.value == true;
          final activeEmail = _emailController.text.trim();
          final canSendCode =
              !_isSendingCode &&
              !_sendCodeCooldown.isActive &&
              !isVerified &&
              _looksLikeEmail(activeEmail);
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
                              color: colors.primarySubtle,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.mark_email_read_rounded,
                              color: colors.primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.settingsEmailVerificationDescription,
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
                        l10n.settingsCurrentEmailLabel,
                        style: appText.meta.copyWith(
                          color: colors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        seededEmail.isNotEmpty
                            ? seededEmail
                            : l10n.settingsEmailUnavailable,
                        style: appText.sectionTitle.copyWith(
                          color: seededEmail.isNotEmpty
                              ? colors.textPrimary
                              : colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                if (isVerified) ...<Widget>[
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: colors.successSubtle,
                      borderRadius: BorderRadius.circular(UiTokens.radius16),
                      border: Border.all(color: colors.successBorder),
                    ),
                    child: Text(
                      l10n.settingsEmailVerifiedReadonlyDescription,
                      style: appText.body.copyWith(
                        color: colors.successForeground,
                        height: 1.55,
                      ),
                    ),
                  ),
                ] else ...<Widget>[
                  EmailTextField(
                    controller: _emailController,
                    inputKey: const Key('settings_email_input'),
                    labelText: l10n.registerEmailAccountLabel,
                    hintText: l10n.registerEmailAccountLabel,
                    textInputAction: TextInputAction.next,
                    enabled: !_isSubmitting,
                    trailing: Tooltip(
                      message: sendButtonLabel,
                      child: AppNavigationIconButton(
                        key: const Key('settings_email_send_code_button'),
                        icon: Icons.send_rounded,
                        size: 34,
                        borderRadius: 10,
                        backgroundColor: colors.primary.withValues(
                          alpha: canSendCode ? 0.12 : 0.06,
                        ),
                        foregroundColor: canSendCode
                            ? colors.primary
                            : colors.primary.withValues(alpha: 0.4),
                        onTap: canSendCode ? () => _sendCode(activeEmail) : null,
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.settingsEmailVerificationInputDescription,
                    style: appText.helper.copyWith(
                      color: colors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  VerificationCodeField(
                    controller: _codeController,
                    labelText: l10n.loginCodeLabel,
                    sendCodeLabel: sendButtonLabel,
                    enabled: !_isSubmitting,
                    isSendingCode: _isSendingCode,
                    onChanged: (_) => setState(() {}),
                    onSendCode: canSendCode ? () => _sendCode(activeEmail) : null,
                    autofillHints: const <String>[AutofillHints.oneTimeCode],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.settingsEmailAutoFillHint,
                    style: appText.helper.copyWith(
                      color: colors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  PrimaryCtaButton(
                    label: l10n.settingsEmailVerifyAction,
                    onPressed:
                        _codeController.text.trim().length >= 4 &&
                            !_isSubmitting
                        ? () => _verifyEmail(activeEmail)
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
