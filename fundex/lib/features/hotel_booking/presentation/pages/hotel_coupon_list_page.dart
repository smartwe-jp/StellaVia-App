import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/status_bar/app_status_bar_providers.dart';
import '../providers/hotel_booking_providers.dart';
import '../widgets/hotel_coupon_list_widgets.dart';
import '../widgets/hotel_state_views.dart';
import '../widgets/hotel_status_bar_preference_scope.dart';

class HotelCouponListPage extends ConsumerWidget {
  const HotelCouponListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final state = ref.watch(hotelCouponsProvider);
    return HotelStatusBarPreferenceScope(
      immersive: false,
      immersiveOnPop: true,
      child: Scaffold(
        backgroundColor: colors.surfaceAlt,
        appBar: AppNavigationBar(
          title: context.l10n.hotelCouponsTitle,
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
          onRefresh: () => ref.refresh(hotelCouponsProvider.future),
          child: state.when(
            loading: () => const CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
            error: (_, __) => CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: HotelFullPageError(
                    onRetry: () => ref.invalidate(hotelCouponsProvider),
                  ),
                ),
              ],
            ),
            data: (result) {
              if (result.coupons.isEmpty) {
                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: <Widget>[
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          context.l10n.hotelCouponsEmpty,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                    sliver: SliverList.separated(
                      itemCount: result.coupons.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        return HotelCouponCard(
                          coupon: result.coupons[index],
                          pageTexts: result.pageTexts,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
