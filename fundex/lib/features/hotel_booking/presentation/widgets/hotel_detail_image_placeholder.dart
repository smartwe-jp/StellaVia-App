import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class HotelDetailImagePlaceholder extends StatelessWidget {
  const HotelDetailImagePlaceholder({super.key, this.iconSize = 34});

  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(color: colors.surface),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: colors.textTertiary,
          size: iconSize,
        ),
      ),
    );
  }
}
