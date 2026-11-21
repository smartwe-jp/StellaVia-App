import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../hotel_booking/domain/entities/hotel_models.dart';
import '../../../hotel_booking/presentation/support/hotel_detail_route_args.dart';
import '../providers/simulation_hotels_provider.dart';
import 'home_data_status.dart';

class SimulationHotelResults extends ConsumerWidget {
  const SimulationHotelResults({super.key, required this.points});
  final int points;

  void _open(BuildContext context, PointsHotel hotel) {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = simulationHotelsProvider(points);
    final hotels = ref.watch(provider);
    final l = context.l10n;
    final format = NumberFormat.decimalPattern(
      Localizations.localeOf(context).toLanguageTag(),
    );
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.simPointsHotelsTitle,
            style: context.appTextTheme.sectionTitle,
          ),
          const SizedBox(height: 8),
          hotels.when(
            skipLoadingOnRefresh: false,
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => HomeDataStatus(
              isLoading: false,
              hasError: true,
              onRetry: () => ref.invalidate(provider),
            ),
            data: (items) => items.isEmpty
                ? Text(l.simPointsHotelsEmpty)
                : Column(
                    children: [
                      for (final hotel in items)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            hotel.name.isEmpty
                                ? l.hotelUnnamedProperty
                                : hotel.name,
                          ),
                          subtitle: Text(
                            l.simPointsHotelStay(
                              format.format(hotel.nightlyPoints),
                              points ~/ hotel.nightlyPoints,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _open(context, hotel),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
