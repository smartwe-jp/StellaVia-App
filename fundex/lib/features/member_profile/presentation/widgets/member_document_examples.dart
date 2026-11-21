import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class MemberDocumentExamples extends StatelessWidget {
  const MemberDocumentExamples({super.key, required this.documentType});

  final String? documentType;

  @override
  Widget build(BuildContext context) {
    final prefix = switch (documentType) {
      'drivers_license' => 'license',
      'my_number' => 'mynumber',
      'passport' => 'passport',
      'residence_card' => 'residence',
      'other' => 'other',
      _ => null,
    };
    if (prefix == null) return const SizedBox.shrink();
    final l = context.l10n;
    final examples = {
      'front': l.memberProfilePhotoDocumentFrontTitle,
      'tilt': l.memberProfilePhotoDocumentObliqueTitle,
      if (prefix != 'mynumber' && prefix != 'passport')
        'back': l.memberProfilePhotoDocumentBackTitle,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.memberProfileDocumentExample,
          style: context.appTextTheme.inputLabel,
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            for (final entry in examples.entries)
              Expanded(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/id-examples/$prefix-${entry.key}.jpg',
                      height: 80,
                      fit: BoxFit.contain,
                      excludeFromSemantics: true,
                    ),
                    Text(
                      entry.value,
                      style: context.appTextTheme.caption,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
