import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import 'hotel_expandable_text.dart';

class HotelDetailInfoSection extends StatelessWidget {
  const HotelDetailInfoSection({
    super.key,
    required this.title,
    required this.body,
    this.icon,
    this.expanded = false,
    this.onExpandedChanged,
  });

  final String title;
  final String body;
  final IconData? icon;
  final bool expanded;
  final ValueChanged<bool>? onExpandedChanged;

  @override
  Widget build(BuildContext context) {
    final normalizedBody = _normalizeBody(body);
    if (normalizedBody.isEmpty) {
      return const SizedBox.shrink();
    }
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.brandWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.borderSoft.withValues(alpha: 0.72)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                if (icon != null) ...<Widget>[
                  Icon(icon, color: colors.brandSecondary, size: 20),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colors.brandPrimaryDark,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            HotelExpandableText(
              text: normalizedBody,
              expanded: expanded,
              onExpandedChanged: onExpandedChanged,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
                height: 1.55,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HotelDetailFacilitySection extends StatelessWidget {
  const HotelDetailFacilitySection({
    super.key,
    required this.title,
    required this.facilities,
  });

  final String title;
  final List<String> facilities;

  @override
  Widget build(BuildContext context) {
    final values = facilities
        .map((facility) => facility.trim())
        .where((facility) => facility.isNotEmpty)
        .toList(growable: false);
    if (values.isEmpty) {
      return const SizedBox.shrink();
    }
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.brandWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.borderSoft.withValues(alpha: 0.72)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.local_laundry_service_outlined,
                  color: colors.brandSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colors.brandPrimaryDark,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: values
                  .take(12)
                  .map(
                    (value) => DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.brandSecondary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        child: Text(
                          value,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: colors.brandSecondary,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }
}

String _normalizeBody(String value) {
  return value
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'</p\s*>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<[^>]+>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .trim();
}
