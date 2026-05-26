import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_booking_presenter.dart';
import 'hotel_detail_image_placeholder.dart';

class HotelOrderStatusFilterBar extends StatelessWidget {
  const HotelOrderStatusFilterBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final HotelOrderStatusFilter selected;
  final ValueChanged<HotelOrderStatusFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppFilterBar<HotelOrderStatusFilter>(
      value: selected,
      onChanged: onChanged,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      items: HotelOrderStatusFilter.values
          .map(
            (filter) => AppFilterBarItem<HotelOrderStatusFilter>(
              value: filter,
              label: _labelFor(context, filter),
            ),
          )
          .toList(growable: false),
    );
  }

  String _labelFor(BuildContext context, HotelOrderStatusFilter filter) {
    return switch (filter) {
      HotelOrderStatusFilter.all => context.l10n.hotelOrdersFilterAll,
      HotelOrderStatusFilter.awaitingPayment =>
        context.l10n.hotelOrdersFilterAwaitingPayment,
      HotelOrderStatusFilter.booked => context.l10n.hotelOrdersFilterBooked,
      HotelOrderStatusFilter.cancelled =>
        context.l10n.hotelOrdersFilterCancelled,
    };
  }
}

class HotelOrderSummaryCard extends StatelessWidget {
  const HotelOrderSummaryCard({
    super.key,
    required this.order,
    required this.presenter,
    this.onTap,
  });

  final HotelOrderSummary order;
  final HotelBookingPresenter presenter;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final title = order.hotelName.isNotEmpty
        ? order.hotelName
        : order.buildingName;
    return Material(
      color: colors.brandWhite,
      borderRadius: BorderRadius.circular(UiTokens.radius12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(UiTokens.radius12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(UiTokens.radius12),
            border: Border.all(color: colors.borderSoft),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: colors.brandPrimaryDark.withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        order.id,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    Text(
                      order.orderStatus.isNotEmpty
                          ? order.orderStatus
                          : order.paymentStatus,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _statusColor(colors),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: colors.borderSoft, height: 1),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(UiTokens.radius8),
                      child: SizedBox(
                        width: 108,
                        height: 108,
                        child: AppRemoteImage(
                          imageUrl: order.hotelImageUrl,
                          fit: BoxFit.cover,
                          placeholder: const HotelDetailImagePlaceholder(),
                          errorWidget: const HotelDetailImagePlaceholder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          if (order.buildingName.isNotEmpty) ...<Widget>[
                            const SizedBox(height: 5),
                            Text(
                              order.buildingName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: colors.textSecondary,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                          const SizedBox(height: 8),
                          Text(
                            _stayRange(),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: colors.textSecondary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${presenter.price(order.totalAmount)}${context.l10n.hotelCurrencyCode}',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: colors.brandAlert,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _statusColor(AppSemanticColorTheme colors) {
    if (order.orderStatusCode == 5 ||
        order.orderStatus.contains('キャンセル') ||
        order.orderStatus.contains('取消') ||
        order.orderStatus.toLowerCase().contains('cancel')) {
      return colors.textPrimary;
    }
    if (order.paymentStatusCode == 40 || order.canPay) {
      return colors.brandAlert;
    }
    return colors.brandSecondary;
  }

  String _stayRange() {
    final checkIn = _formatOrderDate(order.checkIn);
    final checkOut = _formatOrderDate(order.checkOut);
    if (checkIn.isEmpty || checkOut.isEmpty) {
      return checkIn.isNotEmpty ? checkIn : checkOut;
    }
    return '$checkIn ~ $checkOut';
  }

  String _formatOrderDate(String raw) {
    final trimmed = raw.trim();
    if (trimmed.length >= 10) {
      return trimmed.substring(0, 10);
    }
    final parsed = DateTime.tryParse(trimmed);
    if (parsed == null) {
      return trimmed;
    }
    return DateFormat('yyyy-MM-dd').format(parsed);
  }
}

class HotelOrderListLoadMoreButton extends StatelessWidget {
  const HotelOrderListLoadMoreButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.brandPrimary,
          side: BorderSide(color: colors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UiTokens.radius8),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: colors.brandPrimary,
                ),
              )
            : Text(
                context.l10n.hotelOrdersLoadMore,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.brandPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }
}
