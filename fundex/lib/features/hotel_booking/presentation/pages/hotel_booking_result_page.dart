import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/status_bar/app_status_bar_providers.dart';
import '../support/hotel_booking_presenter.dart';
import '../support/hotel_booking_result_route_args.dart';
import '../support/hotel_payment_route_args.dart';
import '../widgets/hotel_booking_result_card.dart';
import '../widgets/hotel_status_bar_preference_scope.dart';

class HotelBookingResultPage extends StatelessWidget {
  const HotelBookingResultPage({super.key, required this.args});

  final HotelBookingResultRouteArgs args;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(context).toLanguageTag(),
    );
    final statusBarHint = ProviderScope.containerOf(
      context,
    ).read(appImmersiveHotelStatusBarHintProvider.notifier);
    void goToHotelRoot() {
      statusBarHint.state = true;
      context.go('/hotel-booking');
    }

    void goToOrders() {
      statusBarHint.state = false;
      context.go('/hotel-booking/orders');
    }

    return HotelStatusBarPreferenceScope(
      immersive: false,
      immersiveOnPop: true,
      child: Scaffold(
        backgroundColor: colors.surfaceAlt,
        body: SafeArea(
          bottom: false,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              HotelBookingResultHero(
                title: context.l10n.hotelBookingResultTitle,
                createdAt: args.createdAt,
                onClose: goToHotelRoot,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 32, 18, 34),
                child: Column(
                  children: <Widget>[
                    HotelBookingResultCard(
                      orderId: args.orderId,
                      totalAmount: args.totalAmount,
                      paymentMethod: args.paymentMethod,
                      presenter: presenter,
                    ),
                    const SizedBox(height: 28),
                    HotelBookingResultActions(
                      onPay: () => context.push(
                        '/hotel-booking/payment',
                        extra: HotelPaymentRouteArgs(
                          orderId: args.orderId,
                          totalAmount: args.totalAmount,
                          initialPaymentMethod: args.paymentMethod,
                        ),
                      ),
                      onBackToOrders: () {
                        goToOrders();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
