import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/status_bar/app_status_bar_providers.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/hotel_models.dart';
import '../providers/hotel_booking_providers.dart';
import '../support/hotel_booking_presenter.dart';
import '../support/hotel_booking_result_route_args.dart';
import '../widgets/hotel_booking_extra_sections.dart';
import '../widgets/hotel_booking_guest_form_section.dart';
import '../widgets/hotel_booking_order_summary_card.dart';
import '../widgets/hotel_booking_payment_section.dart';
import '../widgets/hotel_state_views.dart';
import '../widgets/hotel_status_bar_preference_scope.dart';

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
  late final List<int> _roomAdults;
  late final List<int> _roomKids;
  HotelBookingPaymentMethod _paymentMethod =
      HotelBookingPaymentMethod.creditCard;
  String? _bookerCountryCode = 'JP';
  String _bookerIntlCode = '+81';
  final List<String?> _roomCountryCodes = <String?>[];
  final List<String> _roomIntlCodes = <String>[];
  bool _useGuestNameForInvoice = true;
  bool _didApplyBookerAuthUser = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _bookerFirstNameController = TextEditingController();
    _bookerLastNameController = TextEditingController();
    _bookerEmailController = TextEditingController();
    _bookerPhoneController = TextEditingController();
    _invoiceController = TextEditingController();
    _messageController = TextEditingController();
    _roomFirstNameControllers = <TextEditingController>[];
    _roomLastNameControllers = <TextEditingController>[];
    _roomEmailControllers = <TextEditingController>[];
    _roomPhoneControllers = <TextEditingController>[];
    _roomAdults = <int>[];
    _roomKids = <int>[];
    for (final selection in widget.seed.selectedRooms) {
      _roomFirstNameControllers.add(TextEditingController());
      _roomLastNameControllers.add(TextEditingController());
      _roomEmailControllers.add(TextEditingController());
      _roomPhoneControllers.add(TextEditingController());
      _roomAdults.add(
        selection.room.occupancy ?? widget.seed.criteria.occupancy,
      );
      _roomKids.add(widget.seed.criteria.kids);
      _roomCountryCodes.add('JP');
      _roomIntlCodes.add('+81');
    }
  }

  @override
  void dispose() {
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
    _scheduleBookerAuthUserApply(authUserState.valueOrNull);
    final preparation = preparationState.valueOrNull;
    final amount = preparation?.quotedPrice ?? widget.seed.fallbackAmount;
    final amountText = presenter.price(amount);

    return HotelStatusBarPreferenceScope(
      immersive: false,
      immersiveOnPop: true,
      child: Scaffold(
        backgroundColor: colors.surfaceAlt,
        appBar: AppNavigationBar(
          title: context.l10n.hotelBookingConfirmTitle,
          backgroundColor: colors.surface,
          foregroundColor: colors.textPrimary,
          leading: AppNavigationIconButton(
            icon: Icons.arrow_back_rounded,
            onTap: () {
              ref.read(appImmersiveHotelStatusBarHintProvider.notifier).state =
                  true;
              context.pop();
            },
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
                      HotelBookingOrderSummaryCard(
                        seed: widget.seed,
                        presenter: presenter,
                        amount: amount,
                        couponsAvailableCount:
                            preparation?.couponsAvailableCount ?? 0,
                        onEdit: () => Navigator.of(context).maybePop(),
                      ),
                      const SizedBox(height: 14),
                      HotelBookingCouponRow(
                        availableCount: preparation?.couponsAvailableCount ?? 0,
                        onTap: _showComingSoon,
                      ),
                      const SizedBox(height: 14),
                      HotelBookingPaymentSection(
                        selected: _paymentMethod,
                        registeredCardCount:
                            preparation?.registeredCardCount ?? 0,
                        onChanged: (value) =>
                            setState(() => _paymentMethod = value),
                      ),
                      const SizedBox(height: 14),
                      HotelBookingGuestFormSection(
                        title: context.l10n.hotelBookingBookerInfoTitle,
                        countryCodes: preparation?.countryCodes ?? const [],
                        firstNameController: _bookerFirstNameController,
                        lastNameController: _bookerLastNameController,
                        emailController: _bookerEmailController,
                        phoneController: _bookerPhoneController,
                        selectedCountryCode: _bookerCountryCode,
                        onCountryChanged: (value) =>
                            setState(() => _bookerCountryCode = value),
                        selectedIntlCode: _bookerIntlCode,
                        onIntlCodeChanged: (value) =>
                            setState(() => _bookerIntlCode = value),
                        isRequired: true,
                      ),
                      const SizedBox(height: 14),
                      ...List<
                        Widget
                      >.generate(widget.seed.selectedRooms.length, (index) {
                        final selection = widget.seed.selectedRooms[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: HotelBookingGuestFormSection(
                            title: context.l10n.hotelBookingRoomGuestInfoTitle,
                            roomName: selection.room.name,
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
                            onAdultsChanged: (value) => setState(
                              () => _roomAdults[index] = value
                                  .clamp(1, 99)
                                  .toInt(),
                            ),
                            onKidsChanged: (value) => setState(
                              () =>
                                  _roomKids[index] = value.clamp(0, 99).toInt(),
                            ),
                          ),
                        );
                      }),
                      HotelBookingInvoiceSection(
                        controller: _invoiceController,
                        useGuestName: _useGuestNameForInvoice,
                        onUseGuestNameChanged: (value) =>
                            setState(() => _useGuestNameForInvoice = value),
                      ),
                      const SizedBox(height: 14),
                      HotelBookingMessageSection(
                        controller: _messageController,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: HotelBookingConfirmBottomBar(
                amount: amountText.isEmpty
                    ? context.l10n.hotelPriceAsk
                    : '$amountText ${context.l10n.hotelCurrencyCode}',
                amountLabel: context.l10n.hotelDetailPayableAmount,
                onConfirm: () => _submitBooking(amount),
                isSubmitting: _isSubmitting,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon() {
    AppNotice.show(context, message: context.l10n.hotelDetailBookingComingSoon);
  }

  Future<void> _submitBooking(num? amount) async {
    if (_isSubmitting) {
      return;
    }
    final draft = _buildCreateDraft(amount);
    if (draft == null) {
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      final orderId = await ref.read(createHotelBookingUseCaseProvider)(draft);
      if (!mounted) {
        return;
      }
      setState(() => _isSubmitting = false);
      context.go(
        '/hotel-booking/${Uri.encodeComponent(widget.seed.detail.id)}/result',
        extra: HotelBookingResultRouteArgs(
          orderId: orderId,
          seed: widget.seed,
          totalAmount: draft.totalAmount,
          paymentMethod: _paymentMethod,
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _isSubmitting = false);
      AppNotice.show(context, message: context.l10n.hotelBookingCreateFailed);
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
    if (totalAmount <= 0) {
      AppNotice.show(context, message: context.l10n.hotelBookingCreateFailed);
      return null;
    }
    return HotelBookingCreateDraft(
      seed: widget.seed,
      languageCode: ref.read(hotelLocaleLanguageCodeProvider),
      totalAmount: totalAmount,
      booker: booker,
      roomGuests: List<HotelBookingRoomGuestDraft>.generate(
        widget.seed.selectedRooms.length,
        (index) => HotelBookingRoomGuestDraft(
          firstName: _roomFirstNameControllers[index].text.trim(),
          lastName: _roomLastNameControllers[index].text.trim(),
          nationality: (_roomCountryCodes[index] ?? '').trim(),
          email: _roomEmailControllers[index].text.trim(),
          adults: _roomAdults[index],
          children: _roomKids[index],
        ),
      ),
      receiptTitle: _useGuestNameForInvoice
          ? booker.fullName
          : _invoiceController.text.trim(),
      comment: _messageController.text.trim(),
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

    final intlCode = _normalizeSupportedIntlCode(user.intlTelCode ?? '');
    if (intlCode != null && _bookerIntlCode == '+81') {
      setState(() => _bookerIntlCode = intlCode);
    }
  }

  void _setTextIfEmpty(TextEditingController controller, String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || controller.text.trim().isNotEmpty) {
      return;
    }
    controller.text = trimmed;
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

  String? _normalizeSupportedIntlCode(String rawCode) {
    final trimmed = rawCode.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final normalized = trimmed.startsWith('+') ? trimmed : '+$trimmed';
    return const <String>{'+81', '+86', '+82', '+1'}.contains(normalized)
        ? normalized
        : null;
  }
}

class _BookerAuthUserName {
  const _BookerAuthUserName({required this.lastName, required this.firstName});

  final String lastName;
  final String firstName;
}
