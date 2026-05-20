import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';

class HotelDetailMapSection extends StatelessWidget {
  const HotelDetailMapSection({super.key, required this.detail});

  final HotelDetail detail;

  static bool canShow(HotelDetail detail) =>
      detail.address.trim().isNotEmpty || _coordinateFor(detail) != null;

  @override
  Widget build(BuildContext context) {
    final coordinate = _coordinateFor(detail);
    final address = detail.address.trim();
    if (coordinate == null && address.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = Theme.of(context).appColors;
    final addressLabel = address.isNotEmpty
        ? address
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
                  Icons.place_outlined,
                  color: colors.brandSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        context.l10n.hotelDetailAddress,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: colors.brandPrimaryDark,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        addressLabel,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final height = width.isFinite ? width * 0.8 : 190.0;
                return FundPropertyMapPreviewCard(
                  addressLabel: addressLabel,
                  destination: coordinate,
                  height: height,
                  showAddressOverlay: false,
                  showZoomControls: true,
                  onTap: coordinate == null
                      ? null
                      : () => _showMapAppPicker(context, coordinate),
                );
              },
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

  Future<void> _showMapAppPicker(
    BuildContext context,
    FundPropertyCoordinate coordinate,
  ) {
    final platform = Theme.of(context).platform;
    final options = <_HotelMapAppOption>[
      if (platform == TargetPlatform.iOS)
        _HotelMapAppOption(
          name: 'Apple map',
          icon: Icons.map_outlined,
          uri: _mapUri(_HotelMapAppType.apple, coordinate, context),
        ),
      _HotelMapAppOption(
        name: 'Google Map',
        icon: Icons.public_outlined,
        uri: _mapUri(_HotelMapAppType.google, coordinate, context),
      ),
      _HotelMapAppOption(
        name: 'Yahoo Map',
        icon: Icons.travel_explore_outlined,
        uri: _mapUri(_HotelMapAppType.yahoo, coordinate, context),
      ),
      _HotelMapAppOption(
        name: 'Amap',
        icon: Icons.near_me_outlined,
        uri: _mapUri(_HotelMapAppType.amap, coordinate, context),
      ),
    ];
    final colors = Theme.of(context).appColors;
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: colors.brandWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.borderSoft,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  context.l10n.hotelMapAppPickerTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colors.brandPrimaryDark,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                for (final option in options) ...<Widget>[
                  _HotelMapAppCell(
                    option: option,
                    onTap: () async {
                      Navigator.of(sheetContext).pop();
                      await _openMapApp(context, option.uri);
                    },
                  ),
                  if (option != options.last)
                    Divider(height: 1, color: colors.borderSoft),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Uri _mapUri(
    _HotelMapAppType type,
    FundPropertyCoordinate coordinate,
    BuildContext context,
  ) {
    final title = detail.name.isNotEmpty
        ? detail.name
        : context.l10n.hotelUnnamedProperty;
    final lat = coordinate.latitude;
    final lng = coordinate.longitude;
    final encodedTitle = Uri.encodeComponent(title);
    return switch (type) {
      _HotelMapAppType.apple => Uri.parse(
        'maps://?daddr=$lat,$lng&q=$encodedTitle',
      ),
      _HotelMapAppType.google =>
        _isIos(context)
            ? Uri.parse(
                'comgooglemaps://?daddr=$lat,$lng&directionsmode=driving',
              )
            : Uri.parse('google.navigation:q=$lat,$lng'),
      _HotelMapAppType.yahoo => Uri.parse(
        'yjmap://?lat=$lat&lon=$lng&z=16&mode=map',
      ),
      _HotelMapAppType.amap =>
        _isIos(context)
            ? Uri.parse(
                'iosamap://viewMap?sourceApplication=StellaVia&poiname=$encodedTitle&lat=$lat&lon=$lng&dev=0',
              )
            : Uri.parse(
                'androidamap://viewMap?sourceApplication=StellaVia&poiname=$encodedTitle&lat=$lat&lon=$lng&dev=0',
              ),
    };
  }

  bool _isIos(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  Future<void> _openMapApp(BuildContext context, Uri uri) async {
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (launched) {
        return;
      }
    } catch (_) {
      // Fall through to the user-facing not-installed notice.
    }
    if (!context.mounted) {
      return;
    }
    AppNotice.show(context, message: context.l10n.hotelMapAppNotInstalled);
  }
}

enum _HotelMapAppType { apple, google, yahoo, amap }

class _HotelMapAppOption {
  const _HotelMapAppOption({
    required this.name,
    required this.icon,
    required this.uri,
  });

  final String name;
  final IconData icon;
  final Uri uri;
}

class _HotelMapAppCell extends StatelessWidget {
  const _HotelMapAppCell({required this.option, required this.onTap});

  final _HotelMapAppOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: <Widget>[
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: colors.brandSecondary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(option.icon, color: colors.brandSecondary, size: 21),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                option.name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: colors.brandPrimaryDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colors.textTertiary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
