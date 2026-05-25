import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class HotelBookingSectionCard extends StatelessWidget {
  const HotelBookingSectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.brandWhite,
        borderRadius: BorderRadius.circular(UiTokens.radius12),
        border: Border.all(color: colors.borderSoft.withValues(alpha: 0.70)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.brandPrimaryDark.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class HotelBookingTextField extends StatelessWidget {
  const HotelBookingTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: colors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: colors.textTertiary,
          fontWeight: FontWeight.w600,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UiTokens.radius8),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UiTokens.radius8),
          borderSide: BorderSide(color: colors.brandSecondary, width: 1.4),
        ),
      ),
    );
  }
}
