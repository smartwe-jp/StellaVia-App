import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fundex/features/hotel_booking/presentation/controllers/hotel_booking_controller.dart';
import 'package:fundex/features/hotel_booking/presentation/widgets/hotel_filter_section.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../providers/hotel_booking_providers.dart';
import '../support/hotel_booking_presenter.dart';
import 'hotel_quick_action_section.dart';
import 'hotel_search_conditions_sheet.dart';
import 'hotel_search_summary_bar.dart';

const String _hotelHeroBannerBaseUrl = 'https://stellavia.co.jp/img';
const int _hotelHeroBannerImageCount = 1;
final String _hotelHeroBannerCacheVersion = DateTime.now()
    .millisecondsSinceEpoch
    .toString();

class HotelHeroSection extends ConsumerStatefulWidget {
  const HotelHeroSection({
    super.key,
    required this.state,
    required this.criteria,
    required this.presenter,
    required this.onPriceSortSelected,
    required this.onCriteriaApplied,
    this.onMapTap,
  });

  final HotelBookingState state;
  final HotelSearchCriteria criteria;
  final HotelBookingPresenter presenter;
  final Future<void> Function(HotelSearchCriteria criteria) onCriteriaApplied;
  final Future<void> Function(HotelPriceSort criteria) onPriceSortSelected;
  final VoidCallback? onMapTap;

  @override
  ConsumerState<HotelHeroSection> createState() => _HotelHeroSectionState();
}

class _HotelHeroSectionState extends ConsumerState<HotelHeroSection> {
  Future<void> _openSearchConditions(List<HotelBuildingFilter> filters) async {
    final colors = Theme.of(context).appColors;
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: colors.brandWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (_) {
        return HotelSearchConditionsSheet(
          criteria: widget.criteria,
          presenter: widget.presenter,
          buildingFilters: filters,
          onApply: widget.onCriteriaApplied,
        );
      },
    );
  }

  void _showComingSoon(String featureLabel) {
    AppNotice.show(
      context,
      message: context.l10n.menuFeatureComingSoon(featureLabel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref
        .watch(hotelBuildingFiltersProvider)
        .maybeWhen(
          data: (items) => items,
          orElse: () => const <HotelBuildingFilter>[],
        );
    final destination = hotelAreaLabel(context, widget.criteria.area);
    final summaryLine = context.l10n.hotelSearchSummaryLine(
      destination,
      widget.presenter.stayRange(widget.criteria),
      context.l10n.hotelSearchNights(widget.criteria.nights),
    );
    final guestLine = context.l10n.hotelGuestDetailedSummary(
      widget.criteria.occupancy,
      widget.criteria.kids,
      widget.criteria.roomCount,
    );

    return Stack(
      children: <Widget>[
        AspectRatio(aspectRatio: 0.9, child: _HeroPhoto()),
        Positioned(
          left: 20,
          bottom: 0,
          right: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              HotelSearchSummaryBar(
                summaryLine: summaryLine,
                guestLine: guestLine,
                onTap: () => _openSearchConditions(filters),
              ),

              const SizedBox(height: 30),

              HotelQuickActionSection(
                userInfoLabel: context.l10n.hotelQuickActionUserInfo,
                ordersLabel: context.l10n.hotelQuickActionOrders,
                couponsLabel: context.l10n.hotelQuickActionCoupons,
                contactLabel: context.l10n.hotelQuickActionContact,
                onUserInfoTap: () =>
                    context.push('/hotel-booking/member-profile'),
                onOrdersTap: () =>
                    _showComingSoon(context.l10n.hotelQuickActionOrders),
                onCouponsTap: () =>
                    _showComingSoon(context.l10n.hotelQuickActionCoupons),
                onContactTap: () => context.push('/profile/settings/contact'),
              ),

              const SizedBox(height: 40),

              HotelFilterSection(
                state: widget.state,
                presenter: widget.presenter,
                onPriceSortSelected: widget.onPriceSortSelected,
                onCriteriaApplied: widget.onCriteriaApplied,
                onMapTap: widget.onMapTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroPhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final heroImageUrls = _hotelHeroImageUrls(Localizations.localeOf(context));
    return DecoratedBox(
      decoration: BoxDecoration(color: colors.brandPrimary),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/images/hotel-booking-ui/hotelbg.jpg',
            fit: BoxFit.fitWidth,
          ),
          FundHeroMediaBackground(
            gradientColors: <Color>[colors.heroMiddle, colors.primaryAlt],
            imageUrls: heroImageUrls,
            showArtworkOverlay: false,
            autoPlay: heroImageUrls.length > 1,
            autoPlayInterval: const Duration(seconds: 25),
          ),
          Positioned(left: 20, top: 80, right: 16, child: _HeroCopy()),
        ],
      ),
    );
  }
}

List<String> _hotelHeroImageUrls(Locale locale) {
  final localeSuffix = _hotelHeroLocaleSuffix(locale);
  return List<String>.generate(
    _hotelHeroBannerImageCount,
    (index) =>
        '$_hotelHeroBannerBaseUrl/hotel.${index + 1}.$localeSuffix.jpg'
        '?v=$_hotelHeroBannerCacheVersion',
    growable: false,
  );
}

String _hotelHeroLocaleSuffix(Locale locale) {
  final languageCode = locale.languageCode.toLowerCase();
  if (languageCode == 'ja') {
    return 'ja';
  }
  if (languageCode == 'zh') {
    final scriptCode = locale.scriptCode?.toLowerCase();
    return scriptCode == 'hant' ? 'zh-hant' : 'zh-hans';
  }
  return 'en';
}

class _HeroCopy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          context.l10n.hotelBrandMark,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: colors.onDark,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
        //const SizedBox(height: 10),
        // Text(
        //   context.l10n.hotelTabHeadline,
        //   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        //     color: colors.onDark,
        //     fontWeight: FontWeight.w900,
        //     letterSpacing: 0,
        //   ),
        // ),
        const SizedBox(height: 22),
        Text(
          context.l10n.hotelTabSubtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: colors.onDark.withValues(alpha: 0.80),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
