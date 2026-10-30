import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/hotel_booking_providers.dart';
import '../support/hotel_booking_presenter.dart';
import '../widgets/hotel_state_views.dart';
import '../widgets/hotel_today_checkin_widgets.dart';

class HotelTodayCheckInPage extends ConsumerWidget {
  const HotelTodayCheckInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final state = ref.watch(hotelTodayCheckInControllerProvider);
    final controller = ref.read(hotelTodayCheckInControllerProvider.notifier);
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(context).toLanguageTag(),
    );

    return Scaffold(
      appBar: AppNavigationBar(
        title: context.l10n.hotelTodayCheckInTitle,
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () {
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
            else if (state.items.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    context.l10n.hotelTodayCheckInEmpty,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                sliver: SliverList.separated(
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return HotelTodayCheckInCard(
                      item: item,
                      presenter: presenter,
                      onTap: item.id.isEmpty
                          ? null
                          : () => context.push(
                              '/hotel-booking/check-in/${Uri.encodeComponent(item.id)}',
                            ),
                      onCheckIn: item.id.isEmpty
                          ? null
                          : () => context.push(
                              '/hotel-booking/check-in/${Uri.encodeComponent(item.id)}',
                            ),
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
