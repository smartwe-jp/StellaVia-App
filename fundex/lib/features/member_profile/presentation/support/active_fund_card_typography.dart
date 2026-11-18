import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

/// Keeps the localized currency/unit text while styling the numeric value.
TextSpan activeFundNumericSpan(BuildContext context, String value) {
  final number = RegExp(r'[-+]?\d[\d,]*(?:\.\d+)?').firstMatch(value);
  final text = context.appTextTheme;
  final numericStyle = text.numericCaption.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: context.appColors.infoForeground,
  );
  if (number == null) return TextSpan(text: value, style: numericStyle);
  return TextSpan(
    style: text.micro.copyWith(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: context.appColors.infoForeground,
    ),
    children: [
      TextSpan(text: value.substring(0, number.start)),
      TextSpan(text: number.group(0), style: numericStyle),
      TextSpan(text: value.substring(number.end)),
    ],
  );
}
