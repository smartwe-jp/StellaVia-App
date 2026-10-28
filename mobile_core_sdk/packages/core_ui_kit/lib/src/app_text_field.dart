import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_status_badge.dart';
import 'app_theme_extensions.dart';
import 'ui_tokens.dart';

class AppFieldLabel extends StatelessWidget {
  const AppFieldLabel({super.key, required this.label, this.requiredLabel});
  final String label;
  final String? requiredLabel;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: UiTokens.spacing8,
    runSpacing: UiTokens.spacing4,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      Text(
        label,
        style: context.appTextTheme.inputLabel.copyWith(
          color: context.appColors.textPrimary,
        ),
      ),
      if (requiredLabel != null)
        AppStatusBadge(label: requiredLabel!, tone: AppBadgeTone.accent),
    ],
  );
}

/// Generic form input; validation, formatting and localized copy are supplied
/// by the feature. Focus and editing remain native Flutter behavior.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.inputKey,
    this.controller,
    this.focusNode,
    this.label,
    this.requiredLabel,
    this.hintText,
    this.helperText,
    this.errorText,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.autovalidateMode = AutovalidateMode.disabled,
  });
  final Key? inputKey;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label, requiredLabel, hintText, helperText, errorText;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged, onFieldSubmitted;
  final bool enabled, readOnly, obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final Widget? prefixIcon, suffixIcon;
  final int? maxLines;
  final AutovalidateMode autovalidateMode;

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      errorMaxLines: 3,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          AppFieldLabel(label: label!, requiredLabel: requiredLabel),
          const SizedBox(height: UiTokens.spacing8),
        ],
        Semantics(
          label: label,
          child: validator == null && onSaved == null
              ? TextField(
                  key: inputKey,
                  controller: controller,
                  focusNode: focusNode,
                  enabled: enabled,
                  readOnly: readOnly,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  autofillHints: autofillHints,
                  inputFormatters: inputFormatters,
                  textCapitalization: textCapitalization,
                  onChanged: onChanged,
                  onSubmitted: onFieldSubmitted,
                  maxLines: maxLines,
                  style: context.appTextTheme.inputText,
                  decoration: decoration,
                )
              : TextFormField(
                  key: inputKey,
                  controller: controller,
                  focusNode: focusNode,
                  enabled: enabled,
                  readOnly: readOnly,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  autofillHints: autofillHints,
                  inputFormatters: inputFormatters,
                  textCapitalization: textCapitalization,
                  validator: validator,
                  onSaved: onSaved,
                  onChanged: onChanged,
                  onFieldSubmitted: onFieldSubmitted,
                  autovalidateMode: autovalidateMode,
                  maxLines: maxLines,
                  style: context.appTextTheme.inputText,
                  decoration: decoration,
                ),
        ),
      ],
    );
  }
}
