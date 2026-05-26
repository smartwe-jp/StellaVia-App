import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/status_bar/app_status_bar_providers.dart';
import '../support/hotel_booking_presenter.dart';
import '../support/hotel_booking_result_route_args.dart';
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
    return HotelStatusBarPreferenceScope(
      immersive: false,
      immersiveOnPop: true,
      child: Scaffold(
        backgroundColor: colors.surfaceAlt,
        appBar: AppNavigationBar(
          title: context.l10n.hotelBookingResultAppBarTitle,
          backgroundColor: colors.surface,
          foregroundColor: colors.textPrimary,
          leading: AppNavigationIconButton(
            icon: Icons.close_rounded,
            onTap: () {
              ProviderScope.containerOf(context)
                      .read(appImmersiveHotelStatusBarHintProvider.notifier)
                      .state =
                  true;
              context.go('/hotel-booking');
            },
            backgroundColor: colors.surface.withValues(alpha: 0),
            foregroundColor: colors.textPrimary,
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 28, 18, 28),
            children: <Widget>[
              Text(
                context.l10n.hotelBookingResultTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colors.brandAlert,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 26),
              HotelBookingResultCard(
                orderId: args.orderId,
                totalAmount: args.totalAmount,
                paymentMethod: args.paymentMethod,
                presenter: presenter,
                onBackToOrders: () {
                  ProviderScope.containerOf(context)
                          .read(appImmersiveHotelStatusBarHintProvider.notifier)
                          .state =
                      true;
                  context.go('/hotel-booking');
                },
                onPay: () => AppNotice.show(
                  context,
                  message: context.l10n.hotelPaymentComingSoon,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
