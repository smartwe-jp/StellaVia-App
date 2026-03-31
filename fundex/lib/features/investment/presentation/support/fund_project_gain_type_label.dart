import 'package:flutter/widgets.dart';

import '../../../../app/localization/app_localizations_ext.dart';

String resolveFundProjectGainTypeLabel(BuildContext context, String? gainType) {
  final l10n = context.l10n;
  switch (gainType?.trim().toUpperCase()) {
    case 'INCOME_GAIN':
      return l10n.fundListGainTypeIncomeGain;
    case 'CAPITAL_GAIN':
      return l10n.fundListGainTypeCapitalGain;
    case 'MIXED':
      return l10n.fundListGainTypeMixed;
    default:
      return l10n.fundListMethodUnknown;
  }
}
