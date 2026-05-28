import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../providers/hotel_booking_providers.dart';
import '../widgets/hotel_booking_payment_section.dart';
import '../widgets/hotel_credit_card_picker_sheet.dart';

enum HotelCreditCardSecureResult { success, failure }

Future<void> runHotelCreditCardPaymentFlow({
  required BuildContext context,
  required WidgetRef ref,
  required String orderId,
  HotelBookingPaymentMethod paymentMethod =
      HotelBookingPaymentMethod.creditCard,
  HotelCreditCard? selectedCard,
  VoidCallback? onSuccess,
}) async {
  if (paymentMethod != HotelBookingPaymentMethod.creditCard) {
    AppNotice.show(context, message: context.l10n.hotelPaymentComingSoon);
    return;
  }

  final HotelCreditCard? card;
  if (selectedCard != null) {
    card = selectedCard;
  } else {
    final List<HotelCreditCard> cards;
    try {
      cards = await ref.read(hotelCreditCardsProvider.future);
    } catch (_) {
      if (context.mounted) {
        AppNotice.show(
          context,
          message: context.l10n.hotelPaymentCreditCardFailed,
        );
      }
      return;
    }
    if (!context.mounted) {
      return;
    }
    if (cards.isEmpty) {
      AppNotice.show(context, message: context.l10n.hotelPaymentNoCreditCard);
      return;
    }
    card = await _selectCard(context, cards);
  }
  if (!context.mounted || card == null) {
    return;
  }

  final HotelCreditCardPaymentResult result;
  try {
    result = await ref.read(payHotelOrderWithRegisteredCardUseCaseProvider)(
      cardId: card.id,
      orderId: orderId,
    );
  } catch (_) {
    if (context.mounted) {
      AppNotice.show(
        context,
        message: context.l10n.hotelPaymentCreditCardFailed,
      );
    }
    return;
  }
  if (!context.mounted) {
    return;
  }
  if (!result.pay || result.secureUrl.isEmpty) {
    AppNotice.show(context, message: context.l10n.hotelPaymentCreditCardFailed);
    return;
  }

  final secureResult = await openAppWebViewer<HotelCreditCardSecureResult>(
    context,
    url: result.secureUrl,
    title: context.l10n.hotelPaymentSecureTitle,
    texts: AppWebViewerTexts(
      pageTitle: context.l10n.hotelPaymentSecureTitle,
      loadingLabel: context.l10n.webViewerLoadingLabel,
      loadFailedLabel: context.l10n.webViewerLoadFailedLabel,
      retryLabel: context.l10n.commonRetry,
      invalidUrlNotice: context.l10n.webViewerInvalidUrlNotice,
    ),
    onPageFinishedResult: _secureResultFromUri,
    onExitRequested: _confirmPendingPaymentExit,
  );
  if (!context.mounted) {
    return;
  }
  if (secureResult == HotelCreditCardSecureResult.success) {
    ref.invalidate(hotelOrderDetailProvider(orderId));
    ref.invalidate(hotelOrderListControllerProvider);
    AppNotice.show(
      context,
      message: context.l10n.hotelPaymentCreditCardSuccess,
    );
    onSuccess?.call();
    return;
  }
  if (secureResult == HotelCreditCardSecureResult.failure) {
    AppNotice.show(context, message: context.l10n.hotelPaymentCreditCardFailed);
  }
}

Future<bool> _confirmPendingPaymentExit(BuildContext context) async {
  final l10n = context.l10n;
  final result = await AppDialogs.showAdaptiveAlert<bool>(
    context: context,
    title: l10n.hotelPaymentExitTitle,
    message: l10n.hotelPaymentExitMessage,
    barrierDismissible: false,
    actions: <AppDialogAction<bool>>[
      AppDialogAction<bool>(label: l10n.commonCancel, value: false),
      AppDialogAction<bool>(
        label: l10n.hotelPaymentExitConfirm,
        value: true,
        isDestructive: true,
      ),
    ],
  );
  return result == true;
}

Future<HotelCreditCard?> _selectCard(
  BuildContext context,
  List<HotelCreditCard> cards,
) {
  if (cards.length == 1) {
    return Future<HotelCreditCard?>.value(cards.single);
  }
  return showHotelCreditCardPickerSheet(context: context, cards: cards);
}

HotelCreditCardSecureResult? _secureResultFromUri(Uri uri) {
  final value = uri.toString();
  if (value.contains('paysuccess')) {
    return HotelCreditCardSecureResult.success;
  }
  if (value.contains('payfailed')) {
    return HotelCreditCardSecureResult.failure;
  }
  return null;
}

void goToHotelOrderDetail(BuildContext context, String orderId) {
  context.go('/hotel-booking/orders/${Uri.encodeComponent(orderId)}');
}
