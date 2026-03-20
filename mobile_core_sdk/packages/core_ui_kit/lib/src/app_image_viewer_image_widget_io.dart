import 'dart:io';

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

  final filePath = _resolveFilePath(normalizedSource, uri);
  if (filePath == null) {
    return errorWidget;
  }

  return Image.file(
    File(filePath),
    key: key,
    fit: fit,
    width: width,
    height: height,
    cacheWidth: cacheWidth,
    filterQuality: filterQuality,
    errorBuilder: (_, __, ___) => errorWidget,
  );
}

String? _resolveFilePath(String source, Uri? uri) {
  if (uri != null && uri.isScheme('file')) {
    return uri.toFilePath();
  }
  if (source.startsWith('/')) {
    return source;
  }
  return null;
}
