import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '../../../../app/localization/app_localizations_ext.dart';

String hotelReferenceMilesLabel(
  BuildContext context,
  num points, {
  bool starting = false,
}) {
  final value = NumberFormat.decimalPattern(
    Localizations.localeOf(context).toLanguageTag(),
  ).format(points);
  return starting
      ? context.l10n.hotelMilesReferenceStayFrom(value)
      : context.l10n.hotelMilesReferenceStay(value);
}
