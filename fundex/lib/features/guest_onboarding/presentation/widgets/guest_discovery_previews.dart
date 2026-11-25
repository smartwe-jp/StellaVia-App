import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../home/presentation/providers/home_featured_hotels_provider.dart';
import '../../../home/presentation/support/home_featured_fund_card_mapper.dart';
import '../../../home/presentation/widgets/home_featured_section.dart';
import '../../../hotel_booking/presentation/support/hotel_detail_route_args.dart';
import '../../../investment/presentation/providers/fund_project_providers.dart';

class GuestDiscoveryPreviews extends ConsumerWidget {
  const GuestDiscoveryPreviews({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final projects = ref.watch(fundProjectListProvider);
    final hotels = ref.watch(homeFeaturedHotelsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HomeFeaturedSectionHeader(
          title: l.homeFeaturedFundsTitle,
          actionLabel: l.homeViewAllAction,
          onActionTap: () => context.push('/funds'),
        ),
        projects.when(
          data: (items) {
            if (items.isEmpty) return Text(l.fundListEmpty);
            final fund = buildHomeFeaturedFundCardData(context, items.first);
            return _PreviewTile(
              title: fund.title,
              caption: fund.tags.first.label,
              details:
                  '${l.homeEstimatedYieldLabel} ${fund.annualYield} · ${l.fundListPeriodLabel} ${fund.periodValue}',
              image: fund.imageUrls.firstOrNull,
              onTap: fund.onTap,
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (_, _) => TextButton(
            onPressed: () => ref.invalidate(fundProjectListProvider),
            child: Text(l.fundListRetry),
          ),
        ),
        const SizedBox(height: 20),
        HomeFeaturedSectionHeader(
          title: l.homeFeaturedHotelsTitle,
          actionLabel: l.homeViewAllAction,
          onActionTap: () => context.push('/hotel-booking/host-miles'),
        ),
        hotels.when(
          data: (result) {
            final hotel = result.hotels.firstOrNull;
            if (hotel == null) return Text(l.hotelEmptyResults);
            return _PreviewTile(
              title: hotel.name,
              caption: hotel.area,
              details: hotel.address,
              image: hotel.imageUrl,
              onTap: () => context.push(
                '/hotel-booking/${Uri.encodeComponent(hotel.id)}',
                extra: HotelDetailRouteArgs(
                  criteria: result.criteria,
                  buildingCode: hotel.buildingCode,
                  mode: HotelBookingMode.hostMiles,
                ),
              ),
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (_, _) => TextButton(
            onPressed: () => ref.invalidate(homeFeaturedHotelsProvider),
            child: Text(l.fundListRetry),
          ),
        ),
      ],
    );
  }
}

class _PreviewTile extends StatelessWidget {
  const _PreviewTile({
    required this.title,
    required this.caption,
    required this.details,
    required this.image,
    required this.onTap,
  });
  final String title, caption, details;
  final String? image;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final fallback = ColoredBox(
      color: context.appColors.background,
      child: const Center(child: Icon(Icons.image_outlined)),
    );
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 88,
                  height: 96,
                  child: image == null || image!.isEmpty
                      ? fallback
                      : Image.network(
                          image!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => fallback,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (caption.isNotEmpty)
                      Text(
                        caption,
                        style: context.appTextTheme.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (details.isNotEmpty)
                      Text(
                        details,
                        style: context.appTextTheme.caption,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
