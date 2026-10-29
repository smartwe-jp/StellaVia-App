import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../controllers/hotel_booking_controller.dart';
import '../../domain/entities/hotel_models.dart';
import 'hotel_home_search.dart';

class HotelHomeHeader extends StatelessWidget {
  const HotelHomeHeader({
    super.key,
    required this.state,
    required this.onApply,
  });
  final HotelBookingState state;
  final Future<void> Function(HotelSearchCriteria) onApply;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'STELLAVIA',
                  style: context.appTextTheme.numericTitle.copyWith(
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: context.l10n.notificationsTitle,
                  onPressed: () => context.push('/notifications'),
                  icon: const Icon(Icons.notifications_none),
                ),
              ],
            ),
          ),
        ),
      ),
      const Divider(height: 1),
      Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.hotelHomeTitle,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            HotelHomeSearch(criteria: state.criteria, onApply: onApply),
            const SizedBox(height: 18),
            Material(
              color: context.appColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: context.appColors.primary, width: 1.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                key: const Key('hotel_host_miles_entry'),
                onTap: () => context.push('/hotel-booking/host-miles'),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.homeBookWithMiles,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: context.appColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              context.l10n.hotelMilesEntryDescription,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: context.appColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: context.appColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            HotelHomeFilters(criteria: state.criteria, onApply: onApply),
            const SizedBox(height: 8),
            if (!state.isLoading && state.error == null)
              Text(
                context.l10n.hotelHomeResults(state.totalCount),
                style: Theme.of(context).textTheme.labelLarge,
              ),
          ],
        ),
      ),
    ],
  );
}
