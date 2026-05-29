import 'dart:async';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/environment_provider.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../hotel_booking/domain/entities/hotel_models.dart';
import '../../../hotel_booking/presentation/providers/hotel_booking_providers.dart';
import '../../../hotel_booking/presentation/support/hotel_credit_card_payment_flow.dart';
import '../../../hotel_booking/presentation/support/hotel_payment_route_args.dart';
import '../widgets/settings_credit_card_widgets.dart';

class SettingsCreditCardAddRouteArgs {
  const SettingsCreditCardAddRouteArgs.payment({required this.payment});

  final HotelPaymentRouteArgs payment;
}

class SettingsCreditCardAddResult {
  const SettingsCreditCardAddResult({required this.saved, required this.paid});

  final bool saved;
  final bool paid;
}

class SettingsCreditCardPage extends ConsumerWidget {
  const SettingsCreditCardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final cardsState = ref.watch(hotelCreditCardsProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: context.l10n.creditCardListTitle,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(hotelCreditCardsProvider.future),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: <Widget>[
            SettingsRegisteredCreditCardSection(
              cardsState: cardsState,
              onRetry: () => ref.invalidate(hotelCreditCardsProvider),
              onDelete: (card) => _deleteCard(context, ref, card),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: PrimaryCtaButton(
            label: context.l10n.creditCardAddAction,
            horizontalPadding: 0,
            onPressed: () => _openAddPage(context, ref),
          ),
        ),
      ),
    );
  }

  Future<void> _openAddPage(BuildContext context, WidgetRef ref) async {
    final result = await context.push<Object?>(
      '/profile/settings/credit-card/add',
    );
    final added =
        result == true ||
        (result is SettingsCreditCardAddResult && result.saved);
    if (!context.mounted || !added) {
      return;
    }
    ref.invalidate(hotelCreditCardsProvider);
    AppNotice.show(context, message: context.l10n.creditCardSaved);
  }

  Future<void> _deleteCard(
    BuildContext context,
    WidgetRef ref,
    HotelCreditCard card,
  ) async {
    final l10n = context.l10n;
    final confirmed = await AppDialogs.showAdaptiveAlert<bool>(
      context: context,
      title: l10n.creditCardDeleteConfirmTitle,
      message: l10n.creditCardDeleteConfirmBody,
      barrierDismissible: false,
      actions: <AppDialogAction<bool>>[
        AppDialogAction<bool>(label: l10n.commonCancel, value: false),
        AppDialogAction<bool>(
          label: l10n.creditCardDeleteAction,
          value: true,
          isDestructive: true,
        ),
      ],
    );
    if (!context.mounted || confirmed != true) {
      return;
    }
    try {
      final message = await AppLoadingDialog.run(
        context,
        () => ref.read(unregisterHotelCreditCardUseCaseProvider)(card.id),
      );
      if (!context.mounted) {
        return;
      }
      ref.invalidate(hotelCreditCardsProvider);
      AppNotice.show(
        context,
        message: message.trim().isEmpty ? l10n.creditCardDeleted : message,
      );
    } catch (_) {
      if (context.mounted) {
        AppNotice.show(context, message: l10n.creditCardDeleteFailed);
      }
    }
  }
}

class SettingsCreditCardAddPage extends ConsumerStatefulWidget {
  const SettingsCreditCardAddPage({super.key, this.args});

  final SettingsCreditCardAddRouteArgs? args;

  @override
  ConsumerState<SettingsCreditCardAddPage> createState() =>
      _SettingsCreditCardAddPageState();
}

class _SettingsCreditCardAddPageState
    extends ConsumerState<SettingsCreditCardAddPage> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _holderController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final FocusNode _cvvFocusNode = FocusNode();

  String? _selectedMonth;
  String? _selectedYear;
  String _mobileCountryCode = '81';
  bool _isDefault = true;
  bool _isCvvFocused = false;
  bool _isSaving = false;

  bool get _isPaymentMode => widget.args != null;

  @override
  void initState() {
    super.initState();
    _cvvFocusNode.addListener(_handleCvvFocusChanged);
    unawaited(_seedContactFields());
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _holderController.dispose();
    _cvvController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _cvvFocusNode
      ..removeListener(_handleCvvFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _handleCvvFocusChanged() {
    if (_isCvvFocused == _cvvFocusNode.hasFocus) {
      return;
    }
    setState(() {
      _isCvvFocused = _cvvFocusNode.hasFocus;
    });
  }

  Future<void> _seedContactFields() async {
    final user = await ref.read(currentAuthUserProvider.future);
    if (!mounted || user == null) {
      return;
    }
    final holderName = _preferredCardholderName(user);
    if (_holderController.text.trim().isEmpty && holderName.isNotEmpty) {
      _holderController.text = holderName;
    }
    if (_emailController.text.trim().isEmpty) {
      _emailController.text = user.email?.trim() ?? '';
    }
    if (_mobileController.text.trim().isEmpty) {
      _mobileController.text = _firstNonEmpty(<String?>[
        user.phone,
        user.mobile,
      ]);
    }
    final intlCode = _normalizeIntlCode(user.intlTelCode ?? '');
    if (intlCode.isNotEmpty) {
      setState(() {
        _mobileCountryCode = intlCode;
      });
    }
  }

  Future<void> _submit() async {
    if (_isSaving) {
      return;
    }
    final l10n = context.l10n;
    final cardNumber = _cardNumberController.text
        .split('')
        .where(_isAsciiDigit)
        .join();
    final holder = _holderController.text.trim();
    final cvv = _cvvController.text.trim();
    final email = _emailController.text.trim();
    final mobile = _mobileController.text.trim();
    final month = _selectedMonth;
    final year = _selectedYear;
    final tokenApiKey = ref.read(veritransTokenApiKeyProvider).trim();

    if (cardNumber.length < 12 ||
        holder.isEmpty ||
        cvv.isEmpty ||
        month == null ||
        year == null ||
        (email.isEmpty && mobile.isEmpty)) {
      AppNotice.show(context, message: l10n.creditCardValidationRequired);
      return;
    }
    if (tokenApiKey.isEmpty) {
      AppNotice.show(context, message: l10n.creditCardTokenKeyMissing);
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final token = await ref.read(createHotelCreditCardTokenUseCaseProvider)(
        HotelCreditCardTokenDraft(
          cardNumber: cardNumber,
          cardExpire: '$month/${year.substring(year.length - 2)}',
          securityCode: cvv,
          cardholderName: holder,
          tokenApiKey: tokenApiKey,
        ),
      );
      final draft = HotelCreditCardRegistrationDraft(
        token: token,
        defaultFlag: _isDefault,
        mobileCountryCode: _mobileCountryCode,
        mobileNumber: mobile,
        email: email,
      );
      final payment = widget.args?.payment;
      if (payment == null) {
        await ref.read(registerHotelCreditCardUseCaseProvider)(draft);
        if (mounted) {
          ref.invalidate(hotelCreditCardsProvider);
          context.pop(true);
        }
        return;
      }
      final payResult =
          await ref.read(payHotelOrderWithCreditCardTokenUseCaseProvider)(
            draft: HotelCreditCardRegistrationDraft(
              token: token,
              defaultFlag: _isDefault,
              mobileCountryCode: _mobileCountryCode,
              mobileNumber: mobile,
              email: email,
              bookingOrderId: payment.orderId,
            ),
            saveCard: _isDefault,
          );
      if (mounted) {
        if (_isDefault) {
          ref.invalidate(hotelCreditCardsProvider);
        }
        await completeHotelCreditCardPaymentFlow(
          context: context,
          ref: ref,
          orderId: payment.orderId,
          result: payResult,
          onSuccess: () {
            if (!mounted) {
              return;
            }
            context.pop(
              SettingsCreditCardAddResult(saved: _isDefault, paid: true),
            );
          },
        );
      }
    } catch (error) {
      if (mounted) {
        AppNotice.show(
          context,
          message: _errorMessage(error, fallback: l10n.creditCardTokenFailed),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: context.l10n.creditCardSettingsTitle,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(false),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: <Widget>[
          SettingsCreditCardFormSection(
            cardNumberController: _cardNumberController,
            holderController: _holderController,
            cvvController: _cvvController,
            emailController: _emailController,
            mobileController: _mobileController,
            cvvFocusNode: _cvvFocusNode,
            selectedMonth: _selectedMonth,
            selectedYear: _selectedYear,
            mobileCountryCode: _mobileCountryCode,
            isDefault: _isDefault,
            isCvvFocused: _isCvvFocused,
            isSaving: _isSaving,
            inputFormatters: const <TextInputFormatter>[
              CreditCardNumberInputFormatter(maxDigits: 19),
            ],
            onCardPreviewChanged: () => setState(() {}),
            onMonthChanged: (value) => setState(() => _selectedMonth = value),
            onYearChanged: (value) => setState(() => _selectedYear = value),
            onCountryCodeChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() {
                _mobileCountryCode = value;
              });
            },
            onDefaultChanged: (value) => setState(() => _isDefault = value),
            onBack: () => context.pop(false),
            onSubmit: _submit,
            defaultSwitchLabel: _isPaymentMode
                ? context.l10n.creditCardSaveAction
                : null,
            submitLabel: _isPaymentMode
                ? context.l10n.hotelBookingResultPay
                : null,
          ),
        ],
      ),
    );
  }

  String _preferredCardholderName(AuthUser user) {
    final english = _firstNonEmpty(<String?>[
      _joinName(user.firstNameEn, user.lastNameEn),
      _joinName(user.lastNameEn, user.firstNameEn),
    ]);
    if (english.isNotEmpty) {
      return english.toUpperCase();
    }
    return _firstNonEmpty(<String?>[
      _joinName(user.firstName, user.lastName),
      _joinName(user.lastName, user.firstName),
      user.username,
    ]).toUpperCase();
  }

  String _joinName(String? left, String? right) {
    return <String>[
      left?.trim() ?? '',
      right?.trim() ?? '',
    ].where((part) => part.isNotEmpty).join(' ');
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

  String _normalizeIntlCode(String raw) {
    final trimmed = raw.trim();
    if (trimmed.startsWith('+')) {
      return trimmed.substring(1);
    }
    return trimmed;
  }

  bool _isAsciiDigit(String value) {
    if (value.length != 1) {
      return false;
    }
    final codeUnit = value.codeUnitAt(0);
    return codeUnit >= 48 && codeUnit <= 57;
  }

  String _errorMessage(Object error, {required String fallback}) {
    final message = error.toString().replaceFirst('Exception: ', '').trim();
    if (message.isEmpty || message.contains('DioException')) {
      return fallback;
    }
    return message;
  }
}
