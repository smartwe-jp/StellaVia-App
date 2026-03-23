import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';
import 'ui_buttons.dart';
import 'ui_tokens.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.inputKey,
    this.onChanged,
    this.hintText,
    this.enabled = true,
    this.keyboardType,
    this.leadingIcon = Icons.alternate_email_rounded,
    this.textInputAction,
    this.autofillHints = const <String>[AutofillHints.email],
  });

  final TextEditingController controller;
  final String labelText;
  final Key? inputKey;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final bool enabled;
  final TextInputType? keyboardType;
  final IconData leadingIcon;
  final TextInputAction? textInputAction;
  final Iterable<String> autofillHints;

  @override
  Widget build(BuildContext context) {
    return _BaseInputField(
      fieldKey: inputKey,
      controller: controller,
      labelText: labelText,
      hintText: hintText ?? labelText,
      enabled: enabled,
      keyboardType: keyboardType ?? TextInputType.emailAddress,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      leadingIcon: leadingIcon,
      onChanged: onChanged,
    );
  }
}

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.inputKey,
    this.onChanged,
    this.hintText,
    this.enabled = true,
    this.leadingIcon = Icons.phone_iphone_rounded,
    this.textInputAction,
    this.autofillHints = const <String>[AutofillHints.telephoneNumber],
  });

  final TextEditingController controller;
  final String labelText;
  final Key? inputKey;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final bool enabled;
  final IconData leadingIcon;
  final TextInputAction? textInputAction;
  final Iterable<String> autofillHints;

  @override
  Widget build(BuildContext context) {
    return _BaseInputField(
      fieldKey: inputKey,
      controller: controller,
      labelText: labelText,
      hintText: hintText ?? labelText,
      enabled: enabled,
      keyboardType: TextInputType.phone,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      leadingIcon: leadingIcon,
      onChanged: onChanged,
    );
  }
}

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.inputKey,
    this.onChanged,
    this.hintText,
    this.enabled = true,
    this.leadingIcon = Icons.lock_outline_rounded,
    this.textInputAction,
    this.autofillHints = const <String>[AutofillHints.password],
  });

  final TextEditingController controller;
  final String labelText;
  final Key? inputKey;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final bool enabled;
  final IconData leadingIcon;
  final TextInputAction? textInputAction;
  final Iterable<String> autofillHints;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final hotelTheme = Theme.of(context).extension<AppFTKTheme>()!;
    return _BaseInputField(
      fieldKey: widget.inputKey,
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText ?? widget.labelText,
      enabled: widget.enabled,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      leadingIcon: widget.leadingIcon,
      obscureText: _obscureText,
      onChanged: widget.onChanged,
      trailing: GestureDetector(
        onTap: widget.enabled
            ? () => setState(() => _obscureText = !_obscureText)
            : null,
        behavior: HitTestBehavior.opaque,
        child: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: 20,
          color: hotelTheme.categoryIdleIconColor,
        ),
      ),
    );
  }
}

class VerificationCodeField extends StatelessWidget {
  const VerificationCodeField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.sendCodeLabel,
    this.onChanged,
    this.hintText,
    this.enabled = true,
    this.onSendCode,
    this.isSendingCode = false,
    this.inputKey,
    this.sendButtonKey,
    this.buttonWidth = 126,
    this.autofillHints = const <String>[AutofillHints.oneTimeCode],
  });

  final TextEditingController controller;
  final String labelText;
  final String sendCodeLabel;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final bool enabled;
  final VoidCallback? onSendCode;
  final bool isSendingCode;
  final Key? inputKey;
  final Key? sendButtonKey;
  final double buttonWidth;
  final Iterable<String> autofillHints;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _FieldLabel(labelText: labelText),
        const SizedBox(height: UiTokens.spacing8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _BaseInputField(
                fieldKey: inputKey,
                controller: controller,
                labelText: labelText,
                showLabel: false,
                hintText: hintText ?? labelText,
                enabled: enabled,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                autofillHints: autofillHints,
                leadingIcon: Icons.sms_outlined,
                onChanged: onChanged,
              ),
            ),
            const SizedBox(width: UiTokens.spacing12),
            CompactActionButton(
              key: sendButtonKey,
              label: sendCodeLabel,
              width: buttonWidth,
              isLoading: isSendingCode,
              onPressed: enabled ? onSendCode : null,
            ),
          ],
        ),
      ],
    );
  }
}

class _BaseInputField extends StatelessWidget {
  const _BaseInputField({
    this.fieldKey,
    required this.controller,
    required this.labelText,
    this.showLabel = true,
    required this.hintText,
    required this.leadingIcon,
    this.trailing,
    this.onChanged,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.obscureText = false,
  });

  final Key? fieldKey;
  final TextEditingController controller;
  final String labelText;
  final bool showLabel;
  final String hintText;
  final IconData leadingIcon;
  final Widget? trailing;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final hotelTheme = theme.extension<AppFTKTheme>()!;
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = theme.colorScheme.surface;
    final fillColor = isDark
        ? surfaceColor.withValues(alpha: 0.9)
        : surfaceColor.withValues(alpha: 0.92);
    final iconBg = hotelTheme.primaryButtonColor.withValues(
      alpha: isDark ? 0.18 : 0.12,
    );
    final iconColor = hotelTheme.primaryButtonColor;
    final hintStyle = appText.body.copyWith(
      color: colors.textSecondary.withValues(alpha: 0.95),
    );
    final textStyle = appText.inputText;

    final inputShell = _InputShell(
      enabled: enabled,
      fillColor: fillColor,
      glowColor: hotelTheme.primaryButtonColor.withValues(alpha: 0.16),
      shadowColor: isDark
          ? colors.scrim.withValues(alpha: 0.50)
          : colors.scrim.withValues(alpha: 0.06),
      defaultBorderColor: isDark
          ? hotelTheme.cardBorderColor.withValues(alpha: 0.88)
          : hotelTheme.cardBorderColor.withValues(alpha: 1),
      focusedBorderColor: hotelTheme.primaryButtonColor,
      disabledBorderColor: hotelTheme.cardBorderColor.withValues(alpha: 0.45),
      child: Row(
        children: <Widget>[
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(leadingIcon, size: 18, color: iconColor),
          ),
          const SizedBox(width: UiTokens.spacing12),
          Expanded(
            child: TextField(
              key: fieldKey,
              controller: controller,
              enabled: enabled,
              obscureText: obscureText,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              onChanged: onChanged,
              autofocus: false,
              autofillHints: autofillHints,
              style: textStyle,
              cursorColor: hotelTheme.primaryButtonColor,
              decoration: InputDecoration(
                isDense: true,
                hintText: hintText,
                hintStyle: hintStyle,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                counterText: '',
              ),
            ),
          ),
          if (trailing != null) ...<Widget>[
            const SizedBox(width: UiTokens.spacing8),
            trailing!,
          ],
        ],
      ),
    );

    if (!showLabel) {
      return inputShell;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _FieldLabel(labelText: labelText),
        const SizedBox(height: UiTokens.spacing8),
        inputShell,
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.labelText});

  final String labelText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Text(
      labelText,
      style: appText.inputLabel.copyWith(color: colors.textSecondary),
    );
  }
}

class _InputShell extends StatefulWidget {
  const _InputShell({
    required this.child,
    required this.fillColor,
    required this.glowColor,
    required this.shadowColor,
    required this.defaultBorderColor,
    required this.focusedBorderColor,
    required this.disabledBorderColor,
    required this.enabled,
  });

  final Widget child;
  final Color fillColor;
  final Color glowColor;
  final Color shadowColor;
  final Color defaultBorderColor;
  final Color focusedBorderColor;
  final Color disabledBorderColor;
  final bool enabled;

  @override
  State<_InputShell> createState() => _InputShellState();
}

class _InputShellState extends State<_InputShell> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (bool focused) {
        if (_isFocused == focused) {
          return;
        }
        setState(() {
          _isFocused = focused;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          horizontal: UiTokens.spacing12,
          vertical: UiTokens.spacing12,
        ),
        decoration: BoxDecoration(
          color: widget.enabled
              ? (_isFocused
                    ? widget.fillColor.withValues(alpha: 1)
                    : widget.fillColor)
              : widget.fillColor.withValues(alpha: 0.62),
          border: Border.all(
            color: !widget.enabled
                ? widget.disabledBorderColor
                : (_isFocused
                      ? widget.focusedBorderColor
                      : widget.defaultBorderColor),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(18),
          // boxShadow: <BoxShadow>[
          //   BoxShadow(
          //     color: _isFocused ? widget.glowColor : widget.shadowColor,
          //     blurRadius: _isFocused ? 20 : 14,
          //     offset: _isFocused ? const Offset(0, 6) : const Offset(0, 4),
          //   ),
          // ],
        ),
        child: widget.child,
      ),
    );
  }
}
