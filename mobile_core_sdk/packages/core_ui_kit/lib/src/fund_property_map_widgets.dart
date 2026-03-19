import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_notice.dart';
import 'app_theme_extensions.dart';
import 'ui_tokens.dart';

class FundPropertyCoordinate {
  const FundPropertyCoordinate({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  LatLng toLatLng() => LatLng(latitude, longitude);
}

class FundPropertyMapSheetStrings {
  const FundPropertyMapSheetStrings({
    required this.close,
    required this.destination,
    required this.currentLocation,
    required this.directions,
    required this.openMapApp,
    required this.cancel,
    required this.locationPermissionDenied,
    required this.locationUnavailable,
  });

  final String close;
  final String destination;
  final String currentLocation;
  final String directions;
  final String openMapApp;
  final String cancel;
  final String locationPermissionDenied;
  final String locationUnavailable;
}

class FundPropertyMapPreviewCard extends StatelessWidget {
  const FundPropertyMapPreviewCard({
    super.key,
    required this.addressLabel,
    this.height = 164,
    this.onTap,
  });

  final String addressLabel;
  final double height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Material(
      color: colors.infoSubtle,
      borderRadius: BorderRadius.circular(UiTokens.radius16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(UiTokens.radius16),
        child: SizedBox(
          width: double.infinity,
          height: height,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
              decoration: BoxDecoration(
                color: colors.surface.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(14),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: colors.scrim.withValues(alpha: 0.10),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                '📍 $addressLabel',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: appText.sectionTitle.copyWith(color: colors.primary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FundPropertyMapBottomSheet extends StatefulWidget {
  const FundPropertyMapBottomSheet({
    super.key,
    required this.title,
    required this.destination,
    required this.strings,
  });

  final String title;
  final FundPropertyCoordinate destination;
  final FundPropertyMapSheetStrings strings;

  static Future<void> show({
    required BuildContext context,
    required String title,
    required FundPropertyCoordinate destination,
    required FundPropertyMapSheetStrings strings,
  }) {
    final colors = Theme.of(context).appColors;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: colors.surface.withValues(alpha: 0),
      barrierColor: colors.scrim.withValues(alpha: 0.38),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.94,
          child: FundPropertyMapBottomSheet(
            title: title,
            destination: destination,
            strings: strings,
          ),
        );
      },
    );
  }

  @override
  State<FundPropertyMapBottomSheet> createState() =>
      _FundPropertyMapBottomSheetState();
}

class _FundPropertyMapBottomSheetState
    extends State<FundPropertyMapBottomSheet> {
  final MapController _mapController = MapController();
  LatLng? _currentLatLng;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final topPadding = MediaQuery.paddingOf(context).top;
    final destinationLatLng = widget.destination.toLatLng();
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      child: ColoredBox(
        color: colors.surface,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: destinationLatLng,
                  initialZoom: 5.6,
                ),
                children: <Widget>[
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'fun.d.ex',
                  ),
                  MarkerLayer(
                    markers: <Marker>[
                      Marker(
                        point: destinationLatLng,
                        width: 40,
                        height: 40,
                        child: const _DestinationMarker(),
                      ),
                      if (_currentLatLng != null)
                        Marker(
                          point: _currentLatLng!,
                          width: 22,
                          height: 22,
                          child: const _CurrentLocationMarker(),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: topPadding + 4,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 64,
                decoration: BoxDecoration(
                  color: colors.infoSubtle,
                  border: Border.all(
                    color: colors.surface.withValues(alpha: 0.15),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        visualDensity: const VisualDensity(
                          horizontal: -1,
                          vertical: -1,
                        ),
                      ),
                      child: Text(
                        widget.strings.close,
                        style: appText.pageTitle.copyWith(
                          color: colors.brandAlert,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: appText.sectionTitle.copyWith(
                            color: colors.brandAlert,
                            letterSpacing: 1.6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 12,
              bottom: 16 + MediaQuery.paddingOf(context).bottom,
              child: Row(
                children: <Widget>[
                  _MapFloatingActionButton(
                    icon: Icons.location_on_outlined,
                    label: widget.strings.destination,
                    onTap: () => _moveToDestination(destinationLatLng),
                  ),
                  const SizedBox(width: 8),
                  _MapFloatingActionButton(
                    icon: Icons.navigation_outlined,
                    label: widget.strings.currentLocation,
                    onTap: _moveToCurrentLocation,
                  ),
                  const SizedBox(width: 8),
                  _MapFloatingActionButton(
                    icon: Icons.explore_outlined,
                    label: widget.strings.directions,
                    onTap: _showNavigationActionSheet,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _moveToDestination(LatLng destination) {
    _mapController.move(destination, 15.8);
  }

  Future<void> _moveToCurrentLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showSnackBar(widget.strings.locationPermissionDenied);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      if (!mounted) {
        return;
      }

      final current = LatLng(position.latitude, position.longitude);
      setState(() {
        _currentLatLng = current;
      });
      _mapController.move(current, 14.6);
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showSnackBar(widget.strings.locationUnavailable);
    }
  }

  Future<void> _showNavigationActionSheet() async {
    final open = await showCupertinoModalPopup<bool>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(widget.strings.openMapApp),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(widget.strings.cancel),
          ),
        );
      },
    );

    if (open == true) {
      await _openSystemMapApp();
    }
  }

  Future<void> _openSystemMapApp() async {
    final destination = widget.destination;
    final label = Uri.encodeComponent(widget.title);
    final lat = destination.latitude;
    final lng = destination.longitude;

    final platform = Theme.of(context).platform;
    final candidates = <Uri>[
      if (platform == TargetPlatform.iOS)
        Uri.parse('maps://?daddr=$lat,$lng&q=$label')
      else
        Uri.parse('google.navigation:q=$lat,$lng'),
      Uri.parse('geo:0,0?q=$lat,$lng($label)'),
      Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng'),
    ];

    for (final uri in candidates) {
      try {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (launched) {
          return;
        }
      } catch (_) {
        continue;
      }
    }

    if (!mounted) {
      return;
    }
    _showSnackBar(widget.strings.locationUnavailable);
  }

  void _showSnackBar(String message) {
    AppNotice.show(context, message: message);
  }
}

class _MapFloatingActionButton extends StatelessWidget {
  const _MapFloatingActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Material(
      color: colors.surface.withValues(alpha: 0.92),
      elevation: 1.5,
      shadowColor: colors.scrim.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: colors.border.withValues(alpha: 0.72),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: SizedBox(
          width: 92,
          height: 78,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 29, color: colors.textSecondary),
              const SizedBox(height: 3),
              Text(
                label,
                style: appText.sectionTitle.copyWith(color: colors.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DestinationMarker extends StatelessWidget {
  const _DestinationMarker();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.location_pin,
      size: 40,
      color: Theme.of(context).appColors.danger,
    );
  }
}

class _CurrentLocationMarker extends StatelessWidget {
  const _CurrentLocationMarker();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.primary,
        shape: BoxShape.circle,
        border: Border.all(color: colors.surface, width: 2.4),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.scrim.withValues(alpha: 0.18),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
