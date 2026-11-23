import 'dart:math' as math;

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../support/hotel_booking_presenter.dart';
import 'hotel_booking_section_card.dart';

class HotelBookingMilesReview extends StatelessWidget {
  const HotelBookingMilesReview({
    super.key,
    required this.balance,
    required this.cost,
    required this.roomCount,
    required this.roomLimit,
    required this.policy,
    required this.accepted,
    required this.onChanged,
    required this.onRetryPolicy,
  });

  final num? balance, cost;
  final int roomCount;
  final int? roomLimit;
  final String policy;
  final bool accepted;
  final ValueChanged<bool> onChanged;
  final VoidCallback onRetryPolicy;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final text = context.appTextTheme;
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(context).toLanguageTag(),
    );
    String miles(num? value) => value == null
        ? '—'
        : '${presenter.amount(value)} ${l.myPageChartMileUnit}';
    final rows = [
      (l.myPageChartMilesBalance, miles(balance)),
      (
        '${l.hotelDetailRequiredMiles} (${l.hotelMilesRoomValue(roomCount)})',
        miles(cost),
      ),
      (
        l.hotelDetailEstimatedMiles,
        miles(
          balance == null || cost == null
              ? null
              : math.max(0, balance! - cost!),
        ),
      ),
      (
        l.hotelDetailEstimatedRooms,
        roomLimit == null
            ? '—'
            : l.hotelMilesRoomValue(math.max(0, roomLimit! - roomCount)),
      ),
    ];
    return HotelBookingSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          for (final row in rows)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Expanded(child: Text(row.$1, style: text.body)),
                Flexible(
                  child: Text(
                    row.$2,
                    textAlign: TextAlign.end,
                    style: text.bodyStrong,
                  ),
                ),
              ],
            ),
          Text(l.hotelDetailEstimateNotice, style: text.caption),
          const Divider(),
          Text(l.hotelDetailRefundPolicy, style: text.bodyStrong),
          Text(policy.isEmpty ? l.hotelCancellationPolicyUnavailable : policy),
          if (policy.isEmpty)
            TextButton(onPressed: onRetryPolicy, child: Text(l.commonRetry)),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(l.hotelAcceptCancellationPolicy),
            value: accepted && policy.isNotEmpty,
            onChanged: policy.isEmpty
                ? null
                : (value) => onChanged(value == true),
          ),
        ],
      ),
    );
  }
}
