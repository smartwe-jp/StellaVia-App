import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_booking_presenter.dart';
import 'hotel_search_conditions_sheet.dart';
import 'hotel_search_summary_bar.dart';

class HotelMapControls extends StatelessWidget {
  const HotelMapControls({
    super.key,
    required this.criteria,
    required this.presenter,
    required this.onBack,
    required this.onOpenFilters,
    required this.onShowList,
    required this.onNearby,
  });

  final HotelSearchCriteria criteria;
  final HotelBookingPresenter presenter;
  final VoidCallback onBack;
  final VoidCallback onOpenFilters;
  final VoidCallback onShowList;
  final VoidCallback onNearby;

  @override
  Widget build(BuildContext context) {
    final destination = hotelAreaLabel(context, criteria.area);
    final summaryLine = context.l10n.hotelSearchSummaryLine(
      destination,
      presenter.stayRange(criteria),
      context.l10n.hotelSearchNights(criteria.nights),
    );
    final guestLine = context.l10n.hotelGuestDetailedSummary(
      criteria.occupancy,
      criteria.kids,
      criteria.roomCount,
    );

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HotelSearchSummaryBar(
              summaryLine: summaryLine,
              guestLine: guestLine,
              onTap: onOpenFilters,
              leading: _HotelMapHeaderIcon(
                icon: Icons.chevron_left_rounded,
                onTap: onBack,
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                _HotelMapPillButton(
                  label: context.l10n.hotelToolbarFilter,
                  selected: true,
                  onTap: onOpenFilters,
                ),
                _HotelMapPillButton(
                  label: context.l10n.hotelMapListButton,
                  onTap: onShowList,
                ),
                _HotelMapPillButton(
                  label: context.l10n.hotelMapNearbyButton,
                  onTap: onNearby,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HotelMapHeaderIcon extends StatelessWidget {
  const _HotelMapHeaderIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Material(
      color: colors.surfaceAlt,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, color: colors.brandPrimaryDark, size: 24),
        ),
      ),
    );
  }
}

class _HotelMapPillButton extends StatelessWidget {
  const _HotelMapPillButton({
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final backgroundColor = selected ? colors.brandPrimary : colors.brandWhite;
    final foregroundColor = selected ? colors.onDark : colors.brandPrimaryDark;
    return Material(
      color: backgroundColor,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? colors.brandPrimary : colors.borderSoft,
        ),
      ),
      elevation: selected ? 0 : 1,
      shadowColor: colors.brandPrimaryDark.withValues(alpha: 0.10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
