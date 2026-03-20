import 'package:flutter/material.dart';

Widget buildAppImageViewerImage({
  required String source,
  required BoxFit fit,
  required double width,
  required double height,
  required int cacheWidth,
  required FilterQuality filterQuality,
  required Widget loadingWidget,
  required Widget errorWidget,
  Key? key,
}) {
  final normalizedSource = source.trim();
  final uri = Uri.tryParse(normalizedSource);
  if (uri != null && (uri.isScheme('https') || uri.isScheme('http'))) {
    return Image.network(
      normalizedSource,
      key: key,
      fit: fit,
      width: width,
      height: height,
      cacheWidth: cacheWidth,
      filterQuality: filterQuality,
      loadingBuilder:
          (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) {
            if (loadingProgress == null) {
              return child;
            }
            return loadingWidget;
          },
      errorBuilder: (_, __, ___) => errorWidget,
    );
  }
  return errorWidget;
}
