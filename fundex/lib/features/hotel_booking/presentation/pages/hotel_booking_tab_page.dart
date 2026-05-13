import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/hotel_booking_providers.dart';
import '../support/hotel_booking_presenter.dart';
import '../widgets/hotel_filter_section.dart';
import '../widgets/hotel_hero_section.dart';
import '../widgets/hotel_state_views.dart';
import '../widgets/hotel_summary_card.dart';

class HotelBookingTabPage extends ConsumerWidget {
  const HotelBookingTabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _HotelBookingTabContent();
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
                criteria: state.criteria,
                presenter: presenter,
                onSearch: controller.submitSearch,
                onBuildingSelected: controller.selectBuildingCode,
                onGuestsChanged: controller.setGuestCounts,
              ),
            ),
            SliverToBoxAdapter(
              child: HotelFilterSection(
                state: state,
                onPriceSortSelected: controller.setPriceSort,
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
                    return HotelSummaryCard(
                      hotel: state.hotels[index],
                      presenter: presenter,
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
