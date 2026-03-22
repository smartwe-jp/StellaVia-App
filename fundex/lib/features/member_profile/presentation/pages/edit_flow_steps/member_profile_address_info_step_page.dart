import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations_ext.dart';

class MemberProfileAddressInfoStepPage extends StatelessWidget {
  const MemberProfileAddressInfoStepPage({
    super.key,
    required this.postalCodeController,
    required this.prefecture,
    required this.cityAddressController,
    required this.prefectureItems,
    this.primaryButtonEnabled = true,
    this.titleOverride,
    this.descriptionOverride,
    this.primaryButtonLabelOverride,
    this.onPrefectureChanged,
    this.onAddressSearch,
    this.onNext,
    this.onSkip,
  });

  final TextEditingController postalCodeController;
  final String? prefecture;
  final TextEditingController cityAddressController;
  final List<DropdownMenuItem<String>> prefectureItems;
  final bool primaryButtonEnabled;
  final String? titleOverride;
  final String? descriptionOverride;
  final String? primaryButtonLabelOverride;
  final ValueChanged<String?>? onPrefectureChanged;
  final VoidCallback? onAddressSearch;
  final VoidCallback? onNext;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MemberProfileEditStepScaffold(
      title: titleOverride ?? l10n.memberProfileStep2Title,
      description: descriptionOverride ?? l10n.memberProfileStep2Description,
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
          MemberProfileSelectField<String>(
            label: l10n.memberProfilePrefectureLabel,
            value: prefecture,
            items: prefectureItems,
            onChanged: onPrefectureChanged,
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
