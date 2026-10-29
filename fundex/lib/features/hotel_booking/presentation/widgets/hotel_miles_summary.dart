import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../support/hotel_home_text_styles.dart';

class HotelMilesSummary extends StatelessWidget {
  const HotelMilesSummary({
    super.key,
    required this.rank,
    required this.balance,
    required this.rooms,
  });
  final String rank, balance, rooms;
  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.all(16),
    backgroundColor: context.appColors.surfaceAlt,
    borderColor: context.appColors.borderSoft,
    borderRadius: BorderRadius.circular(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rank,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: context.appColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _Metric(label: context.l10n.homeHostMiles, value: balance),
            ),
            Expanded(
              child: _Metric(label: context.l10n.hotelMilesRooms, value: rooms),
            ),
          ],
        ),
      ],
    ),
  );
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: context.appColors.textSecondary),
      ),
      const SizedBox(height: 8),
      Text(value, style: HotelHomeTextStyles.milesValue(context)),
    ],
  );
}
