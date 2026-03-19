class NotificationDetailParagraph {
  const NotificationDetailParagraph({required this.runs});

  final List<NotificationDetailTextRun> runs;
}

class NotificationDetailTextRun {
  const NotificationDetailTextRun({required this.text, this.linkUri});

  final String text;
  final Uri? linkUri;

  bool get isLink => linkUri != null;
}

class NotificationDetailContentParser {
  const NotificationDetailContentParser._();

  static final RegExp _paragraphSeparator = RegExp(r'(?:\r?\n){2,}');
  static final RegExp _linkPattern = RegExp(
    r'((?:https?:\/\/|www\.)[^\s<]+)',
    caseSensitive: false,
  );
  static final RegExp _trailingPunctuationPattern = RegExp(r'[)\]}>.,!?;:]+$');

  static List<NotificationDetailParagraph> parse(String raw) {
    final normalized = raw.replaceAll('\r\n', '\n').trim();
    if (normalized.isEmpty) {
      return const <NotificationDetailParagraph>[];
    }

    return normalized
        .split(_paragraphSeparator)
        .map((String paragraph) => paragraph.trim())
        .where((String paragraph) => paragraph.isNotEmpty)
        .map(_parseParagraph)
        .toList(growable: false);
  }

  static NotificationDetailParagraph _parseParagraph(String paragraph) {
    final lines = paragraph.split('\n');
    final runs = <NotificationDetailTextRun>[];

    for (var index = 0; index < lines.length; index += 1) {
      runs.addAll(_parseInlineRuns(lines[index]));
      if (index < lines.length - 1) {
        runs.add(const NotificationDetailTextRun(text: '\n'));
      }
    }

    return NotificationDetailParagraph(runs: runs);
  }

  static List<NotificationDetailTextRun> _parseInlineRuns(String line) {
    if (line.isEmpty) {
      return const <NotificationDetailTextRun>[
        NotificationDetailTextRun(text: ''),
      ];
    }

    final runs = <NotificationDetailTextRun>[];
    var cursor = 0;
    for (final match in _linkPattern.allMatches(line)) {
      if (match.start > cursor) {
        runs.add(
          NotificationDetailTextRun(text: line.substring(cursor, match.start)),
        );
      }

      final rawLinkText = match.group(0) ?? '';
      final trimmedLinkText = rawLinkText.replaceFirst(
        _trailingPunctuationPattern,
        '',
      );
      final trailingText = rawLinkText.substring(trimmedLinkText.length);
      final linkUri = _tryParseLinkUri(trimmedLinkText);

      if (linkUri == null || trimmedLinkText.isEmpty) {
        runs.add(NotificationDetailTextRun(text: rawLinkText));
      } else {
        runs.add(
          NotificationDetailTextRun(text: trimmedLinkText, linkUri: linkUri),
        );
        if (trailingText.isNotEmpty) {
          runs.add(NotificationDetailTextRun(text: trailingText));
        }
      }

      cursor = match.end;
    }

    if (cursor < line.length) {
      runs.add(NotificationDetailTextRun(text: line.substring(cursor)));
    }

    return runs;
  }

  static Uri? _tryParseLinkUri(String raw) {
    if (raw.isEmpty) {
      return null;
    }
    final candidate = raw.startsWith('www.') ? 'https://$raw' : raw;
    final uri = Uri.tryParse(candidate);
    if (uri == null ||
        !uri.hasScheme ||
        (uri.host.isEmpty && uri.scheme != 'mailto')) {
      return null;
    }
    return uri;
  }
}
