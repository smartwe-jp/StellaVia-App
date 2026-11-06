import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_booking_presenter.dart';
import '../support/hotel_detail_styles.dart';

/// Per-room-type whole-stay reference values; never add them to the total.
class HotelExtraGuestMilesBreakdown extends StatelessWidget {
  const HotelExtraGuestMilesBreakdown({super.key, required this.rows});
  final List<HotelRoomTypeExtraGuestPrice> rows;

  @override
  Widget build(BuildContext context) {
    final visible = rows
        .where((row) => row.extraGuestCount > 0 || row.extraGuestPoints != null)
        .toList();
    if (visible.isEmpty) return const SizedBox.shrink();
    final l = context.l10n;
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(context).toLanguageTag(),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.hotelExtraGuestMilesTitle,
            style: HotelDetailStyles.label(context),
          ),
          for (final row in visible)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      row.roomTypeName,
                      style: HotelDetailStyles.caption(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      row.extraGuestPoints == null
                          ? '—'
                          : '${presenter.amount(row.extraGuestPoints!)} ${l.myPageChartMileUnit}',
                      textAlign: TextAlign.right,
                      style: HotelDetailStyles.body(context),
                    ),
                  ),
                ],
              ),
            ),
          Text(
            l.hotelExtraGuestMilesNotice,
            style: HotelDetailStyles.caption(context),
          ),
        ],
      ),
    );
  }
}
