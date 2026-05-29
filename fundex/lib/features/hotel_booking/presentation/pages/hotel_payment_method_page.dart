import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../settings/presentation/pages/settings_credit_card_page.dart';
import '../../domain/entities/hotel_models.dart';
import '../providers/hotel_booking_providers.dart';
import '../support/hotel_booking_presenter.dart';
import '../support/hotel_credit_card_payment_flow.dart';
import '../support/hotel_payment_route_args.dart';
import '../widgets/hotel_booking_payment_section.dart';
import '../widgets/hotel_payment_method_widgets.dart';
import '../widgets/hotel_status_bar_preference_scope.dart';

class HotelPaymentMethodPage extends ConsumerStatefulWidget {
  const HotelPaymentMethodPage({super.key, required this.args});

  final HotelPaymentRouteArgs args;

  @override
  ConsumerState<HotelPaymentMethodPage> createState() =>
      _HotelPaymentMethodPageState();
}

class _HotelPaymentMethodPageState
    extends ConsumerState<HotelPaymentMethodPage> {
  late HotelBookingPaymentMethod _paymentMethod =
      widget.args.initialPaymentMethod;
  HotelCreditCard? _selectedCard;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(context).toLanguageTag(),
    );
    final cardsState = ref.watch(hotelCreditCardsProvider);
    _syncSelectedCard(cardsState.valueOrNull ?? const <HotelCreditCard>[]);

    return HotelStatusBarPreferenceScope(
      immersive: false,
      child: Scaffold(
        backgroundColor: colors.surfaceAlt,
        appBar: AppNavigationBar(
          title: context.l10n.hotelPaymentPageTitle,
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
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 126),
              children: <Widget>[
                HotelPaymentOrderSummaryCard(
                  orderId: widget.args.orderId,
                  amount: widget.args.totalAmount,
                  presenter: presenter,
                ),
                const SizedBox(height: 14),
                HotelBookingPaymentSection(
                  selected: _paymentMethod,
                  registeredCardCount: cardsState.valueOrNull?.length ?? 0,
                  onChanged: (value) {
                    setState(() {
                      _paymentMethod = value;
                    });
                  },
                ),
                const SizedBox(height: 14),
                if (_paymentMethod == HotelBookingPaymentMethod.creditCard)
                  HotelPaymentCreditCardSection(
                    cards: cardsState.valueOrNull ?? const <HotelCreditCard>[],
                    selectedCard: _selectedCard,
                    isLoading: cardsState.isLoading,
                    onCardChanged: (card) {
                      setState(() {
                        _selectedCard = card;
                      });
                    },
                    onAddCard: _openAddCardPage,
                  ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: HotelPaymentBottomBar(
                isSubmitting: _isSubmitting,
                onPay: _submitPayment,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _syncSelectedCard(List<HotelCreditCard> cards) {
    if (_paymentMethod != HotelBookingPaymentMethod.creditCard ||
        cards.isEmpty) {
      return;
    }
    if (_selectedCard != null &&
        cards.any((card) => card.id == _selectedCard!.id)) {
      return;
    }
    final defaultCards = cards.where((card) => card.isDefault);
    _selectedCard = defaultCards.isNotEmpty ? defaultCards.first : cards.first;
  }

  Future<void> _openAddCardPage() async {
    final result = await context.push<Object?>(
      '/profile/settings/credit-card/add',
      extra: SettingsCreditCardAddRouteArgs.payment(payment: widget.args),
    );
    if (!mounted || result is! SettingsCreditCardAddResult) {
      return;
    }
    if (result.saved) {
      ref.invalidate(hotelCreditCardsProvider);
    }
    if (!result.paid) {
      return;
    }
    if (widget.args.redirectToOrderDetailOnSuccess) {
      goToHotelOrderDetail(context, widget.args.orderId);
      return;
    }
    context.pop(true);
  }

  Future<void> _submitPayment() async {
    if (_isSubmitting) {
      return;
    }
    if (_paymentMethod != HotelBookingPaymentMethod.creditCard) {
      AppNotice.show(context, message: context.l10n.hotelPaymentComingSoon);
      return;
    }
    if (_selectedCard == null) {
      AppNotice.show(context, message: context.l10n.hotelPaymentNoCreditCard);
      return;
    }

    setState(() => _isSubmitting = true);
    await runHotelCreditCardPaymentFlow(
      context: context,
      ref: ref,
      orderId: widget.args.orderId,
      paymentMethod: _paymentMethod,
      selectedCard: _selectedCard,
      onSuccess: () {
        if (!mounted) {
          return;
        }
        if (widget.args.redirectToOrderDetailOnSuccess) {
          goToHotelOrderDetail(context, widget.args.orderId);
          return;
        }
        context.pop(true);
      },
    );
    if (mounted) {
      setState(() => _isSubmitting = false);
    }
  }
}
