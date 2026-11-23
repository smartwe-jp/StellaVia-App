import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../hotel_booking/domain/entities/hotel_models.dart';
import '../widgets/simulation_hotel_card.dart';

class SimulationHotelsPage extends StatelessWidget {
  const SimulationHotelsPage({
    super.key,
    required this.hotels,
    required this.points,
  });
  final List<PointsHotel> hotels;
  final int points;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppNavigationBar(
      title: context.l10n.simPointsHotelsTitle,
      leading: BackButton(onPressed: () => Navigator.of(context).pop()),
    ),
    body: SafeArea(
      top: false,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: hotels.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, index) =>
            SimulationHotelCard(hotel: hotels[index], points: points),
      ),
    ),
  );
}
