import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class HotelDiscountBadge extends StatelessWidget {
  const HotelDiscountBadge({
    super.key,
    required this.name,
    required this.discount,
  });

  final String name;
  final num? discount;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final label = name.trim();
    final value = _formatDiscount(context, discount);
    if (label.isEmpty || value.isEmpty) {
      return const SizedBox.shrink();
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 240),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(UiTokens.radius8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.brandWhite,
            border: Border.all(color: colors.brandAlert),
            borderRadius: BorderRadius.circular(UiTokens.radius8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colors.brandAlert,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(color: colors.brandAlert),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colors.brandWhite,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDiscount(BuildContext context, num? raw) {
    if (raw == null || raw <= 0) {
      return '';
    }
    final text = raw % 1 == 0 ? raw.toInt().toString() : raw.toString();
    return context.l10n.hotelDiscountBadgeValue(text);
  }
}
