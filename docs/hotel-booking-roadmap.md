# Hotel Booking Roadmap

Last updated: 2026-08-14

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
- After login, app startup and app-language changes sync the current hotel language to authenticated `/pms/setUserLang?lang=...` so hotel backend response messages follow the active locale. The sync is skipped while logged out. The language codes use the existing hotel mapping: Japanese `JP`, English `EN`, and Chinese `CH`.
- Hotel home shows quick actions above the search filter controls: stay benefits, hotel orders, frequent guests, coupons, and contact. Stay benefits opens `/hotel-booking/stay-benefits`, which reuses the filter/sort/map toolbar, `/hotel/hotelSearch` list API with `stayBenefit: true`, the public `/hotel/homePage/stayBenefitPeriods` date-period API, and home hotel cards with normal price display. The stay-benefit list uses `stayBenefitParticipate` from each hotel row to replace the remaining-room line with a muted "no stay benefit for current date" status when the selected date is not eligible. The older hotel-specific member profile route `/hotel-booking/member-profile`, backed by `/pms/member/info` and `/pms/member/custSetInfo`, remains implemented but is not currently linked from the hotel home quick-action row. Hotel orders opens `/hotel-booking/orders`, frequent guests opens `/hotel-booking/contacts` backed by `/pms/member/memberContactsList`, saves add/edit changes through `/pms/member/memberContactsSaveOrUpdate`, and deletes contacts through `/pms/member/memberContactsDelete`; coupons opens `/hotel-booking/coupons`, and contact opens the existing contact form.
- App settings now includes a credit-card list entry under bank account settings. The list page calls `/creditCard/register/list` and opens a separate fullscreen add page at `/profile/settings/credit-card/add`; the add page validates card data through Veritrans `/4gtoken`, then registers through `/creditCard/register`. The Veritrans token API key is injected through `VERITRANS_TOKEN_API_KEY` rather than committed in code.
- Hotel list search uses fixed area choices only: all areas as `area: ""`, plus `osaka`, `kyoto`, and `nagano` (displayed as Hakuba/白馬). Building/property type choices come from `/hotel/buildingCode`, including the empty-code "all" option returned by the API. `/hotel/hotelSearch` requests include `stayBenefit`, defaulting to `false` for normal hotel browsing and set to `true` for the stay-benefits list.
- Hotel home paginates `/hotel/hotelSearch` with 9 rows per page. Pulling near the bottom automatically requests the next `startPage`, appends rows, and stops when the loaded count reaches the API `count`.
- The app Home tab also shows a compact featured-hotel rail under the latest-fund rail. It uses the same `/hotel/hotelSearch` list contract with the default hotel search criteria, requests the first 4 hotels, renders the existing `HotelSummaryCard` horizontally, and opens the public hotel detail route with the same criteria when a card is tapped.
- Stay-benefit date selection consumes `/hotel/homePage/stayBenefitPeriods`, highlights eligible check-in dates in the shared calendar with the warning/gold theme, and enforces a single-night range: tapping an eligible date selects that date as check-in and the following date as check-out. The sheet displays the guidance text that stay benefits support only one night.
- Entering the stay-benefits list no longer requests `/pms/my/fundBenefitTickets` while that endpoint is temporarily disabled in the app layer; stay-benefit ticket amount is treated as unavailable for now.
- Hotel home shows selected search conditions as a compact summary bar; tapping the summary bar or search icon opens the full four-row search condition sheet over the tab bar. The sheet edits a local draft and refreshes the list only after "Check availability". Hotel date picking uses the shared custom range calendar across home/search and detail; home/search shows date cells without prices, while detail injects `/pms/priceByDate` prices into the same calendar.
- Hotel list cards navigate to the public detail route `/hotel-booking/:id` with the current search criteria.
- Full-page hotel loading failures show both retry and back actions. Back pops the existing route stack when possible and otherwise returns to `/hotel-booking`, so direct-entry API failures do not trap the user.
- Hotel remaining inventory labels distinguish room-based properties from whole-building properties using only the hotel `buildingCode`: `"1"` displays room units, while `"2"` machiya and `"3"` townhouse display building units. Detail responses do not currently include `buildingCode`, so hotel detail route entries pass the selected summary hotel's `buildingCode` into the detail page for room-card display.
- Hotel discount badges can open a discount-detail dialog backed by `POST /hotel/homePage/priceDiscount` with the current stay dates, language, and hotel id. On the main hotel list, the dialog includes a booking action that navigates to hotel detail with the current criteria; other discount-badge entry points show details only.
- Hotel detail has a first UI/data slice: hero gallery, stay summary, room-plan selection, detail sections, refund policy text, and sticky booking amount bar. Booking submit is still a placeholder action.
- Entering hotel detail triggers the legacy-compatible detail request set: `/pms/hotelinfobyidapp`, `/pms/refundStrategyText`, and `/pms/priceByDate`, plus the public `/hotel/homePage/stayBenefitPeriod` request with the current `hotelId` to load that hotel's supported stay-benefit dates. Detail-page use of those dates is still pending.
- In the stay-benefit flow, hotel detail now evaluates stay-benefit ticket usability before booking: the selected check-in date must be supported by `/hotel/homePage/stayBenefitPeriod`, stay length must be exactly one night, room count must be one, the member must hold an unused fund stay-benefit ticket, and the highest unused ticket `benefitAmount` must be greater than or equal to the current reference booking amount. Insufficient amount means the ticket cannot be used at all and cannot be partially applied. When the stay-benefit rules fail, the detail page shows the reason and the bottom action continues as regular booking only after confirmation.
- Hotel detail stay-date and guest changes follow the legacy detail-page behavior: date or adult/child changes reload the detail data and reset selected room-plan quantities and assigned occupancy price; the detail guest popup does not edit the search room-count field. The detail stay-date calendar uses the already-loaded `/pms/priceByDate` map to show each day's price under the day number while selecting the check-in/check-out range. In the custom calendar, tapping a date while a full range is selected resets that date as the new check-in only; tapping a later date after a check-in-only state completes the range, while tapping the same or an earlier date resets the check-in.
- Hotel detail shows `checkInMessage` as a yellow notice card above the room list when it is non-empty. Do not display request/assign `message` values there.
- Hotel detail room quantity changes call `/pms/assign/occupancy` only for `bookingType == 0` room/room-type booking and use the returned assigned price for the booking amount before entering confirmation. Total selected room quantity is not capped by the current adult count; each room type is limited only by its currently available room count, while the stay-benefit single-room rule remains unchanged. When the assign response returns positive `extraGuestCount`, the room card shows the extra guest count and `extraGuestPrice` above the quantity stepper. Non-room-selection bookings such as whole-property booking do not require room quantity selection.
- Hotel detail room plans honor `roomTypeDTO4APPs.minStay`: when the selected stay is shorter than a room type's positive minimum-stay value, its remaining-room label is replaced with a localized minimum-stay notice and its add-room action is disabled. Missing, zero, or negative values do not restrict selection.
- Tapping the hotel detail booking button re-runs `/pms/assign/occupancy` for `bookingType == 0`; if the response contains `message`, show it in a cancel/confirm dialog and continue to confirmation only after confirm. For non-room-selection bookings, `checkInMessage` is used as the confirmation notice before entering the confirmation page.
- Tapping a room plan card opens a room-detail bottom sheet with room photos, facts, facility categories, and room description from the detail API room-type fields.
- Hotel booking confirmation has a first UI/data slice at `/hotel-booking/:id/confirm`: order summary, coupon entry row, payment method selection, booker form, guest form, invoice, note, and sticky amount bar. For `bookingType == 0`, selected room quantities are expanded into one guest form per actual room and `/pms/bookingorder/save/v2` receives one `roomCusts` entry per room. Room guest forms are grouped in one section card under a single title, with each room number/name shown above its fields; room guest name and nationality/region are required, room guest email is optional, and room guest forms do not collect phone numbers. Adult defaults are distributed across room guest forms by assigning one adult per room first, then cycling remaining adults from the first room while respecting adult capacity; users can still edit the counters before submitting. The first room guest defaults to using the booker information through a checked shortcut checkbox, which can be unchecked for independent editing. Booker and editable room guest forms can open the saved frequent-guest contact picker, add/edit contacts, refresh the contact list, and fill the current form from the selected contact. For non-room-selection bookings, confirmation shows one whole-property guest form. Booker email remains required.
- Entering hotel booking confirmation initializes the legacy-compatible preparation request set: `/pms/page` for `APP011`, `APP003`, `APP004`, and `APP012`, plus `/pms/countryCodeList`, extra-person quote, `/pms/coupons/order/custListV2`, `/pms/member/memberContactsList`, and `/creditCard/register/list`. `bookingType == 0` uses `/pms/order/room/extraPerson` with `roomTypeCustNums`; non-room-selection bookings use `/pms/order/extraPerson` with `orderRoomTypeData` and `customerCount`.
- In the stay-benefit confirmation flow, `/pms/my/fundBenefitTickets` is temporarily not requested, so the page does not auto-select a stay-benefit ticket and continues with the regular payable amount unless a ticket is restored through a future flow.
- Hotel booking confirmation coupon selection uses `/pms/coupons/order/custListV2` for ordinary coupons. The stay-benefit ticket request `/pms/my/fundBenefitTickets` is temporarily disabled in the app layer, so stay-benefit tickets are not loaded into the picker for now. Selecting or clearing an ordinary coupon re-quotes through the booking-type-specific extra-person endpoint with `couponsCounts`, and the selected coupon is passed into `/pms/bookingorder/save/v2`. Guest count changes also re-quote through the same endpoint without inserting/removing in-list loading UI, so scroll position is preserved. The confirmation summary card shows selected room types as left-aligned room rows with right-aligned quantities, then a separate payable-amount section; when a coupon or stay-benefit ticket changes the payable amount, show the original price as a strikethrough beside the payable amount, but do not show member-registration discount UI for now. Adult and child counters are independently limited by room-type `adults` and `kids` from the detail API instead of sharing one total occupancy cap; when `kids` is missing or `0`, the child counter uses the adult limit. When the returned `roomPriceElements.priceTip` is non-empty, show that text in red above the corresponding room guest counter, right-aligned and without an extra container.
- Hotel booking confirmation auto-fills empty booker fields from the current App authenticated user cache. Booker name uses App `lastName`/`firstName` first and falls back to `lastNameEn`/`firstNameEn`; email, phone, and phone country code use the authenticated user fields.
- Successful hotel pre-order creation navigates to `/hotel-booking/:id/result` with the order id, selected payment method, payable amount, and a notice that payment is still required within the backend timeout window. Any payment action now opens `/hotel-booking/payment`, a redesigned payment-method selection page that defaults to the order's submitted payment method but lets the user choose again before paying. The credit-card payment path supports both registered cards and adding a card during payment: registered cards load `/creditCard/register/list` and pay through `/creditCard/member/cardIdPay`; new-card payment tokenizes through Veritrans, then uses `/creditCard/payAndAuth` when the user does not save the card or `/creditCard/member/payAndJoin` when the user saves it. All credit-card payment paths open the returned 3D Secure URL in the shared web viewer and treat URLs containing `paysuccess` / `payfailed` as payment completion signals. The visible payment options are currently credit card and standby balance only. Standby balance display and insufficiency checks use the App account statistic `withdrawableAmount` derived from `firstLevelAccountTotal - lockedFee`; the actual hotel standby-balance payment still pays through `/pms/pay4order` with `paymentCode: "10"`. WeChat payment calls `/pms/pay4order` with `paymentCode: "14"`; Alipay payment does not use `/pms/pay4order` and instead calls `/ali/app/pay` with `id` and `system` (`android`, `iphone`, or `ipad`), but both native options are temporarily hidden until platform and merchant configuration is complete. Native paths launch payment through Flutter plugins, call `/pms/optimismPayment` after the native result, and refresh hotel order list/detail state. The Alipay native Flutter plugin is currently not linked because its bundled iOS framework is device-only and breaks simulator builds; keep the backend Alipay order path modeled, and restore a simulator-compatible SDK/XCFramework or a true device-only integration when real-device Alipay validation resumes. The static WeChat plugin config in `fundex/pubspec.yaml` still contains placeholder values and must be replaced with merchant-console values before real device payment validation.
- Hotel order list is available from the hotel home quick-action row at `/hotel-booking/orders`. It calls `/pms/order/list` with top status filters for all, awaiting payment, booked, and cancelled orders, loads 5 rows per page, and keeps list state in a Riverpod controller.
- Hotel today check-in list is available from the hotel home quick-action row at `/hotel-booking/check-in`. Entering the page refreshes `/pms/page` for `APP007`, `APP003`, and `APP008`, then calls authenticated `GET /pms/order/todayCheckIn?lang=...` and renders the returned bookings in the app's hotel order-card style. Tapping a booking opens the dedicated check-in detail page backed by `POST /pms/order/detail`; the detail check-in action confirms with a common dialog, submits `POST /pms/book/cust/checked` with `bookingOrderId` and `checkedIn: 1`, surfaces backend failure messages such as before-time rejection, and refreshes the detail/list providers after success. Once the detail status becomes staying (`checkedIn == 1` or localized staying text), the room card shows room number, room password, fixed Wi-Fi guidance, and switches the primary action to red checkout. Checkout uses the same endpoint with `checkedIn: 2`, then refreshes the current detail/list state on success.
- Hotel coupon list is available from the hotel home quick-action row at `/hotel-booking/coupons`. It loads `APP011` page text for legacy type-2 coupon labels and calls `/pms/coupons/custListV2` with the current hotel language code. The previous "My fund stay benefit" ticket segment is not active while `/pms/my/fundBenefitTickets` requests are disabled.
- Hotel order detail is available at `/hotel-booking/orders/:orderId`. Entering the page loads `/pms/order/detail` plus `/pms/page` for `APP008`, `APP003`, and `APP0011`, maps the legacy detail fields into typed domain data, and renders the first redesigned order-detail UI slice. Its more menu includes a receipt action that opens a bottom sheet prefilled from `receiptTitle` and `contactEmail`, then requests `/pms/order/invoice` and surfaces backend messages with the shared app toast.
- SDK-level hotel API client/DTO foundation exists for the first migration slice.

Current gaps:

- Native Alipay/WeChat real-device merchant validation is still pending because the configured app ids, schemes, universal links, Android package/signature, and merchant-console settings are not available yet. Alipay native SDK linkage also needs a simulator-safe package or explicit device-only reintroduction before final validation.
- No refund or cancel policy flow.
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
- Implemented Swagger-backed methods: `/hotel/hotelSearch`, `/hotel/homePage/stayBenefitPeriods`, `/hotel/homePage/stayBenefitPeriod`, `/pms/hotelinfobyidapp`, `/booking/order` Airhost booking creation, `/booking/order/sendPaymentLink`, and `/pms/pay4order`.
- Swagger currently emits several request schema property keys as Chinese labels while placing the real wire field name in `example` values, for example `房源档案ID` -> `hotelInfoID` and `预订平台ID` -> `siteID`. The SDK DTOs use the wire field names observed from these examples and the legacy request payloads.
- Implemented legacy-compatible methods pending Swagger confirmation or replacement: building code, room facility filters, refund strategy text, price calendar, assign occupancy, booking confirmation page text/country/coupon/contact/card preparation, hotel member info/update, booking create v2, order list/detail, member pay info, cancel rule, and cancel order.
- Hotel DTOs are generated with `freezed_annotation` / `json_serializable`; do not add hand-written model parsing functions for new hotel DTOs unless the backend returns dynamic-key rows such as `/hotel/homePage/stayBenefitPeriods`.

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
| `aliAppPay` | `ali/app/pay` | Start Alipay app payment |
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
| `pmsMyFundBenefitTickets` | `pms/my/fundBenefitTickets` | Current member's fund stay benefit ticket list |
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

## 2026-10-28 酒店首页设计更新

- 设计来源：Figma `I9xMTxYMyek9AvMWtDvkFi`，普通首页 `8110:798`、宿主マイル首页 `8110:968`。
- 普通首页替换为品牌栏、日期人数搜索、宿主マイル入口、区域/价格排序及新版酒店卡片。保留现有搜索条件弹层、真实接口、分页、刷新、错误缓存与详情跳转；旧横幅/快捷入口仅从此首页移出，旧实现与路由保留。Tab 不变。
- 新路由 `/hotel-booking/host-miles` 暂为明确标记的设计预览；等级 BRONZE、余额 12,000、可约 2 室和酒店里程均是独立示例数据，不是账户或接口结果。预览搜索/筛选/预约按钮禁用；不接下单流程。用户已确认本阶段采用明确标记的设计预览和示例数据，后续再接真实宿主マイル接口。
- 不将旧 `stayBenefit` / `stayBenefitParticipate` 解释为宿主マイル资格。房屋类型仍使用现有 buildingCode 映射；里程说明单独放在卡片内容。
- 新业务组合位于 hotel_booking/presentation/widgets，静态预览 fixture 与配色位于 support，四语言 ARB 已生成。
- 验证：定向 analyze；首页区域/排序、四语言 320px/1.3 字号、预览禁止预约；已有 controller 与鉴权路由回归。未做真机或后台预约验证。

## 2026-10-29 数据层增量与契约修正

- hotelSearch 的 stayBenefit=true 已在10-15测试发布中明确用于宿主マイル/Point特典，支持多晚；日期不符合的酒店仍返回，stayBenefitParticipate表示整段日期适用性。此结论取代10-28预览记录中“不解释为宿主マイル资格”的旧判断。
- SDK与领域数据增加列表detail/description，以及room/extraPerson报价pointTotal（可空），现有UI不使用新字段，预览页和单晚选择暂不改动。
- 权益接口/余额/过期提醒/等级规则由新的host_miles模块提供；有效预约室数为null时保持未知。
- 预约、支付、房间分配新增字段与旧券流程切换仍由后续任务处理；支付14与旧隐藏WeChat路径的编码冲突需届时核实。
- 来源、接口清单、完成口径和验证见 [StellaVia 数据接入](stellavia-data-integration.md)。

## 2026-10-29 酒店首页样式收敛

本期酒店首页/里程预览文字排版集中到 HotelHomeTextStyles；HotelHomeCard、里程入口与摘要外壳改用 SDK AppCard 的可选背景/边框/圆角能力。数据、预览标记、搜索与跳转行为不变，业务组合继续由 hotel_booking 持有。四语言小屏与预览交互回归通过。

## 2026-10-29 宿主マイル首页真实数据

- `/hotel-booking/host-miles` 已移除设计示例，接入 account-summary 的 availablePoints、user-tier-info 的 currentTier、remainingBookingRooms（maxRooms-currentBookingRooms，下限0）与 leadTimeMonths；缺失值为未知，部分接口失败不隐藏其他成功数据。
- 游客可查酒店，不请求账户接口；登录身份变化重建 autoDispose controller，旧请求不能回写。下拉刷新、返回登录及前台恢复刷新；同账号刷新失败保留有效旧值。
- 独立宿主里程列表固定 hotelSearch stayBenefit=true，支持地区/价格排序/人数/多晚日期与9条分页。旧券单晚选择器保留，通过显式 allowMultiNightBenefits 使用新多晚查询。变更查询条件清除旧列表，刷新保留旧列表，并拒绝迟到的旧查询/分页结果。
- 酒店图片/名称/地址/库存来自实际列表；stayBenefitParticipate 表示所选日期适用性，不等于账户可下单资格。列表缺少已确认的所需里程字段，显示未知，不把lowestPrice换算为里程。
- 卡片不进入详情/预定，预约按钮禁用并显示准备中；不接旧券校验、下单和支付。旧预览fixture保留为未引用外部实现，线上页面不再读取。
- 验证：涉及文件定向 analyze 通过；宿主首页 controller/widget 测试通过，覆盖游客、账号切换、刷新失败保留数据、分页、迟到响应和四语言320px/1.3字号；已查看390px页面截图，未做登录设备上的真实接口联调。变更范围 diff --check 通过。

## 2026-10-29 住宿管理根Tab

- 用户确认底部Tab同步调整为首页/基金/酒店/住宿管理/My Page；住宿管理复用HotelOrderListPage(isRootTab:true)，使用/bookings根路由、/bookings/:orderId详情。旧/hotel-booking/orders[/:orderId]保留重定向，避免旧路径被酒店动态:id误匹配。游客仍需登录，不扩大预约/支付范围。
- 根Tab去除返回按钮，保留现有订单过滤/分页/取消/支付。支持下拉、切回Tab、从订单详情返回、前台恢复刷新。
- 订单列表provider按登录身份重建；游客不请求，换号清空，disposed/较早请求不能回写，刷新失败保留旧列表。
- 验证：Tab/实际路由分支与旧路径匹配/鉴权回归28项通过，订单缓存与迟到响应2项通过；App/SDK定向analyze通过。已查看393px TabBar截图，四语言320px/放大字号和深色模式覆盖；未做真实设备订单联调。

### 2026-10-30 宿泊管理首页

- `/bookings` 改为独立 `HotelManagementPage`，顶部2×2入口恢复预约列表、入住办理、优惠券、常用宿泊者；保留既有页面、鉴权和业务流程。
- 预约历史迁至 `/bookings/history`，注册在动态orderId之前；`/hotel-booking/orders`兼容重定向到历史页。`/bookings/:orderId`及旧详情别名不变。历史页显示返回按钮，兜底返回宿泊管理。
- 下方参考Figma `8190:1492`「07 宿泊管理」最后两块：同時予約保有数与次の旅を予約する。前者使用user-tier-info的currentBookingRooms/maxRooms（不根据订单列表估算）；后者进入宿主マイル酒店首页。缺失数字显示—，加载失败保留旧值并可重试。
- tier资源按当前账号身份隔离，未登录不请求；支持下拉、根Tab、前台恢复及子页返回刷新。原四入口组件保留，新组合留在hotel_booking/presentation/widgets，复用SDK AppCard。
- 四语言布局及五入口跳转、账号隔离/错误缓存、主路由顺序与鉴权回归已覆盖；未新增预定提交流程。

宿泊管理首页顶部沿用原AppNavigationBar（白底、原字号、根Tab无返回按钮），不采用07设计的大标题导航；四宫格与下方两块保持。

## 2026-10-30: Common hotel detail redesign (04)

- Regular hotel cards and host-miles hotel cards now open the redesigned gallery, introduction, room selection, totals and hotel guide. Date/guest editing remains available; editing either discards the previous selection/quote.
- `HotelDetailRouteArgs.mode` explicitly distinguishes regular from host miles. The old fund-stay-voucher `stayBenefit` rules remain in `LegacyHotelDetailPage`; host miles never enters the one-night/voucher amount checks.
- `HotelDetailSelectionController` owns quantity/assignment/quote state; the session key includes hotel data, search criteria, locale, account identity and mode. Disposed sessions ignore late network results. Sold-out/minimum-stay/known room-limit constraints disable increments; failed requests clear stale totals and expose retry.
- Regular booking uses assignment price and preserves login/profile completion, final occupancy check, server-message confirmation and the existing confirmation seed. Host miles uses the existing quote `pointTotal`, account balance and tier remaining rooms. No per-room/night miles are invented; missing points remain unknown. Remaining balance/room values are estimates, with no account mutation.
- Cancellation text is `HotelDetail.refundPolicyText`, already fetched via `/pms/refundStrategyText` for the hotel/check-in/language. The sample design's fixed points-refund schedule is not hardcoded.
- Host-miles submission/payment remain out of this slice: the CTA explicitly says coming soon and cannot enter ordinary/voucher checkout. The detail shows tier lead-time guidance; final date eligibility and miles redemption still require the subsequent booking-flow integration.
- Generic UI primitives/fonts/tokens are reused. Hotel-specific composition lives in feature widgets; typography/display mapping and selection state are in support/controllers. Original Figma SVG assets are bundled locally; photos remain API supplied.
- Validation: controller tests cover money vs miles, quote payload, missing/error totals, inventory/minimum stay/room limits and late responses. Four-locale mobile layout tests check cards, totals and API cancellation text; entry tests verify explicit host-miles routing. The hotel-module/router suite passed 50 tests, and targeted analysis passed for touched files. No live reservation was submitted.

- 2026-10-30 滚动显隐：新版酒店详情顶部标准导航栏与底部预约栏共用 SDK 滚动显隐机制，向下浏览隐藏、反向滑动出现、回到顶部恢复。页面持有独立状态；普通／里程两种模式共用，旧住宿券页维持原实现。新增实际拖动测试验证两栏同步折叠／恢复；相关详情和主壳 13 项测试通过。

- 顶部显隐修正：解决带 47 px 顶部安全区时 AppNavigationBar Column 在动画中间帧高度不足的 overflow。顶部使用 AppScrollNavigationBar 保持 65 px 内部尺寸并整体平移；底部价格区域未变更。逐帧回归验证内部高度恒定、位置随 reveal 变化及无布局异常，详情页 10 项测试通过。

- 根 Tab 顶栏补接：酒店首页品牌导航与宿泊管理导航现在读取主壳显隐状态，随底部 Tab 同步出现／隐藏；酒店搜索筛选仍在列表内。App 首页同步修正。相关既有页面测试 10 项和新增根 Tab 状态／高度测试 3 项通过。
