import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../hotel_booking/domain/entities/hotel_models.dart';
import '../../../hotel_booking/presentation/support/hotel_detail_route_args.dart';
import '../../../hotel_booking/presentation/widgets/hotel_property_card.dart';

class SimulationHotelCard extends StatelessWidget {
  const SimulationHotelCard({
    super.key,
    required this.hotel,
    required this.points,
  });
  final PointsHotel hotel;
  final int points;

  void _open(BuildContext context) {
    final start = hotel.referenceCheckIn;
    final end = hotel.referenceCheckOut;
    final criteria = start != null && end != null && end.isAfter(start)
        ? HotelSearchCriteria(checkInDate: start, checkOutDate: end)
        : HotelSearchCriteria.initial(DateTime.now());
    context.push(
      '/hotel-booking/${Uri.encodeComponent(hotel.id)}',
      extra: HotelDetailRouteArgs(
        criteria: criteria,
        buildingCode: hotel.buildingCode,
        mode: HotelBookingMode.hostMiles,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat.decimalPattern(
      Localizations.localeOf(context).toLanguageTag(),
    );
    return HotelPropertyCard(
      name: hotel.name,
      location: hotel.location,
      imageUrl: hotel.imageUrl,
      onTap: () => _open(context),
      details: [
        const Divider(height: 12),
        Text(
          context.l10n.simPointsHotelStay(
            format.format(hotel.nightlyPoints),
            points ~/ hotel.nightlyPoints,
          ),
          style: context.appTextTheme.body,
        ),
      ],
    );
  }
}
