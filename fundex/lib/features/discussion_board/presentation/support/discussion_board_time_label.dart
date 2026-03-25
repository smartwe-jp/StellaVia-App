import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';

String buildDiscussionBoardTimeLabel(
  BuildContext context, {
  required String createdAtIso,
  required String fallbackLabel,
}) {
  final parsed = DateTime.tryParse(createdAtIso);
  if (parsed == null) {
    return fallbackLabel;
  }

  final local = parsed.toLocal();
  final now = DateTime.now();
  final difference = now.difference(local);
  if (difference.isNegative) {
    return DateFormat('yyyy/MM/dd', Localizations.localeOf(context).toLanguageTag())
        .format(local);
  }

  final l10n = AppLocalizations.of(context);
  if (difference < const Duration(hours: 1)) {
    final minutes = difference.inMinutes <= 0 ? 1 : difference.inMinutes;
    return l10n.kizunarkTimeMinutesAgo(minutes);
  }
  if (difference < const Duration(days: 1)) {
    final hours = difference.inHours <= 0 ? 1 : difference.inHours;
    return l10n.kizunarkTimeHoursAgo(hours);
  }
  return DateFormat(
    'yyyy/MM/dd',
    Localizations.localeOf(context).toLanguageTag(),
  ).format(local);
}
