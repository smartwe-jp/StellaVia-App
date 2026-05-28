import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';

Future<HotelCreditCard?> showHotelCreditCardPickerSheet({
  required BuildContext context,
  required List<HotelCreditCard> cards,
}) {
  return AppBottomSheet.showAdaptive<HotelCreditCard>(
    context: context,
    useRootNavigator: true,
    builder: (BuildContext context) {
      return HotelCreditCardPickerSheet(cards: cards);
    },
  );
}

class HotelCreditCardPickerSheet extends StatelessWidget {
  const HotelCreditCardPickerSheet({super.key, required this.cards});

  final List<HotelCreditCard> cards;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          context.l10n.hotelPaymentSelectCreditCardTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        Flexible(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: cards.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (BuildContext context, int index) {
              final card = cards[index];
              return _CreditCardOptionTile(card: card);
            },
          ),
        ),
      ],
    );
  }
}

class _CreditCardOptionTile extends StatelessWidget {
  const _CreditCardOptionTile({required this.card});

  final HotelCreditCard card;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final title = card.maskedNumber.trim().isEmpty
        ? context.l10n.creditCardMaskedCardFallback
        : card.maskedNumber.trim();
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(UiTokens.radius16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(card),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(UiTokens.radius16),
            border: Border.all(color: colors.borderSoft),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: <Widget>[
                Icon(Icons.credit_card_rounded, color: colors.brandPrimaryDark),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (card.expire.trim().isNotEmpty) ...<Widget>[
                        const SizedBox(height: 3),
                        Text(
                          card.expire.trim(),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (card.isDefault)
                  _DefaultCardChip(label: context.l10n.creditCardDefaultChip),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, color: colors.textTertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DefaultCardChip extends StatelessWidget {
  const _DefaultCardChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.successSubtle,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colors.success,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
