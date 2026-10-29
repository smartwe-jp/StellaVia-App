import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';

/// Disabled design controls until a host-miles availability contract exists.
class HotelMilesPreviewSearch extends StatelessWidget {
  const HotelMilesPreviewSearch({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
        decoration: BoxDecoration(
          border: Border.all(color: context.appColors.borderSoft),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.hotelHomeDatesGuests,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(context.l10n.homeFeaturePreparing),
                ],
              ),
            ),
            CircleAvatar(
              radius: 28,
              backgroundColor: context.appColors.primary,
              child: Icon(Icons.search, color: context.appColors.onDark),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      Wrap(
        spacing: 12,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(minimumSize: const Size(100, 36)),
            onPressed: null,
            child: Text('${context.l10n.hotelHomeArea} ⌄'),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(minimumSize: const Size(100, 36)),
            onPressed: null,
            child: Text('${context.l10n.hotelToolbarSort} ⌄'),
          ),
        ],
      ),
    ],
  );
}
