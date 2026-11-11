import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../host_miles/domain/entities/host_miles_models.dart';
import '../../domain/entities/hotel_models.dart';
import '../controllers/hotel_detail_selection_controller.dart';
import '../support/hotel_booking_presenter.dart';
import '../support/hotel_detail_display.dart';
import '../support/hotel_detail_route_args.dart';
import '../support/hotel_detail_styles.dart';
import 'hotel_booking_service_footer.dart';
import 'hotel_detail_guide.dart';
import 'hotel_description_section.dart';
import 'hotel_detail_photo_gallery.dart';
import 'hotel_detail_room_card.dart';
import 'hotel_detail_selection_summary.dart';
import 'hotel_detail_stay_summary_bar.dart';
import 'hotel_room_detail_sheet.dart';

class HotelDetailRedesignContent extends StatelessWidget {
  const HotelDetailRedesignContent({
    super.key,
    required this.detail,
    required this.criteria,
    required this.selection,
    required this.onDates,
    required this.onGuests,
    required this.onBook,
    required this.openingConfirmation,
    required this.membershipFailed,
    required this.onMembershipRetry,
    this.tier,
    this.account,
  });
  final HotelDetail detail;
  final HotelSearchCriteria criteria;
  final HotelDetailSelectionController selection;
  final HostMilesTier? tier;
  final HostMilesAccount? account;
  final bool membershipFailed;
  final bool openingConfirmation;
  final VoidCallback onDates, onGuests, onBook, onMembershipRetry;
  @override
  Widget build(BuildContext c) {
    final miles = selection.mode == HotelBookingMode.hostMiles;
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(c).toLanguageTag(),
    );
    final roomLimit = miles ? tier?.remainingBookingRooms : null;
    final balance = account?.availablePoints ?? tier?.pointsBalance;
    final extraGuestsByRoom = {
      for (final row
          in selection.assignment?.roomTypeExtraGuestPrices ??
              const <HotelRoomTypeExtraGuestPrice>[])
        if (row.extraGuestCount > 0) row.roomTypeId: row,
    };
    return Column(
      children: [
        Expanded(
          child: ColoredBox(
            color: c.appColors.surface,
            child: ListView(
              children: [
                HotelDetailPhotoGallery(images: detail.images),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (detail.address.isNotEmpty)
                        Text(
                          detail.address,
                          style: HotelDetailStyles.caption(
                            c,
                          ).copyWith(color: c.appColors.primary),
                        ),
                      const SizedBox(height: 12),
                      Text(detail.name, style: HotelDetailStyles.title(c)),
                      if (detail.tags.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            for (final tag in detail.tags)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: c.appColors.background,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  tag,
                                  style: HotelDetailStyles.spec(c),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HotelDescriptionSection(detail: detail),
                      if (detail.checkInMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            hotelDetailPlainText(detail.checkInMessage),
                            style: HotelDetailStyles.body(c),
                          ),
                        ),
                      if (miles &&
                          (tier?.leadTimeMonths != null ||
                              membershipFailed)) ...[
                        if (tier?.leadTimeMonths case final months?)
                          Text(
                            c.l10n.hotelMilesAdvanceMonths(months),
                            style: HotelDetailStyles.roomMetadata(c).copyWith(
                              color: c.appColors.primary,
                            ),
                          ),
                        if (membershipFailed)
                          TextButton(
                            onPressed: onMembershipRetry,
                            child: Text(c.l10n.commonRetry),
                          ),
                        const SizedBox(height: 20),
                      ],
                      HotelDetailStaySummaryBar(
                        flat: true,
                        showRoomCount: !miles,
                        criteria: criteria,
                        presenter: presenter,
                        onDatesTap: openingConfirmation ? null : onDates,
                        onGuestsTap: openingConfirmation ? null : onGuests,
                      ),
                      const SizedBox(height: 16),
                      Semantics(
                        header: true,
                        child: Text(
                          c.l10n.hotelDetailAvailableRooms,
                          textAlign: TextAlign.start,
                          style: HotelDetailStyles.label(
                            c,
                          ).copyWith(color: c.appColors.primary),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (miles && roomLimit != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '${c.l10n.hotelDetailEstimatedRooms}  ${c.l10n.hotelMilesRoomValue(selection.remainingAllowance(roomLimit)!)}',
                            style: HotelDetailStyles.caption(c),
                          ),
                        ),
                      if (detail.roomPlans.isEmpty)
                        Text(c.l10n.hotelDetailNoRooms),
                      for (
                        var index = 0;
                        index < detail.roomPlans.length;
                        index++
                      )
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: HotelDetailRoomCard(
                            room: detail.roomPlans[index],
                            quantity: selection.quantities[index] ?? 0,
                            remaining: miles
                                ? selection.additionalRooms(
                                    index,
                                    roomLimit: roomLimit,
                                  )
                                : null,
                            allowanceExhausted:
                                miles &&
                                selection.remainingAllowance(roomLimit) == 0,
                            extraGuests:
                                extraGuestsByRoom[detail.roomPlans[index].id],
                            shortfall: selection.milesShortfall(index, balance),
                            nights: criteria.nights,
                            miles: miles,
                            onDetails: () => showHotelRoomDetailSheet(
                              context: c,
                              detail: detail,
                              room: detail.roomPlans[index],
                            ),
                            onMinus:
                                selection.busy ||
                                    openingConfirmation ||
                                    (selection.quantities[index] ?? 0) == 0
                                ? null
                                : () => selection.change(
                                    index,
                                    (selection.quantities[index] ?? 0) - 1,
                                  ),
                            onPlus:
                                openingConfirmation ||
                                    !selection.canAdd(
                                      index,
                                      roomLimit: roomLimit,
                                      balance: balance,
                                    )
                                ? null
                                : () => selection.change(
                                    index,
                                    (selection.quantities[index] ?? 0) + 1,
                                    roomLimit: roomLimit,
                                    balance: balance,
                                  ),
                          ),
                        ),
                      HotelDetailSelectionSummary(
                        selection: selection,
                        tier: tier,
                        account: account,
                      ),
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
                HotelDetailGuide(detail: detail),
                const HotelBookingServiceFooter(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        HotelDetailReservationPanel(
          selection: selection,
          onBook: onBook,
          busy: openingConfirmation,
        ),
      ],
    );
  }
}
