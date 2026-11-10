import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_detail_display.dart';
import '../support/hotel_detail_styles.dart';

class HotelDescriptionSection extends StatelessWidget {
  const HotelDescriptionSection({super.key, required this.detail});
  final HotelDetail detail;

  @override
  Widget build(BuildContext context) {
    final body = hotelDetailPlainText(detail.detailText);
    if (body.isEmpty) return const SizedBox.shrink();
    final title = hotelFeatureTitle(body);
    void showDetails() {
      AppBottomSheet.showAdaptive<void>(
        context: context,
        useRootNavigator: true,
        builder: (sheetContext) => SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      detail.name,
                      style: HotelDetailStyles.heading(sheetContext),
                    ),
                  ),
                  const CloseButton(),
                ],
              ),
              const SizedBox(height: 12),
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    body,
                    style: HotelDetailStyles.body(sheetContext),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final heading = HotelDetailStyles.heading(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final painter = TextPainter(
            text: TextSpan(text: title, style: heading),
            textDirection: Directionality.of(context),
            textScaler: MediaQuery.textScalerOf(context),
            maxLines: 3,
            ellipsis: '…',
          )..layout(maxWidth: constraints.maxWidth);
          var preview = title;
          if (painter.didExceedMaxLines) {
            final line = painter.computeLineMetrics().last;
            final end = painter
                .getPositionForOffset(
                  Offset(line.left + line.width, line.baseline),
                )
                .offset;
            preview = '${title.substring(0, end).trimRight()}…';
          }
          painter.dispose();
          return Text.rich(
            TextSpan(
              style: heading,
              children: [
                TextSpan(text: '$preview '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: Semantics(
                    link: true,
                    child: InkWell(
                      onTap: showDetails,
                      child: Text(
                        context.l10n.hotelFeatureDetailsLink,
                        style: context.appTextTheme.link.copyWith(
                          fontSize: heading.fontSize,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
