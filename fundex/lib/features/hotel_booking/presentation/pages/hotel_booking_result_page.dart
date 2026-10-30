import 'package:flutter/material.dart';
import 'package:fundex/features/hotel_booking/presentation/widgets/hotel_booking_service_footer.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../support/hotel_booking_presenter.dart';
import '../support/hotel_booking_result_route_args.dart';
import '../support/hotel_payment_route_args.dart';
import '../widgets/hotel_booking_result_card.dart';

class HotelBookingResultPage extends StatelessWidget {
  const HotelBookingResultPage({super.key, required this.args});

  final HotelBookingResultRouteArgs args;

  @override
  Widget build(BuildContext context) {
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(context).toLanguageTag(),
    );
    final isStayBenefitBooking =
        args.paymentMethod == null && args.seed.criteria.stayBenefit;
    void goToHotelRoot() {
      context.go('/hotel-booking');
    }

    void goToOrders() {
      context.go('/hotel-booking/orders');
    }

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            HotelBookingResultHero(
              title: isStayBenefitBooking
                  ? context.l10n.hotelBookingResultSuccessTitle
                  : context.l10n.hotelBookingResultTitle,
              createdAt: args.createdAt,
              showCountdown: !isStayBenefitBooking,
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
                    isStayBenefitBooking: isStayBenefitBooking,
                  ),
                  const SizedBox(height: 28),
                  HotelBookingResultActions(
                    onPay: args.paymentMethod == null
                        ? null
                        : () => context.push(
                            '/hotel-booking/payment',
                            extra: HotelPaymentRouteArgs(
                              orderId: args.orderId,
                              totalAmount: args.totalAmount,
                              initialPaymentMethod: args.paymentMethod!,
                            ),
                          ),
                    onBackToOrders: () {
                      goToOrders();
                    },
                  ),
                  const SizedBox(height: 18),
                  const HotelBookingServiceFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
