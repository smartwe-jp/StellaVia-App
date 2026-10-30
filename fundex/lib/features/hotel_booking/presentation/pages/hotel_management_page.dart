import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../main_shell/presentation/providers/main_shell_providers.dart';
import '../../../main_shell/presentation/widgets/main_shell_tab_refresh_scope.dart';
import '../providers/hotel_management_providers.dart';
import '../widgets/hotel_bookings_refresh_scope.dart';
import '../widgets/hotel_management_actions.dart';
import '../widgets/hotel_management_summary.dart';

class HotelManagementPage extends ConsumerStatefulWidget {
  const HotelManagementPage({super.key});
  @override
  ConsumerState<HotelManagementPage> createState() =>
      _HotelManagementPageState();
}

class _HotelManagementPageState extends ConsumerState<HotelManagementPage> {
  final _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() => refreshHotelManagementTier(ref);
  Future<void> _open(String path) async {
    await context.push(path);
    if (mounted) await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final tier = ref.watch(hotelManagementTierProvider);
    return MainShellTabRefreshScope(
      tabIndex: MainShellTab.bookings.index,
      scrollController: _scrollController,
      onRefresh: (_) => _refresh(),
      child: HotelBookingsRefreshScope(
        onRefresh: _refresh,
        child: Scaffold(
          appBar: AppScrollNavigationBar(
            reveal: ref.watch(mainShellChromeRevealProvider),
            backgroundColor: context.appColors.surface,
            navigationBar: AppNavigationBar(
              title: context.l10n.mainTabBookings,
              backgroundColor: context.appColors.surface,
              foregroundColor: context.appColors.textPrimary,
            ),
          ),
          body: SafeArea(
            top: false,
            bottom: false,
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  HotelManagementActions(
                    onOrders: () => _open('/bookings/history'),
                    onCheckIn: () => _open('/hotel-booking/check-in'),
                    onCoupons: () => _open('/hotel-booking/coupons'),
                    onContacts: () => _open('/hotel-booking/contacts'),
                  ),
                  const SizedBox(height: 20),
                  HotelManagementCapacity(
                    current: tier.valueOrNull?.currentBookingRooms,
                    maximum: tier.valueOrNull?.maxRooms,
                    loading: tier.isLoading,
                    hasError: tier.hasError,
                    onRetry: _refresh,
                  ),
                  const SizedBox(height: 12),
                  HotelManagementNextTrip(
                    onTap: () => _open('/hotel-booking/host-miles'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
