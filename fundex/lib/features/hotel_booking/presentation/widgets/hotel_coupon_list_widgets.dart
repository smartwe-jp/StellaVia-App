import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

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
                      decoration: BoxDecoration(color: colors.highlightGold),
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
  const HotelCouponPickerResult({this.coupon, this.shouldClear = false});

  final HotelCoupon? coupon;
  final bool shouldClear;
}

Future<HotelCouponPickerResult?> showHotelCouponPickerSheet({
  required BuildContext context,
  required List<HotelCoupon> coupons,
  required Map<String, String> pageTexts,
  int? selectedCouponId,
}) {
  return AppBottomSheet.showAdaptive<HotelCouponPickerResult>(
    context: context,
    useRootNavigator: true,
    builder: (BuildContext context) {
      return HotelCouponPickerSheet(
        coupons: coupons,
        pageTexts: pageTexts,
        selectedCouponId: selectedCouponId,
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
  });

  final List<HotelCoupon> coupons;
  final Map<String, String> pageTexts;
  final int? selectedCouponId;

  @override
  State<HotelCouponPickerSheet> createState() => _HotelCouponPickerSheetState();
}

enum _CouponSegment { available, unavailable }

class _HotelCouponPickerSheetState extends State<HotelCouponPickerSheet> {
  _CouponSegment _segment = _CouponSegment.available;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final available = widget.coupons
        .where((coupon) => coupon.canUse ?? true)
        .toList(growable: false);
    final unavailable = widget.coupons
        .where((coupon) => !(coupon.canUse ?? true))
        .toList(growable: false);
    final visible = _segment == _CouponSegment.available
        ? available
        : unavailable;
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
              if (widget.selectedCouponId != null)
                TextButton(
                  onPressed: () => Navigator.of(
                    context,
                  ).pop(const HotelCouponPickerResult(shouldClear: true)),
                  child: Text(context.l10n.hotelCouponsClearSelection),
                ),
            ],
          ),
          const SizedBox(height: 14),
          AppFilterBar<_CouponSegment>(
            value: _segment,
            onChanged: (value) => setState(() => _segment = value),
            items: <AppFilterBarItem<_CouponSegment>>[
              AppFilterBarItem<_CouponSegment>(
                value: _CouponSegment.available,
                label: context.l10n.hotelCouponsAvailableSegment(
                  available.length,
                ),
              ),
              AppFilterBarItem<_CouponSegment>(
                value: _CouponSegment.unavailable,
                label: context.l10n.hotelCouponsUnavailableSegment(
                  unavailable.length,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: visible.isEmpty
                ? Center(
                    child: Text(
                      context.l10n.hotelCouponsEmpty,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.textTertiary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: visible.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (BuildContext context, int index) {
                      final coupon = visible[index];
                      return HotelCouponCard(
                        coupon: coupon,
                        pageTexts: widget.pageTexts,
                        isSelected: coupon.id == widget.selectedCouponId,
                        isDisabled: !(coupon.canUse ?? true),
                        onTap: () => Navigator.of(
                          context,
                        ).pop(HotelCouponPickerResult(coupon: coupon)),
                      );
                    },
                  ),
          ),
        ],
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

String? _formatNumber(num? value) {
  if (value == null) {
    return null;
  }
  if (value % 1 == 0) {
    return value.toInt().toString();
  }
  return value.toString();
}
