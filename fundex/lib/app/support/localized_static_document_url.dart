String localizedStaticDocumentSuffix(String localeTag) {
  final normalizedTag = localeTag.replaceAll('_', '-').toLowerCase();
  return switch (normalizedTag) {
    String tag when tag.startsWith('ja') => 'ja',
    String tag
        when tag.startsWith('zh-hant') ||
            tag.startsWith('zh-tw') ||
            tag.startsWith('zh-hk') ||
            tag.startsWith('zh-mo') =>
      'zh-hant',
    String tag when tag.startsWith('zh') => 'zh-hans',
    _ => 'en',
  };
}

String localizedStaticPdfUrl(String url, String localeTag) {
  final suffix = localizedStaticDocumentSuffix(localeTag);
  return withLocalizedStaticPdfSuffix(url, suffix);
}

String withLocalizedStaticPdfSuffix(String url, String suffix) {
  final trimmed = url.trim();
  if (trimmed.isEmpty) {
    return trimmed;
  }

  final uri = Uri.tryParse(trimmed);
  if (uri == null || uri.path.isEmpty) {
    return trimmed;
  }

  final localizedPath = _withLocalizedPdfPathSuffix(uri.path, suffix);
  if (localizedPath == uri.path) {
    return trimmed;
  }
  return uri.replace(path: localizedPath).toString();
}

String _withLocalizedPdfPathSuffix(String path, String suffix) {
  final pdfPattern = RegExp(
    r'(?:\.(?:ja|en|zh-hans|zh-hant))?\.pdf$',
    caseSensitive: false,
  );
  if (!pdfPattern.hasMatch(path)) {
    return path;
  }
  return path.replaceFirst(pdfPattern, '.$suffix.pdf');
}
