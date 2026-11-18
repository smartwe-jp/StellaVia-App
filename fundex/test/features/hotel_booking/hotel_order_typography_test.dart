import 'package:fundex/features/hotel_booking/presentation/widgets/hotel_coupon_list_widgets.dart';
import 'package:fundex/features/hotel_booking/presentation/widgets/hotel_member_contact_card.dart';
import 'package:fundex/features/hotel_booking/presentation/support/hotel_coupon_display.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/l10n/app_localizations.dart';
import 'package:fundex/features/hotel_booking/domain/entities/hotel_models.dart';
import 'package:fundex/features/hotel_booking/presentation/support/hotel_booking_presenter.dart';
import 'package:fundex/features/hotel_booking/presentation/widgets/hotel_order_list_widgets.dart';
import 'package:fundex/features/hotel_booking/presentation/widgets/hotel_order_detail_widgets.dart';
import 'package:fundex/features/hotel_booking/presentation/widgets/hotel_today_checkin_widgets.dart';
import 'package:fundex/features/hotel_booking/presentation/widgets/hotel_today_checkin_detail_widgets.dart';

const summary = HotelOrderSummary(
  id: '1232819',
  hotelName: '谷町君・ホテル・難波77',
  buildingName: '',
  hotelImageUrl: '',
  hotelAddress: '大阪市浪速区敷津東1-6-21',
  checkIn: '2026-11-20 15:00:00',
  checkOut: '2026-11-26 10:00:00',
  paymentStatus: '',
  paymentStatusCode: 45,
  orderStatus: '予約完了',
  orderStatusCode: 2,
  mile: 20900,
  totalAmount: 19000,
  bookingOrderTime: '',
  payCode: '',
  canPay: false,
  canRefund: true,
);
const checkIn = HotelTodayCheckIn(
  id: '1232819',
  hotelName: '谷町君・ホテル・難波77',
  buildingName: '',
  hotelImageUrl: '',
  hotelAddress: '大阪市浪速区敷津東1-6-21',
  checkIn: '2026-11-20 15:00:00',
  checkOut: '2026-11-26 10:00:00',
  paymentStatus: '',
  paymentStatusCode: 45,
  orderStatus: '予約完了',
  orderStatusCode: 2,
  mile: 20900,
  totalAmount: 19000,
  roomNo: '101',
  checkedIn: false,
);
const detail = HotelOrderDetail(
  summary: summary,
  hotelId: '1',
  imageUrl: '',
  address: '大阪市浪速区敷津東1-6-21',
  latitude: null,
  longitude: null,
  orderNo: '1232819',
  serialNo: '',
  createdTime: '',
  guestName: 'Taro Yamada',
  receiptTitle: '',
  contactEmail: 'guest@example.com',
  contactIntlCode: '81',
  contactMobile: '12345',
  nationalityText: '',
  checkedInStatus: 0,
  checkedInText: '未入居',
  adultCount: 2,
  childCount: 0,
  paidAmount: 19000,
  originalAmount: 19000,
  couponDiscountAmount: null,
  fundBenefitTicket: null,
  payName: '',
  payCode: '',
  paymentTime: '',
  comment: '',
  checkInGuide: 'フロントデスクでチェックインの手続きを行ってください。',
  cancelRule: '',
  gatePassword: '',
  rooms: [],
  roomId: '1',
  roomNo: '101',
  bookingType: 1,
  pageTexts: {},
);
void main() {
  test('coupon hotel names omit legacy empty entries', () {
    expect(hotelCouponHotelNames('[星ホテル, null, , 谷町君]'), '星ホテル・谷町君');
    expect(hotelCouponHotelNames('null'), '');
    expect(hotelCouponHotelNames('Hotel, Osaka'), 'Hotel, Osaka');
  });

  setUpAll(() => initializeDateFormatting());
  for (final locale in AppLocalizations.supportedLocales) {
    for (final scale in [1.0, 1.2]) {
      testWidgets('order and check-in layouts $locale scale $scale', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final presenter = HotelBookingPresenter('en');
        final views = [
          ListView(
            children: [
              const HotelCouponCard(
                coupon: HotelCoupon(
                  id: 1,
                  name: '10%优惠的优惠券',
                  number: 1,
                  detail: '',
                  type: 3,
                  discount: 10,
                  amount: null,
                  amountEvery: '',
                  hotelNames: '[星ホテル, null, 谷町君]',
                  beginDate: '2026-11-18',
                  endDate: '2027-01-31',
                  createdTime: '',
                  canUse: true,
                ),
                pageTexts: {},
              ),
              HotelMemberContactCard(
                contact: const HotelMemberContact(
                  id: '1',
                  memberId: null,
                  name: '谷町君 株式会社',
                  firstName: '',
                  lastName: '',
                  email: 'guest@example.com',
                  intlCode: '81',
                  mobile: '09085309521',
                  nationality: 'JP',
                  nationalityText: '日本',
                  isDefault: true,
                ),
                onTap: () {},
                onDelete: () {},
              ),
            ],
          ),

          ListView(
            children: [
              HotelOrderSummaryCard(order: summary, presenter: presenter),
            ],
          ),
          ListView(
            children: [
              HotelTodayCheckInCard(item: checkIn, presenter: presenter),
            ],
          ),
          HotelOrderDetailContent(
            detail: detail,
            presenter: presenter,
            onBack: () {},
            onMore: (_) {},
            onPay: () {},
            onCancel: () {},
            onPaymentCountdownExpired: () {},
          ),
          HotelTodayCheckInDetailContent(
            detail: detail,
            onCheckIn: (_) {},
            onCheckOut: (_) {},
          ),
        ];
        for (final view in views) {
          await tester.pumpWidget(
            MaterialApp(
              theme: AppThemeFactory.light(locale: locale),
              locale: locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home: MediaQuery(
                data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                child: Scaffold(body: view),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox.shrink());
        }
      });
    }
  }
}
