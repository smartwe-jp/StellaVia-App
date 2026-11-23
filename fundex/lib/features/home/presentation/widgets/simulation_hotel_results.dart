import 'dart:math' as math;

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../pages/simulation_hotels_page.dart';
import 'simulation_hotel_card.dart';
import '../providers/simulation_hotels_provider.dart';
import 'home_data_status.dart';

class SimulationHotelResults extends ConsumerWidget {
  const SimulationHotelResults({super.key, required this.points});
  final int points;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = simulationHotelsProvider(points);
    final hotels = ref.watch(provider);
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.simPointsHotelsTitle, style: context.appTextTheme.sectionTitle),
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
              : LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 12,
                      children: [
                        for (final hotel in items.take(6))
                          SizedBox(
                            width: math.min(320.0, constraints.maxWidth * .9),
                            child: SimulationHotelCard(
                              hotel: hotel,
                              points: points,
                            ),
                          ),
                        AppButton(
                          variant: AppButtonVariant.secondary,
                          fullWidth: false,
                          onPressed: () => Navigator.of(context).push<void>(
                            MaterialPageRoute(
                              builder: (_) => SimulationHotelsPage(
                                hotels: items,
                                points: points,
                              ),
                            ),
                          ),
                          label: l.homeShowMoreAction,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
