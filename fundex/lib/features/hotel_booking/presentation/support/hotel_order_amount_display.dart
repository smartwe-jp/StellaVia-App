import 'package:flutter/widgets.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import 'hotel_booking_presenter.dart';

({String label, String value, bool usesMiles}) hotelOrderAmountDisplay(
  BuildContext context,
  HotelBookingPresenter presenter, {
  required num? mile,
  required num? totalAmount,
  required String priceLabel,
}) {
  if (mile != null && mile.isFinite && mile > 0) {
    return (
      label: context.l10n.myPageChartMiles,
      value: context.l10n.hotelMilesReferenceStay(presenter.amount(mile)),
      usesMiles: true,
    );
  }
  return (
    label: priceLabel,
    value: presenter.price(totalAmount),
    usesMiles: false,
  );
}
