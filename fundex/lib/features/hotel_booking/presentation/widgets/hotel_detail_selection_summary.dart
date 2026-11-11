import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../host_miles/domain/entities/host_miles_models.dart';
import '../controllers/hotel_detail_selection_controller.dart';
import '../support/hotel_booking_presenter.dart';
import '../support/hotel_detail_route_args.dart';
import '../support/hotel_detail_styles.dart';
import '../support/hotel_quote_status.dart';
import 'hotel_extra_guest_miles_breakdown.dart';

class HotelDetailSelectionSummary extends StatelessWidget {
  const HotelDetailSelectionSummary({
    super.key,
    required this.selection,
    this.tier,
    this.account,
  });
  final HotelDetailSelectionController selection;
  final HostMilesTier? tier;
  final HostMilesAccount? account;
  @override
  Widget build(BuildContext c) {
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(c).toLanguageTag(),
    );
    final miles = selection.mode == HotelBookingMode.hostMiles;
    final amount = selection.amount;
    final balance = account?.availablePoints ?? tier?.pointsBalance;
    final remaining = balance == null
        ? null
        : amount != null
        ? balance - amount
        : selection.roomCount == 0
        ? balance
        : null;
    final roomLimit = tier?.remainingBookingRooms;
    final labels = <(String, String)>[
      (
        c.l10n.hotelDetailSelection,
        '${c.l10n.hotelSearchNights(selection.criteria.nights)} · ${c.l10n.hotelMilesRoomValue(selection.roomCount)}',
      ),
      (
        miles ? c.l10n.hotelDetailRequiredMiles : c.l10n.hotelDetailStayTotal,
        amount == null
            ? '—'
            : miles
            ? '${presenter.amount(amount)} ${c.l10n.myPageChartMileUnit}'
            : presenter.price(amount),
      ),
      if (miles) ...[
        (
          c.l10n.hotelDetailEstimatedMiles,
          remaining == null
              ? '—'
              : '${presenter.amount(remaining < 0 ? 0 : remaining)} ${c.l10n.myPageChartMileUnit}',
        ),
        (
          c.l10n.hotelDetailEstimatedRooms,
          roomLimit == null
              ? '—'
              : c.l10n.hotelMilesRoomValue(
                  selection.remainingAllowance(roomLimit)!,
                ),
        ),
      ],
    ];
    return DecoratedBox(
      decoration: BoxDecoration(
        color: HotelDetailStyles.summary(c),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final row in labels)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(row.$1, style: HotelDetailStyles.caption(c)),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        row.$2,
                        textAlign: TextAlign.right,
                        style: c.appTextTheme.bodyStrong.copyWith(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            if (miles && selection.assignment != null)
              HotelExtraGuestMilesBreakdown(
                rows: selection.assignment!.roomTypeExtraGuestPrices,
              ),
            if (selection.busy) const LinearProgressIndicator(),
            if (miles)
              Text(
                c.l10n.hotelDetailEstimateNotice,
                style: HotelDetailStyles.body(c),
              ),
            if (remaining != null && remaining < 0)
              Text(
                c.l10n.hotelDetailMilesInsufficient,
                style: HotelDetailStyles.label(c),
              ),
            if (roomLimit != null && roomLimit < selection.roomCount)
              Text(
                c.l10n.hotelDetailRoomsInsufficient,
                style: HotelDetailStyles.label(c),
              ),
            if (miles &&
                selection.roomCount > 0 &&
                !selection.busy &&
                !selection.failed &&
                amount == null)
              Text(
                c.l10n.hotelDetailMilesUnavailable,
                style: HotelDetailStyles.caption(c),
              ),
            if (selection.failed) ...[
              Text(
                hotelQuoteStatus(c, selection),
                style: HotelDetailStyles.caption(c),
              ),
              TextButton(
                onPressed: selection.refreshQuote,
                child: Text(c.l10n.commonRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class HotelDetailReservationPanel extends StatelessWidget {
  const HotelDetailReservationPanel({
    super.key,
    required this.selection,
    required this.onBook,
    required this.busy,
  });
  final HotelDetailSelectionController selection;
  final VoidCallback onBook;
  final bool busy;
  @override
  Widget build(BuildContext c) {
    final miles = selection.mode == HotelBookingMode.hostMiles;
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(c).toLanguageTag(),
    );
    final amount = selection.amount;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.appColors.surface,
        border: Border(top: BorderSide(color: c.appColors.borderSoft)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: c.appColors.brandPrimaryDark,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${miles ? c.l10n.hotelDetailRequiredMiles : c.l10n.hotelDetailStayTotal}  ${amount == null
                      ? '—'
                      : miles
                      ? '${presenter.amount(amount)} ${c.l10n.myPageChartMileUnit}'
                      : presenter.price(amount)}',
                  style: c.appTextTheme.bodyStrong.copyWith(
                    color: c.appColors.onDark,
                  ),
                ),
              ),
              if (!miles && selection.busy) ...[
                const LinearProgressIndicator(),
                Text(
                  hotelQuoteStatus(c, selection),
                  style: c.appTextTheme.caption,
                ),
              ],
              if (selection.failed) ...[
                Text(
                  hotelQuoteStatus(c, selection),
                  style: c.appTextTheme.caption,
                ),
                TextButton(
                  onPressed: selection.refreshQuote,
                  child: Text(c.l10n.commonRetry),
                ),
              ],
              SizedBox(
                height: 10,
                child: miles && selection.busy
                    ? const Align(
                        alignment: Alignment.topCenter,
                        child: LinearProgressIndicator(),
                      )
                    : null,
              ),
              AppButton(
                label: miles
                    ? c.l10n.hotelDetailMilesPending
                    : c.l10n.hotelDetailProceed,
                onPressed:
                    miles ||
                        busy ||
                        selection.busy ||
                        selection.failed ||
                        selection.roomCount == 0 ||
                        amount == null ||
                        !selection.detail.isBookable
                    ? null
                    : onBook,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
