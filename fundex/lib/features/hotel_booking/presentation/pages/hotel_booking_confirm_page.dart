import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../support/hotel_booking_text_styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/support/app_request_error_message_resolver.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../member_profile/presentation/providers/mypage_providers.dart';
import '../../domain/entities/hotel_models.dart';
import '../providers/hotel_booking_providers.dart';
import '../providers/hotel_management_providers.dart';
import '../providers/hotel_detail_membership_provider.dart';
import '../providers/hotel_host_miles_provider.dart';
import '../support/hotel_reference_miles_display.dart';
import '../support/hotel_booking_presenter.dart';
import '../support/hotel_booking_result_route_args.dart';
import '../support/hotel_phone_intl_codes.dart';
import '../support/hotel_room_guest_form_targets.dart';
import '../widgets/hotel_booking_extra_sections.dart';
import '../widgets/hotel_booking_guest_form_section.dart';
import '../widgets/hotel_booking_order_summary_card.dart';
import '../widgets/hotel_booking_miles_review.dart';
import '../widgets/hotel_regular_booking_button.dart';
import '../support/hotel_detail_display.dart';
import '../widgets/hotel_booking_payment_section.dart';
import '../widgets/hotel_booking_service_footer.dart';
import '../widgets/hotel_booking_section_card.dart';
import '../widgets/hotel_coupon_list_widgets.dart';
import '../widgets/hotel_member_contact_picker_sheet.dart';
import '../widgets/hotel_state_views.dart';

class HotelBookingConfirmPage extends ConsumerStatefulWidget {
  const HotelBookingConfirmPage({super.key, required this.seed});

  final HotelBookingConfirmSeed seed;

  @override
  ConsumerState<HotelBookingConfirmPage> createState() =>
      _HotelBookingConfirmPageState();
}

class _HotelBookingConfirmPageState
    extends ConsumerState<HotelBookingConfirmPage> {
  late final TextEditingController _bookerFirstNameController;
  late final TextEditingController _bookerLastNameController;
  late final TextEditingController _bookerEmailController;
  late final TextEditingController _bookerPhoneController;
  late final TextEditingController _invoiceController;
  late final TextEditingController _messageController;
  late final List<TextEditingController> _roomFirstNameControllers;
  late final List<TextEditingController> _roomLastNameControllers;
  late final List<TextEditingController> _roomEmailControllers;
  late final List<TextEditingController> _roomPhoneControllers;
  late final List<HotelRoomGuestFormTarget> _roomGuestTargets;
  late final List<int> _roomAdults;
  late final List<int> _roomKids;
  HotelBookingPaymentMethod _paymentMethod =
      HotelBookingPaymentMethod.creditCard;
  String? _bookerCountryCode = 'JP';
  String _bookerIntlCode = '+81';
  final List<String?> _roomCountryCodes = <String?>[];
  final List<String> _roomIntlCodes = <String>[];
  bool _useGuestNameForInvoice = true;
  bool _useBookerInfoForFirstRoomGuest = true;
  bool _didApplyBookerAuthUser = false;
  bool _isSubmitting = false;
  bool _acceptedPolicy = false;
  bool _isQuoting = false;
  num? _requiredMiles;
  int _quoteRevision = 0;
  HotelCoupon? _selectedCoupon;
  HotelFundBenefitTicket? _selectedFundBenefitTicket;
  final List<HotelFundBenefitTicket> _fundBenefitTickets =
      const <HotelFundBenefitTicket>[];
  num? _quotedAmountOverride;
  num? _quotedOriginalAmountOverride;
  List<HotelBookingRoomPriceElement> _roomPriceElements =
      const <HotelBookingRoomPriceElement>[];

  @override
  void initState() {
    super.initState();
    _bookerFirstNameController = TextEditingController();
    _bookerLastNameController = TextEditingController();
    _bookerEmailController = TextEditingController();
    _bookerPhoneController = TextEditingController();
    _invoiceController = TextEditingController();
    _messageController = TextEditingController();
    _bookerFirstNameController.addListener(_handleBookerInfoChanged);
    _bookerLastNameController.addListener(_handleBookerInfoChanged);
    _bookerEmailController.addListener(_handleBookerInfoChanged);
    _bookerPhoneController.addListener(_handleBookerInfoChanged);
    _roomFirstNameControllers = <TextEditingController>[];
    _roomLastNameControllers = <TextEditingController>[];
    _roomEmailControllers = <TextEditingController>[];
    _roomPhoneControllers = <TextEditingController>[];
    _roomGuestTargets = buildHotelRoomGuestTargets(widget.seed);
    _roomAdults = <int>[];
    _roomKids = <int>[];
    for (final target in _roomGuestTargets) {
      _roomFirstNameControllers.add(TextEditingController());
      _roomLastNameControllers.add(TextEditingController());
      _roomEmailControllers.add(TextEditingController());
      _roomPhoneControllers.add(TextEditingController());
      _roomAdults.add(target.initialAdults);
      _roomKids.add(target.initialKids);
      _roomCountryCodes.add('JP');
      _roomIntlCodes.add('+81');
    }
    _syncFirstRoomGuestFromBooker();
    if (widget.seed.hostMiles) {
      _requoteCurrentGuests();
    }
  }

  @override
  void dispose() {
    _bookerFirstNameController.removeListener(_handleBookerInfoChanged);
    _bookerLastNameController.removeListener(_handleBookerInfoChanged);
    _bookerEmailController.removeListener(_handleBookerInfoChanged);
    _bookerPhoneController.removeListener(_handleBookerInfoChanged);
    _bookerFirstNameController.dispose();
    _bookerLastNameController.dispose();
    _bookerEmailController.dispose();
    _bookerPhoneController.dispose();
    _invoiceController.dispose();
    _messageController.dispose();
    for (final controller in <TextEditingController>[
      ..._roomFirstNameControllers,
      ..._roomLastNameControllers,
      ..._roomEmailControllers,
      ..._roomPhoneControllers,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(context).toLanguageTag(),
    );
    final preparationState = ref.watch(
      hotelBookingPreparationProvider(widget.seed),
    );
    final authUserState = ref.watch(currentAuthUserProvider);
    final miles = widget.seed.hostMiles;
    final accountStatisticState = miles
        ? null
        : ref.watch(myPageAccountStatisticProvider);
    final identity = miles ? ref.watch(hotelManagementIdentityProvider) : null;
    final tier = identity == null
        ? null
        : ref.watch(hotelManagementTierResourceProvider(identity)).valueOrNull;
    final balance = identity == null
        ? null
        : ref
                  .watch(hotelDetailAccountProvider(identity))
                  .valueOrNull
                  ?.availablePoints ??
              tier?.pointsBalance;
    final roomLimit = tier?.remainingBookingRooms;
    final roomCount = _roomGuestTargets.length;
    final insufficient =
        _requiredMiles != null && balance != null && _requiredMiles! > balance;
    final tooManyRooms = roomLimit != null && roomCount > roomLimit;
    final policyQuery = HotelDetailQuery(
      hotelId: widget.seed.detail.id,
      criteria: widget.seed.criteria,
    );
    var policy = hotelDetailPlainText(widget.seed.detail.refundPolicyText);
    if (miles && policy.isEmpty) {
      policy = hotelDetailPlainText(
        ref
                .watch(hotelDetailProvider(policyQuery))
                .valueOrNull
                ?.refundPolicyText ??
            '',
      );
    }
    _scheduleBookerAuthUserApply(authUserState.valueOrNull);
    final preparation = preparationState.valueOrNull;
    final effectiveRoomPriceElements = _roomPriceElements.isNotEmpty
        ? _roomPriceElements
        : preparation?.roomPriceElements ??
              const <HotelBookingRoomPriceElement>[];
    final amount =
        _quotedAmountOverride ??
        preparation?.quotedPrice ??
        widget.seed.fallbackAmount;
    final usesFundBenefitTicket = _selectedFundBenefitTicket != null;
    final payableAmount = usesFundBenefitTicket ? 0 : amount;
    final originalAmount = usesFundBenefitTicket
        ? amount
        : _quotedOriginalAmountOverride ?? preparation?.originalPrice;
    final amountText = presenter.price(payableAmount);
    final couponEntryCount =
        (preparation?.couponsAvailableCount ?? 0) +
        (widget.seed.criteria.stayBenefit ? _fundBenefitTickets.length : 0);

    return Scaffold(
      appBar: AppNavigationBar(
        title: context.l10n.hotelBookingConfirmTitle,
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
          backgroundColor: colors.surface.withValues(alpha: 0),
          foregroundColor: colors.textPrimary,
        ),
      ),
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 132),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(<Widget>[
                    if (preparationState.isLoading)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: LinearProgressIndicator(
                          color: colors.brandSecondary,
                          backgroundColor: colors.borderSoft,
                        ),
                      ),
                    if (preparationState.hasError)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: HotelInlineErrorNotice(
                          onRetry: () => ref.invalidate(
                            hotelBookingPreparationProvider(widget.seed),
                          ),
                        ),
                      ),
                    if (miles && !_isQuoting && _requiredMiles == null)
                      HotelInlineErrorNotice(onRetry: _requoteCurrentGuests),
                    if (miles && balance == null && identity != null)
                      HotelInlineErrorNotice(
                        onRetry: () {
                          ref.invalidate(hotelDetailAccountProvider(identity));
                          ref.invalidate(
                            hotelManagementTierResourceProvider(identity),
                          );
                        },
                      ),
                    if (tooManyRooms)
                      Text(context.l10n.hotelDetailRoomsInsufficient),
                    if (insufficient) ...[
                      Text(
                        context.l10n.hotelDetailMilesShortfall(
                          presenter.amount(_requiredMiles! - balance),
                        ),
                      ),
                      HotelRegularBookingButton(
                        hotelId: widget.seed.detail.id,
                        criteria: widget.seed.criteria,
                      ),
                    ],
                    HotelBookingOrderSummaryCard(
                      seed: widget.seed,
                      presenter: presenter,
                      amount: miles ? _requiredMiles : payableAmount,
                      originalAmount: originalAmount,
                      selectedCoupon: _selectedCoupon,
                      selectedFundBenefitTicket: _selectedFundBenefitTicket,
                      showOriginalAmount: usesFundBenefitTicket,
                      onEdit: () => Navigator.of(context).maybePop(),
                    ),
                    if (!miles) ...<Widget>[
                      const SizedBox(height: 14),
                      HotelBookingCouponRow(
                        availableCount: couponEntryCount,
                        selectedCouponName: _couponRowSelectedName(presenter),
                        onTap: preparation == null
                            ? _showComingSoon
                            : () => _openCouponPicker(preparation),
                      ),
                    ],
                    if (!miles && !usesFundBenefitTicket) ...<Widget>[
                      const SizedBox(height: 14),
                      HotelBookingPaymentSection(
                        selected: _paymentMethod,
                        registeredCardCount:
                            preparation?.registeredCardCount ?? 0,
                        accountBalance: accountStatisticState
                            ?.valueOrNull
                            ?.withdrawableAmount,
                        isAccountBalanceLoading:
                            accountStatisticState?.isLoading ?? false,
                        payableAmount: amount ?? 0,
                        onChanged: (value) =>
                            setState(() => _paymentMethod = value),
                      ),
                    ],
                    const SizedBox(height: 14),
                    HotelBookingGuestFormSection(
                      title: context.l10n.hotelBookingBookerInfoTitle,
                      countryCodes: preparation?.countryCodes ?? const [],
                      firstNameController: _bookerFirstNameController,
                      lastNameController: _bookerLastNameController,
                      emailController: _bookerEmailController,
                      phoneController: _bookerPhoneController,
                      selectedCountryCode: _bookerCountryCode,
                      onCountryChanged: _setBookerCountryCode,
                      selectedIntlCode: _bookerIntlCode,
                      onIntlCodeChanged: _setBookerIntlCode,
                      isRequired: true,
                      onSavedContactTap: _openSavedContactPickerForBooker,
                    ),
                    const SizedBox(height: 14),
                    _RoomGuestFormsCard(
                      title: context.l10n.hotelBookingRoomGuestInfoTitle,
                      children: List<Widget>.generate(
                        _roomGuestTargets.length,
                        (index) {
                          final target = _roomGuestTargets[index];
                          final useBookerInfo =
                              index == 0 && _useBookerInfoForFirstRoomGuest;
                          final form = HotelBookingGuestFormSection(
                            title: context.l10n.hotelBookingRoomGuestInfoTitle,
                            roomName: _roomDisplayName(target),
                            countryCodes: preparation?.countryCodes ?? const [],
                            firstNameController:
                                _roomFirstNameControllers[index],
                            lastNameController: _roomLastNameControllers[index],
                            emailController: _roomEmailControllers[index],
                            phoneController: _roomPhoneControllers[index],
                            selectedCountryCode: _roomCountryCodes[index],
                            onCountryChanged: (value) => setState(
                              () => _roomCountryCodes[index] = value,
                            ),
                            selectedIntlCode: _roomIntlCodes[index],
                            onIntlCodeChanged: (value) =>
                                setState(() => _roomIntlCodes[index] = value),
                            adults: _roomAdults[index],
                            kids: _roomKids[index],
                            maxAdults: _maxAdultsFor(index),
                            maxKids: _maxKidsFor(index),
                            isRequired: true,
                            priceTipText: miles
                                ? ''
                                : _priceTipForRoom(
                                    index,
                                    effectiveRoomPriceElements,
                                  ),
                            showTitle: false,
                            showPhoneFields: false,
                            wrapInCard: false,
                            enabled: !useBookerInfo,
                            onSavedContactTap: useBookerInfo
                                ? null
                                : () => _openSavedContactPickerForRoom(index),
                            onAdultsChanged: (value) =>
                                _setRoomAdults(index, value),
                            onKidsChanged: (value) =>
                                _setRoomKids(index, value),
                          );
                          if (index != 0) {
                            return form;
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _UseBookerInfoCheckbox(
                                value: _useBookerInfoForFirstRoomGuest,
                                onChanged: _setUseBookerInfoForFirstRoomGuest,
                              ),
                              const SizedBox(height: 10),
                              form,
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 14),
                    HotelBookingInvoiceSection(
                      controller: _invoiceController,
                      useGuestName: _useGuestNameForInvoice,
                      onUseGuestNameChanged: (value) =>
                          setState(() => _useGuestNameForInvoice = value),
                    ),
                    const SizedBox(height: 14),
                    HotelBookingMessageSection(controller: _messageController),
                    const SizedBox(height: 18),
                    if (miles) ...[
                      HotelBookingMilesReview(
                        balance: balance,
                        cost: _requiredMiles,
                        roomCount: roomCount,
                        roomLimit: roomLimit,
                        policy: policy,
                        accepted: _acceptedPolicy,
                        onChanged: (value) =>
                            setState(() => _acceptedPolicy = value),
                        onRetryPolicy: () =>
                            ref.invalidate(hotelDetailProvider(policyQuery)),
                      ),
                      const SizedBox(height: 18),
                    ],
                    const HotelBookingServiceFooter(),
                  ]),
                ),
              ),
            ],
          ),
          if (_isQuoting)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: LinearProgressIndicator(
                  minHeight: 2,
                  color: colors.brandSecondary,
                  backgroundColor: colors.borderSoft.withValues(alpha: 0),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: HotelBookingConfirmBottomBar(
              amount: miles
                  ? (_requiredMiles == null
                        ? '—'
                        : hotelReferenceMilesLabel(context, _requiredMiles!))
                  : amountText.isEmpty
                  ? context.l10n.hotelPriceAsk
                  : '$amountText ${context.l10n.hotelCurrencyCode}',
              amountLabel: miles
                  ? context.l10n.hotelDetailRequiredMiles
                  : context.l10n.hotelDetailPayableAmount,
              onConfirm:
                  miles &&
                      (_isQuoting ||
                          _requiredMiles == null ||
                          balance == null ||
                          insufficient ||
                          tooManyRooms ||
                          !_acceptedPolicy ||
                          policy.isEmpty)
                  ? null
                  : () => _submitBooking(payableAmount),
              isSubmitting: _isSubmitting,
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon() {
    AppNotice.show(context, message: context.l10n.hotelDetailBookingComingSoon);
  }

  Future<void> _openSavedContactPickerForBooker() async {
    final contact = await showHotelMemberContactPickerSheet(context: context);
    if (!mounted || contact == null) {
      return;
    }
    _applyContactToBooker(contact);
  }

  Future<void> _openSavedContactPickerForRoom(int index) async {
    final contact = await showHotelMemberContactPickerSheet(context: context);
    if (!mounted || contact == null) {
      return;
    }
    _applyContactToRoom(index, contact);
  }

  void _applyContactToBooker(HotelMemberContact contact) {
    _setText(_bookerLastNameController, contact.lastName);
    _setText(_bookerFirstNameController, contact.firstName);
    _setText(_bookerEmailController, contact.email);
    _setText(_bookerPhoneController, contact.mobile);
    _setBookerCountryCode(
      contact.nationality.trim().isEmpty ? null : contact.nationality.trim(),
    );
    final intlCode = normalizeHotelPhoneIntlCode(contact.intlCode);
    if (intlCode != null) {
      _setBookerIntlCode(intlCode);
    }
  }

  void _applyContactToRoom(int index, HotelMemberContact contact) {
    if (index < 0 || index >= _roomGuestTargets.length) {
      return;
    }
    setState(() {
      _setText(_roomLastNameControllers[index], contact.lastName);
      _setText(_roomFirstNameControllers[index], contact.firstName);
      _setText(_roomEmailControllers[index], contact.email);
      _setText(_roomPhoneControllers[index], contact.mobile);
      _roomCountryCodes[index] = contact.nationality.trim().isEmpty
          ? null
          : contact.nationality.trim();
      final intlCode = normalizeHotelPhoneIntlCode(contact.intlCode);
      if (intlCode != null) {
        _roomIntlCodes[index] = intlCode;
      }
    });
  }

  String? _couponRowSelectedName(HotelBookingPresenter presenter) {
    final couponName = _selectedCoupon?.name.trim();
    if (couponName != null && couponName.isNotEmpty) {
      return couponName;
    }
    final ticket = _selectedFundBenefitTicket;
    if (ticket == null) {
      return null;
    }
    return '宿泊特典・${presenter.amount(ticket.benefitAmount)}円';
  }

  int? _maxGuestsFor(int index) {
    final maxGuests = _roomGuestTargets[index].maxGuests;
    return maxGuests != null && maxGuests > 0 ? maxGuests : null;
  }

  int? _maxAdultsFor(int index) {
    final maxAdults =
        _roomGuestTargets[index].maxAdults ?? _maxGuestsFor(index);
    return maxAdults != null && maxAdults > 0 ? maxAdults : null;
  }

  int? _maxKidsFor(int index) {
    final maxKids = _roomGuestTargets[index].maxKids;
    return maxKids != null && maxKids > 0 ? maxKids : _maxAdultsFor(index);
  }

  void _setRoomAdults(int index, int value) {
    final maxAdults = _maxAdultsFor(index) ?? 99;
    final nextAdults = value.clamp(1, maxAdults).toInt();
    if (nextAdults == _roomAdults[index]) {
      return;
    }
    setState(() {
      _roomAdults[index] = nextAdults;
    });
    _requoteCurrentGuests();
  }

  void _setRoomKids(int index, int value) {
    final maxKids = _maxKidsFor(index) ?? 99;
    final nextKids = value.clamp(0, maxKids).toInt();
    if (nextKids == _roomKids[index]) {
      return;
    }
    setState(() {
      _roomKids[index] = nextKids;
    });
    _requoteCurrentGuests();
  }

  Future<void> _requoteCurrentGuests() async {
    final revision = ++_quoteRevision;
    setState(() {
      _isQuoting = true;
      _requiredMiles = null;
    });
    try {
      final quote = await ref.read(quoteHotelBookingPriceUseCaseProvider)(
        _buildQuoteRequest(_selectedCoupon),
      );
      if (!mounted || revision != _quoteRevision) {
        return;
      }
      setState(() {
        _requiredMiles = (quote.pointsRequired ?? -1) >= 0
            ? quote.pointsRequired
            : null;
        _quotedAmountOverride = quote.quotedPrice ?? widget.seed.fallbackAmount;
        _quotedOriginalAmountOverride = quote.originalPrice;
        _roomPriceElements = quote.roomPriceElements;
        _isQuoting = false;
      });
    } catch (_) {
      if (!mounted || revision != _quoteRevision) {
        return;
      }
      setState(() => _isQuoting = false);
      AppNotice.show(context, message: context.l10n.hotelBookingCreateFailed);
    }
  }

  Future<void> _openCouponPicker(HotelBookingPreparation preparation) async {
    final referenceAmount =
        _quotedAmountOverride ??
        preparation.quotedPrice ??
        widget.seed.fallbackAmount;
    final result = await showHotelCouponPickerSheet(
      context: context,
      coupons: preparation.coupons,
      pageTexts: preparation.pageTexts,
      selectedCouponId: _selectedCoupon?.id,
      fundBenefitTickets: widget.seed.criteria.stayBenefit
          ? _fundBenefitTickets
          : const <HotelFundBenefitTicket>[],
      selectedFundBenefitTicketId: _selectedFundBenefitTicket?.id,
      fundBenefitReferenceAmount: referenceAmount,
    );
    if (!mounted || result == null) {
      return;
    }
    if (result.shouldClear) {
      final hadCoupon = _selectedCoupon != null;
      setState(() {
        _selectedCoupon = null;
        _selectedFundBenefitTicket = null;
      });
      if (hadCoupon) {
        await _requoteCouponSelection(null, preparation);
      }
      return;
    }
    final nextFundBenefitTicket = result.fundBenefitTicket;
    if (nextFundBenefitTicket != null) {
      final hadCoupon = _selectedCoupon != null;
      setState(() {
        _selectedCoupon = null;
        _selectedFundBenefitTicket = nextFundBenefitTicket;
      });
      if (hadCoupon) {
        await _requoteCouponSelection(null, preparation);
      }
      return;
    }
    final nextCoupon = result.coupon;
    if (nextCoupon?.id == _selectedCoupon?.id) {
      return;
    }
    setState(() {
      _selectedCoupon = nextCoupon;
      _selectedFundBenefitTicket = null;
    });
    await _requoteCouponSelection(nextCoupon, preparation);
  }

  Future<void> _requoteCouponSelection(
    HotelCoupon? nextCoupon,
    HotelBookingPreparation preparation,
  ) async {
    try {
      final quote = await AppLoadingDialog.run(
        context,
        () => ref.read(quoteHotelBookingPriceUseCaseProvider)(
          _buildQuoteRequest(nextCoupon),
        ),
        message: context.l10n.commonPleaseWait,
      );
      if (!mounted) {
        return;
      }
      _quoteRevision += 1;
      setState(() {
        _quotedAmountOverride =
            quote.quotedPrice ??
            preparation.quotedPrice ??
            widget.seed.fallbackAmount;
        _quotedOriginalAmountOverride = quote.originalPrice;
        _roomPriceElements = quote.roomPriceElements;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _selectedCoupon = null;
        _selectedFundBenefitTicket = null;
      });
      AppNotice.show(context, message: context.l10n.hotelBookingCreateFailed);
    }
  }

  Future<void> _submitBooking(num? amount) async {
    if (_isSubmitting ||
        (widget.seed.hostMiles &&
            (!_acceptedPolicy || _isQuoting || _requiredMiles == null))) {
      return;
    }
    final draft = _buildCreateDraft(amount);
    if (draft == null) {
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      final orderId = await AppLoadingDialog.run(
        context,
        () => ref.read(createHotelBookingUseCaseProvider)(draft),
        message: context.l10n.commonPleaseWait,
      );
      if (!mounted) {
        return;
      }
      setState(() => _isSubmitting = false);
      if (widget.seed.hostMiles) {
        ref.invalidate(hotelHostMilesProvider);
        ref.invalidate(hotelDetailAccountProvider);
        ref.invalidate(hotelManagementTierResourceProvider);
        ref.invalidate(hotelOrderListControllerProvider);
      }
      context.go(
        '/hotel-booking/${Uri.encodeComponent(widget.seed.detail.id)}/result',
        extra: HotelBookingResultRouteArgs(
          orderId: orderId,
          seed: widget.seed,
          totalAmount: draft.totalAmount,
          requiredMiles: widget.seed.hostMiles ? _requiredMiles : null,
          paymentMethod:
              !widget.seed.hostMiles && _selectedFundBenefitTicket == null
              ? _paymentMethod
              : null,
          createdAt: DateTime.now().toIso8601String(),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _isSubmitting = false);
      AppNotice.show(
        context,
        message: resolveAppRequestErrorMessage(
          error,
          context.l10n.hotelBookingCreateFailed,
        ),
      );
    }
  }

  HotelBookingCreateDraft? _buildCreateDraft(num? amount) {
    final booker = HotelBookingPersonDraft(
      firstName: _bookerFirstNameController.text.trim(),
      lastName: _bookerLastNameController.text.trim(),
      nationality: (_bookerCountryCode ?? '').trim(),
      intlCode: _bookerIntlCode.trim(),
      mobile: _bookerPhoneController.text.trim(),
      email: _bookerEmailController.text.trim(),
    );
    if (booker.firstName.isEmpty ||
        booker.lastName.isEmpty ||
        booker.nationality.isEmpty ||
        booker.mobile.isEmpty ||
        booker.email.isEmpty) {
      AppNotice.show(
        context,
        message: context.l10n.hotelBookingRequiredFieldsMissing,
      );
      return null;
    }
    final totalAmount = amount ?? widget.seed.fallbackAmount ?? 0;
    if (totalAmount < 0 ||
        (totalAmount == 0 &&
            !widget.seed.hostMiles &&
            _selectedFundBenefitTicket == null)) {
      AppNotice.show(context, message: context.l10n.hotelBookingCreateFailed);
      return null;
    }
    final roomGuests = _buildRoomGuestDrafts();
    if (roomGuests == null) {
      return null;
    }
    return HotelBookingCreateDraft(
      seed: widget.seed,
      languageCode: ref.read(hotelLocaleLanguageCodeProvider),
      totalAmount: totalAmount,
      booker: booker,
      roomGuests: roomGuests,
      receiptTitle: _useGuestNameForInvoice
          ? booker.fullName
          : _invoiceController.text.trim(),
      comment: _messageController.text.trim(),
      selectedCoupons: widget.seed.hostMiles || _selectedCoupon?.id == null
          ? const <HotelBookingSelectedCoupon>[]
          : <HotelBookingSelectedCoupon>[
              HotelBookingSelectedCoupon(couponId: _selectedCoupon!.id!),
            ],
      fundBenefitTicketNo: _selectedFundBenefitTicket?.ticketNo.trim() ?? '',
    );
  }

  List<HotelBookingRoomGuestDraft>? _buildRoomGuestDrafts() {
    final guests = <HotelBookingRoomGuestDraft>[];
    for (var index = 0; index < _roomGuestTargets.length; index += 1) {
      final guest = HotelBookingRoomGuestDraft(
        firstName: _roomFirstNameControllers[index].text.trim(),
        lastName: _roomLastNameControllers[index].text.trim(),
        nationality: (_roomCountryCodes[index] ?? '').trim(),
        email: _roomEmailControllers[index].text.trim(),
        adults: _roomAdults[index],
        children: _roomKids[index],
      );
      if (guest.firstName.isEmpty ||
          guest.lastName.isEmpty ||
          guest.nationality.isEmpty) {
        AppNotice.show(
          context,
          message: context.l10n.hotelBookingRoomGuestRequiredFieldsMissing,
        );
        return null;
      }
      guests.add(guest);
    }
    return guests;
  }

  HotelBookingQuoteRequest _buildQuoteRequest(HotelCoupon? coupon) {
    return HotelBookingQuoteRequest(
      stayBenefit: widget.seed.hostMiles,
      hotelId: widget.seed.detail.id,
      checkIn: widget.seed.criteria.checkInDate,
      checkOut: widget.seed.criteria.checkOutDate,
      languageCode: ref.read(hotelLocaleLanguageCodeProvider),
      rooms: List<HotelBookingQuoteRoom>.generate(
        _roomGuestTargets.length,
        (index) => HotelBookingQuoteRoom(
          roomTypeId: _roomGuestTargets[index].room.id,
          occupancy: _roomAdults[index] + _roomKids[index],
        ),
      ),
      coupons: widget.seed.hostMiles || coupon?.id == null
          ? const <HotelBookingSelectedCoupon>[]
          : <HotelBookingSelectedCoupon>[
              HotelBookingSelectedCoupon(couponId: coupon!.id!),
            ],
      usesRoomPlanSelection: widget.seed.usesRoomPlanSelection,
      selectedRooms: widget.seed.selectedRooms,
    );
  }

  void _scheduleBookerAuthUserApply(AuthUser? user) {
    if (user == null || _didApplyBookerAuthUser) {
      return;
    }
    _didApplyBookerAuthUser = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _applyBookerAuthUser(user);
    });
  }

  void _applyBookerAuthUser(AuthUser user) {
    final name = _resolveBookerAuthUserName(user);
    _setTextIfEmpty(_bookerLastNameController, name.lastName);
    _setTextIfEmpty(_bookerFirstNameController, name.firstName);
    _setTextIfEmpty(_bookerEmailController, user.email ?? '');
    _setTextIfEmpty(
      _bookerPhoneController,
      _firstNonEmpty(<String?>[user.phone, user.mobile]),
    );

    final intlCode = normalizeHotelPhoneIntlCode(user.intlTelCode ?? '');
    if (intlCode != null && _bookerIntlCode == '+81') {
      _setBookerIntlCode(intlCode);
    }
  }

  void _handleBookerInfoChanged() {
    _syncFirstRoomGuestFromBooker();
  }

  void _setBookerCountryCode(String? value) {
    setState(() {
      _bookerCountryCode = value;
      if (_useBookerInfoForFirstRoomGuest && _roomCountryCodes.isNotEmpty) {
        _roomCountryCodes[0] = value;
      }
    });
  }

  void _setBookerIntlCode(String value) {
    setState(() {
      _bookerIntlCode = value;
      if (_useBookerInfoForFirstRoomGuest && _roomIntlCodes.isNotEmpty) {
        _roomIntlCodes[0] = value;
      }
    });
  }

  void _setUseBookerInfoForFirstRoomGuest(bool value) {
    setState(() {
      _useBookerInfoForFirstRoomGuest = value;
      if (value) {
        _syncFirstRoomGuestFromBooker();
      }
    });
  }

  void _syncFirstRoomGuestFromBooker() {
    if (!_useBookerInfoForFirstRoomGuest || _roomGuestTargets.isEmpty) {
      return;
    }
    _setText(_roomLastNameControllers[0], _bookerLastNameController.text);
    _setText(_roomFirstNameControllers[0], _bookerFirstNameController.text);
    _setText(_roomEmailControllers[0], _bookerEmailController.text);
    _setText(_roomPhoneControllers[0], _bookerPhoneController.text);
    if (_roomCountryCodes.isNotEmpty) {
      _roomCountryCodes[0] = _bookerCountryCode;
    }
    if (_roomIntlCodes.isNotEmpty) {
      _roomIntlCodes[0] = _bookerIntlCode;
    }
  }

  void _setTextIfEmpty(TextEditingController controller, String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || controller.text.trim().isNotEmpty) {
      return;
    }
    controller.text = trimmed;
  }

  void _setText(TextEditingController controller, String value) {
    if (controller.text == value) {
      return;
    }
    controller.text = value;
  }

  _BookerAuthUserName _resolveBookerAuthUserName(AuthUser user) {
    return _BookerAuthUserName(
      lastName: _firstNonEmpty(<String?>[user.firstName, user.firstNameEn]),
      firstName: _firstNonEmpty(<String?>[user.lastName, user.lastNameEn]),
    );
  }

  String _firstNonEmpty(Iterable<String?> values) {
    for (final value in values) {
      final trimmed = value?.trim() ?? '';
      if (trimmed.isNotEmpty) {
        return trimmed;
      }
    }
    return '';
  }

  String _roomDisplayName(HotelRoomGuestFormTarget target) {
    final base = target.room.name.trim().isEmpty
        ? widget.seed.detail.name
        : target.room.name.trim();
    if (!widget.seed.usesRoomPlanSelection) {
      return base;
    }
    return '$base #${target.instanceNumber}';
  }

  String _priceTipForRoom(
    int index,
    List<HotelBookingRoomPriceElement> priceElements,
  ) {
    if (index < priceElements.length) {
      final row = priceElements[index];
      final roomTypeId = row.roomTypeId.trim();
      if (roomTypeId.isEmpty ||
          roomTypeId == _roomGuestTargets[index].room.id) {
        return row.priceTip;
      }
    }
    final roomId = _roomGuestTargets[index].room.id;
    for (final row in priceElements) {
      if (row.roomTypeId == roomId && row.priceTip.isNotEmpty) {
        return row.priceTip;
      }
    }
    return '';
  }
}

class _UseBookerInfoCheckbox extends StatelessWidget {
  const _UseBookerInfoCheckbox({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      visualDensity: VisualDensity.compact,
      value: value,
      activeColor: colors.brandPrimary,
      onChanged: (nextValue) => onChanged(nextValue ?? false),
      title: Text(
        context.l10n.hotelBookingUseBookerInfoForGuest,
        style: HotelBookingTextStyles.value(
          context,
        ).copyWith(color: colors.textSecondary, fontWeight: FontWeight.w700),
      ),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}

class _RoomGuestFormsCard extends StatelessWidget {
  const _RoomGuestFormsCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return HotelBookingSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: HotelBookingTextStyles.heading(
              context,
            ).copyWith(color: colors.textPrimary, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 18),
          for (var index = 0; index < children.length; index += 1) ...<Widget>[
            if (index > 0) ...<Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Divider(height: 1, color: colors.borderSoft),
              ),
            ],
            children[index],
          ],
        ],
      ),
    );
  }
}

class _BookerAuthUserName {
  const _BookerAuthUserName({required this.lastName, required this.firstName});

  final String lastName;
  final String firstName;
}
