import '../entities/hotel_models.dart';

abstract class HotelBookingRepository {
  Future<List<PointsHotel>> searchHotelsByPoints(int points);

  Future<HotelSearchResult> searchHotels({
    required HotelSearchCriteria criteria,
    required String languageCode,
    int page = 1,
    int limit = 20,
  });

  Future<List<HotelBuildingFilter>> fetchBuildingFilters({
    required String languageCode,
  });

  Future<List<HotelStayBenefitPeriod>> fetchStayBenefitPeriods();

  Future<List<HotelStayBenefitPeriod>> fetchStayBenefitPeriodsForHotel({
    required String hotelId,
  });

  Future<HotelPriceDiscount> fetchPriceDiscount({
    required String hotelId,
    required HotelSearchCriteria criteria,
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

  Future<HotelBookingQuote> quoteBookingPrice(HotelBookingQuoteRequest request);

  Future<HotelCouponListResult> fetchCoupons({required String languageCode});

  Future<List<HotelFundBenefitTicket>> fetchFundBenefitTickets();

  Future<List<HotelMemberContact>> fetchMemberContacts({
    required String languageCode,
  });

  Future<List<HotelCountryCode>> fetchCountryCodes({
    required String languageCode,
  });

  Future<void> saveMemberContact(HotelMemberContactDraft draft);

  Future<void> deleteMemberContact({required String id});

  Future<String> createBooking(HotelBookingCreateDraft draft);

  Future<HotelOrderListResult> fetchOrderList({
    required String languageCode,
    required HotelOrderStatusFilter status,
    int page = 1,
    int limit = 5,
  });

  Future<List<HotelTodayCheckIn>> fetchTodayCheckIns({
    required String languageCode,
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

  Future<void> setUserLanguage({required String languageCode});

  Future<HotelOrderCancelRule> fetchCancelOrderRule({
    required String languageCode,
    required String orderId,
  });

  Future<String> cancelOrder({
    required String languageCode,
    required String orderId,
  });

  Future<String> checkInOrderCustomer({
    required String orderId,
    required int checkedIn,
    String? roomId,
  });

  Future<HotelMemberProfile> fetchMemberProfile();

  Future<void> updateMemberProfile(HotelMemberProfile profile);

  Future<List<HotelCreditCard>> fetchRegisteredCreditCards();

  Future<HotelMemberPayInfo> fetchMemberPayInfo();

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

  Future<HotelOrderPaymentResult> payOrder({
    required String orderId,
    required String paymentCode,
    required num totalAmount,
    required String languageCode,
    bool isCheck = false,
  });

  Future<HotelOrderPaymentResult> createAlipayPayment({
    required String orderId,
    required String system,
  });

  Future<String> syncOptimismPayment({
    required String orderId,
    required bool success,
  });
}
