import 'package:flutter/widgets.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/support/app_request_error_message_resolver.dart';
import '../controllers/hotel_detail_selection_controller.dart';

String hotelQuoteStatus(
  BuildContext context,
  HotelDetailSelectionController selection,
) {
  final l = context.l10n;
  if (selection.busy) {
    return selection.stage == HotelQuoteStage.assigning
        ? l.hotelQuoteAssigning
        : l.hotelQuoteCalculating;
  }
  if (selection.error == HotelQuoteIssue.missingPoints) {
    return l.hotelDetailMilesUnavailable;
  }
  final fallback = selection.failedStage == HotelQuoteStage.quoting
      ? l.hotelQuoteFailed
      : l.hotelAssignOccupancyFailed;
  if (selection.error == null || selection.error is HotelQuoteIssue) {
    return fallback;
  }
  return resolveAppRequestErrorMessage(selection.error!, fallback);
}
