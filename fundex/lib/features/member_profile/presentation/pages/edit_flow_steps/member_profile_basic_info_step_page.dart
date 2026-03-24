import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../app/localization/app_localizations_ext.dart';

class MemberProfileBasicInfoStepPage extends StatelessWidget {
  const MemberProfileBasicInfoStepPage({
    super.key,
    required this.familyNameController,
    required this.givenNameController,
    required this.familyNameKanaController,
    required this.givenNameKanaController,
    required this.familyNameRomanController,
    required this.givenNameRomanController,
    required this.birthdayController,
    required this.phoneController,
    required this.showAgeWarning,
    this.primaryButtonEnabled = true,
    this.titleOverride,
    this.descriptionOverride,
    this.primaryButtonLabelOverride,
    this.onBirthdayTap,
    this.onNext,
    this.onSkip,
  });

  final TextEditingController familyNameController;
  final TextEditingController givenNameController;
  final TextEditingController familyNameKanaController;
  final TextEditingController givenNameKanaController;
  final TextEditingController familyNameRomanController;
  final TextEditingController givenNameRomanController;
  final TextEditingController birthdayController;
  final TextEditingController phoneController;
  final bool showAgeWarning;
  final bool primaryButtonEnabled;
  final String? titleOverride;
  final String? descriptionOverride;
  final String? primaryButtonLabelOverride;
  final VoidCallback? onBirthdayTap;
  final VoidCallback? onNext;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    return MemberProfileEditStepScaffold(
      title: titleOverride ?? l10n.memberProfileStep1Title,
      description: descriptionOverride ?? l10n.memberProfileStep1Description,
      primaryButtonLabel: primaryButtonLabelOverride ?? l10n.commonNext,
      onPrimaryPressed: onNext,
      primaryButtonEnabled: primaryButtonEnabled,
      showSkip: false,
      skipLabel: l10n.commonSkipChevron,
      onSkip: onSkip,
      child: Column(
        children: <Widget>[
          MemberProfileDualTextFieldRow(
            startLabel: l10n.memberProfileFamilyNameLabel,
            startController: familyNameController,
            startHintText: l10n.memberProfileFamilyNameHint,
            endLabel: l10n.memberProfileGivenNameLabel,
            endController: givenNameController,
            endHintText: l10n.memberProfileGivenNameHint,
          ),
          const SizedBox(height: 14),
          MemberProfileDualTextFieldRow(
            startLabel: l10n.memberProfileFamilyNameKanaLabel,
            startController: familyNameKanaController,
            startHintText: l10n.memberProfileFamilyNameKanaHint,
            startInputFormatters: <TextInputFormatter>[
              MemberProfileInputFormatters.katakanaOnly,
            ],
            endLabel: l10n.memberProfileGivenNameKanaLabel,
            endController: givenNameKanaController,
            endHintText: l10n.memberProfileGivenNameKanaHint,
            endInputFormatters: <TextInputFormatter>[
              MemberProfileInputFormatters.katakanaOnly,
            ],
          ),
          const SizedBox(height: 14),
          MemberProfileDualTextFieldRow(
            startLabel: l10n.memberProfileFamilyNameRomanLabel,
            startController: familyNameRomanController,
            startHintText: l10n.memberProfileFamilyNameRomanHint,
            startKeyboardType: TextInputType.name,
            startInputFormatters: <TextInputFormatter>[
              MemberProfileInputFormatters.romanNameOnly,
            ],
            endLabel: l10n.memberProfileGivenNameRomanLabel,
            endController: givenNameRomanController,
            endHintText: l10n.memberProfileGivenNameRomanHint,
            endKeyboardType: TextInputType.name,
            endInputFormatters: <TextInputFormatter>[
              MemberProfileInputFormatters.romanNameOnly,
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
