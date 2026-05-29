import 'dart:math' as math;

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../hotel_booking/domain/entities/hotel_models.dart';

class SettingsRegisteredCreditCardSection extends StatelessWidget {
  const SettingsRegisteredCreditCardSection({
    super.key,
    required this.cardsState,
    required this.onRetry,
    required this.onDelete,
  });

  final AsyncValue<List<HotelCreditCard>> cardsState;
  final VoidCallback onRetry;
  final ValueChanged<HotelCreditCard> onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          l10n.creditCardRegisteredSectionTitle,
          style: appText.sectionTitle.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 14),
        cardsState.when(
          loading: () => Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: colors.primary,
                ),
              ),
            ),
          ),
          error: (_, __) => Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  l10n.uiErrorRequestFailed,
                  style: appText.body.copyWith(color: colors.textSecondary),
                ),
              ),
              TextButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
            ],
          ),
          data: (cards) {
            if (cards.isEmpty) {
              return Text(
                l10n.creditCardNoRegistered,
                style: appText.body.copyWith(color: colors.textSecondary),
              );
            }
            return Column(
              children: <Widget>[
                for (var index = 0; index < cards.length; index += 1) ...[
                  _RegisteredCreditCardTile(
                    card: cards[index],
                    onDelete: () => onDelete(cards[index]),
                  ),
                  if (index != cards.length - 1) const SizedBox(height: 14),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class SettingsCreditCardFormSection extends StatelessWidget {
  const SettingsCreditCardFormSection({
    super.key,
    required this.cardNumberController,
    required this.holderController,
    required this.cvvController,
    required this.emailController,
    required this.mobileController,
    required this.cvvFocusNode,
    required this.selectedMonth,
    required this.selectedYear,
    required this.mobileCountryCode,
    required this.isDefault,
    required this.isCvvFocused,
    required this.isSaving,
    required this.inputFormatters,
    required this.onCardPreviewChanged,
    required this.onMonthChanged,
    required this.onYearChanged,
    required this.onCountryCodeChanged,
    required this.onDefaultChanged,
    required this.onBack,
    required this.onSubmit,
    this.showBackButton = false,
    this.defaultSwitchLabel,
    this.submitLabel,
  });

  final TextEditingController cardNumberController;
  final TextEditingController holderController;
  final TextEditingController cvvController;
  final TextEditingController emailController;
  final TextEditingController mobileController;
  final FocusNode cvvFocusNode;
  final String? selectedMonth;
  final String? selectedYear;
  final String mobileCountryCode;
  final bool isDefault;
  final bool isCvvFocused;
  final bool isSaving;
  final List<TextInputFormatter> inputFormatters;
  final VoidCallback onCardPreviewChanged;
  final ValueChanged<String?> onMonthChanged;
  final ValueChanged<String?> onYearChanged;
  final ValueChanged<String?> onCountryCodeChanged;
  final ValueChanged<bool> onDefaultChanged;
  final VoidCallback onBack;
  final VoidCallback onSubmit;
  final bool showBackButton;
  final String? defaultSwitchLabel;
  final String? submitLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final years = _expiryYears();

    return _SettingsCreditCardPanel(
      title: l10n.creditCardAddSectionTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SettingsCreditCardPreview(
            cardNumber: cardNumberController.text,
            holderName: holderController.text,
            month: selectedMonth,
            year: selectedYear,
            cvv: cvvController.text,
            isBack: isCvvFocused,
          ),
          const SizedBox(height: 22),
          _SettingsCreditCardTextField(
            label: l10n.creditCardNumberLabel,
            controller: cardNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: inputFormatters,
            onChanged: (_) => onCardPreviewChanged(),
          ),
          const SizedBox(height: 14),
          _SettingsCreditCardTextField(
            label: l10n.creditCardHolderLabel,
            controller: holderController,
            textCapitalization: TextCapitalization.characters,
            onChanged: (_) => onCardPreviewChanged(),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.creditCardExpiryLabel,
            style: appText.inputLabel.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 560;
              final month = _SettingsCreditCardDropdown(
                value: selectedMonth,
                hint: l10n.creditCardMonthHint,
                items: _months,
                onChanged: onMonthChanged,
              );
              final year = _SettingsCreditCardDropdown(
                value: selectedYear,
                hint: l10n.creditCardYearHint,
                items: years,
                onChanged: onYearChanged,
              );
              final cvv = _SettingsCreditCardTextField(
                label: l10n.creditCardCvvLabel,
                controller: cvvController,
                focusNode: cvvFocusNode,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                onChanged: (_) => onCardPreviewChanged(),
                obscureText: true,
              );
              if (compact) {
                return Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(child: month),
                        const SizedBox(width: 10),
                        Expanded(child: year),
                      ],
                    ),
                    const SizedBox(height: 14),
                    cvv,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(child: month),
                  const SizedBox(width: 12),
                  Expanded(child: year),
                  const SizedBox(width: 12),
                  Expanded(child: cvv),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          Text(
            l10n.creditCardBankContactHint,
            style: appText.helper.copyWith(color: colors.textTertiary),
          ),
          const SizedBox(height: 10),
          _SettingsCreditCardTextField(
            label: l10n.creditCardBankEmailLabel,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 520;
              final country = _SettingsCreditCardCountryDropdown(
                value: mobileCountryCode,
                onChanged: onCountryCodeChanged,
              );
              final mobile = _SettingsCreditCardTextField(
                label: l10n.creditCardMobileLabel,
                controller: mobileController,
                keyboardType: TextInputType.phone,
              );
              if (compact) {
                return Column(
                  children: <Widget>[
                    country,
                    const SizedBox(height: 14),
                    mobile,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SizedBox(width: 160, child: country),
                  const SizedBox(width: 12),
                  Expanded(child: mobile),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          Row(
            children: <Widget>[
              Switch(
                value: isDefault,
                activeThumbColor: colors.brandWhite,
                activeTrackColor: colors.highlightGold,
                inactiveThumbColor: colors.surface,
                inactiveTrackColor: colors.disabled,
                onChanged: onDefaultChanged,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  defaultSwitchLabel ?? l10n.creditCardDefaultPaymentLabel,
                  style: appText.body.copyWith(color: colors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: <Widget>[
              if (showBackButton) ...<Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: isSaving ? null : onBack,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      foregroundColor: colors.textSecondary,
                      side: BorderSide(color: colors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(UiTokens.radius12),
                      ),
                    ),
                    child: Text(l10n.creditCardBackAction),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: FilledButton(
                  onPressed: isSaving ? null : onSubmit,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: colors.highlightGold,
                    foregroundColor: colors.onDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(UiTokens.radius12),
                    ),
                  ),
                  child: isSaving
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: colors.onDark,
                          ),
                        )
                      : Text(submitLabel ?? l10n.creditCardSaveAction),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SettingsCreditCardPreview extends StatelessWidget {
  const SettingsCreditCardPreview({
    super.key,
    required this.cardNumber,
    required this.holderName,
    required this.month,
    required this.year,
    required this.cvv,
    required this.isBack,
  });

  final String cardNumber;
  final String holderName;
  final String? month;
  final String? year;
  final String cvv;
  final bool isBack;

  @override
  Widget build(BuildContext context) {
    final unknown = context.l10n.creditCardPreviewUnknown;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: AspectRatio(
          aspectRatio: 1.58,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: isBack ? math.pi : 0),
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeInOutCubic,
            builder: (context, value, child) {
              final showBack = value > math.pi / 2;
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(value),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateY(showBack ? math.pi : 0),
                  child: showBack
                      ? _CreditCardPreviewBack(
                          brand: _cardBrandLabel(cardNumber, unknown),
                          cvv: cvv,
                        )
                      : _CreditCardPreviewFront(
                          cardNumber: cardNumber,
                          holderName: holderName,
                          month: month,
                          year: year,
                          brand: _cardBrandLabel(cardNumber, unknown),
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SettingsCreditCardPanel extends StatelessWidget {
  const _SettingsCreditCardPanel({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(UiTokens.radius20),
        border: Border.all(color: colors.borderSoft),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.scrim.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: appText.sectionTitle.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _RegisteredCreditCardTile extends StatelessWidget {
  const _RegisteredCreditCardTile({required this.card, required this.onDelete});

  final HotelCreditCard card;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final brand = _registeredCardBrand(card, l10n.creditCardPreviewUnknown);
    final number = _formatRegisteredCardNumber(card.maskedNumber);
    final holder = card.holderName.trim().isEmpty
        ? l10n.creditCardPreviewFullName
        : card.holderName.trim().toUpperCase();
    final expire = card.expire.trim().isEmpty ? 'MM/YY' : card.expire.trim();

    return AspectRatio(
      aspectRatio: 1.68,
      child: _CreditCardPreviewSurface(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        brand,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: appText.heroSubtitle.copyWith(
                          color: colors.onDark,
                        ),
                      ),
                      if (card.isDefault) ...<Widget>[
                        const SizedBox(height: 6),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: colors.brandWhite.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: colors.brandWhite.withValues(alpha: 0.28),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            child: Text(
                              l10n.creditCardDefaultChip,
                              style: appText.micro.copyWith(
                                color: colors.onDark,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Spacer(),
                  _RegisteredCreditCardDeleteButton(onTap: onDelete),
                ],
              ),
              const Spacer(),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  number,
                  style: appText.heroSubtitle.copyWith(color: colors.onDark),
                ),
              ),
              const Spacer(),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _PreviewLabelValue(
                      label: l10n.creditCardPreviewCardHolder,
                      value: holder,
                    ),
                  ),
                  const SizedBox(width: 18),
                  _PreviewLabelValue(
                    label: l10n.creditCardPreviewExpires,
                    value: expire,
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisteredCreditCardDeleteButton extends StatelessWidget {
  const _RegisteredCreditCardDeleteButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Material(
      color: colors.brandWhite.withValues(alpha: 0.16),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            Icons.delete_outline_rounded,
            size: 22,
            color: colors.danger,
            semanticLabel: context.l10n.creditCardDeleteAction,
          ),
        ),
      ),
    );
  }
}

class _CreditCardPreviewFront extends StatelessWidget {
  const _CreditCardPreviewFront({
    required this.cardNumber,
    required this.holderName,
    required this.month,
    required this.year,
    required this.brand,
  });

  final String cardNumber;
  final String holderName;
  final String? month;
  final String? year;
  final String brand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;

    return _CreditCardPreviewSurface(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 54,
                  height: 42,
                  decoration: BoxDecoration(
                    color: colors.brandWhite.withValues(alpha: 0.38),
                    borderRadius: BorderRadius.circular(UiTokens.radius12),
                    border: Border.all(
                      color: colors.brandWhite.withValues(alpha: 0.48),
                    ),
                  ),
                  child: Icon(
                    Icons.sim_card_rounded,
                    color: colors.onDark.withValues(alpha: 0.84),
                  ),
                ),
                const Spacer(),
                Text(
                  brand,
                  style: appText.heroSubtitle.copyWith(color: colors.onDark),
                ),
              ],
            ),
            const Spacer(),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                _formatPreviewNumber(cardNumber),
                style: appText.heroSubtitle.copyWith(color: colors.onDark),
              ),
            ),
            const Spacer(),
            Row(
              children: <Widget>[
                Expanded(
                  child: _PreviewLabelValue(
                    label: l10n.creditCardPreviewCardHolder,
                    value: holderName.trim().isEmpty
                        ? l10n.creditCardPreviewFullName
                        : holderName.trim().toUpperCase(),
                  ),
                ),
                const SizedBox(width: 18),
                _PreviewLabelValue(
                  label: l10n.creditCardPreviewExpires,
                  value: month == null || year == null
                      ? 'MM/YY'
                      : '$month/${year!.substring(year!.length - 2)}',
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CreditCardPreviewBack extends StatelessWidget {
  const _CreditCardPreviewBack({required this.brand, required this.cvv});

  final String brand;
  final String cvv;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;

    return _CreditCardPreviewSurface(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(height: 44, color: colors.brandPrimaryDark),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  l10n.creditCardCvvLabel,
                  style: appText.body.copyWith(color: colors.onDark),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Container(
                height: 44,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: colors.brandWhite,
                  borderRadius: BorderRadius.circular(UiTokens.radius8),
                ),
                child: Text(
                  cvv.trim().isEmpty ? '***' : cvv.trim(),
                  style: appText.cardTitle.copyWith(color: colors.textPrimary),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  brand.isEmpty ? l10n.creditCardPreviewUnknown : brand,
                  style: appText.heroSubtitle.copyWith(color: colors.onDark),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreditCardPreviewSurface extends StatelessWidget {
  const _CreditCardPreviewSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(UiTokens.radius20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.brandPrimary,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              colors.brandPrimaryBright.withValues(alpha: 0.82),
              colors.brandPrimary,
              colors.brandPrimaryDark,
            ],
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colors.scrim.withValues(alpha: 0.20),
              blurRadius: 24,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            const Positioned(
              right: -34,
              top: 24,
              child: _CardTextureBand(width: 190, height: 42, alpha: 0.10),
            ),
            const Positioned(
              left: -48,
              bottom: 30,
              child: _CardTextureBand(width: 210, height: 38, alpha: 0.08),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class _CardTextureBand extends StatelessWidget {
  const _CardTextureBand({
    required this.width,
    required this.height,
    required this.alpha,
  });

  final double width;
  final double height;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.brandWhite.withValues(alpha: alpha),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _PreviewLabelValue extends StatelessWidget {
  const _PreviewLabelValue({
    required this.label,
    required this.value,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final String label;
  final String value;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: <Widget>[
        Text(
          label,
          style: appText.helper.copyWith(
            color: colors.onDark.withValues(alpha: 0.70),
          ),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: crossAxisAlignment == CrossAxisAlignment.end
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Text(
            value,
            style: appText.cardTitle.copyWith(color: colors.onDark),
          ),
        ),
      ],
    );
  }
}

class _SettingsCreditCardTextField extends StatelessWidget {
  const _SettingsCreditCardTextField({
    required this.label,
    required this.controller,
    this.focusNode,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
  });

  final String label;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final TextCapitalization textCapitalization;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: appText.inputLabel.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          obscureText: obscureText,
          onChanged: onChanged,
          style: appText.body.copyWith(color: colors.textPrimary),
          decoration: _creditCardInputDecoration(context),
        ),
      ],
    );
  }
}

class CreditCardNumberInputFormatter extends TextInputFormatter {
  const CreditCardNumberInputFormatter({this.maxDigits = 19});

  final int maxDigits;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = _asciiDigitsOnly(newValue.text);
    final limitedDigits = digits.length > maxDigits
        ? digits.substring(0, maxDigits)
        : digits;
    final grouped = _groupCardDigits(limitedDigits);
    final digitsBeforeCursor = _asciiDigitsOnly(
      newValue.text.substring(
        0,
        newValue.selection.end.clamp(0, newValue.text.length),
      ),
    ).length.clamp(0, limitedDigits.length);
    final cursorOffset = _offsetForDigitCount(grouped, digitsBeforeCursor);

    return TextEditingValue(
      text: grouped,
      selection: TextSelection.collapsed(offset: cursorOffset),
    );
  }

  String _groupCardDigits(String digits) {
    final groups = <String>[];
    for (var index = 0; index < digits.length; index += 4) {
      final end = (index + 4).clamp(0, digits.length);
      groups.add(digits.substring(index, end));
    }
    return groups.join(' ');
  }

  int _offsetForDigitCount(String text, int digitCount) {
    if (digitCount <= 0) {
      return 0;
    }
    var seenDigits = 0;
    for (var index = 0; index < text.length; index += 1) {
      final codeUnit = text.codeUnitAt(index);
      if (codeUnit >= 48 && codeUnit <= 57) {
        seenDigits += 1;
      }
      if (seenDigits >= digitCount) {
        return index + 1;
      }
    }
    return text.length;
  }
}

class _SettingsCreditCardDropdown extends StatelessWidget {
  const _SettingsCreditCardDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.textPrimary),
      hint: Text(
        hint,
        style: appText.body.copyWith(color: colors.textSecondary),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: appText.body),
            ),
          )
          .toList(growable: false),
      onChanged: onChanged,
      decoration: _creditCardInputDecoration(context),
    );
  }
}

class _SettingsCreditCardCountryDropdown extends StatelessWidget {
  const _SettingsCreditCardCountryDropdown({
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final countryOptions = _phoneCountryOptions(value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          l10n.creditCardIntlCodeLabel,
          style: appText.inputLabel.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: colors.textPrimary,
          ),
          items: countryOptions
              .map(
                (option) => DropdownMenuItem<String>(
                  value: option.intlTeleCode,
                  child: Text(option.dialLabel, style: appText.body),
                ),
              )
              .toList(growable: false),
          onChanged: onChanged,
          decoration: _creditCardInputDecoration(context),
        ),
      ],
    );
  }
}

InputDecoration _creditCardInputDecoration(BuildContext context) {
  final colors = Theme.of(context).appColors;
  final radius = BorderRadius.circular(UiTokens.radius12);

  return InputDecoration(
    isDense: true,
    filled: true,
    fillColor: colors.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
    enabledBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: colors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: colors.primary, width: 1.4),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: colors.danger),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: colors.danger, width: 1.4),
    ),
  );
}

String _formatPreviewNumber(String raw) {
  final digits = _asciiDigitsOnly(raw);
  if (digits.isEmpty) {
    return '####  ####  ####  ####';
  }
  final padded = digits.padRight(16, '#');
  final visible = padded.length > 16 ? padded.substring(0, 16) : padded;
  final groups = <String>[];
  for (var index = 0; index < visible.length; index += 4) {
    final end = (index + 4).clamp(0, visible.length);
    groups.add(visible.substring(index, end));
  }
  return groups.join('  ');
}

String _cardBrandLabel(String raw, String unknownLabel) {
  final digits = _asciiDigitsOnly(raw);
  if (digits.startsWith('4')) {
    return 'VISA';
  }
  if (digits.startsWith('5') || digits.startsWith('2')) {
    return 'Mastercard';
  }
  if (digits.startsWith('34') || digits.startsWith('37')) {
    return 'AMEX';
  }
  if (digits.startsWith('35')) {
    return 'JCB';
  }
  return unknownLabel;
}

String _registeredCardBrand(HotelCreditCard card, String unknownLabel) {
  final code = card.brandCode.trim();
  if (code.isNotEmpty) {
    return code.toUpperCase();
  }
  return _cardBrandLabel(card.maskedNumber, unknownLabel);
}

String _formatRegisteredCardNumber(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) {
    return '####  ####  ####  ####';
  }
  final normalized = trimmed
      .replaceAll('\u3000', ' ')
      .replaceAll('-', ' ')
      .split(' ')
      .where((part) => part.isNotEmpty)
      .join(' ');
  if (normalized.contains(' ')) {
    return normalized;
  }
  final groups = <String>[];
  for (var index = 0; index < normalized.length; index += 4) {
    final end = (index + 4).clamp(0, normalized.length);
    groups.add(normalized.substring(index, end));
  }
  return groups.join('  ');
}

String _asciiDigitsOnly(String raw) {
  final digits = StringBuffer();
  for (final codeUnit in raw.codeUnits) {
    if (codeUnit >= 48 && codeUnit <= 57) {
      digits.writeCharCode(codeUnit);
    }
  }
  return digits.toString();
}

List<PhoneCountryCodeOption> _phoneCountryOptions(String value) {
  final hasSelected = phoneCountryCodeOptions.any(
    (option) => option.intlTeleCode == value,
  );
  if (hasSelected) {
    return phoneCountryCodeOptions;
  }
  return <PhoneCountryCodeOption>[
    ...phoneCountryCodeOptions,
    PhoneCountryCodeOption(
      intlTeleCode: value,
      name: value,
      shortName: '+$value',
    ),
  ];
}

List<String> _expiryYears() {
  final now = DateTime.now();
  return List<String>.generate(16, (index) => '${now.year + index}');
}

const List<String> _months = <String>[
  '01',
  '02',
  '03',
  '04',
  '05',
  '06',
  '07',
  '08',
  '09',
  '10',
  '11',
  '12',
];
