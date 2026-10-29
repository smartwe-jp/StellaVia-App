import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

/// Typography of Figma My Page summary (8038:31937), using app font families.
class MyPageSummaryStyles {
  MyPageSummaryStyles(BuildContext context) : _text = context.appTextTheme;
  final AppSemanticTextTheme _text;
  TextStyle get heading =>
      _text.sectionTitle.copyWith(fontSize: 18, fontWeight: FontWeight.w700);
  TextStyle get total =>
      _text.numericHeadline.copyWith(fontSize: 28, fontWeight: FontWeight.w600);
  TextStyle get metric =>
      _text.numericCaption.copyWith(fontSize: 11, fontWeight: FontWeight.w400);
  TextStyle get value => _text.numericCaption.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.7,
  );
  TextStyle get fundTitle => _text.body.copyWith(fontSize: 16, height: 1.7);
}
