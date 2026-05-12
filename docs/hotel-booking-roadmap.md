# Hotel Booking Roadmap

Last updated: 2026-05-12

This document defines the working plan for the upcoming hotel booking feature. It should be read before opening task threads related to hotel list, hotel detail, room selection, booking, payment, or hotel orders.

## Current Status

Existing code:

- `fundex/lib/features/hotel_booking/presentation/pages/hotel_booking_tab_page.dart`
- `mobile_core_sdk/packages/company_api_runtime/lib/src/hotel/hotel_api_client.dart`
- `mobile_core_sdk/packages/company_api_runtime/lib/src/hotel/hotel_dtos.dart`
- `mobile_core_sdk/packages/company_api_runtime/test/hotel_api_client_test.dart`

Current behavior:

- Placeholder hotel page file exists and demonstrates `memberProfileActionGuardProvider.ensureCompleted(...)`, but it is not wired into the active root tab shell.
- Current `/hotel-booking` route redirects to `/funds`.
- SDK-level hotel API client/DTO foundation exists for the first migration slice.
- No app-side hotel data/domain implementation yet.

Current gaps:

- No app-side hotel entity/repository/usecase/provider layer.
- No hotel list/detail/search/room/booking/order pages.
- No hotel payment/refund/cancel policy flow.
- No hotel-specific l10n beyond placeholder tab labels.
- Hotel API success-code contract is still unresolved: old app checks `code == 200`, while current architecture notes say hotel uses `code == 0`.

## Legacy Reference Sources

Hotel booking is a migration-and-redesign effort, not a greenfield feature.

Primary functional/API references:

- API path source: `/Users/aaronhou/Documents/financing-flutter-getx/lib/app/config/http_conf.dart`
- Legacy feature source: `/Users/aaronhou/Documents/financing-flutter-getx/lib/app/modules/hotel`

Reference scope:

- Use the old project to understand hotel API paths, request/response fields, flow order, edge cases, and business behavior.
- Use the old hotel module to understand what the existing app already supports: list, detail, room selection, calendar price, booking, payment, order list/detail, cancellation/refund, contacts, receipts, coupons, member discount, and credit-card flows.
- Do not copy the old project architecture, GetX state model, route structure, untyped map parsing, or page implementation style.
- New implementation must follow this app's Clean Architecture + Riverpod + SDK-client strategy.
- New UI should be redesigned for StellaVia/current app style; do not preserve old UI layouts unless the user explicitly asks.

Migration principle:

1. First migrate API paths, data fields, and behavior flow from the old app.
2. Then model them as typed SDK DTOs and app domain entities.
3. Then rebuild the UI and page state with current app architecture.

## Product Goal

Add a hotel booking module that can coexist with the existing fund investment app without breaking investment, wallet, profile, settings, or discussion flows.

The hotel module should reuse existing app infrastructure:

- Auth state and route guard.
- Member profile completion guard.
- Shared UI kit components and tokens.
- Network clusters and envelope parsing.
- Image/PDF/web/video helpers if relevant.
- Wallet/payment primitives only when the final hotel payment model requires them.

## Suggested User Flow

Initial minimum viable flow:

1. Hotel tab / entry page.
2. Hotel search or list.
3. Hotel detail.
4. Room plan selection.
5. Booking date/guest input.
6. Booking confirmation.
7. Booking result.
8. Booking list.
9. Booking detail.
10. Cancel flow if backend supports it.

Later optional flow:

- Coupon/benefit usage.
- Campaign display.
- Favorites/history.
- Review or comments.
- Map/directions.
- Hotel document/PDF display.

## Proposed Module Structure

Target layout:

```text
fundex/lib/features/hotel_booking/
  data/
    datasources/
      hotel_booking_remote_data_source.dart
    models/
      hotel_booking_dtos.dart
    repositories/
      hotel_booking_repository_impl.dart
  domain/
    entities/
      hotel_models.dart
    repositories/
      hotel_booking_repository.dart
    usecases/
      fetch_hotel_list_usecase.dart
      fetch_hotel_detail_usecase.dart
      fetch_room_plan_list_usecase.dart
      create_hotel_booking_usecase.dart
      fetch_hotel_booking_list_usecase.dart
      fetch_hotel_booking_detail_usecase.dart
      cancel_hotel_booking_usecase.dart
  presentation/
    controllers/
      hotel_booking_controller.dart
    pages/
      hotel_booking_tab_page.dart
      hotel_detail_page.dart
      hotel_booking_confirm_page.dart
      hotel_booking_result_page.dart
      hotel_booking_list_page.dart
      hotel_booking_detail_page.dart
    providers/
      hotel_booking_providers.dart
    support/
      hotel_booking_presenter.dart
      hotel_booking_models.dart
    widgets/
      hotel_card.dart
      room_plan_card.dart
```

SDK target if APIs are stable/reusable:

```text
mobile_core_sdk/packages/company_api_runtime/lib/src/hotel/
  hotel_api_client.dart
  hotel_dtos.dart
```

## API Strategy

Current primary source is the old app's `http_conf.dart` hotel section. If a newer hotel Swagger/OpenAPI source is provided later, treat it as authoritative and update this roadmap before changing code.

Before implementing hotel API calls, confirm:

- Base cluster: `AppApiCluster.hotel` or another configured cluster.
- Swagger/OpenAPI source if available.
- Envelope success code. Existing architecture notes say Hotel uses `code == 0`.
- Pagination structure.
- Auth requirement per endpoint.
- Date format and timezone handling.
- Price fields and currency semantics.
- Booking state enum values.
- Cancellation policy fields.
- Payment model: wallet, external payment, offline settlement, or mixed.

Current SDK implementation note:

- `HotelApiClient` currently accepts both `code == 0` and `code == 200` because the legacy app checks `200` while the new architecture notes mention `0`.
- This compatibility is temporary. Tighten the success profile once the authoritative hotel API contract is confirmed.
- Implemented first-slice methods: hotel search, building code, room facility filters, hotel detail, price calendar, booking create v2, order list/detail, member pay info, cancel rule, cancel order, and pay-for-order trigger.
- Hotel DTOs are generated with `freezed_annotation` / `json_serializable`; do not add hand-written model parsing functions for new hotel DTOs.

If Swagger is incomplete:

- Use the old app `http_conf.dart`, old module request payloads, and real request/response examples as temporary sources.
- Mark temporary assumptions in code comments near API path/client definitions.
- Update this roadmap once backend contract is confirmed.

Known legacy hotel endpoint keys from `http_conf.dart`:

| Legacy key | Path | Purpose |
| --- | --- | --- |
| `postHotellist` | `hotel/hotelSearch` | Hotel/minpaku list search |
| `postHotelBuildingCode` | `hotel/buildingCode` | Room/building type list |
| `pmsPage` | `pms/page` | Page configuration text/data |
| `refundStrategyText` | `pms/refundStrategyText` | Refund policy text |
| `esLoadRoomFacility` | `pms/esLoadRoomFacility` | Filter/facility conditions |
| `hotelinfobyidapp` | `pms/hotelinfobyidapp` | Hotel detail |
| `bookingorderSave` | `pms/bookingorder/save` | Create booking order |
| `bookingorderSaveV2` | `pms/bookingorder/save/v2` | Create booking order v2 |
| `bookingRepeatBookings` | `pms/repeatBookings` | Duplicate-booking validation |
| `bookingPmsSite` | `pms/site` | Booking platform data |
| `paymentType` | `pms/paymenttype` | Payment type list |
| `pay4order` | `pms/pay4order` | Start payment |
| `hotelOrderList` | `pms/order/list` | Hotel order list |
| `hotelOrderDetail` | `pms/order/detail` | Hotel order detail |
| `permitMemberPay` | `pms/book/permitMemberPay` | User account/payment eligibility info |
| `hotelcancelOrderRule` | `pms/book/cancelOrderRule` | Cancellation/refund notice |
| `hotelcancelOrder` | `pms/book/cancelOrder/v2` | Cancel/refund order |
| `hotelpriceByDate` | `pms/priceByDate` | Calendar price by date |
| `postExtraPerson` | `pms/order/extraPerson` | Extra-person request for order |
| `postRoomExtraPerson` | `pms/order/room/extraPerson` | Extra-person request for one room |
| `payoptimismPayment` | `pms/optimismPayment` | WeChat/Alipay backend sync callback |
| `hotelBookCustChecked` | `pms/book/cust/checked` | Customer checked hotel order |
| `hotelOrderRoomUnlock` | `pms/orderRoomUnlock` | Hotel order room unlock |
| `postInvoice` | `pms/order/invoice` | Download/order receipt |
| `pmsCouponsOrderCustlist` | `pms/coupons/order/custListV2` | Coupon availability for order page |
| `pmsCouponsCustlist` | `pms/coupons/custListV2` | Coupon list |
| `pmsMemberDiscount` | `pms/gtj/memberDiscount` | Member discount |
| `postHotelDiscount` | `hotel/homePage/priceDiscount` | List discount |
| `pmscountryCodeList` | `pms/countryCodeList` | Contact country-code list |
| `pmsAssignOccupancy` | `pms/assign/occupancy` | Detail page occupancy add/remove |
| `pmsmemberContactsList` | `pms/member/memberContactsList` | Frequent contact list |
| `pmsmemberContactsUpdate` | `pms/member/memberContactsSaveOrUpdate` | Add/edit frequent contact |
| `pmsmemberContactsDelete` | `pms/member/memberContactsDelete` | Delete frequent contact |
| `pmsmemberContactsDefault` | `pms/member/contactsDefaultOption` | Default contact option |
| `cardPayAuth` | `creditCard/payAndAuth` | Credit-card pay/auth without saving card |
| `cardPayJoin` | `creditCard/member/payAndJoin` | Credit-card pay and save card |
| `cardRegisterList` | `creditCard/register/list` | Registered card list |
| `cardPayById` | `creditCard/member/cardIdPay` | Pay with registered card id |
| `cardUnRegisterById` | `creditCard/unregister` | Delete registered card |
| `cardRegister` | `creditCard/register` | Register card |

Environment/base-url notes from the old project:

- Production base was commented as `https://hotel.gutingjun.com/api/`.
- SIT base was `https://hotel-sit.gutingjun.com/api/`.
- Share URL was based on `/hoteldetail?id=`.
- Credit-card public key and token API key existed in the old app; do not hardcode them in the new app. Wire them through environment config/secrets if this flow is migrated.

## Data Model Draft

Initial entities likely needed:

- `HotelSummary`
  - id, name, location, coverImageUrl, tags, lowestPrice, rating, availability status.
- `HotelDetail`
  - id, name, description, address, images, facilities, policies, check-in/out time, room plans.
- `RoomPlan`
  - id, hotelId, roomName, planName, capacity, mealType, images, price, remainingRooms, cancellationPolicy.
- `HotelBookingDraft`
  - hotelId, roomPlanId, checkInDate, checkOutDate, guestCount, guestName/contact, note.
- `HotelBookingOrder`
  - id, orderNo, hotelName, roomPlanName, stay dates, guest count, amount, status, payment status, cancel policy.

Keep DTOs separate from entities. Do not expose backend field names directly to UI if a presenter/display model is needed.

## UI Strategy

- Do not keep the placeholder `Card/ListTile` visual style for final hotel pages.
- Reuse `core_ui_kit` primitives but define a hotel-specific visual language if needed.
- Hotel pages must use theme/token colors, not hardcoded `Color(0x...)`, `Colors.*`, or page-local hex constants.
- Shared reusable hotel cards should move to SDK only when they are not product-specific.
- Keep page files focused on composition and provider/event binding. Put non-trivial child UI in separate files under `presentation/widgets/`, and put display mapping/formatting in `presentation/support`.
- All user text must be in ARB.
- Images should use existing cached image approach to avoid placeholder flicker.
- Root tab content should support pull-to-refresh and should avoid clearing old content on transient network failure.

## Guarding Rules

Use existing guards instead of creating hotel-specific duplicated checks:

- Browsing hotel list/detail can be public unless product decides otherwise.
- Creating a booking should require login.
- Confirming a booking should require member profile completion if legally or operationally required.
- If phone/identity verification is required, use current centralized providers/guards. Remember phone verification means `/member/login/index` `phone` is non-empty only.

## Task Breakdown

Recommended task threads:

1. Hotel API contract discovery
   - Start from old `http_conf.dart` hotel endpoint keys and old module requests.
   - Locate Swagger/OpenAPI if available, or collect backend examples.
   - Produce endpoint list, request payloads, response samples, and field mapping.
   - Update this roadmap.

2. SDK hotel client skeleton
   - Done for the first API slice.
   - Continue refining with real response samples and confirmed success codes.

3. App domain/data vertical slice
   - Add entities, repository, remote datasource, usecases, providers.
   - Keep remote datasource thin over SDK client.

4. Hotel list tab replacement
   - Replace placeholder tab with list/search UI.
   - Pull-to-refresh and non-destructive offline failure behavior.

5. Hotel detail page
   - Route, detail data, image gallery, room-plan entry.

6. Room plan and booking draft
   - Date/guest selection, validation, draft state.

7. Booking confirmation and submit
   - Submit API, confirmation UI, result UI.

8. Booking list/detail
   - User order list and order detail.

9. Cancel/refund/payment integration
   - Only after backend payment/cancel contract is confirmed.

10. Polish and localization
   - Final copy, all locales, edge states, accessibility, tests.

## Validation Defaults

For a hotel task thread, prefer targeted validation first:

```bash
cd /Users/aaronhou/Documents/GitHub/HanjouFinace/fundex
rtk fvm flutter gen-l10n
rtk fvm flutter analyze <touched dart files>
rtk fvm flutter test <specific test file>
```

For SDK client work:

```bash
cd /Users/aaronhou/Documents/GitHub/HanjouFinace/mobile_core_sdk/packages/company_api_runtime
rtk fvm flutter test test/<new_or_changed_test>.dart
rtk fvm flutter analyze lib/src/hotel test/<new_or_changed_test>.dart
```

Run broader `flutter analyze` / `flutter test` only when the change affects shared infrastructure or before release.

## Open Questions

- Is there a newer authoritative hotel API documentation URL, or should the old app remain the primary source for now?
- Is hotel browsing public or login-only?
- Does booking require full member profile completion, phone verification, real-person verification, or all of them?
- What payment method is used for hotel booking?
- Are hotel orders connected to wallet/account history?
- Are hotel benefits related to owner/fund benefits or a separate product domain?
- Does hotel need multilingual content from backend, or should app localize static labels only?
