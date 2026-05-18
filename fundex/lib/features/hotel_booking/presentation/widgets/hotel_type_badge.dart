import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class HotelTypeBadge extends StatelessWidget {
  const HotelTypeBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final text = label.trim();
    if (text.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = Theme.of(context).appColors;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 176),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.brandPrimaryDark.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: colors.brandWhite.withValues(alpha: 0.38)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colors.brandPrimaryDark.withValues(alpha: 0.22),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colors.brandWhite,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
