import '../widgets/hotel_booking_payment_section.dart';

class HotelPaymentRouteArgs {
  const HotelPaymentRouteArgs({
    required this.orderId,
    required this.totalAmount,
    required this.initialPaymentMethod,
    this.redirectToOrderDetailOnSuccess = true,
  });

  final String orderId;
  final num totalAmount;
  final HotelBookingPaymentMethod initialPaymentMethod;
  final bool redirectToOrderDetailOnSuccess;
}
