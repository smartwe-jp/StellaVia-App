# Hotel Booking Roadmap

Last updated: 2026-05-29

This document defines the working plan for the upcoming hotel booking feature. It should be read before opening task threads related to hotel list, hotel detail, room selection, booking, payment, or hotel orders.

## Current Status

Existing code:

- `fundex/lib/features/hotel_booking/presentation/pages/hotel_booking_tab_page.dart`
- `mobile_core_sdk/packages/company_api_runtime/lib/src/hotel/hotel_api_client.dart`
- `mobile_core_sdk/packages/company_api_runtime/lib/src/hotel/hotel_dtos.dart`
- `mobile_core_sdk/packages/company_api_runtime/test/hotel_api_client_test.dart`

Current behavior:

- Hotel page is wired as the fourth bottom tab at `/hotel-booking`; Profile remains as the fifth bottom tab.
- Hotel tab implements the first home/list/search slice using the SDK `HotelApiClient`.
- Hotel browsing is public. The current booking action still uses `memberProfileActionGuardProvider.ensureCompleted(...)` until the real booking flow is implemented.
- Hotel home hero temporarily reuses the same remote banner image URL pattern as the home tab.
- Hotel home and hotel detail are immersive with transparent status bars and content extending to the top edge. Other hotel child pages, including orders, profile, confirmation, and result pages, use the default app status bar.
- Hotel API requests include fixed app metadata headers from the app network layer: `x-client-type: Stellavia-App` and `app-version` from `PackageInfo.version`.
- Hotel home shows a four-entry quick action row above the search filter controls: user info, hotel orders, coupons, and contact. User info opens the hotel-specific profile route `/hotel-booking/member-profile` backed by `/pms/member/info` and `/pms/member/custSetInfo`, contact opens the existing contact form, and unfinished hotel order/coupon pages currently show the shared app toast.
- App settings now includes a credit-card list entry under bank account settings. The list page calls `/creditCard/register/list` and opens a separate fullscreen add page at `/profile/settings/credit-card/add`; the add page validates card data through Veritrans `/4gtoken`, then registers through `/creditCard/register`. The Veritrans token API key is injected through `VERITRANS_TOKEN_API_KEY` rather than committed in code.
- Hotel list search uses fixed area choices only: all areas as `area: ""`, plus `osaka`, `kyoto`, and `tokyo`. Building/property type choices come from `/hotel/buildingCode`, including the empty-code "all" option returned by the API.
- Hotel home shows selected search conditions as a compact summary bar; tapping the summary bar or search icon opens the full four-row search condition sheet over the tab bar. The sheet edits a local draft and refreshes the list only after "Check availability".
- Hotel list cards navigate to the public detail route `/hotel-booking/:id` with the current search criteria.
- Hotel detail has a first UI/data slice: hero gallery, stay summary, room-plan selection, detail sections, refund policy text, and sticky booking amount bar. Booking submit is still a placeholder action.
- Entering hotel detail triggers the legacy-compatible detail request set: `/pms/hotelinfobyidapp`, `/pms/refundStrategyText`, and `/pms/priceByDate`.
- Hotel detail stay-date and guest changes follow the legacy detail-page behavior: date or adult/child changes reload the detail data and reset selected room-plan quantities and assigned occupancy price; the detail guest popup does not edit the search room-count field.
- Hotel detail shows `checkInMessage` as a yellow notice card above the room list when it is non-empty. Do not display request/assign `message` values there.
- Hotel detail room quantity changes call `/pms/assign/occupancy` and use the returned assigned price for the booking amount before entering confirmation.
- Tapping the hotel detail booking button re-runs `/pms/assign/occupancy`; if the response contains `message`, show it in a cancel/confirm dialog and continue to confirmation only after confirm.
- Tapping a room plan card opens a room-detail bottom sheet with room photos, facts, facility categories, and room description from the detail API room-type fields.
- Hotel booking confirmation has a first UI/data slice at `/hotel-booking/:id/confirm`: order summary, coupon entry row, payment method selection, booker form, room guest form, invoice, note, and sticky amount bar. The submit action creates a pre-order through `/pms/bookingorder/save/v2`.
- Entering hotel booking confirmation initializes the legacy-compatible preparation request set: `/pms/page` for `APP011`, `APP003`, `APP004`, and `APP012`, plus `/pms/countryCodeList`, `/pms/order/room/extraPerson`, `/pms/coupons/order/custListV2`, `/pms/member/memberContactsList`, and `/creditCard/register/list`.
- Hotel booking confirmation auto-fills empty booker fields from the current App authenticated user cache. Booker name uses App `lastName`/`firstName` first and falls back to `lastNameEn`/`firstNameEn`; email, phone, and phone country code use the authenticated user fields.
- Successful hotel pre-order creation navigates to `/hotel-booking/:id/result` with the order id, selected payment method, payable amount, and a notice that payment is still required within the backend timeout window. Any payment action now opens `/hotel-booking/payment`, a redesigned payment-method selection page that defaults to the order's submitted payment method but lets the user choose again before paying. The credit-card payment path supports both registered cards and adding a card during payment: registered cards load `/creditCard/register/list` and pay through `/creditCard/member/cardIdPay`; new-card payment tokenizes through Veritrans, then uses `/creditCard/payAndAuth` when the user does not save the card or `/creditCard/member/payAndJoin` when the user saves it. All credit-card payment paths open the returned 3D Secure URL in the shared web viewer and treat URLs containing `paysuccess` / `payfailed` as payment completion signals. Alipay and WeChat remain placeholders.
- Hotel order list is available from the hotel home quick-action row at `/hotel-booking/orders`. It calls `/pms/order/list` with top status filters for all, awaiting payment, booked, and cancelled orders, loads 5 rows per page, and keeps list state in a Riverpod controller.
- Hotel order detail is available at `/hotel-booking/orders/:orderId`. Entering the page loads `/pms/order/detail` plus `/pms/page` for `APP008`, `APP003`, and `APP0011`, maps the legacy detail fields into typed domain data, and renders the first redesigned order-detail UI slice. Its more menu includes a receipt action that opens a bottom sheet prefilled from `receiptTitle` and `contactEmail`, then requests `/pms/order/invoice` and surfaces backend messages with the shared app toast.
- SDK-level hotel API client/DTO foundation exists for the first migration slice.

Current gaps:

- No Alipay, WeChat, refund, or cancel policy flow.
- Hotel API success-code contract is still unresolved: old app checks `code == 200`, while current architecture notes say hotel uses `code == 0`.

## API And Legacy Reference Sources

Hotel booking is a migration-and-redesign effort, not a greenfield feature.

Primary API reference:

- Swagger UI: `https://hotel-sit.gutingjun.com/api/swagger-ui/index.html#/`
- OpenAPI JSON: `https://hotel-sit.gutingjun.com/api/v3/api-docs`

Legacy functional references:

- API path source: `/Users/aaronhou/Documents/financing-flutter-getx/lib/app/config/http_conf.dart`
- Legacy feature source: `/Users/aaronhou/Documents/financing-flutter-getx/lib/app/modules/hotel`

Reference scope:

- Use Swagger to understand hotel API paths, request/response fields, and schemas.
- Use the old hotel module to understand what the existing app already supports: list, detail, room selection, calendar price, booking, payment, order list/detail, cancellation/refund, contacts, receipts, coupons, member discount, and credit-card flows.
- Do not copy the old project architecture, GetX state model, route structure, untyped map parsing, or page implementation style.
- New implementation must follow this app's Clean Architecture + Riverpod + SDK-client strategy.
- New UI should be redesigned for StellaVia/current app style; do not preserve old UI layouts unless the user explicitly asks.

Migration principle:

1. First bind API paths and data fields to Swagger.
2. Use the old app only to fill behavior/flow gaps not covered by Swagger.
3. Then model them as typed SDK DTOs and app domain entities.
4. Then rebuild the UI and page state with current app architecture.

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

Current primary source is the hotel Swagger/OpenAPI:

- Swagger UI: `https://hotel-sit.gutingjun.com/api/swagger-ui/index.html#/`
- OpenAPI JSON: `https://hotel-sit.gutingjun.com/api/v3/api-docs`

The old app's `http_conf.dart` hotel section is now a legacy compatibility/reference source only.

Before implementing hotel API calls, confirm:

- Base cluster: `AppApiCluster.hotel` or another configured cluster.
- Swagger/OpenAPI operation and schema.
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
- Implemented Swagger-backed methods: `/hotel/hotelSearch`, `/pms/hotelinfobyidapp`, `/booking/order` Airhost booking creation, `/booking/order/sendPaymentLink`, and `/pms/pay4order`.
- Swagger currently emits several request schema property keys as Chinese labels while placing the real wire field name in `example` values, for example `房源档案ID` -> `hotelInfoID` and `预订平台ID` -> `siteID`. The SDK DTOs use the wire field names observed from these examples and the legacy request payloads.
- Implemented legacy-compatible methods pending Swagger confirmation or replacement: building code, room facility filters, refund strategy text, price calendar, assign occupancy, booking confirmation page text/country/coupon/contact/card preparation, hotel member info/update, booking create v2, order list/detail, member pay info, cancel rule, and cancel order.
- Hotel DTOs are generated with `freezed_annotation` / `json_serializable`; do not add hand-written model parsing functions for new hotel DTOs.

If Swagger is incomplete:

- Use the old app `http_conf.dart`, old module request payloads, and real request/response examples as temporary sources only when Swagger lacks the needed contract.
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
   - Start from hotel Swagger/OpenAPI.
   - Use old `http_conf.dart` hotel endpoint keys and old module requests only for behavior gaps or missing Swagger contracts.
   - Produce endpoint list, request payloads, response samples, and field mapping.
   - Update this roadmap.

2. SDK hotel client skeleton
   - Done for the first API slice.
   - Continue refining with real response samples and confirmed success codes.

3. App domain/data vertical slice
   - Add entities, repository, remote datasource, usecases, providers.
   - Keep remote datasource thin over SDK client.

4. Hotel list tab replacement
   - Done for first slice.
   - Current home search summary includes destination, date range, stay nights, adults, children, and room count.
   - Full search condition sheet fields are destination, building type, date range, adults, children, and room count.
   - Pull-to-refresh preserves old content on refresh failure.

5. Hotel detail page
   - First slice done: route, detail data, image gallery, room-plan selection UI, refund policy text, and bottom amount bar.
   - Remaining: date/guest edit from detail page, map entry, image preview, and final visual tuning after real response variety is confirmed.

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

- Is hotel browsing public or login-only?
- Does booking require full member profile completion, phone verification, real-person verification, or all of them?
- What payment method is used for hotel booking?
- Are hotel orders connected to wallet/account history?
- Are hotel benefits related to owner/fund benefits or a separate product domain?
- Does hotel need multilingual content from backend, or should app localize static labels only?
