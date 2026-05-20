import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:url_launcher/url_launcher.dart';

import 'app_dialogs.dart';
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

  gmaps.LatLng toGoogleLatLng() => gmaps.LatLng(latitude, longitude);
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
    this.openSettings = '',
    this.locationPermissionSettingsTitle = '',
    this.locationPermissionSettingsMessage = '',
  });

  final String close;
  final String destination;
  final String currentLocation;
  final String directions;
  final String openMapApp;
  final String cancel;
  final String locationPermissionDenied;
  final String locationUnavailable;
  final String openSettings;
  final String locationPermissionSettingsTitle;
  final String locationPermissionSettingsMessage;
}

class FundPropertyMapPreviewCard extends StatefulWidget {
  const FundPropertyMapPreviewCard({
    super.key,
    required this.addressLabel,
    this.destination,
    this.height = 164,
    this.showAddressOverlay = true,
    this.showZoomControls = false,
    this.onTap,
  });

  final String addressLabel;
  final FundPropertyCoordinate? destination;
  final double height;
  final bool showAddressOverlay;
  final bool showZoomControls;
  final VoidCallback? onTap;

  @override
  State<FundPropertyMapPreviewCard> createState() =>
      _FundPropertyMapPreviewCardState();
}

class _FundPropertyMapPreviewCardState
    extends State<FundPropertyMapPreviewCard> {
  gmaps.GoogleMapController? _mapController;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Material(
      color: colors.infoSubtle,
      borderRadius: BorderRadius.circular(UiTokens.radius16),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(UiTokens.radius16),
        child: SizedBox(
          width: double.infinity,
          height: widget.height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(UiTokens.radius16),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                if (widget.destination != null)
                  IgnorePointer(
                    child: gmaps.GoogleMap(
                      initialCameraPosition: gmaps.CameraPosition(
                        target: widget.destination!.toGoogleLatLng(),
                        zoom: 14.2,
                      ),
                      markers: <gmaps.Marker>{
                        gmaps.Marker(
                          markerId: const gmaps.MarkerId('destination'),
                          position: widget.destination!.toGoogleLatLng(),
                        ),
                      },
                      compassEnabled: false,
                      liteModeEnabled: !widget.showZoomControls,
                      mapToolbarEnabled: false,
                      myLocationButtonEnabled: false,
                      myLocationEnabled: false,
                      rotateGesturesEnabled: false,
                      scrollGesturesEnabled: false,
                      tiltGesturesEnabled: false,
                      zoomControlsEnabled: false,
                      zoomGesturesEnabled: false,
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                    ),
                  )
                else
                  ColoredBox(color: colors.infoSubtle),
                if (widget.showAddressOverlay)
                  Align(
                    alignment: widget.destination == null
                        ? Alignment.center
                        : Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 13,
                        ),
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
                          widget.addressLabel,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: appText.sectionTitle.copyWith(
                            color: colors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (widget.showZoomControls && widget.destination != null)
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: Column(
                      children: <Widget>[
                        _MapRoundIconButton(
                          icon: Icons.add,
                          size: 36,
                          iconSize: 21,
                          onTap: () {
                            _mapController?.animateCamera(
                              gmaps.CameraUpdate.zoomIn(),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        _MapRoundIconButton(
                          icon: Icons.remove,
                          size: 36,
                          iconSize: 21,
                          onTap: () {
                            _mapController?.animateCamera(
                              gmaps.CameraUpdate.zoomOut(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
              ],
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
  static const _destinationMarkerId = gmaps.MarkerId('destination');
  static const _currentMarkerId = gmaps.MarkerId('current');

  gmaps.GoogleMapController? _mapController;
  gmaps.LatLng? _currentLatLng;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final topPadding = MediaQuery.paddingOf(context).top;
    final destinationLatLng = widget.destination.toGoogleLatLng();
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      child: ColoredBox(
        color: colors.surface,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: gmaps.GoogleMap(
                initialCameraPosition: gmaps.CameraPosition(
                  target: destinationLatLng,
                  zoom: 13,
                ),
                markers: _buildMarkers(destinationLatLng),
                compassEnabled: true,
                mapToolbarEnabled: false,
                myLocationButtonEnabled: false,
                myLocationEnabled: false,
                zoomControlsEnabled: false,
                onMapCreated: (gmaps.GoogleMapController controller) {
                  _mapController = controller;
                  controller.showMarkerInfoWindow(_destinationMarkerId);
                },
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
              bottom: 102 + MediaQuery.paddingOf(context).bottom,
              child: Column(
                children: <Widget>[
                  _MapRoundIconButton(
                    icon: Icons.add,
                    onTap: () {
                      _mapController?.animateCamera(
                        gmaps.CameraUpdate.zoomIn(),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _MapRoundIconButton(
                    icon: Icons.remove,
                    onTap: () {
                      _mapController?.animateCamera(
                        gmaps.CameraUpdate.zoomOut(),
                      );
                    },
                  ),
                ],
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

  Set<gmaps.Marker> _buildMarkers(gmaps.LatLng destination) {
    return <gmaps.Marker>{
      gmaps.Marker(
        markerId: _destinationMarkerId,
        position: destination,
        infoWindow: gmaps.InfoWindow(title: widget.title),
      ),
      if (_currentLatLng != null)
        gmaps.Marker(
          markerId: _currentMarkerId,
          position: _currentLatLng!,
          icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
            gmaps.BitmapDescriptor.hueAzure,
          ),
          infoWindow: gmaps.InfoWindow(title: widget.strings.currentLocation),
        ),
    };
  }

  void _moveToDestination(gmaps.LatLng destination) {
    _mapController?.animateCamera(
      gmaps.CameraUpdate.newLatLngZoom(destination, 15.8),
    );
    _mapController?.showMarkerInfoWindow(_destinationMarkerId);
  }

  Future<void> _moveToCurrentLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      final shouldOpenSettings =
          permission == LocationPermission.deniedForever ||
          (permission == LocationPermission.denied &&
              (Theme.of(context).platform == TargetPlatform.iOS ||
                  Theme.of(context).platform == TargetPlatform.macOS));
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (shouldOpenSettings &&
            widget.strings.openSettings.isNotEmpty &&
            widget.strings.locationPermissionSettingsTitle.isNotEmpty &&
            widget.strings.locationPermissionSettingsMessage.isNotEmpty) {
          final openSettings = await AppDialogs.showAdaptiveAlert<bool>(
            context: context,
            title: widget.strings.locationPermissionSettingsTitle,
            message: widget.strings.locationPermissionSettingsMessage,
            actions: <AppDialogAction<bool>>[
              AppDialogAction<bool>(label: widget.strings.cancel, value: false),
              AppDialogAction<bool>(
                label: widget.strings.openSettings,
                value: true,
                isDefaultAction: true,
              ),
            ],
          );
          if (openSettings == true) {
            await Geolocator.openAppSettings();
          }
          return;
        }
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

      final current = gmaps.LatLng(position.latitude, position.longitude);
      setState(() {
        _currentLatLng = current;
      });
      await _mapController?.animateCamera(
        gmaps.CameraUpdate.newLatLngZoom(current, 14.6),
      );
      _mapController?.showMarkerInfoWindow(_currentMarkerId);
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

class _MapRoundIconButton extends StatelessWidget {
  const _MapRoundIconButton({
    required this.icon,
    required this.onTap,
    this.size = 44,
    this.iconSize = 24,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Material(
      color: colors.surface.withValues(alpha: 0.94),
      elevation: 1.5,
      shadowColor: colors.scrim.withValues(alpha: 0.15),
      shape: CircleBorder(
        side: BorderSide(color: colors.border.withValues(alpha: 0.72)),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: colors.textPrimary, size: iconSize),
        ),
      ),
    );
  }
}
