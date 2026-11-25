import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../guest_onboarding/presentation/widgets/guest_account_layout.dart';

class GuestRegistrationForm extends StatefulWidget {
  const GuestRegistrationForm({
    super.key,
    required this.email,
    required this.code,
    required this.invite,
    required this.codeSent,
    required this.busy,
    required this.policyRows,
    required this.remainingSeconds,
    required this.onSend,
    required this.onSubmit,
    required this.onChanged,
    required this.onChangeEmail,
  });
  final TextEditingController email, code, invite;
  final bool codeSent, busy;
  final List<Widget> policyRows;
  final int remainingSeconds;
  final VoidCallback? onSend, onSubmit;
  final VoidCallback onChanged, onChangeEmail;
  @override
  State<GuestRegistrationForm> createState() => _GuestRegistrationFormState();
}

class _GuestRegistrationFormState extends State<GuestRegistrationForm> {
  late bool _showInvite = widget.invite.text.isNotEmpty;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context).textTheme;
    final muted = theme.bodyMedium?.copyWith(
      color: context.appColors.textSecondary,
    );
    final cooldown = l.guestResendIn(widget.remainingSeconds);
    final codeSent = widget.codeSent;
    void back() {
      if (codeSent) {
        widget.onChangeEmail();
      } else if (context.canPop()) {
        context.pop();
      } else {
        context.go('/guest-guide');
      }
    }

    return PopScope(
      canPop: !codeSent,
      onPopInvokedWithResult: (popped, _) {
        if (!popped && codeSent && !widget.busy) widget.onChangeEmail();
      },
      child: GuestAccountLayout(
        title: codeSent ? l.registerCodeLabel : l.authEmailRegisterTitle,
        leading: Tooltip(
          message: l.commonBack,
          child: AppNavigationIconButton(
            icon: Icons.arrow_back_rounded,
            backgroundColor: context.appColors.surface.withValues(alpha: 0),
            foregroundColor: context.appColors.textPrimary,
            onTap: widget.busy ? null : back,
          ),
        ),
        children: [
          const SizedBox(height: 12),
          if (!codeSent) ...[
            Text(
              l.guestAccountEyebrow,
              style: theme.labelMedium?.copyWith(
                color: context.appColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              l.registerQuickTitle,
              style: theme.headlineMedium?.copyWith(
                fontSize: 29,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(l.guestGuideEmailIntro, style: muted?.copyWith(fontSize: 16)),
            const SizedBox(height: 20),
            Text(
              l.registerEmailAccountLabel,
              style: theme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            _Field(
              controller: widget.email,
              hint: 'name@example.com',
              enabled: !widget.busy,
              onChanged: widget.onChanged,
              keyboard: TextInputType.emailAddress,
              autofill: AutofillHints.email,
            ),
            const SizedBox(height: 16),
            GuestAccountButton(
              widget.remainingSeconds > 0 ? cooldown : l.guestSendCode,
              onTap: widget.onSend,
            ),
            const SizedBox(height: 16),
            Text(l.guestSpamHint, style: muted),
            const SizedBox(height: 24),
            const Spacer(),
            GuestAccountLink(
              l.guestExistingLogin,
              onTap: widget.busy
                  ? null
                  : () =>
                        context.push('/login', extra: widget.email.text.trim()),
            ),
          ] else ...[
            Text(
              l.guestGuideCheckEmail,
              style: theme.headlineSmall?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            Text(l.guestSentTo(widget.email.text.trim()), style: muted),
            const SizedBox(height: 6),
            GuestAccountLink(
              l.guestGuideChangeEmail,
              onTap: widget.busy ? null : widget.onChangeEmail,
            ),
            const SizedBox(height: 8),
            _Field(
              controller: widget.code,
              hint: l.guestCodeHint,
              enabled: !widget.busy,
              onChanged: widget.onChanged,
              keyboard: TextInputType.number,
              autofill: AutofillHints.oneTimeCode,
            ),
            const SizedBox(height: 12),
            if (widget.remainingSeconds > 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(cooldown, style: muted),
              )
            else
              GuestAccountLink(l.guestSendCode, onTap: widget.onSend),
            GuestAccountLink(
              l.guestInviteToggle,
              icon: _showInvite ? Icons.remove : Icons.add,
              onTap: () => setState(() => _showInvite = !_showInvite),
            ),
            if (_showInvite)
              _Field(
                controller: widget.invite,
                hint: l.registerInviteCodeHint,
                enabled: !widget.busy,
                onChanged: widget.onChanged,
              ),
            const SizedBox(height: 8),
            GuestAccountPanel(
              children: [
                Text(
                  l.guestAgreements,
                  style: theme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...widget.policyRows,
              ],
            ),
            const SizedBox(height: 24),
            const Spacer(),
            GuestAccountButton(
              l.registerSubmit,
              key: const Key('guest_register_submit'),
              onTap: widget.onSubmit,
              alignDisabled: true,
            ),
            const SizedBox(height: 16),
            Text(l.guestSubmitHint, style: muted?.copyWith(fontSize: 12)),
          ],
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    required this.enabled,
    required this.onChanged,
    this.keyboard,
    this.autofill,
  });
  final TextEditingController controller;
  final String hint;
  final bool enabled;
  final VoidCallback onChanged;
  final TextInputType? keyboard;
  final String? autofill;
  @override
  Widget build(BuildContext context) {
    final shape = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboard,
      autofillHints: autofill == null ? null : [autofill!],
      onChanged: (_) => onChanged(),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.bodyLarge,
        filled: true,
        fillColor: context.appColors.textSecondary.withValues(alpha: .08),
        border: shape,
        enabledBorder: shape,
        contentPadding: const EdgeInsets.all(15),
      ),
    );
  }
}
