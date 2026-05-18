import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class HotelRemainingRoomsLabel extends StatelessWidget {
  const HotelRemainingRoomsLabel({
    super.key,
    required this.count,
    this.textAlign = TextAlign.start,
  });

  final int count;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final textColor = count < 5 ? colors.danger : colors.brandSecondary;
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
    if (count < 5) {
      return context.l10n.hotelRemainingRoomsFew(count);
    }
    return context.l10n.hotelRemainingRoomsMany;
  }
}
