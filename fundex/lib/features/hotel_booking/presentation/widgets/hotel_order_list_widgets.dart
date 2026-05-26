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
    this.onRebook,
    this.onViewDetail,
  });

  final HotelOrderSummary order;
  final HotelBookingPresenter presenter;
  final VoidCallback? onTap;
  final VoidCallback? onRebook;
  final VoidCallback? onViewDetail;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final title = order.hotelName.isNotEmpty
        ? order.hotelName
        : order.buildingName;
    final checkIn = _dateTimeParts(order.checkIn);
    final checkOut = _dateTimeParts(order.checkOut);
    final statusBadge = _statusBadge(context, colors);
    final viewDetailTap = onViewDetail ?? onTap;
    final amountText = presenter.price(order.totalAmount);

    return AspectRatio(
      aspectRatio: 4.2 / 3,
      child: Material(
        color: colors.brandWhite,
        elevation: 3,
        shadowColor: colors.brandPrimaryDark.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(UiTokens.radius28),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(UiTokens.radius28),
              border: Border.all(color: colors.borderSoft),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${context.l10n.hotelOrdersOrderNoPrefix}${order.id}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                      if (statusBadge != null) ...<Widget>[
                        const SizedBox(width: 8),
                        _OrderStatusBadge(data: statusBadge),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(color: colors.borderSoft, height: 1),
                  const SizedBox(height: 14),
                  Row(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                UiTokens.radius12,
                              ),
                              child: AppRemoteImage(
                                imageUrl: order.hotelImageUrl,
                                fit: BoxFit.cover,
                                placeholder: const HotelDetailImagePlaceholder(),
                                errorWidget: const HotelDetailImagePlaceholder(),
                              ),
                            ),
                          ),
                        ),
  
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: colors.textPrimary,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                order.hotelAddress.isNotEmpty
                                    ? order.hotelAddress
                                    : order.buildingName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: colors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 10),
                              _OrderStayDatePanel(
                                checkIn: checkIn,
                                checkOut: checkOut,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              context.l10n.hotelOrdersAmountLabel,
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: colors.textSecondary,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              amountText.isEmpty ? '--' : amountText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: colors.brandAlert,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      _OrderActionButton(
                        label: context.l10n.hotelOrdersRebookAction,
                        onTap: onRebook,
                        foregroundColor: colors.brandPrimary,
                        backgroundColor: colors.brandWhite,
                        borderColor: colors.border,
                      ),
                      const SizedBox(width: 8),
                      _OrderActionButton(
                        label: context.l10n.hotelOrdersDetailAction,
                        onTap: viewDetailTap,
                        foregroundColor: colors.onDark,
                        backgroundColor: colors.brandPrimary,
                        borderColor: colors.brandPrimary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _OrderStatusBadgeData? _statusBadge(
    BuildContext context,
    AppSemanticColorTheme colors,
  ) {
    if (order.orderStatusCode == 5 ||
        order.orderStatus.contains('キャンセル') ||
        order.orderStatus.contains('取消') ||
        order.orderStatus.toLowerCase().contains('cancel')) {
      return _OrderStatusBadgeData(
        label: order.orderStatus.isNotEmpty
            ? order.orderStatus
            : context.l10n.hotelOrdersFilterCancelled,
        foregroundColor: colors.dangerForeground,
        backgroundColor: colors.dangerSubtle,
        borderColor: colors.dangerBorder,
      );
    }
    if (order.paymentStatusCode == 40 || order.canPay) {
      return _OrderStatusBadgeData(
        label: order.paymentStatus.isNotEmpty
            ? order.paymentStatus
            : context.l10n.hotelOrdersFilterAwaitingPayment,
        foregroundColor: colors.warningForeground,
        backgroundColor: colors.warningSubtle,
        borderColor: colors.warningBorder,
      );
    }
    if (order.orderStatus.isNotEmpty) {
      return _OrderStatusBadgeData(
        label: order.orderStatus,
        foregroundColor: colors.successForeground,
        backgroundColor: colors.successSubtle,
        borderColor: colors.successBorder,
      );
    }
    if (order.paymentStatus.isNotEmpty) {
      return _OrderStatusBadgeData(
        label: order.paymentStatus,
        foregroundColor: colors.textSecondary,
        backgroundColor: colors.surfaceAlt,
        borderColor: colors.borderSoft,
      );
    }
    return null;
  }

  _OrderDateTimeParts _dateTimeParts(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return const _OrderDateTimeParts(date: '--/--', time: '--:--');
    }
    final parsed = DateTime.tryParse(trimmed.replaceFirst(' ', 'T'));
    if (parsed != null) {
      return _OrderDateTimeParts(
        date: DateFormat('MM/dd').format(parsed),
        time: DateFormat('HH:mm').format(parsed),
      );
    }
    final date = trimmed.length >= 10
        ? trimmed.substring(5, 10).replaceAll('-', '/')
        : trimmed;
    final time = trimmed.length >= 16 ? trimmed.substring(11, 16) : '--:--';
    return _OrderDateTimeParts(date: date, time: time);
  }
}

class _OrderStatusBadgeData {
  const _OrderStatusBadgeData({
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  final String label;
  final Color foregroundColor;
  final Color backgroundColor;
  final Color borderColor;
}

class _OrderStatusBadge extends StatelessWidget {
  const _OrderStatusBadge({required this.data});

  final _OrderStatusBadgeData data;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: data.backgroundColor,
        shape: StadiumBorder(side: BorderSide(color: data.borderColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          data.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: data.foregroundColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _OrderDateTimeParts {
  const _OrderDateTimeParts({required this.date, required this.time});

  final String date;
  final String time;
}

class _OrderStayDatePanel extends StatelessWidget {
  const _OrderStayDatePanel({required this.checkIn, required this.checkOut});

  final _OrderDateTimeParts checkIn;
  final _OrderDateTimeParts checkOut;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(UiTokens.radius20),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _OrderStayDateColumn(
                label: context.l10n.hotelOrdersCheckInLabel,
                parts: checkIn,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 20,
                color: colors.highlightGold,
              ),
            ),
            Expanded(
              child: _OrderStayDateColumn(
                label: context.l10n.hotelOrdersCheckOutLabel,
                parts: checkOut,
                alignEnd: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderStayDateColumn extends StatelessWidget {
  const _OrderStayDateColumn({
    required this.label,
    required this.parts,
    this.alignEnd = false,
  });

  final String label;
  final _OrderDateTimeParts parts;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final textAlign = alignEnd ? TextAlign.end : TextAlign.start;
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          parts.date,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: colors.brandPrimaryDark,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          parts.time,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: colors.brandPrimaryDark,
            fontWeight: FontWeight.w800,
            height: 1.05,
          ),
        ),
      ],
    );
  }
}

class _OrderActionButton extends StatelessWidget {
  const _OrderActionButton({
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderColor,
    this.onTap,
  });

  final String label;
  final Color foregroundColor;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: StadiumBorder(side: BorderSide(color: borderColor)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
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
