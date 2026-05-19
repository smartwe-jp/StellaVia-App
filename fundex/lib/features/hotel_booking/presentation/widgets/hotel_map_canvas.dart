import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_booking_presenter.dart';

const Offset _priceMarkerAnchor = Offset(0.5, 0.73);

class HotelMapCanvas extends StatefulWidget {
  const HotelMapCanvas({
    super.key,
    required this.hotels,
    required this.selectedHotelId,
    required this.fallbackTarget,
    required this.presenter,
    required this.onHotelSelected,
    required this.onMapTap,
  });

  final List<HotelSummary> hotels;
  final String? selectedHotelId;
  final gmaps.LatLng fallbackTarget;
  final HotelBookingPresenter presenter;
  final ValueChanged<HotelSummary> onHotelSelected;
  final VoidCallback onMapTap;

  @override
  State<HotelMapCanvas> createState() => _HotelMapCanvasState();
}

class _HotelMapCanvasState extends State<HotelMapCanvas> {
  final Map<String, gmaps.BitmapDescriptor> _iconCache =
      <String, gmaps.BitmapDescriptor>{};
  gmaps.GoogleMapController? _controller;
  Set<gmaps.Marker> _markers = const <gmaps.Marker>{};
  int _generation = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _rebuildMarkers();
  }

  @override
  void didUpdateWidget(covariant HotelMapCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hotels != widget.hotels ||
        oldWidget.selectedHotelId != widget.selectedHotelId ||
        oldWidget.presenter.localeName != widget.presenter.localeName) {
      _rebuildMarkers();
    }
    if (oldWidget.selectedHotelId != widget.selectedHotelId) {
      _moveToSelectedHotel();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return gmaps.GoogleMap(
      initialCameraPosition: gmaps.CameraPosition(
        target: _initialTarget(),
        zoom: 13,
      ),
      markers: _markers,
      myLocationButtonEnabled: false,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
      onTap: (_) => widget.onMapTap(),
      onMapCreated: (controller) {
        _controller = controller;
        _moveToSelectedHotel();
      },
    );
  }

  gmaps.LatLng _initialTarget() {
    final selected = _selectedHotel;
    if (selected != null) {
      return _coordinateFor(selected)!;
    }
    for (final hotel in widget.hotels) {
      final coordinate = _coordinateFor(hotel);
      if (coordinate != null) {
        return coordinate;
      }
    }
    return widget.fallbackTarget;
  }

  HotelSummary? get _selectedHotel {
    final selectedHotelId = widget.selectedHotelId;
    if (selectedHotelId == null) {
      return null;
    }
    for (final hotel in widget.hotels) {
      if (hotel.id == selectedHotelId && _coordinateFor(hotel) != null) {
        return hotel;
      }
    }
    return null;
  }

  void _moveToSelectedHotel() {
    final controller = _controller;
    final selected = _selectedHotel;
    final coordinate = selected == null ? null : _coordinateFor(selected);
    if (controller == null || coordinate == null) {
      return;
    }
    controller.animateCamera(gmaps.CameraUpdate.newLatLng(coordinate));
  }

  Future<void> _rebuildMarkers() async {
    final generation = ++_generation;
    final colors = Theme.of(context).appColors;
    final textStyle = Theme.of(context).textTheme.labelLarge;
    final priceAskLabel = context.l10n.hotelPriceAsk;
    final pixelRatio = MediaQuery.devicePixelRatioOf(context).clamp(1.0, 3.0);
    final nextMarkers = <gmaps.Marker>{};

    for (final hotel in widget.hotels) {
      final coordinate = _coordinateFor(hotel);
      if (coordinate == null) {
        continue;
      }
      final isSelected = hotel.id == widget.selectedHotelId;
      final price = widget.presenter.price(hotel.lowestPrice);
      final label = price.isEmpty ? priceAskLabel : price;
      final icon = await _iconFor(
        label: label,
        isSelected: isSelected,
        pixelRatio: pixelRatio,
        textStyle: textStyle,
        backgroundColor: isSelected
            ? colors.brandPrimaryDark
            : colors.primaryAlt,
        textColor: colors.onDark,
        shadowColor: colors.brandPrimaryDark.withValues(alpha: 0.55),
      );
      nextMarkers.add(
        gmaps.Marker(
          markerId: gmaps.MarkerId(hotel.id),
          position: coordinate,
          icon: icon,
          anchor: _priceMarkerAnchor,
          onTap: () => widget.onHotelSelected(hotel),
        ),
      );
    }

    if (!mounted || generation != _generation) {
      return;
    }
    setState(() {
      _markers = nextMarkers;
    });
  }

  Future<gmaps.BitmapDescriptor> _iconFor({
    required String label,
    required bool isSelected,
    required double pixelRatio,
    required TextStyle? textStyle,
    required Color backgroundColor,
    required Color textColor,
    required Color shadowColor,
  }) async {
    final cacheKey = Object.hash(
      label,
      isSelected,
      backgroundColor.toARGB32(),
      textColor.toARGB32(),
      pixelRatio,
    ).toString();
    final cached = _iconCache[cacheKey];
    if (cached != null) {
      return cached;
    }

    final icon = await _createPriceMarkerBitmap(
      label: label,
      pixelRatio: pixelRatio,
      textStyle: textStyle,
      backgroundColor: backgroundColor,
      textColor: textColor,
      shadowColor: shadowColor,
    );
    _iconCache[cacheKey] = icon;
    return icon;
  }

  Future<gmaps.BitmapDescriptor> _createPriceMarkerBitmap({
    required String label,
    required double pixelRatio,
    required TextStyle? textStyle,
    required Color backgroundColor,
    required Color textColor,
    required Color shadowColor,
  }) async {
    final markerTextStyle = (textStyle ?? const TextStyle()).copyWith(
      color: textColor,
      fontSize: 16,
      fontWeight: FontWeight.w900,
      letterSpacing: 0,
    );
    final textPainter = TextPainter(
      text: TextSpan(text: label, style: markerTextStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    final logicalWidth = math.max(92.0, textPainter.width + 30);
    const bubbleHeight = 30.0;
    const tailHeight = 7.0;
    const shadowHeight = 10.0;
    const bottomPadding = 4.0;
    const logicalHeight =
        bubbleHeight + tailHeight + shadowHeight + bottomPadding;
    final centerX = logicalWidth / 2;
    final imageWidth = (logicalWidth * pixelRatio).ceil();
    final imageHeight = (logicalHeight * pixelRatio).ceil();
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)..scale(pixelRatio);
    final bubbleRect = Rect.fromLTWH(0, 0, logicalWidth, bubbleHeight);
    final rrect = RRect.fromRectAndRadius(
      bubbleRect,
      const Radius.circular(10),
    );

    final shadowPaint = Paint()..color = shadowColor;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, bubbleHeight + tailHeight + 3),
        width: 26,
        height: shadowHeight,
      ),
      shadowPaint,
    );

    final paint = Paint()..color = backgroundColor;
    canvas.drawRRect(rrect, paint);
    final tailPath = Path()
      ..moveTo(centerX - 9, bubbleHeight - 1)
      ..lineTo(centerX, bubbleHeight + tailHeight)
      ..lineTo(centerX + 9, bubbleHeight - 1)
      ..close();
    canvas.drawPath(tailPath, paint);
    textPainter.paint(
      canvas,
      Offset(
        (logicalWidth - textPainter.width) / 2,
        (bubbleHeight - textPainter.height) / 2,
      ),
    );

    final image = await recorder.endRecording().toImage(
      imageWidth,
      imageHeight,
    );
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = data?.buffer.asUint8List() ?? Uint8List(0);
    return gmaps.BitmapDescriptor.bytes(
      bytes,
      width: logicalWidth,
      height: logicalHeight,
    );
  }

  gmaps.LatLng? _coordinateFor(HotelSummary hotel) {
    final latitude = hotel.latitude;
    final longitude = hotel.longitude;
    if (latitude == null || longitude == null) {
      return null;
    }
    if (latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180) {
      return null;
    }
    return gmaps.LatLng(latitude, longitude);
  }
}
