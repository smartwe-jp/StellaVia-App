import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../main_shell/presentation/providers/main_shell_providers.dart';
import '../../../main_shell/presentation/widgets/main_shell_tab_refresh_scope.dart';
import '../providers/hotel_booking_providers.dart';
import '../support/hotel_booking_presenter.dart';
import '../support/hotel_detail_route_args.dart';
import '../support/hotel_map_route_args.dart';
import '../widgets/hotel_booking_service_footer.dart';
import '../widgets/hotel_home_header.dart';
import '../widgets/hotel_price_discount_dialog.dart';
import '../widgets/hotel_state_views.dart';
import '../widgets/hotel_home_card.dart';

class HotelBookingTabPage extends ConsumerWidget {
  const HotelBookingTabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _HotelBookingTabContent();
  }
}

class _HotelBookingTabContent extends ConsumerStatefulWidget {
  const _HotelBookingTabContent();

  @override
  ConsumerState<_HotelBookingTabContent> createState() =>
      _HotelBookingTabContentState();
}

class _HotelBookingTabContentState
    extends ConsumerState<_HotelBookingTabContent> {
  final ScrollController _scrollController = ScrollController();

  static const double _loadMoreTriggerExtent = 480;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hotelBookingControllerProvider);
    final controller = ref.read(hotelBookingControllerProvider.notifier);
    final colors = Theme.of(context).appColors;
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(context).toLanguageTag(),
    );

    return MainShellTabRefreshScope(
      tabIndex: MainShellTab.hotel.index,
      onRefresh: (_) => controller.refresh(),
      scrollController: _scrollController,
      child: ColoredBox(
        color: colors.background,
        child: Column(
          children: [
            AppScrollNavigationBar(
              reveal: ref.watch(mainShellChromeRevealProvider),
              backgroundColor: colors.background,
              navigationBar: const HotelHomeNavigationBar(),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refresh,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.depth != 0) {
                      return false;
                    }
                    if (notification.metrics.extentAfter <
                            _loadMoreTriggerExtent &&
                        state.hasMore &&
                        state.loadMoreError == null) {
                      controller.loadMore();
                    }
                    return false;
                  },
                  child: CustomScrollView(
                    key: const Key('hotel_tab_content'),
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: HotelHomeHeader(
                          state: state,
                          onApply: controller.applyCriteria,
                        ),
                      ),
                      if (state.error != null && state.hasContent)
                        SliverToBoxAdapter(
                          child: HotelInlineErrorNotice(
                            onRetry: controller.refresh,
                          ),
                        ),
                      if (state.isLoading)
                        const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (state.error != null && !state.hasContent)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: HotelFullPageError(
                            onRetry: controller.refresh,
                          ),
                        )
                      else if (state.hotels.isEmpty)
                        const SliverFillRemaining(
                          hasScrollBody: false,
                          child: HotelEmptyList(),
                        )
                      else ...<Widget>[
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                          sliver: SliverList.separated(
                            itemCount: state.hotels.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final hotel = state.hotels[index];
                              final mapArgs = HotelMapRouteArgs.fromHotel(
                                criteria: state.criteria,
                                hotel: hotel,
                              );
                              return HotelHomeCard(
                                hotel: hotel,
                                presenter: presenter,
                                onDiscountTap: hotel.id.trim().isEmpty
                                    ? null
                                    : () => showHotelPriceDiscountDialog(
                                        context: context,
                                        hotelId: hotel.id,
                                        criteria: state.criteria,
                                        presenter: presenter,
                                        showBookingAction: true,
                                        onBookingTap: () => context.push(
                                          '/hotel-booking/${Uri.encodeComponent(hotel.id)}',
                                          extra: HotelDetailRouteArgs(
                                            criteria: state.criteria,
                                            buildingCode: hotel.buildingCode,
                                          ),
                                        ),
                                      ),
                                onTap: hotel.id.trim().isEmpty
                                    ? null
                                    : () => context.push(
                                        '/hotel-booking/${Uri.encodeComponent(hotel.id)}',
                                        extra: HotelDetailRouteArgs(
                                          criteria: state.criteria,
                                          buildingCode: hotel.buildingCode,
                                        ),
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
                        if (state.hasMore || state.isLoadingMore)
                          SliverToBoxAdapter(
                            child: _HotelListLoadMoreFooter(
                              isLoading: state.isLoadingMore,
                              error: state.loadMoreError,
                              onRetry: controller.loadMore,
                            ),
                          )
                        else
                          const SliverToBoxAdapter(child: SizedBox(height: 24)),
                        const SliverToBoxAdapter(
                          child: HotelBookingServiceFooter(),
                        ),
                      ],
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

class _HotelListLoadMoreFooter extends StatelessWidget {
  const _HotelListLoadMoreFooter({
    required this.isLoading,
    required this.error,
    required this.onRetry,
  });

  final bool isLoading;
  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      child: SizedBox(
        height: 48,
        child: Center(
          child: error == null
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: colors.brandPrimary,
                  ),
                )
              : TextButton.icon(
                  onPressed: isLoading ? null : onRetry,
                  icon: Icon(Icons.refresh_rounded, color: colors.brandPrimary),
                  label: Text(context.l10n.commonRetry),
                ),
        ),
      ),
    );
  }
}
