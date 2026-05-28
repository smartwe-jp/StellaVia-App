import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_booking_presenter.dart';
import 'hotel_detail_image_placeholder.dart';

class HotelOrderDetailContent extends StatelessWidget {
  const HotelOrderDetailContent({
    super.key,
    required this.detail,
    required this.presenter,
    required this.onBack,
    required this.onMore,
    required this.onPay,
    required this.onRefund,
  });

  final HotelOrderDetail detail;
  final HotelBookingPresenter presenter;
  final VoidCallback onBack;
  final VoidCallback onMore;
  final VoidCallback onPay;
  final VoidCallback onRefund;

  @override
  Widget build(BuildContext context) {
    final canShowActions = detail.summary.canPay || detail.summary.canRefund;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Stack(
      children: <Widget>[
        CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: _OrderDetailHero(
                detail: detail,
                onBack: onBack,
                onMore: onMore,
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                16,
                14,
                16,
                canShowActions ? 108 + bottomInset : 28 + bottomInset,
              ),
              sliver: SliverList.list(
                children: <Widget>[
                  _OrderHotelOverviewCard(detail: detail, presenter: presenter),
                  _OrderCheckInGuideCard(detail: detail),
                  _OrderBookerInfoSection(detail: detail),
                  _OrderGuestInfoSection(detail: detail),
                  _OrderPaymentInfoSection(
                    detail: detail,
                    presenter: presenter,
                  ),
                  _OrderLocationSection(detail: detail),
                  _OrderCancelPolicySection(detail: detail),
                ],
              ),
            ),
          ],
        ),
        if (canShowActions)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _OrderDetailBottomActions(
              canPay: detail.summary.canPay,
              canRefund: detail.summary.canRefund,
              onPay: onPay,
              onRefund: onRefund,
            ),
          ),
      ],
    );
  }
}

class _OrderDetailHero extends StatelessWidget {
  const _OrderDetailHero({
    required this.detail,
    required this.onBack,
    required this.onMore,
  });

  final HotelOrderDetail detail;
  final VoidCallback onBack;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[colors.brandPrimaryDark, colors.brandPrimary],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _HeroIconButton(
                  icon: Icons.chevron_left_rounded,
                  onTap: onBack,
                ),
                _HeroIconButton(icon: Icons.more_horiz_rounded, onTap: onMore),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              context.l10n.hotelOrderDetailTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: colors.onDark,
                fontWeight: FontWeight.w900,
                height: 1.18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${context.l10n.hotelOrdersOrderNoPrefix}${detail.summary.id}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.onDark.withValues(alpha: 0.72),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                if (detail.summary.orderStatus.isNotEmpty)
                  _StatusBadge(
                    label: detail.summary.orderStatus,
                    tone: _orderStatusTone(detail.summary.orderStatusCode),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroIconButton extends StatelessWidget {
  const _HeroIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Material(
      color: colors.brandWhite.withValues(alpha: 0.14),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: colors.onDark, size: 25),
        ),
      ),
    );
  }
}

enum _StatusBadgeTone { success, danger, warning, neutral }

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.tone});

  final String label;
  final _StatusBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final (background, border, foreground) = switch (tone) {
      _StatusBadgeTone.success => (
        colors.successSoft,
        colors.successBorder,
        colors.successForeground,
      ),
      _StatusBadgeTone.danger => (
        colors.infoSoft.withValues(alpha: 0.10),
        colors.infoBorder,
        colors.onDark.withValues(alpha: 0.72),
      ),
      _StatusBadgeTone.warning => (
        colors.warningSoft,
        colors.warningBorder,
        colors.warningForeground,
      ),
      _StatusBadgeTone.neutral => (
        colors.infoSoft,
        colors.infoBorder,
        colors.infoForeground,
      ),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: foreground,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

_StatusBadgeTone _orderStatusTone(int? code) {
  switch (code) {
    case 80:
      return _StatusBadgeTone.success;
    case 25:
    case 30:
    case 40:
      return _StatusBadgeTone.warning;
    case 70:
    case 98:
      return _StatusBadgeTone.danger;
    default:
      return _StatusBadgeTone.neutral;
  }
}

bool _isPaymentCompleted(int? code) {
  return code == 45;
}

class _OrderHotelOverviewCard extends StatelessWidget {
  const _OrderHotelOverviewCard({
    required this.detail,
    required this.presenter,
  });

  final HotelOrderDetail detail;
  final HotelBookingPresenter presenter;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final title = detail.summary.hotelName.isNotEmpty
        ? detail.summary.hotelName
        : detail.summary.buildingName;
    final imageUrl = detail.imageUrl.isNotEmpty
        ? detail.imageUrl
        : detail.summary.hotelImageUrl;
    final address = detail.address.isNotEmpty
        ? detail.address
        : detail.summary.hotelAddress;
    return _OrderDetailCard(
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  width: 96,
                  height: 114,
                  child: AppRemoteImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: const HotelDetailImagePlaceholder(),
                    errorWidget: const HotelDetailImagePlaceholder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w900,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: <Widget>[
                        _MutedChip(
                          label: context.l10n.hotelOrderDetailBookingTypeRoom,
                        ),
                        _MutedChip(
                          label: context.l10n.hotelSearchNights(
                            _nights(detail),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _StayDatePanel(detail: detail),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: _MiniInfoTile(
                  label: context.l10n.hotelOrderDetailGuestCountLabel,
                  value: _guestCountText(context, detail),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MiniInfoTile(
                  label: context.l10n.hotelOrderDetailTotalAmount,
                  value: presenter.price(detail.summary.totalAmount),
                  isAmount: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StayDatePanel extends StatelessWidget {
  const _StayDatePanel({required this.detail});

  final HotelOrderDetail detail;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final checkIn = _DateParts.from(detail.summary.checkIn);
    final checkOut = _DateParts.from(detail.summary.checkOut);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _StayDateColumn(
                label: context.l10n.hotelOrdersCheckInLabel,
                parts: checkIn,
              ),
            ),
            Icon(Icons.arrow_forward_rounded, color: colors.highlightGold),
            Expanded(
              child: _StayDateColumn(
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

class _StayDateColumn extends StatelessWidget {
  const _StayDateColumn({
    required this.label,
    required this.parts,
    this.alignEnd = false,
  });

  final String label;
  final _DateParts parts;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '${parts.date}\n${parts.time}',
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: colors.brandPrimaryDark,
            fontWeight: FontWeight.w900,
            height: 1.12,
          ),
        ),
      ],
    );
  }
}

class _MiniInfoTile extends StatelessWidget {
  const _MiniInfoTile({
    required this.label,
    required this.value,
    this.isAmount = false,
  });

  final String label;
  final String value;
  final bool isAmount;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colors.textTertiary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value.isEmpty ? '-' : value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isAmount ? colors.brandAlert : colors.brandPrimaryDark,
                fontWeight: FontWeight.w900,
                height: 1.24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCheckInGuideCard extends StatelessWidget {
  const _OrderCheckInGuideCard({required this.detail});

  final HotelOrderDetail detail;

  @override
  Widget build(BuildContext context) {
    if (!_isPaymentCompleted(detail.summary.paymentStatusCode)) {
      return const SizedBox.shrink();
    }
    final guide = _stripHtml(detail.checkInGuide).trim();
    final password = detail.gatePassword.trim();
    if (guide.isEmpty && password.isEmpty) {
      return const SizedBox.shrink();
    }
    final colors = Theme.of(context).appColors;
    return _OrderDetailCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SectionHeader(
            title: context.l10n.hotelOrderDetailCheckInGuide,
            trailing: _StatusBadge(
              label: _checkedInLabel(context, detail),
              tone: _StatusBadgeTone.neutral,
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.warningSubtle,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colors.warningBorder),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                guide.isEmpty ? context.l10n.hotelOrderDetailNoGuide : guide,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                  height: 1.65,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (password.isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.brandWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.borderSoft),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            context.l10n.hotelOrderDetailGatePassword,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: colors.textTertiary,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            password,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: colors.brandPrimaryDark,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: password));
                        AppNotice.show(
                          context,
                          message: context.l10n.hotelOrderDetailCopied,
                        );
                      },
                      child: Text(context.l10n.hotelOrderDetailCopy),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OrderPaymentInfoSection extends StatelessWidget {
  const _OrderPaymentInfoSection({
    required this.detail,
    required this.presenter,
  });

  final HotelOrderDetail detail;
  final HotelBookingPresenter presenter;

  @override
  Widget build(BuildContext context) {
    final couponDiscountAmount = detail.couponDiscountAmount ?? 0;
    final createdTime = detail.createdTime.trim().isNotEmpty
        ? detail.createdTime
        : detail.summary.bookingOrderTime;
    return _PlainSectionShell(
      title: context.l10n.hotelOrderDetailPaymentInfo,
      child: Column(
        children: <Widget>[
          _InfoLine(
            data: _InfoLineData.payment(
              context.l10n.hotelOrderDetailOrderTime,
              _formatOrderPaymentTime(createdTime),
            ),
          ),
          _InfoLine(
            data: _InfoLineData.payment(
              context.l10n.hotelOrderDetailOrderStatus,
              detail.summary.orderStatus,
            ),
          ),
          _InfoLine(
            data: _InfoLineData.payment(
              context.l10n.hotelOrderDetailCouponDiscount,
              couponDiscountAmount > 0
                  ? presenter.price(couponDiscountAmount)
                  : context.l10n.hotelOrderDetailCouponUnused,
            ),
          ),
          _PaymentAmountLine(detail: detail, presenter: presenter),
          _InfoLine(
            data: _InfoLineData.payment(
              context.l10n.hotelOrderDetailPaymentStatus,
              _paymentStatusLabel(context, detail.summary),
            ),
          ),
          _InfoLine(
            data: _InfoLineData.payment(
              context.l10n.hotelOrderDetailReceiptTitle,
              detail.receiptTitle,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentAmountLine extends StatelessWidget {
  const _PaymentAmountLine({required this.detail, required this.presenter});

  final HotelOrderDetail detail;
  final HotelBookingPresenter presenter;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final actualAmount = detail.summary.totalAmount;
    final originalAmount = detail.originalAmount ?? actualAmount;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.borderSoft)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 92,
              child: Text(
                context.l10n.hotelOrderDetailPaidAmount,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.brandPrimaryDark,
                  fontWeight: FontWeight.w900,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: actualAmount == null
                    ? Text(
                        '-',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w700,
                          height: 1.45,
                        ),
                      )
                    : RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(height: 1.45),
                          children: <InlineSpan>[
                            if (originalAmount != null) ...<InlineSpan>[
                              TextSpan(
                                text: presenter.price(originalAmount),
                                style: TextStyle(
                                  color: colors.textTertiary,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: colors.textTertiary,
                                ),
                              ),
                              const TextSpan(text: '  '),
                            ],
                            TextSpan(
                              text: presenter.price(actualAmount),
                              style: TextStyle(
                                color: colors.brandAlert,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderBookerInfoSection extends StatelessWidget {
  const _OrderBookerInfoSection({required this.detail});

  final HotelOrderDetail detail;

  @override
  Widget build(BuildContext context) {
    return _PlainSection(
      title: context.l10n.hotelOrderDetailBookerInfo,
      rows: <_InfoLineData>[
        _InfoLineData(
          context.l10n.hotelOrderDetailCustomerName,
          detail.guestName.isNotEmpty ? detail.guestName : detail.receiptTitle,
        ),
        _InfoLineData(
          context.l10n.hotelOrderDetailNationality,
          detail.nationalityText,
        ),
        _InfoLineData(context.l10n.hotelOrderDetailEmail, detail.contactEmail),
        _InfoLineData(context.l10n.hotelOrderDetailPhone, _phoneText(detail)),
        _InfoLineData(
          context.l10n.hotelOrderDetailBookingComment,
          detail.comment,
        ),
        _InfoLineData(
          context.l10n.hotelOrderDetailCreatedAt,
          _formatDateTime(detail.summary.bookingOrderTime),
        ),
      ],
    );
  }
}

class _OrderGuestInfoSection extends StatelessWidget {
  const _OrderGuestInfoSection({required this.detail});

  final HotelOrderDetail detail;

  @override
  Widget build(BuildContext context) {
    final guests = detail.guests;
    if (guests.isEmpty && detail.rooms.isEmpty) {
      return const SizedBox.shrink();
    }
    return _PlainSectionShell(
      title: context.l10n.hotelOrderDetailGuestInfo,
      trailing: _MutedChip(
        label: context.l10n.hotelOrderDetailGuestBadge(guests.length),
      ),
      child: Column(
        children: <Widget>[
          if (guests.isNotEmpty)
            for (var index = 0; index < guests.length; index += 1)
              _GuestLine(index: index + 1, guest: guests[index])
          else
            for (final room in detail.rooms) _RoomLine(room: room),
        ],
      ),
    );
  }
}

class _GuestLine extends StatelessWidget {
  const _GuestLine({required this.index, required this.guest});

  final int index;
  final HotelOrderRoomGuest guest;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.borderSoft)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.brandPrimaryDark,
                shape: BoxShape.circle,
              ),
              child: SizedBox(
                width: 28,
                height: 28,
                child: Center(
                  child: Text(
                    index.toString(),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colors.onDark,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    guest.name.isEmpty ? '-' : guest.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _guestSubtitle(context, guest),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colors.textTertiary,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _GuestMetaLine(
                    label: context.l10n.hotelOrderDetailEmail,
                    value: guest.email,
                  ),
                  _GuestMetaLine(
                    label: context.l10n.hotelOrderDetailRoomGuestCount,
                    value: guest.guestCount == null
                        ? ''
                        : context.l10n.hotelOrderDetailGuestBadge(
                            guest.guestCount!,
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuestMetaLine extends StatelessWidget {
  const _GuestMetaLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Text(
        '$label: ${value.trim().isEmpty ? '-' : value}',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colors.textSecondary,
          height: 1.35,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _RoomLine extends StatelessWidget {
  const _RoomLine({required this.room});

  final HotelOrderRoomSummary room;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: <Widget>[
          if (room.imageUrl.isNotEmpty) ...<Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 56,
                height: 56,
                child: AppRemoteImage(
                  imageUrl: room.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: const HotelDetailImagePlaceholder(),
                  errorWidget: const HotelDetailImagePlaceholder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              room.name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (room.roomCount != null) _MutedChip(label: 'x ${room.roomCount}'),
        ],
      ),
    );
  }
}

class _OrderLocationSection extends StatelessWidget {
  const _OrderLocationSection({required this.detail});

  final HotelOrderDetail detail;

  @override
  Widget build(BuildContext context) {
    final coordinate = _coordinateFor(detail);
    final address = detail.address.isNotEmpty
        ? detail.address
        : detail.summary.hotelAddress;
    if (address.isEmpty && coordinate == null) {
      return const SizedBox.shrink();
    }
    final colors = Theme.of(context).appColors;
    return _PlainSectionShell(
      title: context.l10n.hotelOrderDetailLocation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (address.isNotEmpty)
            Text(
              address,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
                height: 1.45,
                fontWeight: FontWeight.w700,
              ),
            ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              return FundPropertyMapPreviewCard(
                addressLabel: address,
                destination: coordinate,
                height: width.isFinite ? width * 0.56 : 170,
                showAddressOverlay: false,
                showZoomControls: true,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OrderCancelPolicySection extends StatelessWidget {
  const _OrderCancelPolicySection({required this.detail});

  final HotelOrderDetail detail;

  @override
  Widget build(BuildContext context) {
    final text = _stripHtml(detail.cancelRule).trim();
    if (text.isEmpty) {
      return const SizedBox.shrink();
    }
    final colors = Theme.of(context).appColors;
    return _PlainSectionShell(
      title: context.l10n.hotelOrderDetailCancelPolicy,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: colors.textSecondary,
          height: 1.65,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _OrderDetailBottomActions extends StatelessWidget {
  const _OrderDetailBottomActions({
    required this.canPay,
    required this.canRefund,
    required this.onPay,
    required this.onRefund,
  });

  final bool canPay;
  final bool canRefund;
  final VoidCallback onPay;
  final VoidCallback onRefund;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.brandWhite.withValues(alpha: 0.96),
        border: Border(top: BorderSide(color: colors.borderSoft)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.brandPrimaryDark.withValues(alpha: 0.10),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Row(
            children: <Widget>[
              if (canPay)
                Expanded(
                  child: FilledButton(
                    onPressed: onPay,
                    child: Text(context.l10n.hotelOrderDetailPayNow),
                  ),
                ),
              if (canPay && canRefund) const SizedBox(width: 12),
              if (canRefund)
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.danger,
                      foregroundColor: colors.onDark,
                    ),
                    onPressed: onRefund,
                    child: Text(context.l10n.hotelOrderDetailRefundRequest),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderDetailCard extends StatelessWidget {
  const _OrderDetailCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.brandWhite.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: colors.borderSoft),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colors.brandPrimaryDark.withValues(alpha: 0.10),
              blurRadius: 34,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }
}

class _PlainSection extends StatelessWidget {
  const _PlainSection({required this.title, required this.rows});

  final String title;
  final List<_InfoLineData> rows;

  @override
  Widget build(BuildContext context) {
    return _PlainSectionShell(
      title: title,
      child: Column(
        children: <Widget>[
          for (final row in rows.where((row) => row.value.trim().isNotEmpty))
            _InfoLine(data: row),
        ],
      ),
    );
  }
}

class _PlainSectionShell extends StatelessWidget {
  const _PlainSectionShell({
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 8, 2, 18),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colors.borderSoft)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _SectionHeader(title: title, trailing: trailing),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colors.brandPrimaryDark,
                fontWeight: FontWeight.w900,
                height: 1.25,
              ),
            ),
          ),
          if (trailing != null) ...<Widget>[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class _InfoLineData {
  const _InfoLineData(
    this.label,
    this.value, {
    this.valueFontWeight = FontWeight.w600,
    this.showEmptyFallback = false,
  });

  const _InfoLineData.payment(String label, String value)
    : this(
        label,
        value,
        valueFontWeight: FontWeight.w700,
        showEmptyFallback: true,
      );

  final String label;
  final String value;
  final FontWeight valueFontWeight;
  final bool showEmptyFallback;
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.data});

  final _InfoLineData data;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.borderSoft)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 92,
              child: Text(
                data.label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.brandPrimaryDark,
                  fontWeight: FontWeight.w900,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                data.value.trim().isEmpty && data.showEmptyFallback
                    ? '-'
                    : data.value,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: data.valueFontWeight,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MutedChip extends StatelessWidget {
  const _MutedChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _DateParts {
  const _DateParts({required this.date, required this.time});

  factory _DateParts.from(String raw) {
    final dateTime = _parseDateTime(raw);
    if (dateTime == null) {
      return const _DateParts(date: '-', time: '-');
    }
    return _DateParts(
      date: DateFormat('MM/dd').format(dateTime),
      time: DateFormat('HH:mm').format(dateTime),
    );
  }

  final String date;
  final String time;
}

FundPropertyCoordinate? _coordinateFor(HotelOrderDetail detail) {
  final lat = detail.latitude;
  final lng = detail.longitude;
  if (lat == null || lng == null) {
    return null;
  }
  if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
    return null;
  }
  return FundPropertyCoordinate(latitude: lat, longitude: lng);
}

String _checkedInLabel(BuildContext context, HotelOrderDetail detail) {
  if (detail.checkedInText.isNotEmpty) {
    return detail.checkedInText;
  }
  if (detail.summary.checkIn.trim().isEmpty) {
    return context.l10n.hotelOrderDetailNotCheckedIn;
  }
  return context.l10n.hotelOrderDetailNotCheckedIn;
}

String _guestCountText(BuildContext context, HotelOrderDetail detail) {
  final adultCount = detail.adultCount ?? 0;
  final childCount = detail.childCount ?? 0;
  if (adultCount == 0 && childCount == 0) {
    final guestCount = detail.guests.fold<int>(
      0,
      (value, guest) => value + (guest.guestCount ?? 0),
    );
    return guestCount > 0
        ? context.l10n.hotelOrderDetailGuestBadge(guestCount)
        : '-';
  }
  return '${context.l10n.hotelGuestAdults}$adultCount · '
      '${context.l10n.hotelGuestChildren}$childCount';
}

String _phoneText(HotelOrderDetail detail) {
  final code = detail.contactIntlCode.trim();
  final mobile = detail.contactMobile.trim();
  if (code.isEmpty) {
    return mobile;
  }
  if (mobile.isEmpty) {
    return '+$code';
  }
  return '+$code $mobile';
}

String _paymentStatusLabel(BuildContext context, HotelOrderSummary summary) {
  return switch (summary.paymentStatusCode) {
    40 => context.l10n.hotelPaymentStatusNotPaid,
    41 => context.l10n.hotelPaymentStatusInvalidPaid,
    43 => context.l10n.hotelPaymentStatusPartialPay,
    45 => context.l10n.hotelPaymentStatusPaid,
    49 => context.l10n.hotelPaymentStatusOverpaid,
    50 => context.l10n.hotelPaymentStatusNotRefunded,
    52 => context.l10n.hotelPaymentStatusRefunding,
    53 => context.l10n.hotelPaymentStatusPartialRefunded,
    55 => context.l10n.hotelPaymentStatusRefunded,
    _ => summary.paymentStatus,
  };
}

String _guestSubtitle(BuildContext context, HotelOrderRoomGuest guest) {
  return <String>[
    guest.roomTypeName,
    if (guest.checkedInText.isNotEmpty)
      guest.checkedInText
    else
      context.l10n.hotelOrderDetailNotCheckedIn,
    if (guest.roomNo.isNotEmpty)
      '${context.l10n.hotelOrderDetailRoomNumber}: ${guest.roomNo}',
  ].where((value) => value.trim().isNotEmpty).join(' · ');
}

int _nights(HotelOrderDetail detail) {
  final checkIn = _parseDateTime(detail.summary.checkIn);
  final checkOut = _parseDateTime(detail.summary.checkOut);
  if (checkIn == null || checkOut == null) {
    return 1;
  }
  return checkOut
      .difference(DateTime(checkIn.year, checkIn.month, checkIn.day))
      .inDays
      .clamp(1, 365);
}

DateTime? _parseDateTime(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  return DateTime.tryParse(trimmed) ??
      DateTime.tryParse(trimmed.replaceFirst(' ', 'T'));
}

String _formatDateTime(String raw) {
  final dateTime = _parseDateTime(raw);
  if (dateTime == null) {
    return raw.trim();
  }
  return DateFormat('yyyy/MM/dd HH:mm').format(dateTime);
}

String _formatOrderPaymentTime(String raw) {
  final dateTime = _parseDateTime(raw);
  if (dateTime == null) {
    return raw.trim();
  }
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
}

String _stripHtml(String raw) {
  return raw
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'</p\s*>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<[^>]+>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .trim();
}
