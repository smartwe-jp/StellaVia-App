import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../support/notification_detail_content_parser.dart';
import '../support/notification_item_view_data.dart';

class NotificationDetailSheet extends StatelessWidget {
  const NotificationDetailSheet({
    super.key,
    required this.detail,
    required this.body,
    required this.closeLabel,
    required this.linkOpenFailedMessage,
  });

  final NotificationItemViewData detail;
  final String body;
  final String closeLabel;
  final String linkOpenFailedMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final paragraphs = NotificationDetailContentParser.parse(body);
    final maxHeight = MediaQuery.sizeOf(context).height * 0.78;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(bottom: BorderSide(color: colors.borderSoft)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 0, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (detail.dateLabel.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              detail.dateLabel,
                              style: appText.meta.copyWith(
                                color: colors.textTertiary,
                              ),
                            ),
                          ),
                        Text(
                          detail.title,
                          style: appText.cardTitle.copyWith(
                            color: colors.textPrimary,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: UiTokens.spacing8),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      closeLabel,
                      style: appText.button.copyWith(color: colors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(4, 16, 4, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  for (var index = 0; index < paragraphs.length; index += 1)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: index == paragraphs.length - 1
                            ? 0
                            : UiTokens.spacing16,
                      ),
                      child: _NotificationRichParagraph(
                        paragraph: paragraphs[index],
                        baseStyle: appText.body.copyWith(
                          color: colors.textSecondary,
                          height: 1.7,
                        ),
                        linkStyle: appText.link.copyWith(
                          color: colors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: colors.primary,
                        ),
                        linkOpenFailedMessage: linkOpenFailedMessage,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationRichParagraph extends StatefulWidget {
  const _NotificationRichParagraph({
    required this.paragraph,
    required this.baseStyle,
    required this.linkStyle,
    required this.linkOpenFailedMessage,
  });

  final NotificationDetailParagraph paragraph;
  final TextStyle baseStyle;
  final TextStyle linkStyle;
  final String linkOpenFailedMessage;

  @override
  State<_NotificationRichParagraph> createState() =>
      _NotificationRichParagraphState();
}

class _NotificationRichParagraphState
    extends State<_NotificationRichParagraph> {
  late List<TapGestureRecognizer?> _recognizers;

  @override
  void initState() {
    super.initState();
    _recognizers = _buildRecognizers();
  }

  @override
  void didUpdateWidget(covariant _NotificationRichParagraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.paragraph != widget.paragraph) {
      _disposeRecognizers();
      _recognizers = _buildRecognizers();
    }
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  List<TapGestureRecognizer?> _buildRecognizers() {
    return widget.paragraph.runs
        .map((NotificationDetailTextRun run) {
          if (!run.isLink || run.linkUri == null) {
            return null;
          }
          return TapGestureRecognizer()..onTap = () => _openLink(run.linkUri!);
        })
        .toList(growable: false);
  }

  void _disposeRecognizers() {
    for (final recognizer in _recognizers) {
      recognizer?.dispose();
    }
  }

  Future<void> _openLink(Uri uri) async {
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        AppNotice.show(context, message: widget.linkOpenFailedMessage);
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      AppNotice.show(context, message: widget.linkOpenFailedMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spans = List<InlineSpan>.generate(widget.paragraph.runs.length, (
      int index,
    ) {
      final run = widget.paragraph.runs[index];
      return TextSpan(
        text: run.text,
        style: run.isLink ? widget.linkStyle : widget.baseStyle,
        recognizer: _recognizers[index],
      );
    });

    return Text.rich(TextSpan(children: spans), style: widget.baseStyle);
  }
}
