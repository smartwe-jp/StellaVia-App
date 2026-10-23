import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_theme_extensions.dart';
import 'app_text_field.dart';
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
    this.trailing,
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
  final Widget? trailing;

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
      trailing: trailing,
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
    this.trailing,
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
  final Widget? trailing;

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
      trailing: trailing,
      onChanged: onChanged,
    );
  }
}

class InviteCodeTextField extends StatelessWidget {
  const InviteCodeTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.inputKey,
    this.onChanged,
    this.hintText,
    this.enabled = true,
    this.leadingIcon = Icons.confirmation_number_outlined,
    this.textInputAction = TextInputAction.done,
    this.optionalLabel,
  });

  final TextEditingController controller;
  final String labelText;
  final Key? inputKey;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final bool enabled;
  final IconData leadingIcon;
  final TextInputAction? textInputAction;
  final String? optionalLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hotelTheme = theme.extension<AppFTKTheme>()!;
    final normalizedOptionalLabel = optionalLabel?.trim() ?? '';

    return _BaseInputField(
      fieldKey: inputKey,
      controller: controller,
      labelText: labelText,
      showLabel: false,
      hintText: hintText ?? labelText,
      enabled: enabled,
      keyboardType: TextInputType.text,
      textInputAction: textInputAction,
      autofillHints: const <String>[],
      inputFormatters: const <TextInputFormatter>[
        _UpperCaseTextInputFormatter(),
      ],
      leadingIcon: leadingIcon,
      textCapitalization: TextCapitalization.characters,
      trailing: normalizedOptionalLabel.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(
                horizontal: UiTokens.spacing8,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                color: hotelTheme.primaryButtonColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                normalizedOptionalLabel,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: hotelTheme.primaryButtonColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
      onChanged: onChanged,
    );
  }
}

class _UpperCaseTextInputFormatter extends TextInputFormatter {
  const _UpperCaseTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final upperText = newValue.text.toUpperCase();
    if (upperText == newValue.text) {
      return newValue;
    }
    return newValue.copyWith(text: upperText, composing: TextRange.empty);
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
    this.sendButtonBackgroundColor,
    this.sendButtonForegroundColor,
    this.sendButtonFilled = false,
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
  final Color? sendButtonBackgroundColor;
  final Color? sendButtonForegroundColor;
  final bool sendButtonFilled;
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
                inputFormatters: <TextInputFormatter>[
                  const _VerificationCodeInputFormatter(),
                ],
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
              backgroundColor: sendButtonBackgroundColor,
              foregroundColor: sendButtonForegroundColor,
              filledBackground: sendButtonFilled,
              onPressed: enabled ? onSendCode : null,
            ),
          ],
        ),
      ],
    );
  }
}

class _VerificationCodeInputFormatter extends TextInputFormatter {
  const _VerificationCodeInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final oldDigits = _digitsOnly(oldValue.text);
    var nextDigits = _digitsOnly(newValue.text);
    if (oldDigits.isNotEmpty && nextDigits.startsWith(oldDigits)) {
      final appendedDigits = nextDigits.substring(oldDigits.length);
      if (appendedDigits.length > 1) {
        nextDigits = appendedDigits;
      }
    }
    return TextEditingValue(
      text: nextDigits,
      selection: TextSelection.collapsed(offset: nextDigits.length),
      composing: TextRange.empty,
    );
  }

  static String _digitsOnly(String value) {
    return value.runes
        .where((int rune) => rune >= 48 && rune <= 57)
        .map(String.fromCharCode)
        .join();
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
    this.inputFormatters,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
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
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) => AppTextField(
    inputKey: fieldKey,
    controller: controller,
    label: showLabel ? labelText : null,
    hintText: hintText,
    enabled: enabled,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    autofillHints: autofillHints,
    inputFormatters: inputFormatters,
    obscureText: obscureText,
    textCapitalization: textCapitalization,
    onChanged: onChanged,
    prefixIcon: Icon(leadingIcon),
    suffixIcon: trailing == null
        ? null
        : Padding(
            padding: const EdgeInsets.all(UiTokens.spacing12),
            child: trailing,
          ),
  );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.labelText});
  final String labelText;

  @override
  Widget build(BuildContext context) => AppFieldLabel(label: labelText);
}
