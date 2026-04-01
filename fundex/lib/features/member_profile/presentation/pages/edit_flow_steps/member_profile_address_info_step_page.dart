import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations_ext.dart';

class MemberProfileAddressInfoStepPage extends StatelessWidget {
  const MemberProfileAddressInfoStepPage({
    super.key,
    required this.postalCodeController,
    required this.prefectureController,
    required this.cityAddressController,
    this.primaryButtonEnabled = true,
    this.titleOverride,
    this.descriptionOverride,
    this.secondaryButtonLabelOverride,
    this.onSecondaryPressed,
    this.primaryButtonLabelOverride,
    this.onAddressSearch,
    this.onNext,
    this.onSkip,
  });

  final TextEditingController postalCodeController;
  final TextEditingController prefectureController;
  final TextEditingController cityAddressController;
  final bool primaryButtonEnabled;
  final String? titleOverride;
  final String? descriptionOverride;
  final String? secondaryButtonLabelOverride;
  final VoidCallback? onSecondaryPressed;
  final String? primaryButtonLabelOverride;
  final VoidCallback? onAddressSearch;
  final VoidCallback? onNext;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MemberProfileEditStepScaffold(
      title: titleOverride ?? l10n.memberProfileStep2Title,
      description: descriptionOverride ?? l10n.memberProfileStep2Description,
      secondaryButtonLabel: secondaryButtonLabelOverride,
      onSecondaryPressed: onSecondaryPressed,
      primaryButtonLabel: primaryButtonLabelOverride ?? l10n.commonNext,
      onPrimaryPressed: onNext,
      primaryButtonEnabled: primaryButtonEnabled,
      skipLabel: l10n.commonSkipChevron,
      onSkip: onSkip,
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: MemberProfileTextField(
                  label: l10n.memberProfilePostalCodeLabel,
                  controller: postalCodeController,
                  hintText: l10n.memberProfilePostalCodeHint,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MemberProfileOutlineButton(
                  onPressed: onAddressSearch,
                  label: l10n.memberProfileAddressSearch,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          MemberProfileTextField(
            label: l10n.memberProfilePrefectureLabel,
            controller: prefectureController,
          ),
          const SizedBox(height: 14),
          MemberProfileTextField(
            label: l10n.memberProfileCityAddressLabel,
            controller: cityAddressController,
            hintText: l10n.memberProfileCityAddressHint,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
