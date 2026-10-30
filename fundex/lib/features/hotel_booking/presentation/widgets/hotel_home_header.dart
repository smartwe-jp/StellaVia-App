import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../controllers/hotel_booking_controller.dart';
import '../../domain/entities/hotel_models.dart';
import 'hotel_home_search.dart';
import '../support/hotel_home_text_styles.dart';

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
      Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.hotelHomeTitle,
              style: HotelHomeTextStyles.pageTitle(context),
            ),
            const SizedBox(height: 10),
            HotelHomeSearch(criteria: state.criteria, onApply: onApply),
            const SizedBox(height: 18),
            AppCard(
              key: const Key('hotel_host_miles_entry'),
              borderRadius: BorderRadius.circular(20),
              borderColor: context.appColors.primary,
              borderWidth: 1.5,
              padding: const EdgeInsets.all(14),
              onTap: () => context.push('/hotel-booking/host-miles'),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.homeBookWithMiles,
                          style: HotelHomeTextStyles.sectionTitle(
                            context,
                          ).copyWith(color: context.appColors.primary),
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
                  Icon(Icons.chevron_right, color: context.appColors.primary),
                ],
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

/// Brand navigation remains separate from the scrolling search/filter content.
class HotelHomeNavigationBar extends StatelessWidget
    implements PreferredSizeWidget {
  const HotelHomeNavigationBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(57);
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
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
                  style: HotelHomeTextStyles.brandWordmark(context),
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
    ],
  );
}
