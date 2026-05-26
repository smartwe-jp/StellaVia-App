import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/status_bar/app_status_bar_providers.dart';
import '../providers/hotel_booking_providers.dart';
import '../support/hotel_booking_presenter.dart';
import '../widgets/hotel_order_list_widgets.dart';
import '../widgets/hotel_state_views.dart';
import '../widgets/hotel_status_bar_preference_scope.dart';

class HotelOrderListPage extends ConsumerWidget {
  const HotelOrderListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final state = ref.watch(hotelOrderListControllerProvider);
    final controller = ref.read(hotelOrderListControllerProvider.notifier);
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(context).toLanguageTag(),
    );

    return HotelStatusBarPreferenceScope(
      immersive: false,
      immersiveOnPop: true,
      child: Scaffold(
        backgroundColor: colors.surfaceAlt,
        appBar: AppNavigationBar(
          title: context.l10n.hotelOrdersTitle,
          backgroundColor: colors.surface,
          foregroundColor: colors.textPrimary,
          leading: AppNavigationIconButton(
            icon: Icons.arrow_back_rounded,
            onTap: () {
              ref.read(appImmersiveHotelStatusBarHintProvider.notifier).state =
                  true;
              if (context.canPop()) {
                context.pop();
                return;
              }
              context.go('/hotel-booking');
            },
            backgroundColor: colors.surface.withValues(alpha: 0),
            foregroundColor: colors.textPrimary,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: controller.refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: HotelOrderStatusFilterBar(
                    selected: state.status,
                    onChanged: controller.setStatus,
                  ),
                ),
              ),
              if (state.error != null && state.hasContent)
                SliverToBoxAdapter(
                  child: HotelInlineErrorNotice(onRetry: controller.refresh),
                ),
              if (state.isLoading && !state.hasContent)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.error != null && !state.hasContent)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: HotelFullPageError(onRetry: controller.refresh),
                )
              else if (state.orders.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      context.l10n.hotelOrdersEmpty,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverList.separated(
                    itemCount: state.orders.length + (state.hasMore ? 1 : 0),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index >= state.orders.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: HotelOrderListLoadMoreButton(
                            isLoading: state.isLoadingMore,
                            onPressed: controller.loadMore,
                          ),
                        );
                      }
                      final order = state.orders[index];
                      void openDetail() {
                        if (order.id.isEmpty) {
                          return;
                        }
                        context.push(
                          '/hotel-booking/orders/${Uri.encodeComponent(order.id)}',
                        );
                      }

                      return HotelOrderSummaryCard(
                        order: order,
                        presenter: presenter,
                        onTap: openDetail,
                        onRebook: () => AppNotice.show(
                          context,
                          message: context.l10n.hotelOrdersRebookComingSoon,
                        ),
                        onViewDetail: openDetail,
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
