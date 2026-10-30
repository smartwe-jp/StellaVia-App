import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_detail_display.dart';
import '../support/hotel_detail_styles.dart';
import 'hotel_detail_map_section.dart';

class HotelDetailGuide extends StatelessWidget {
  const HotelDetailGuide({super.key, required this.detail});
  final HotelDetail detail;
  @override
  Widget build(BuildContext c) {
    final sections = <(String, String)>[
      (
        c.l10n.hotelDetailCheckInTime,
        [
          if (detail.checkInTime.isNotEmpty)
            c.l10n.hotelDetailCheckInAfter(detail.checkInTime),
          if (detail.checkOutTime.isNotEmpty)
            c.l10n.hotelDetailCheckOutBefore(detail.checkOutTime),
        ].join('\n'),
      ),
      (c.l10n.hotelDetailCheckInGuide, detail.checkInGuide),
      (c.l10n.hotelDetailDescription, detail.detailText),
      (c.l10n.hotelDetailTravel, detail.travelText),
      (c.l10n.hotelDetailSurrounding, detail.surroundingText),
      (c.l10n.hotelDetailPolicy, detail.ruleText),
      (c.l10n.hotelDetailRefundPolicy, detail.refundPolicyText),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (detail.facilities.isNotEmpty)
            _Section(
              title: c.l10n.hotelDetailFacilities,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final value in detail.facilities)
                    Chip(
                      label: Text(value, style: HotelDetailStyles.caption(c)),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ),
          for (final section in sections)
            if (hotelDetailPlainText(section.$2).isNotEmpty)
              _Section(
                title: section.$1,
                child: Text(
                  hotelDetailPlainText(section.$2),
                  style: HotelDetailStyles.body(c),
                ),
              ),
          if (HotelDetailMapSection.canShow(detail))
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: HotelDetailMapSection(detail: detail),
            ),
          if (detail.telNo.isNotEmpty)
            _Section(
              title: c.l10n.hotelDetailContact,
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () =>
                      launchUrl(Uri(scheme: 'tel', path: detail.telNo)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/images/hotel-detail-phone.svg',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          detail.telNo,
                          style: HotelDetailStyles.amount(c),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext c) => Padding(
    padding: const EdgeInsets.only(bottom: 32),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: HotelDetailStyles.heading(c)),
        const SizedBox(height: 16),
        Divider(height: 1, color: c.appColors.borderSoft),
        const SizedBox(height: 16),
        child,
      ],
    ),
  );
}
