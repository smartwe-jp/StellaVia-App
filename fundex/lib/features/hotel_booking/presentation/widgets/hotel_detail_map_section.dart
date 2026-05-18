import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';

class HotelDetailMapSection extends StatelessWidget {
  const HotelDetailMapSection({super.key, required this.detail});

  final HotelDetail detail;

  static bool canShow(HotelDetail detail) => _coordinateFor(detail) != null;

  @override
  Widget build(BuildContext context) {
    final coordinate = _coordinateFor(detail);
    if (coordinate == null) {
      return const SizedBox.shrink();
    }

    final colors = Theme.of(context).appColors;
    final address = detail.address.isNotEmpty
        ? detail.address
        : context.l10n.hotelDetailAddress;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.brandWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.borderSoft.withValues(alpha: 0.72)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.map_outlined,
                  color: colors.brandSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.l10n.hotelToolbarMap,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colors.brandPrimaryDark,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FundPropertyMapPreviewCard(
              addressLabel: address,
              destination: coordinate,
              height: 190,
              onTap: () => _showMapSheet(context, coordinate),
            ),
          ],
        ),
      ),
    );
  }

  static FundPropertyCoordinate? _coordinateFor(HotelDetail detail) {
    final latitude = detail.latitude;
    final longitude = detail.longitude;
    if (latitude == null || longitude == null) {
      return null;
    }
    if (latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180) {
      return null;
    }
    return FundPropertyCoordinate(latitude: latitude, longitude: longitude);
  }

  void _showMapSheet(BuildContext context, FundPropertyCoordinate coordinate) {
    final title = detail.name.isNotEmpty
        ? detail.name
        : context.l10n.hotelUnnamedProperty;
    FundPropertyMapBottomSheet.show(
      context: context,
      title: title,
      destination: coordinate,
      strings: FundPropertyMapSheetStrings(
        close: context.l10n.fundDetailMapClose,
        destination: context.l10n.fundDetailMapDestination,
        currentLocation: context.l10n.fundDetailMapCurrentLocation,
        directions: context.l10n.fundDetailMapDirections,
        openMapApp: context.l10n.fundDetailMapOpenMapApp,
        cancel: context.l10n.fundDetailMapCancel,
        locationPermissionDenied: context.l10n.fundDetailMapPermissionDenied,
        locationUnavailable: context.l10n.fundDetailMapUnavailable,
      ),
    );
  }
}
