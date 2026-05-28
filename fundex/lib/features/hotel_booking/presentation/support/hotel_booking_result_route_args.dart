import '../../domain/entities/hotel_models.dart';
import '../widgets/hotel_booking_payment_section.dart';

class HotelBookingResultRouteArgs {
  const HotelBookingResultRouteArgs({
    required this.orderId,
    required this.seed,
    required this.totalAmount,
    required this.paymentMethod,
    required this.createdAt,
  });

  final String orderId;
  final HotelBookingConfirmSeed seed;
  final num totalAmount;
  final HotelBookingPaymentMethod paymentMethod;
  final String createdAt;
}
