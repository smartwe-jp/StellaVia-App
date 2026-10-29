import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../support/hotel_home_theme.dart';

class HotelMilesPreviewSummary extends StatelessWidget {
  const HotelMilesPreviewSummary({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: HotelHomeTheme.bronzeSurface(context),
      border: Border.all(color: context.appColors.borderSoft),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BRONZE',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: HotelHomeTheme.bronzeInk(context),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _Metric(
                label: context.l10n.homeHostMiles,
                value: '12,000',
              ),
            ),
            Expanded(
              child: _Metric(
                label: context.l10n.hotelMilesRooms,
                value: context.l10n.hotelMilesRoomValue(2),
              ),
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
      Text(
        value,
        style: context.appTextTheme.numericTitle.copyWith(fontSize: 24),
      ),
    ],
  );
}
