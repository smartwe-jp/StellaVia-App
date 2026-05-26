import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/hotel_booking_providers.dart';
import '../support/hotel_booking_presenter.dart';
import '../support/hotel_map_route_args.dart';
import '../widgets/hotel_hero_section.dart';
import '../widgets/hotel_status_bar_preference_scope.dart';
import '../widgets/hotel_state_views.dart';
import '../widgets/hotel_summary_card.dart';

class HotelBookingTabPage extends ConsumerWidget {
  const HotelBookingTabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const HotelStatusBarPreferenceScope(
      immersive: true,
      child: _HotelBookingTabContent(),
    );
  }
}

class _HotelBookingTabContent extends ConsumerWidget {
  const _HotelBookingTabContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(hotelBookingControllerProvider);
    final controller = ref.read(hotelBookingControllerProvider.notifier);
    final colors = Theme.of(context).appColors;
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(context).toLanguageTag(),
    );

    return ColoredBox(
      color: colors.surfaceAlt,
      child: RefreshIndicator(
        onRefresh: controller.refresh,
        child: CustomScrollView(
          key: const Key('hotel_tab_content'),
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: HotelHeroSection(
                state: state,
                criteria: state.criteria,
                presenter: presenter,
                onCriteriaApplied: controller.applyCriteria,
                onPriceSortSelected: controller.setPriceSort,
                onMapTap: () =>
                    context.push('/hotel-booking/map', extra: state.criteria),
                onOrdersTap: () => context.push('/hotel-booking/orders'),
              ),
            ),
            if (state.error != null && state.hasContent)
              SliverToBoxAdapter(
                child: HotelInlineErrorNotice(onRetry: controller.refresh),
              ),
            if (state.isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.error != null && !state.hasContent)
              SliverFillRemaining(
                hasScrollBody: false,
                child: HotelFullPageError(onRetry: controller.refresh),
              )
            else if (state.hotels.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: HotelEmptyList(),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                sliver: SliverList.separated(
                  itemCount: state.hotels.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final hotel = state.hotels[index];
                    final mapArgs = HotelMapRouteArgs.fromHotel(
                      criteria: state.criteria,
                      hotel: hotel,
                    );
                    return HotelSummaryCard(
                      hotel: hotel,
                      presenter: presenter,
                      onTap: hotel.id.trim().isEmpty
                          ? null
                          : () => context.push(
                              '/hotel-booking/${Uri.encodeComponent(hotel.id)}',
                              extra: state.criteria,
                            ),
                      onMapTap: mapArgs.hasValidTarget
                          ? () => context.push(
                              '/hotel-booking/map',
                              extra: mapArgs,
                            )
                          : null,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
