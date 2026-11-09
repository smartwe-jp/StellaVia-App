import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../providers/hotel_booking_providers.dart';
import '../support/hotel_booking_presenter.dart';

Future<void> showHotelPriceDiscountDialog({
  required BuildContext context,
  required String hotelId,
  required HotelSearchCriteria criteria,
  required HotelBookingPresenter presenter,
  bool showBookingAction = false,
  VoidCallback? onBookingTap,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return _HotelPriceDiscountDialog(
        query: HotelPriceDiscountQuery(hotelId: hotelId, criteria: criteria),
        presenter: presenter,
        showBookingAction: showBookingAction,
        onBookingTap: onBookingTap,
      );
    },
  );
}

class _HotelPriceDiscountDialog extends ConsumerWidget {
  const _HotelPriceDiscountDialog({
    required this.query,
    required this.presenter,
    required this.showBookingAction,
    required this.onBookingTap,
  });

  final HotelPriceDiscountQuery query;
  final HotelBookingPresenter presenter;
  final bool showBookingAction;
  final VoidCallback? onBookingTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final state = ref.watch(hotelPriceDiscountProvider(query));
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
      backgroundColor: colors.brandWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UiTokens.radius12),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _DialogHeader(onClose: () => Navigator.of(context).pop()),
              const SizedBox(height: 24),
              state.when(
                loading: () => const SizedBox(
                  height: 220,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) => _DiscountError(
                  onRetry: () =>
                      ref.invalidate(hotelPriceDiscountProvider(query)),
                ),
                data: (discount) => _DiscountContent(
                  discount: discount,
                  presenter: presenter,
                  showBookingAction: showBookingAction,
                  onBookingTap: onBookingTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            context.l10n.hotelDiscountDetailTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        IconButton.filledTonal(
          onPressed: onClose,
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    );
  }
}

class _DiscountContent extends StatelessWidget {
  const _DiscountContent({
    required this.discount,
    required this.presenter,
    required this.showBookingAction,
    required this.onBookingTap,
  });

  final HotelPriceDiscount discount;
  final HotelBookingPresenter presenter;
  final bool showBookingAction;
  final VoidCallback? onBookingTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _AmountBand(
          label: context.l10n.hotelDiscountDetailOriginalPrice,
          value: _money(discount.originalAmount),
          backgroundColor: colors.surfaceAlt,
          valueColor: colors.textPrimary,
        ),
        const SizedBox(height: 12),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.primaryAlt.withValues(alpha: 0.12),
          ),
          child: Column(
            children: <Widget>[
              _AmountBand(
                label: context.l10n.hotelDiscountDetailDiscount,
                value: _negativeMoney(discount.totalDiscountAmount),
                backgroundColor: colors.brandWhite.withValues(alpha: 0),
                labelColor: colors.danger,
                valueColor: colors.danger,
              ),
              Divider(height: 1, color: colors.danger.withValues(alpha: 0.36)),
              _DiscountLine(
                label: _discountLabel(
                  context,
                  discount.discountName,
                  discount.discount,
                ),
                value: _negativeMoney(discount.discountAmount),
              ),
              Divider(height: 1, color: colors.borderSoft),
              _DiscountLine(
                label: _discountLabel(
                  context,
                  discount.memberDiscountName,
                  discount.memberDiscount,
                ),
                value: _negativeMoney(discount.memberDiscountAmount),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _AmountBand(
          label: context.l10n.hotelDiscountDetailFinalPrice,
          value: _money(discount.finalAmount),
          backgroundColor: colors.brandWhite,
          valueColor: colors.textPrimary,
        ),
        if (showBookingAction && onBookingTap != null) ...<Widget>[
          const SizedBox(height: 22),
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                onBookingTap?.call();
              },
              child: Text(context.l10n.hotelDiscountDetailBookAction),
            ),
          ),
        ],
      ],
    );
  }

  String _money(num? value) {
    final text = presenter.price(value);
    return text.isEmpty ? '--' : text;
  }

  String _negativeMoney(num? value) {
    final text = _money(value);
    return text == '--' ? text : '- $text';
  }

  String _discountLabel(BuildContext context, String name, num? discount) {
    final label = name.trim();
    if (discount == null || discount <= 0) {
      return label;
    }
    final text = discount % 1 == 0
        ? discount.toInt().toString()
        : discount.toString();
    final value = context.l10n.hotelDiscountBadgeValue(text);
    return label.isEmpty ? value : '$label $value';
  }
}

class _AmountBand extends StatelessWidget {
  const _AmountBand({
    required this.label,
    required this.value,
    required this.backgroundColor,
    required this.valueColor,
    this.labelColor,
  });

  final String label;
  final String value;
  final Color backgroundColor;
  final Color valueColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(color: backgroundColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: labelColor ?? colors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiscountLine extends StatelessWidget {
  const _DiscountLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: colors.danger,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colors.danger,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscountError extends StatelessWidget {
  const _DiscountError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return SizedBox(
      height: 220,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.error_outline_rounded, color: colors.danger),
          const SizedBox(height: 10),
          Text(
            context.l10n.hotelDiscountDetailLoadFailed,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton(
            onPressed: onRetry,
            child: Text(context.l10n.commonRetry),
          ),
        ],
      ),
    );
  }
}
