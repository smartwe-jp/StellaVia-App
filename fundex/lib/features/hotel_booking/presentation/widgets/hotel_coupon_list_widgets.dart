import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';

class HotelCouponCard extends StatelessWidget {
  const HotelCouponCard({
    super.key,
    required this.coupon,
    required this.pageTexts,
    this.isSelected = false,
    this.isDisabled = false,
    this.onTap,
  });

  final HotelCoupon coupon;
  final Map<String, String> pageTexts;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final badge = _couponBadge(context, coupon, pageTexts);
    final borderColor = isSelected ? colors.brandPrimary : colors.borderSoft;
    return Material(
      color: isDisabled ? colors.surfaceAlt : colors.brandWhite,
      borderRadius: BorderRadius.circular(UiTokens.radius20),
      elevation: isSelected ? 5 : 3,
      shadowColor: colors.brandPrimaryDark.withValues(alpha: 0.08),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        child: Opacity(
          opacity: isDisabled ? 0.58 : 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(UiTokens.radius20),
              border: Border.all(
                color: borderColor,
                width: isSelected ? 1.6 : 1,
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    width: 118,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: colors.primary),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 18,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              badge.primary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: colors.onDark,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              badge.secondary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: colors.onDark.withValues(
                                      alpha: 0.88,
                                    ),
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 1,
                    child: CustomPaint(
                      painter: _CouponDividerPainter(color: colors.borderSoft),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  coupon.name.isEmpty ? '--' : coupon.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: colors.textPrimary,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _CouponTypeChip(
                                label: _couponTypeLabel(context, coupon.type),
                              ),
                              if (isSelected) ...<Widget>[
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: colors.brandPrimary,
                                  size: 22,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 10),
                          _CouponMetaLine(
                            icon: Icons.confirmation_number_outlined,
                            text: context.l10n.hotelCouponsQuantity(
                              coupon.number,
                            ),
                          ),
                          const SizedBox(height: 7),
                          _CouponMetaLine(
                            icon: Icons.event_available_rounded,
                            text: _validPeriodText(context, coupon),
                          ),
                          if (coupon.hotelNames.isNotEmpty) ...<Widget>[
                            const SizedBox(height: 7),
                            _CouponMetaLine(
                              icon: Icons.apartment_rounded,
                              text: coupon.hotelNames,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HotelCouponPickerResult {
  const HotelCouponPickerResult({
    this.coupon,
    this.fundBenefitTicket,
    this.shouldClear = false,
  });

  final HotelCoupon? coupon;
  final HotelFundBenefitTicket? fundBenefitTicket;
  final bool shouldClear;
}

class HotelFundBenefitTicketCard extends StatelessWidget {
  const HotelFundBenefitTicketCard({
    super.key,
    required this.ticket,
    this.isSelected = false,
    this.isDisabled = false,
    this.onTap,
  });

  final HotelFundBenefitTicket ticket;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;
    final amountText = _formatYen(context, ticket.benefitAmount);
    return Material(
      color: isDisabled ? colors.surfaceAlt : colors.brandWhite,
      borderRadius: BorderRadius.circular(UiTokens.radius20),
      elevation: isSelected ? 5 : 3,
      shadowColor: colors.brandPrimaryDark.withValues(alpha: 0.08),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        child: Opacity(
          opacity: isDisabled ? 0.58 : 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(UiTokens.radius20),
              border: Border.all(
                color: isSelected ? colors.brandPrimary : colors.borderSoft,
                width: isSelected ? 1.6 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color.alphaBlend(
                      colors.primaryAlt.withValues(alpha: 0.16),
                      colors.surface,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                amountText,
                                style: textTheme.headlineSmall?.copyWith(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                context
                                    .l10n
                                    .hotelFundBenefitTicketAmountCaption,
                                style: textTheme.labelMedium?.copyWith(
                                  color: colors.textSecondary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _FundBenefitStatusChip(status: ticket.ticketStatus),
                        if (isSelected) ...<Widget>[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.check_circle_rounded,
                            color: colors.brandPrimary,
                            size: 22,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Column(
                    children: <Widget>[
                      _FundBenefitMetaLine(
                        icon: Icons.confirmation_number_outlined,
                        label: context.l10n.hotelFundBenefitTicketNoLabel,
                        value: ticket.ticketNo.isEmpty ? '--' : ticket.ticketNo,
                      ),
                      const SizedBox(height: 10),
                      _FundBenefitMetaLine(
                        icon: Icons.card_giftcard_rounded,
                        label:
                            context.l10n.hotelFundBenefitTicketGrantMethodLabel,
                        value: _grantMethodLabel(context, ticket.grantMethod),
                      ),
                      const SizedBox(height: 10),
                      _FundBenefitMetaLine(
                        icon: Icons.event_available_rounded,
                        label:
                            context.l10n.hotelFundBenefitTicketGrantDateLabel,
                        value: _formatDate(ticket.grantTime),
                      ),
                      if (ticket.usedTime.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 10),
                        _FundBenefitMetaLine(
                          icon: Icons.task_alt_rounded,
                          label:
                              context.l10n.hotelFundBenefitTicketUsedDateLabel,
                          value: _formatDate(ticket.usedTime),
                        ),
                      ],
                      if (ticket.bookingOrderId != null) ...<Widget>[
                        const SizedBox(height: 10),
                        _FundBenefitMetaLine(
                          icon: Icons.receipt_long_rounded,
                          label: context.l10n.hotelFundBenefitTicketOrderLabel,
                          value: ticket.bookingOrderId.toString(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FundBenefitStatusChip extends StatelessWidget {
  const _FundBenefitStatusChip({required this.status});

  final int? status;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final label = switch (status) {
      1 => context.l10n.hotelFundBenefitTicketStatusUnused,
      2 => context.l10n.hotelFundBenefitTicketStatusUsed,
      3 => context.l10n.hotelFundBenefitTicketStatusVoided,
      _ => context.l10n.hotelFundBenefitTicketStatusUnknown,
    };
    final background = switch (status) {
      1 => colors.successSoft,
      2 => colors.surfaceAlt,
      3 => colors.dangerSoft,
      _ => colors.warningSoft,
    };
    final foreground = switch (status) {
      1 => colors.successForeground,
      2 => colors.textSecondary,
      3 => colors.dangerForeground,
      _ => colors.warningForeground,
    };
    final border = switch (status) {
      1 => colors.successBorder,
      2 => colors.border,
      3 => colors.dangerBorder,
      _ => colors.warningBorder,
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: foreground,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _FundBenefitMetaLine extends StatelessWidget {
  const _FundBenefitMetaLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: <Widget>[
        Icon(icon, size: 17, color: colors.textTertiary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: textTheme.bodySmall?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

Future<HotelCouponPickerResult?> showHotelCouponPickerSheet({
  required BuildContext context,
  required List<HotelCoupon> coupons,
  required Map<String, String> pageTexts,
  int? selectedCouponId,
  List<HotelFundBenefitTicket> fundBenefitTickets =
      const <HotelFundBenefitTicket>[],
  int? selectedFundBenefitTicketId,
  num? fundBenefitReferenceAmount,
}) {
  return AppBottomSheet.showAdaptive<HotelCouponPickerResult>(
    context: context,
    useRootNavigator: true,
    builder: (BuildContext context) {
      return HotelCouponPickerSheet(
        coupons: coupons,
        pageTexts: pageTexts,
        selectedCouponId: selectedCouponId,
        fundBenefitTickets: fundBenefitTickets,
        selectedFundBenefitTicketId: selectedFundBenefitTicketId,
        fundBenefitReferenceAmount: fundBenefitReferenceAmount,
      );
    },
  );
}

class HotelCouponPickerSheet extends StatefulWidget {
  const HotelCouponPickerSheet({
    super.key,
    required this.coupons,
    required this.pageTexts,
    required this.selectedCouponId,
    this.fundBenefitTickets = const <HotelFundBenefitTicket>[],
    this.selectedFundBenefitTicketId,
    this.fundBenefitReferenceAmount,
  });

  final List<HotelCoupon> coupons;
  final Map<String, String> pageTexts;
  final int? selectedCouponId;
  final List<HotelFundBenefitTicket> fundBenefitTickets;
  final int? selectedFundBenefitTicketId;
  final num? fundBenefitReferenceAmount;

  @override
  State<HotelCouponPickerSheet> createState() => _HotelCouponPickerSheetState();
}

enum _CouponSegment { coupons, fundBenefits }

class _HotelCouponPickerSheetState extends State<HotelCouponPickerSheet> {
  _CouponSegment _segment = _CouponSegment.coupons;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final hasSelection =
        widget.selectedCouponId != null ||
        widget.selectedFundBenefitTicketId != null;
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.76,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  context.l10n.hotelCouponsSelectTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (hasSelection)
                TextButton(
                  onPressed: () => Navigator.of(
                    context,
                  ).pop(const HotelCouponPickerResult(shouldClear: true)),
                  child: Text(context.l10n.hotelCouponsClearSelection),
                ),
            ],
          ),
          // const SizedBox(height: 14),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(42, 0, 42, 0),
          //   child: AppDualSegmentedControl<_CouponSegment>(
          //     value: _segment,
          //     height: 40,
          //     onChanged: (value) => setState(() => _segment = value),
          //     first: AppDualSegmentItem<_CouponSegment>(
          //       value: _CouponSegment.coupons,
          //       icon: Icons.confirmation_number_outlined,
          //       label: context.l10n.hotelCouponsOrdinarySegment(
          //         widget.coupons.length,
          //       ),
          //     ),
          //     second: AppDualSegmentItem<_CouponSegment>(
          //       value: _CouponSegment.fundBenefits,
          //       icon: Icons.card_giftcard_rounded,
          //       label: context.l10n.hotelFundBenefitTicketsSegment(
          //         widget.fundBenefitTickets.length,
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(height: 14),
          Expanded(
            child: _segment == _CouponSegment.coupons
                ? _CouponPickerCouponList(widget: widget)
                : _CouponPickerFundBenefitList(widget: widget),
          ),
        ],
      ),
    );
  }
}

class _CouponPickerCouponList extends StatelessWidget {
  const _CouponPickerCouponList({required this.widget});

  final HotelCouponPickerSheet widget;

  @override
  Widget build(BuildContext context) {
    if (widget.coupons.isEmpty) {
      return _CouponPickerEmptyText(message: context.l10n.hotelCouponsEmpty);
    }
    return ListView.separated(
      itemCount: widget.coupons.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (BuildContext context, int index) {
        final coupon = widget.coupons[index];
        final isDisabled = !(coupon.canUse ?? true);
        return HotelCouponCard(
          coupon: coupon,
          pageTexts: widget.pageTexts,
          isSelected: coupon.id == widget.selectedCouponId,
          isDisabled: isDisabled,
          onTap: isDisabled
              ? null
              : () => Navigator.of(
                  context,
                ).pop(HotelCouponPickerResult(coupon: coupon)),
        );
      },
    );
  }
}

class _CouponPickerFundBenefitList extends StatelessWidget {
  const _CouponPickerFundBenefitList({required this.widget});

  final HotelCouponPickerSheet widget;

  @override
  Widget build(BuildContext context) {
    if (widget.fundBenefitTickets.isEmpty) {
      return _CouponPickerEmptyText(
        message: context.l10n.hotelFundBenefitTicketsEmpty,
      );
    }
    return ListView.separated(
      itemCount: widget.fundBenefitTickets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (BuildContext context, int index) {
        final ticket = widget.fundBenefitTickets[index];
        final isDisabled = !_isSelectableFundBenefitTicket(
          ticket,
          widget.fundBenefitReferenceAmount,
        );
        return HotelFundBenefitTicketCard(
          ticket: ticket,
          isSelected: ticket.id == widget.selectedFundBenefitTicketId,
          isDisabled: isDisabled,
          onTap: isDisabled
              ? null
              : () => Navigator.of(
                  context,
                ).pop(HotelCouponPickerResult(fundBenefitTicket: ticket)),
        );
      },
    );
  }
}

class _CouponPickerEmptyText extends StatelessWidget {
  const _CouponPickerEmptyText({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: colors.textTertiary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CouponTypeChip extends StatelessWidget {
  const _CouponTypeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.warningSoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.warningBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colors.warningForeground,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _CouponMetaLine extends StatelessWidget {
  const _CouponMetaLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Row(
      children: <Widget>[
        Icon(icon, size: 15, color: colors.textTertiary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _CouponDividerPainter extends CustomPainter {
  const _CouponDividerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const dashHeight = 5.0;
    const gap = 5.0;
    var y = 0.0;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(0, y + dashHeight), paint);
      y += dashHeight + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _CouponDividerPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

({String primary, String secondary}) _couponBadge(
  BuildContext context,
  HotelCoupon coupon,
  Map<String, String> pageTexts,
) {
  return switch (coupon.type) {
    3 => (
      primary: _formatNumber(coupon.discount) ?? coupon.detail,
      secondary: 'OFF',
    ),
    2 => (
      primary:
          '1${pageTexts['respg_meta_appsearchpg0006'] ?? context.l10n.hotelCouponSpecialPrimarySuffix}',
      secondary:
          pageTexts['webpage_meta_h5searchpage00161'] ??
          context.l10n.hotelCouponSpecialSecondary,
    ),
    _ => (
      primary: coupon.amountEvery.isNotEmpty
          ? coupon.amountEvery
          : (_formatNumber(coupon.amount) ?? coupon.detail),
      secondary: 'JPY',
    ),
  };
}

String _couponTypeLabel(BuildContext context, int type) {
  return switch (type) {
    3 => context.l10n.hotelCouponTypeDiscount,
    2 => context.l10n.hotelCouponTypeSpecial,
    _ => context.l10n.hotelCouponTypeVoucher,
  };
}

String _validPeriodText(BuildContext context, HotelCoupon coupon) {
  final begin = coupon.beginDate.isEmpty ? '--' : coupon.beginDate;
  final end = coupon.endDate.isEmpty ? '--' : coupon.endDate;
  return context.l10n.hotelCouponsValidPeriod(begin, end);
}

String _formatYen(BuildContext context, num? value) {
  if (value == null) {
    return '--';
  }
  return NumberFormat.currency(
    locale: Localizations.localeOf(context).toLanguageTag(),
    symbol: '¥',
    decimalDigits: 0,
  ).format(value);
}

String _formatDate(String raw) {
  final value = raw.trim();
  if (value.isEmpty) {
    return '--';
  }
  final date = DateTime.tryParse(value);
  if (date == null) {
    return value.length > 10 ? value.substring(0, 10) : value;
  }
  return DateFormat('yyyy/MM/dd').format(date);
}

String _grantMethodLabel(BuildContext context, int? method) {
  return switch (method) {
    1 => context.l10n.hotelFundBenefitTicketGrantMethodSystem,
    2 => context.l10n.hotelFundBenefitTicketGrantMethodManual,
    _ => '--',
  };
}

bool _isSelectableFundBenefitTicket(
  HotelFundBenefitTicket ticket,
  num? referenceAmount,
) {
  final amount = ticket.benefitAmount ?? 0;
  return ticket.ticketStatus == 1 &&
      ticket.usedTime.trim().isEmpty &&
      ticket.bookingOrderId == null &&
      amount > 0 &&
      (referenceAmount == null || amount > referenceAmount);
}

String? _formatNumber(num? value) {
  if (value == null) {
    return null;
  }
  if (value % 1 == 0) {
    return value.toInt().toString();
  }
  return value.toString();
}
