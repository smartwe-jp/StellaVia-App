import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_detail_route_args.dart';

class HotelRegularBookingButton extends StatelessWidget {
  const HotelRegularBookingButton({
    super.key,
    required this.hotelId,
    required this.criteria,
    this.enabled = true,
  });

  final String hotelId;
  final HotelSearchCriteria criteria;
  final bool enabled;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: enabled
        ? () => context.push(
            '/hotel-booking/${Uri.encodeComponent(hotelId)}',
            extra: HotelDetailRouteArgs(
              criteria: criteria.copyWith(stayBenefit: false),
              buildingCode: criteria.buildingCode ?? '',
            ),
          )
        : null,
    child: Text(context.l10n.hotelBookWithoutMiles),
  );
}
