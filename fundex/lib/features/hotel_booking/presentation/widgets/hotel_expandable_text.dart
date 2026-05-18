import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class HotelExpandableText extends StatefulWidget {
  const HotelExpandableText({
    super.key,
    required this.text,
    this.style,
    this.collapsedMaxLines = 4,
    this.characterThreshold = 100,
    this.expanded,
    this.onExpandedChanged,
  });

  final String text;
  final TextStyle? style;
  final int collapsedMaxLines;
  final int characterThreshold;
  final bool? expanded;
  final ValueChanged<bool>? onExpandedChanged;

  @override
  State<HotelExpandableText> createState() => _HotelExpandableTextState();
}

class _HotelExpandableTextState extends State<HotelExpandableText> {
  bool _expanded = false;

  bool get _effectiveExpanded => widget.expanded ?? _expanded;

  @override
  void didUpdateWidget(covariant HotelExpandableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text && widget.expanded == null) {
      _expanded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return LayoutBuilder(
      builder: (context, constraints) {
        final canExpand = _shouldCollapse(context, constraints.maxWidth);
        final expanded = _effectiveExpanded;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AnimatedSize(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: Text(
                widget.text,
                maxLines: canExpand && !expanded
                    ? widget.collapsedMaxLines
                    : null,
                overflow: canExpand && !expanded
                    ? TextOverflow.ellipsis
                    : TextOverflow.visible,
                style: widget.style,
              ),
            ),
            if (canExpand && !expanded) ...<Widget>[
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: colors.brandSecondary,
                    textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  onPressed: () => _setExpanded(true),
                  child: Text(context.l10n.hotelDetailShowMoreAction),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  bool _shouldCollapse(BuildContext context, double maxWidth) {
    if (_effectiveExpanded) {
      return false;
    }
    if (widget.text.runes.length > widget.characterThreshold) {
      return true;
    }
    if (!maxWidth.isFinite || maxWidth <= 0) {
      return false;
    }

    final painter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: widget.collapsedMaxLines,
      textDirection: Directionality.of(context),
    )..layout(maxWidth: maxWidth);
    return painter.didExceedMaxLines;
  }

  void _setExpanded(bool value) {
    widget.onExpandedChanged?.call(value);
    if (widget.expanded == null) {
      setState(() => _expanded = value);
    }
  }
}
