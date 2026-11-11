import 'package:flutter/material.dart';
import 'package:core_ui_kit/core_ui_kit.dart';

import '../../../../app/localization/app_localizations_ext.dart';

import '../support/hotel_vacancy_theme.dart';

class HotelRemainingRoomsLabel extends StatelessWidget {
  const HotelRemainingRoomsLabel({
    super.key,
    required this.count,
    this.unit = HotelRemainingUnit.room,
    this.textAlign = TextAlign.start,
    this.showFullBadge = true,
  });

  final int count;
  final bool showFullBadge;
  final HotelRemainingUnit unit;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    if (count == 0 && showFullBadge) return const HotelFullBadge();
    if (count < 0) return const SizedBox.shrink();
    return Text(
      _label(context),
      textAlign: textAlign,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: HotelVacancyTheme.textColor(context, count),
        fontWeight: FontWeight.w900,
      ),
    );
  }

  String _label(BuildContext context) {
    return switch (unit) {
      HotelRemainingUnit.room => context.l10n.hotelDetailRemainingRoomsShort(
        count,
      ),
      HotelRemainingUnit.building => context.l10n.hotelRemainingBuildingsFew(
        count,
      ),
    };
  }
}

class HotelFullBadge extends StatelessWidget {
  const HotelFullBadge({super.key});

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(
      color: context.appColors.surfaceAlt,
      shape: const StadiumBorder(),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Text(
        context.l10n.hotelDetailNoVacancy,
        style: context.appTextTheme.chip.copyWith(
          color: context.appColors.primary,
        ),
      ),
    ),
  );
}

enum HotelRemainingUnit { room, building }

HotelRemainingUnit hotelRemainingUnitForBuildingCode(String? buildingCode) {
  return switch (buildingCode?.trim()) {
    '02' || '03' => HotelRemainingUnit.building,
    _ => HotelRemainingUnit.room,
  };
}

HotelRemainingUnit hotelRemainingUnitForHotelSummary({String? buildingCode}) {
  return hotelRemainingUnitForBuildingCode(buildingCode);
}

String hotelBuildingTypeLabelForCode(
  BuildContext context,
  String? buildingCode,
) {
  return switch (buildingCode?.trim()) {
    '01' => context.l10n.hotelBuildingTypeApartment,
    '02' => context.l10n.hotelBuildingTypeMachiya,
    '03' => context.l10n.hotelBuildingTypeTownhouse,
    _ => '',
  };
}
