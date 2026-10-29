import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class HotelRemainingRoomsLabel extends StatelessWidget {
  const HotelRemainingRoomsLabel({
    super.key,
    required this.count,
    this.unit = HotelRemainingUnit.room,
    this.textAlign = TextAlign.start,
    this.color,
  });

  final int count;
  final HotelRemainingUnit unit;
  final TextAlign textAlign;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final textColor =
        color ?? (count < 5 ? colors.danger : colors.brandSecondary);
    return Text(
      _label(context),
      textAlign: textAlign,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  String _label(BuildContext context) {
    if (count <= 0) {
      return context.l10n.hotelNoRooms;
    }
    return switch (unit) {
      HotelRemainingUnit.room => _roomLabel(context),
      HotelRemainingUnit.building => _buildingLabel(context),
    };
  }

  String _roomLabel(BuildContext context) {
    if (count < 5) {
      return context.l10n.hotelRemainingRoomsFew(count);
    }
    return context.l10n.hotelRemainingRoomsMany;
  }

  String _buildingLabel(BuildContext context) {
    if (count < 5) {
      return context.l10n.hotelRemainingBuildingsFew(count);
    }
    return context.l10n.hotelRemainingBuildingsMany;
  }
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
