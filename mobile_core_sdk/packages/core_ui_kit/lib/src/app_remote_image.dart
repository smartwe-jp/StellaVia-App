import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

ImageProvider<Object>? appCachedImageProvider(String? imageUrl) {
  final normalized = imageUrl?.trim();
  if (normalized == null || normalized.isEmpty) {
    return null;
  }
  return CachedNetworkImageProvider(normalized);
}

class AppRemoteImage extends StatelessWidget {
  const AppRemoteImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.placeholder,
    this.errorWidget,
    this.filterQuality = FilterQuality.low,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Alignment alignment;
  final Widget? placeholder;
  final Widget? errorWidget;
  final FilterQuality filterQuality;
  final int? memCacheWidth;
  final int? memCacheHeight;

  @override
  Widget build(BuildContext context) {
    final normalizedUrl = imageUrl.trim();
    if (normalizedUrl.isEmpty) {
      return errorWidget ?? const SizedBox.shrink();
    }

    return CachedNetworkImage(
      imageUrl: normalizedUrl,
      fit: fit,
      width: width,
      height: height,
      alignment: alignment,
      filterQuality: filterQuality,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholderFadeInDuration: Duration.zero,
      useOldImageOnUrlChange: true,
      placeholder: (_, __) => placeholder ?? const SizedBox.shrink(),
      errorWidget: (_, __, ___) => errorWidget ?? const SizedBox.shrink(),
    );
  }
}
