import '../entities/hotel_models.dart';

abstract class HotelBookingRepository {
  Future<HotelSearchResult> searchHotels({
    required HotelSearchCriteria criteria,
    required String languageCode,
    int page = 1,
    int limit = 20,
  });

  Future<List<HotelBuildingFilter>> fetchBuildingFilters({
    required String languageCode,
  });

  Future<HotelDetail> fetchHotelDetail({
    required String hotelId,
    required HotelSearchCriteria criteria,
    required String languageCode,
  });

  Future<HotelAssignOccupancyResult> assignOccupancy({
    required String hotelId,
    required HotelSearchCriteria criteria,
    required List<HotelSelectedRoom> selectedRooms,
    required String languageCode,
  });

  Future<HotelBookingPreparation> fetchBookingPreparation({
    required HotelBookingConfirmSeed seed,
    required String languageCode,
  });

  Future<String> createBooking(HotelBookingCreateDraft draft);

  Future<HotelOrderListResult> fetchOrderList({
    required String languageCode,
    required HotelOrderStatusFilter status,
    int page = 1,
    int limit = 5,
  });

  Future<HotelOrderDetail> fetchOrderDetail({
    required String languageCode,
    required String orderId,
  });

  Future<String> requestOrderInvoice({
    required String orderId,
    required String receiptTitle,
    required String email,
  });

  Future<HotelOrderCancelRule> fetchCancelOrderRule({
    required String languageCode,
    required String orderId,
  });

  Future<String> cancelOrder({
    required String languageCode,
    required String orderId,
  });

  Future<HotelMemberProfile> fetchMemberProfile();

  Future<void> updateMemberProfile(HotelMemberProfile profile);

  Future<List<HotelCreditCard>> fetchRegisteredCreditCards();

  Future<String> registerCreditCard(HotelCreditCardRegistrationDraft draft);

  Future<String> unregisterCreditCard(String cardId);

  Future<HotelCreditCardPaymentResult> payWithCreditCardToken({
    required HotelCreditCardRegistrationDraft draft,
    required bool saveCard,
  });

  Future<HotelCreditCardPaymentResult> payWithRegisteredCreditCard({
    required String cardId,
    required String orderId,
  });
}
