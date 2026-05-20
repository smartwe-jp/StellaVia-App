import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_booking_presenter.dart';

class HotelDetailStaySummaryBar extends StatelessWidget {
  const HotelDetailStaySummaryBar({
    super.key,
    required this.criteria,
    required this.presenter,
    this.onDatesTap,
    this.onGuestsTap,
  });

  final HotelSearchCriteria criteria;
  final HotelBookingPresenter presenter;
  final VoidCallback? onDatesTap;
  final VoidCallback? onGuestsTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.brandWhite,
        borderRadius: BorderRadius.circular(UiTokens.radius16),
        border: Border.all(color: colors.highlightGold.withValues(alpha: 0.45)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.brandPrimaryDark.withValues(alpha: 0.12),
            blurRadius: UiTokens.radius16,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(UiTokens.radius16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _SummaryItem(
                icon: Icons.calendar_month_outlined,
                label: context.l10n.hotelDetailStayDateLabel,
                value:
                    '${presenter.stayRange(criteria)}、 '
                    '${context.l10n.hotelSearchNights(criteria.nights)}',
                onTap: onDatesTap,
              ),
            ),
            SizedBox(
              width: 1,
              height: 60,
              child: ColoredBox(color: colors.borderSoft),
            ),
            Expanded(
              child: _SummaryItem(
                icon: Icons.person_outline_rounded,
                label: context.l10n.hotelDetailGuestRoomLabel,
                value: context.l10n.hotelGuestDetailedSummary(
                  criteria.occupancy,
                  criteria.kids,
                  criteria.roomCount,
                ),
                onTap: onGuestsTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(icon, size: 18, color: colors.brandSecondary),
              const SizedBox(width: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.brandSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colors.brandPrimaryDark,
              fontWeight: FontWeight.w600,
              height: 1.12,
            ),
          ),
        ],
      ),
    );
    if (onTap == null) {
      return content;
    }
    return Material(
      type: MaterialType.transparency,
      child: InkWell(onTap: onTap, child: content),
    );
  }
}
