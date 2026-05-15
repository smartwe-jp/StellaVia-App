import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../support/hotel_booking_presenter.dart';

class HotelDetailBottomBar extends StatelessWidget {
  const HotelDetailBottomBar({
    super.key,
    required this.amount,
    required this.nights,
    required this.rooms,
    required this.presenter,
    this.isLoading = false,
    required this.onBookNow,
  });

  final num? amount;
  final int nights;
  final int rooms;
  final HotelBookingPresenter presenter;
  final bool isLoading;
  final VoidCallback onBookNow;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final price = presenter.price(amount);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.brandWhite,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.brandPrimaryDark.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 18, 0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      context.l10n.hotelDetailPayableAmount,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      price.isEmpty
                          ? context.l10n.hotelPriceAsk
                          : '$price ${context.l10n.hotelCurrencyCode}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: colors.brandAlert,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.hotelDetailTaxNote(nights, rooms),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              SizedBox(
                width: 150,
                height: 58,
                child: FilledButton(
                  onPressed: isLoading ? null : onBookNow,
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.brandPrimary,
                    foregroundColor: colors.onDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(UiTokens.radius16),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: colors.onDark,
                          ),
                        )
                      : Text(
                          context.l10n.hotelDetailBookNow,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: colors.onDark,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
