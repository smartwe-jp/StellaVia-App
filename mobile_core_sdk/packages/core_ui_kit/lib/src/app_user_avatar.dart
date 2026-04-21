import 'package:flutter/material.dart';

import 'kizunark_widgets.dart';

class AppUserAvatar extends StatelessWidget {
  const AppUserAvatar({
    super.key,
    this.text = '',
    this.avatarUrl,
    this.imageProvider,
    this.avatarSeed,
    this.gradientColorValues,
    this.size = 32,
    this.fontSize = 13,
    this.usePersonIconFallback = true,
  });

  final String text;
  final String? avatarUrl;
  final ImageProvider<Object>? imageProvider;
  final int? avatarSeed;
  final List<int>? gradientColorValues;
  final double size;
  final double fontSize;
  final bool usePersonIconFallback;

  @override
  Widget build(BuildContext context) {
    final effectiveGradientValues =
        (gradientColorValues != null && gradientColorValues!.isNotEmpty)
        ? gradientColorValues!
        : _defaultAvatarGradientValuesForSeed(avatarSeed);

    return KizunarkAvatarBadge(
      text: text,
      imageUrl: avatarUrl,
      imageProvider: imageProvider,
      gradientColors: effectiveGradientValues
          .map(Color.new)
          .toList(growable: false),
      size: size,
      fontSize: fontSize,
      usePersonIconFallback: usePersonIconFallback,
    );
  }
}

List<int> _defaultAvatarGradientValuesForSeed(int? seed) {
  const palette = <List<int>>[
    <int>[0xFF6366F1, 0xFF8B5CF6],
    <int>[0xFFEC4899, 0xFFF472B6],
    <int>[0xFF10B981, 0xFF34D399],
    <int>[0xFFF59E0B, 0xFFFBBF24],
    <int>[0xFF2563EB, 0xFF60A5FA],
    <int>[0xFF14B8A6, 0xFF2DD4BF],
  ];
  if (seed == null) {
    return palette.first;
  }
  return palette[seed.abs() % palette.length];
}
