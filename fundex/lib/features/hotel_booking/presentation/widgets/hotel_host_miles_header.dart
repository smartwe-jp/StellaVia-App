import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../controllers/hotel_host_miles_controller.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_home_text_styles.dart';
import '../support/hotel_miles_display.dart';
import 'hotel_miles_summary.dart';
import 'hotel_home_search.dart';

class HotelHostMilesHeader extends StatelessWidget {
  const HotelHostMilesHeader({
    super.key,
    required this.state,
    required this.authenticated,
    required this.onLogin,
    required this.onRetry,
    required this.onApply,
  });
  final HotelHostMilesState state;
  final bool authenticated;
  final VoidCallback onLogin, onRetry;
  final Future<void> Function(HotelSearchCriteria) onApply;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final display = HotelMilesDisplay(
      state.account.valueOrNull,
      state.tier.valueOrNull,
      l,
      Localizations.localeOf(context).toLanguageTag(),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.hotelMilesTitle, style: HotelHomeTextStyles.pageTitle(context)),
        const SizedBox(height: 4),
        Text(l.hotelMilesDescription, style: context.appTextTheme.caption),
        const SizedBox(height: 16),
        HotelMilesSummary(
          rank: display.rank,
          balance: display.balance,
          rooms: display.rooms,
        ),
        if (!authenticated)
          AppButton(
            label: l.hotelMilesLogin,
            onPressed: onLogin,
            variant: AppButtonVariant.text,
          ),
        if (state.account.isLoading || state.tier.isLoading)
          const LinearProgressIndicator(),
        if (state.account.hasError || state.tier.hasError)
          AppButton(
            label: '${l.homeDataLoadError} ${l.commonRetry}',
            onPressed: onRetry,
            variant: AppButtonVariant.text,
          ),
        const SizedBox(height: 18),
        HotelHomeSearch(
          criteria: state.hotels.criteria,
          onApply: onApply,
          allowMultiNightBenefits: true,
        ),
        const SizedBox(height: 10),
        HotelHomeFilters(criteria: state.hotels.criteria, onApply: onApply),
        if (display.advance != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(display.advance!, style: context.appTextTheme.caption),
          ),
        const SizedBox(height: 12),
        Text(l.hotelMilesBookingPending, style: context.appTextTheme.caption),
        const SizedBox(height: 24),
        Text(
          l.hotelMilesEligibleHotels,
          style: HotelHomeTextStyles.sectionTitle(context),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
