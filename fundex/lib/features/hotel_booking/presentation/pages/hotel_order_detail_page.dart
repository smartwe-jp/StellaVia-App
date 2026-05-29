import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../providers/hotel_booking_providers.dart';
import '../support/hotel_booking_presenter.dart';
import '../support/hotel_order_cancel_flow.dart';
import '../support/hotel_payment_route_args.dart';
import '../widgets/hotel_order_detail_widgets.dart';
import '../widgets/hotel_order_invoice_sheet.dart';
import '../widgets/hotel_payment_method_widgets.dart';
import '../widgets/hotel_state_views.dart';
import '../widgets/hotel_status_bar_preference_scope.dart';

class HotelOrderDetailPage extends ConsumerStatefulWidget {
  const HotelOrderDetailPage({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<HotelOrderDetailPage> createState() =>
      _HotelOrderDetailPageState();
}

class _HotelOrderDetailPageState extends ConsumerState<HotelOrderDetailPage> {
  bool _paymentExpired = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final detailState = ref.watch(hotelOrderDetailProvider(widget.orderId));
    final languageCode = ref.watch(hotelLocaleLanguageCodeProvider);
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(context).toLanguageTag(),
    );

    return HotelStatusBarPreferenceScope(
      immersive: false,
      child: Scaffold(
        backgroundColor: colors.surfaceAlt,
        body: SafeArea(
          top: true,
          bottom: false,
          child: detailState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => HotelFullPageError(
              onRetry: () =>
                  ref.invalidate(hotelOrderDetailProvider(widget.orderId)),
            ),
            data: (detail) {
              return HotelOrderDetailContent(
                detail: detail,
                presenter: presenter,
                paymentExpired: _paymentExpired,
                onBack: () {
                  if (context.canPop()) {
                    context.pop();
                    return;
                  }
                  context.go('/hotel-booking/orders');
                },
                onMore: (moreButtonContext) =>
                    _handleMoreTap(moreButtonContext, detail),
                onPay: () async {
                  final paid = await context.push<bool>(
                    '/hotel-booking/payment',
                    extra: HotelPaymentRouteArgs(
                      orderId: widget.orderId,
                      totalAmount: detail.summary.totalAmount ?? 0,
                      initialPaymentMethod: hotelPaymentMethodFromCode(
                        detail.payCode,
                      ),
                      redirectToOrderDetailOnSuccess: false,
                    ),
                  );
                  if (paid == true) {
                    ref.invalidate(hotelOrderDetailProvider(widget.orderId));
                  }
                },
                onCancel: () => runHotelOrderCancelFlow(
                  context: context,
                  ref: ref,
                  languageCode: languageCode,
                  orderId: widget.orderId,
                  onCancelled: () async {
                    if (_paymentExpired) {
                      setState(() => _paymentExpired = false);
                    }
                    ref.invalidate(hotelOrderDetailProvider(widget.orderId));
                  },
                ),
                onPaymentCountdownExpired: () {
                  if (!_paymentExpired) {
                    setState(() => _paymentExpired = true);
                  }
                  Future<void>.delayed(const Duration(seconds: 3), () {
                    if (!mounted) {
                      return;
                    }
                    ref.invalidate(hotelOrderDetailProvider(widget.orderId));
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _handleMoreTap(
    BuildContext moreButtonContext,
    HotelOrderDetail detail,
  ) async {
    final action = await _showMorePopupMenu(moreButtonContext);
    if (!mounted || action == null) {
      return;
    }
    switch (action) {
      case HotelOrderDetailMoreAction.invoice:
        await _handleInvoiceTap(detail);
    }
  }

  Future<void> _handleInvoiceTap(HotelOrderDetail detail) async {
    final formData = await showHotelOrderInvoiceSheet(
      context: context,
      initialReceiptTitle: detail.receiptTitle.isNotEmpty
          ? detail.receiptTitle
          : detail.guestName,
      initialEmail: detail.contactEmail,
    );
    if (!mounted || formData == null) {
      return;
    }
    final l10n = context.l10n;
    try {
      final message = await AppLoadingDialog.run(
        context,
        () => ref.read(requestHotelOrderInvoiceUseCaseProvider)(
          orderId: widget.orderId,
          receiptTitle: formData.receiptTitle,
          email: formData.email,
        ),
        message: l10n.commonPleaseWait,
      );
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: message.trim().isEmpty
            ? l10n.hotelOrderInvoiceRequested
            : message,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: _invoiceErrorMessage(error, l10n.hotelOrderInvoiceFailed),
      );
    }
  }
}

String _invoiceErrorMessage(Object error, String fallbackMessage) {
  if (error is StateError) {
    final message = error.message.trim();
    if (message.isNotEmpty) {
      return message;
    }
  }
  return fallbackMessage;
}

Future<HotelOrderDetailMoreAction?> _showMorePopupMenu(
  BuildContext anchorContext,
) {
  final renderObject = anchorContext.findRenderObject();
  final overlay = Overlay.of(anchorContext).context.findRenderObject();
  if (renderObject is! RenderBox || overlay is! RenderBox) {
    return Future<HotelOrderDetailMoreAction?>.value(null);
  }
  final colors = Theme.of(anchorContext).appColors;
  final buttonOffset = renderObject.localToGlobal(
    Offset.zero,
    ancestor: overlay,
  );
  final buttonRect = buttonOffset & renderObject.size;
  return showMenu<HotelOrderDetailMoreAction>(
    context: anchorContext,
    position: RelativeRect.fromRect(
      Rect.fromLTWH(buttonRect.right - 180, buttonRect.bottom + 8, 180, 48),
      Offset.zero & overlay.size,
    ),
    color: colors.surface,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(UiTokens.radius12),
      side: BorderSide(color: colors.borderSoft),
    ),
    items: <PopupMenuEntry<HotelOrderDetailMoreAction>>[
      PopupMenuItem<HotelOrderDetailMoreAction>(
        value: HotelOrderDetailMoreAction.invoice,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.receipt_long_rounded,
              size: 20,
              color: colors.brandPrimaryDark,
            ),
            const SizedBox(width: 10),
            Text(
              anchorContext.l10n.hotelOrderDetailReceiptTitle,
              style: Theme.of(anchorContext).textTheme.bodyMedium?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
