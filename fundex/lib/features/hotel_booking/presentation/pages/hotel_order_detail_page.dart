import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/hotel_booking_providers.dart';
import '../support/hotel_booking_presenter.dart';
import '../support/hotel_order_cancel_flow.dart';
import '../support/hotel_payment_route_args.dart';
import '../widgets/hotel_order_detail_widgets.dart';
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
                onMore: () => AppNotice.show(
                  context,
                  message: context.l10n.hotelOrderDetailMoreComingSoon,
                ),
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
}
