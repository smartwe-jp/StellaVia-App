import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../providers/hotel_booking_providers.dart';
import '../widgets/hotel_coupon_list_widgets.dart';
import '../widgets/hotel_state_views.dart';

enum _HotelCouponListSegment { coupons, fundBenefits }

class HotelCouponListPage extends ConsumerStatefulWidget {
  const HotelCouponListPage({super.key});

  @override
  ConsumerState<HotelCouponListPage> createState() =>
      _HotelCouponListPageState();
}

class _HotelCouponListPageState extends ConsumerState<HotelCouponListPage> {
  final _HotelCouponListSegment _segment = _HotelCouponListSegment.coupons;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final couponsState = ref.watch(hotelCouponsProvider);
    final fundBenefitState = _segment == _HotelCouponListSegment.fundBenefits
        ? ref.watch(hotelFundBenefitTicketsProvider)
        : const AsyncValue<List<HotelFundBenefitTicket>>.data(
            <HotelFundBenefitTicket>[],
          );
    return Scaffold(
      appBar: AppNavigationBar(
        title: context.l10n.hotelCouponsTitle,
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
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(42, 16, 42, 0),
          //   child: AppDualSegmentedControl<_HotelCouponListSegment>(
          //     value: _segment,
          //     height: 40,
          //     radius: 999,
          //     onChanged: (value) => setState(() => _segment = value),
          //     first: AppDualSegmentItem<_HotelCouponListSegment>(
          //       value: _HotelCouponListSegment.coupons,
          //       icon: Icons.local_offer_outlined,
          //       label: context.l10n.hotelCouponsOrdinarySegment(
          //         couponsState.valueOrNull?.coupons.length ?? 0,
          //       ),
          //     ),
          //     second: AppDualSegmentItem<_HotelCouponListSegment>(
          //       value: _HotelCouponListSegment.fundBenefits,
          //       icon: Icons.card_giftcard_rounded,
          //       label: context.l10n.hotelFundBenefitTicketsSegment(
          //         fundBenefitState.valueOrNull?.length ?? 0,
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  if (_segment == _HotelCouponListSegment.coupons)
                    ..._buildCouponSlivers(context, couponsState)
                  else
                    ..._buildFundBenefitSlivers(context, fundBenefitState),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refresh() async {
    await Future.wait<void>(<Future<void>>[
      ref.refresh(hotelCouponsProvider.future).then((_) {}),
    ]);
  }

  List<Widget> _buildCouponSlivers(
    BuildContext context,
    AsyncValue<HotelCouponListResult> state,
  ) {
    return state.when<List<Widget>>(
      loading: () => const <Widget>[
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
      error: (_, __) => <Widget>[
        SliverFillRemaining(
          hasScrollBody: false,
          child: HotelFullPageError(
            onRetry: () => ref.invalidate(hotelCouponsProvider),
          ),
        ),
      ],
      data: (result) {
        final coupons = result.coupons;
        if (coupons.isEmpty) {
          return <Widget>[
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyMessage(message: context.l10n.hotelCouponsEmpty),
            ),
          ];
        }
        return <Widget>[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            sliver: SliverList.separated(
              itemCount: coupons.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                return HotelCouponCard(
                  coupon: coupons[index],
                  pageTexts: result.pageTexts,
                );
              },
            ),
          ),
        ];
      },
    );
  }

  List<Widget> _buildFundBenefitSlivers(
    BuildContext context,
    AsyncValue<List<HotelFundBenefitTicket>> state,
  ) {
    return state.when<List<Widget>>(
      loading: () => const <Widget>[
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
      error: (_, __) => <Widget>[
        SliverFillRemaining(
          hasScrollBody: false,
          child: HotelFullPageError(
            onRetry: () => ref.invalidate(hotelFundBenefitTicketsProvider),
          ),
        ),
      ],
      data: (tickets) {
        if (tickets.isEmpty) {
          return <Widget>[
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyMessage(
                message: context.l10n.hotelFundBenefitTicketsEmpty,
              ),
            ),
          ];
        }
        return <Widget>[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            sliver: SliverList.separated(
              itemCount: tickets.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                return HotelFundBenefitTicketCard(ticket: tickets[index]);
              },
            ),
          ),
        ];
      },
    );
  }
}

class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: colors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
