import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/hotel_host_miles_provider.dart';
import '../support/hotel_booking_presenter.dart';
import '../widgets/hotel_home_card.dart';
import '../widgets/hotel_host_miles_header.dart';
import '../widgets/hotel_state_views.dart';

class HotelHostMilesPage extends ConsumerStatefulWidget {
  const HotelHostMilesPage({super.key});
  @override
  ConsumerState<HotelHostMilesPage> createState() => _HotelHostMilesPageState();
}

class _HotelHostMilesPageState extends ConsumerState<HotelHostMilesPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        (ModalRoute.of(context)?.isCurrent ?? false)) {
      ref.read(hotelHostMilesProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hotelHostMilesProvider);
    final controller = ref.read(hotelHostMilesProvider.notifier);
    final hotels = state.hotels;
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(context).toLanguageTag(),
    );
    return Scaffold(
      backgroundColor: context.appColors.surface,
      appBar: AppBar(
        title: Text(context.l10n.homeBookWithMiles),
        leading: BackButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/hotel-booking');
            }
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notice) {
            if (notice.depth == 0 &&
                notice.metrics.extentAfter < 400 &&
                hotels.loadMoreError == null) {
              controller.loadMore();
            }
            return false;
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(18),
            children: [
              HotelHostMilesHeader(
                state: state,
                authenticated:
                    ref.watch(isAuthenticatedProvider).asData?.value == true,
                onLogin: () async {
                  await context.push('/login');
                  if (mounted) {
                    ref.read(hotelHostMilesProvider.notifier).refresh();
                  }
                },
                onRetry: controller.refreshMembership,
                onApply: controller.applyCriteria,
              ),
              if (hotels.error != null)
                HotelInlineErrorNotice(onRetry: controller.refreshHotels),
              if (hotels.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (hotels.hotels.isEmpty && hotels.error == null)
                const HotelEmptyList(),
              for (final hotel in hotels.hotels)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: HotelHomeCard(
                    hotel: hotel,
                    presenter: presenter,
                    hostMilesMode: true,
                  ),
                ),
              if (hotels.isLoadingMore)
                const Center(child: CircularProgressIndicator())
              else if (hotels.hasMore)
                AppButton(
                  label: hotels.loadMoreError == null
                      ? context.l10n.hotelMilesLoadMore
                      : context.l10n.commonRetry,
                  onPressed: controller.loadMore,
                  variant: AppButtonVariant.text,
                ),
              const SizedBox(height: 16),
              AppButton(label: context.l10n.hotelMilesChoose, onPressed: null),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
