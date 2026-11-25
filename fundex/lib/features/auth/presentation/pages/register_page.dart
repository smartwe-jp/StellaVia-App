import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../settings/presentation/providers/settings_content_providers.dart';
import '../../domain/repositories/auth_repository.dart';
import '../providers/auth_providers.dart';
import '../support/code_send_cooldown.dart';
import '../widgets/guest_registration_form.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key, this.initialInviteCode});
  final String? initialInviteCode;

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  late final TextEditingController _accountController;
  late final TextEditingController _codeController;
  late final TextEditingController _inviteCodeController;
  bool _acceptPolicy = false;
  bool _acceptElectronicDelivery = false;
  bool _acceptAntiSocial = false;
  bool _acceptPersonalInformation = false;
  bool _codeSent = false;
  bool _isSubmitting = false;
  bool _isSendingCode = false;
  late final CodeSendCooldown _sendCodeCooldown;

  @override
  void initState() {
    super.initState();
    _accountController = TextEditingController();
    _codeController = TextEditingController();
    _inviteCodeController = TextEditingController(
      text: widget.initialInviteCode,
    );
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
    _sendCodeCooldown.dispose();
    _accountController.dispose();
    _codeController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  bool _looksLikeEmail(String value) {
    final normalized = value.trim();
    return normalized.contains('@') && normalized.contains('.');
  }

  String get _accountValue => _accountController.text.trim();

  bool get _isAccountFormatValid => _looksLikeEmail(_accountValue);

  bool get _canSendCode {
    return _isAccountFormatValid &&
        !_isSendingCode &&
        !_sendCodeCooldown.isActive;
  }

  bool get _canSubmit {
    final hasRequiredFields =
        _isAccountFormatValid && _codeController.text.trim().isNotEmpty;
    return hasRequiredFields &&
        _acceptPolicy &&
        _acceptElectronicDelivery &&
        _acceptAntiSocial &&
        _acceptPersonalInformation &&
        !_isSubmitting;
  }

  Future<bool> _ensureValidAccountInput() async {
    if (_isAccountFormatValid) {
      return true;
    }
    if (!mounted) {
      return false;
    }
    AppNotice.show(context, message: context.l10n.registerEmailAccountInvalid);
    return false;
  }

  Future<void> _showPolicySheet({required String title, required String? url}) {
    final l10n = context.l10n;
    final normalizedUrl = url?.trim() ?? '';
    if (normalizedUrl.isEmpty) {
      AppNotice.show(context, message: l10n.pdfViewerInvalidUrlNotice);
      return Future<void>.value();
    }
    return openAppPdfViewer(context, url: normalizedUrl, title: title);
  }

  String _resolveErrorMessage(Object error, String fallback) {
    if (error is StateError) {
      return error.message.toString();
    }
    if (error is NetworkFailure) {
      return error.message;
    }
    return fallback;
  }

  Future<void> _sendCode() async {
    final l10n = context.l10n;
    if (!await _ensureValidAccountInput()) {
      return;
    }

    setState(() {
      _isSendingCode = true;
    });

    try {
      await ref
          .read(sendRegisterCodeUseCaseProvider)
          .call(
            account: _accountValue,
            intlCode: AuthApiDefaults.defaultIntlCode,
          );

      if (!mounted) {
        return;
      }
      _sendCodeCooldown.start();
      setState(() => _codeSent = true);
      AppNotice.show(context, message: l10n.registerSendCodeSuccess);
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: _resolveErrorMessage(error, l10n.registerSubmitFailed),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSendingCode = false;
        });
      }
    }
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    if (!await _ensureValidAccountInput()) {
      return;
    }
    if (!mounted || _isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref
          .read(registerAccountUseCaseProvider)
          .call(
            account: _accountValue,
            code: _codeController.text.trim(),
            intlCode: AuthApiDefaults.defaultIntlCode,
            inviteCode: _inviteCodeController.text.trim(),
          );
    } on RegistrationSignInRequired {
      if (!mounted) return;
      AppNotice.show(context, message: l10n.registerSuccessMessage);
      context.go('/login', extra: _accountValue);
      return;
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSubmitting = false;
      });
      await AppDialogs.showAdaptiveAlert<void>(
        context: context,
        title: l10n.registerPolicyTitle,
        message: _resolveErrorMessage(error, l10n.registerSubmitFailed),
        actions: <AppDialogAction<void>>[
          AppDialogAction<void>(label: l10n.commonOk, isDefaultAction: true),
        ],
      );
      return;
    }

    if (!mounted) {
      return;
    }

    final router = GoRouter.of(context);
    ref.read(authSessionProvider.notifier).markAuthenticated();
    router.go('/guest-registration-complete');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final operatingCompanyContent = ref
        .watch(settingsOperatingCompanyContentProvider(localeTag))
        .asData
        ?.value;
    final policyRows = <Widget>[
      _RegisterPolicyRow(
        checked: _acceptPolicy,
        label: l10n.settingsCompanyLinkTerms,
        onTap: () => setState(() => _acceptPolicy = !_acceptPolicy),
        onActionTap: () => _showPolicySheet(
          title: l10n.registerPolicyTitle,
          url: operatingCompanyContent?.termsConditionsUrl,
        ),
      ),
      _RegisterPolicyRow(
        checked: _acceptElectronicDelivery,
        label: l10n.guestElectronic,
        onTap: () => setState(
          () => _acceptElectronicDelivery = !_acceptElectronicDelivery,
        ),
        onActionTap: () => _showPolicySheet(
          title: l10n.registerElectronicDeliveryDocumentTitle,
          url: operatingCompanyContent?.electronicInformationUrl,
        ),
      ),
      _RegisterPolicyRow(
        checked: _acceptAntiSocial,
        label: l10n.guestAntiSocial,
        onTap: () => setState(() => _acceptAntiSocial = !_acceptAntiSocial),
        onActionTap: () => _showPolicySheet(
          title: l10n.registerAntiSocialDocumentTitle,
          url: operatingCompanyContent?.antiSocialRuleUrl,
        ),
      ),
      _RegisterPolicyRow(
        checked: _acceptPersonalInformation,
        label: l10n.guestPersonal,
        onTap: () => setState(
          () => _acceptPersonalInformation = !_acceptPersonalInformation,
        ),
        onActionTap: () => _showPolicySheet(
          title: l10n.registerPersonalInformationDocumentTitle,
          url: operatingCompanyContent?.personalInformationUrl,
        ),
      ),
    ];
    return GuestRegistrationForm(
      email: _accountController,
      code: _codeController,
      invite: _inviteCodeController,
      codeSent: _codeSent,
      busy: _isSendingCode || _isSubmitting,
      policyRows: policyRows,
      remainingSeconds: _sendCodeCooldown.remainingSeconds,
      onSend: _canSendCode && !_isSubmitting ? _sendCode : null,
      onSubmit: _canSubmit && !_isSendingCode ? _submit : null,
      onChanged: () => setState(() {}),
      onChangeEmail: () => setState(() {
        _codeSent = false;
        _codeController.clear();
      }),
    );
  }
}

class _RegisterPolicyRow extends StatelessWidget {
  const _RegisterPolicyRow({
    required this.label,
    required this.checked,
    required this.onTap,
    required this.onActionTap,
  });

  final String label;
  final bool checked;
  final VoidCallback onTap;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Semantics(
          checked: checked,
          label: label,
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 32,
              height: 36,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Icon(
                  checked ? Icons.check_box : Icons.check_box_outline_blank,
                  size: 18,
                  color: checked
                      ? context.appColors.primary
                      : context.appColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: InkWell(
            onTap: onActionTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(label, style: theme.textTheme.bodyMedium),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.chevron_right, size: 14),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
