import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations_ext.dart';

class MemberProfileBasicInfoStepPage extends StatelessWidget {
  const MemberProfileBasicInfoStepPage({
    super.key,
    required this.nameKanjiController,
    required this.nameKanaController,
    required this.birthdayController,
    required this.phoneController,
    required this.showAgeWarning,
    this.primaryButtonEnabled = true,
    this.onBirthdayTap,
    this.onNext,
    this.onSkip,
  });

  final TextEditingController nameKanjiController;
  final TextEditingController nameKanaController;
  final TextEditingController birthdayController;
  final TextEditingController phoneController;
  final bool showAgeWarning;
  final bool primaryButtonEnabled;
  final VoidCallback? onBirthdayTap;
  final VoidCallback? onNext;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    return MemberProfileEditStepScaffold(
      title: l10n.memberProfileStep1Title,
      description: l10n.memberProfileStep1Description,
      primaryButtonLabel: l10n.commonNext,
      onPrimaryPressed: onNext,
      primaryButtonEnabled: primaryButtonEnabled,
      skipLabel: l10n.commonSkipChevron,
      onSkip: onSkip,
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: MemberProfileTextField(
                  label: l10n.memberProfileNameKanjiLabel,
                  controller: nameKanjiController,
                  hintText: l10n.memberProfileNameKanjiHint,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MemberProfileTextField(
                  label: l10n.memberProfileNameKanaLabel,
                  controller: nameKanaController,
                  hintText: l10n.memberProfileNameKanaHint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          MemberProfileTextField(
            label: l10n.memberProfileBirthdayLabel,
            controller: birthdayController,
            hintText: l10n.memberProfileBirthdayHint,
            readOnly: true,
            onTap: onBirthdayTap,
            suffixIcon: const Icon(Icons.calendar_month_rounded),
          ),
          if (showAgeWarning) ...<Widget>[
            const SizedBox(height: 12),
            MemberProfileNoticeCard(
              icon: const SizedBox.square(
                dimension: 18,
                child: FittedBox(child: Text('🚫')),
              ),
              title: l10n.memberProfileUnderageTitle,
              body: l10n.memberProfileUnderageBody,
              backgroundColor: colors.dangerSoft,
              borderColor: colors.dangerBorder,
              foregroundColor: colors.dangerForeground,
            ),
          ],
          const SizedBox(height: 14),
          MemberProfileTextField(
            label: l10n.memberProfilePhoneLabel,
            controller: phoneController,
            hintText: l10n.memberProfilePhoneHint,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }
}
