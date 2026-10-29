import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../support/hotel_booking_presenter.dart';
import '../support/hotel_miles_preview.dart';
import '../widgets/hotel_home_card.dart';
import '../widgets/hotel_miles_summary.dart';
import '../widgets/hotel_miles_preview_search.dart';

class HotelHostMilesPage extends StatelessWidget {
  const HotelHostMilesPage({super.key});
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: context.appColors.surface,
      appBar: AppBar(title: Text(context.l10n.homeBookWithMiles)),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(
            context.l10n.hotelMilesTitle,
            style: text.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.hotelMilesDescription,
            style: text.bodySmall?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.hotelMilesPreview,
            style: text.bodySmall?.copyWith(color: context.appColors.primary),
          ),
          const SizedBox(height: 16),
          const HotelMilesPreviewSummary(),
          const SizedBox(height: 18),
          const HotelMilesPreviewSearch(),
          const SizedBox(height: 12),
          Text(
            context.l10n.hotelMilesAdvanceNotice,
            style: text.bodySmall?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            context.l10n.hotelMilesEligibleHotels,
            style: text.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          HotelHomeCard(
            hotel: hotelMilesPreviewHotel(context),
            presenter: HotelBookingPresenter(
              Localizations.localeOf(context).toLanguageTag(),
            ),
            requiredMiles: 12000,
            previewImageAsset: 'assets/images/hotel_miles_preview.png',
          ),
          const SizedBox(height: 16),
          AppButton(label: context.l10n.hotelMilesChoose, onPressed: null),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
