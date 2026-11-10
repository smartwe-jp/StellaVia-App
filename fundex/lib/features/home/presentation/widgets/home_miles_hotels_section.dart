import 'dart:math' as math;
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../hotel_booking/presentation/support/hotel_booking_presenter.dart';
import '../../../hotel_booking/presentation/support/hotel_detail_route_args.dart';
import '../../../hotel_booking/presentation/widgets/hotel_home_card.dart';
import '../../../hotel_booking/presentation/widgets/hotel_state_views.dart';
import '../providers/home_featured_hotels_provider.dart';

class HomeMilesHotelsSection extends ConsumerWidget {
  const HomeMilesHotelsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeFeaturedHotelsProvider);
    final l = context.l10n;
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(context).toLanguageTag(),
    );
    final preview = state.valueOrNull;
    return LayoutBuilder(
      builder: (context, bounds) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FundSectionHeader(
            title: l.homeFeaturedHotelsTitle,
            actionLabel: l.homeFeaturedFundViewDetailAction,
            onActionTap: () => context.push('/hotel-booking/host-miles'),
          ),
          const SizedBox(height: 8),
          if (state.hasError)
            HotelInlineErrorNotice(
              onRetry: () => ref.invalidate(homeFeaturedHotelsProvider),
            ),
          if (state.isLoading && (preview?.hotels.isEmpty ?? true))
            const Center(child: CircularProgressIndicator.adaptive()),
          if (state.hasValue &&
              !state.isLoading &&
              !state.hasError &&
              preview?.hotels.isEmpty == true)
            Text(l.hotelEmptyResults, style: context.appTextTheme.bodyMuted),
          if (preview != null && preview.hotels.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  for (final hotel in preview.hotels)
                    SizedBox(
                      width: math.min(320, bounds.maxWidth),
                      child: HotelHomeCard(
                        hotel: hotel,
                        presenter: presenter,
                        hostMilesMode: true,
                        onTap: () => context.push(
                          '/hotel-booking/${Uri.encodeComponent(hotel.id)}',
                          extra: HotelDetailRouteArgs(
                            criteria: preview.criteria,
                            buildingCode: hotel.buildingCode,
                            mode: HotelBookingMode.hostMiles,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
