import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations_ext.dart';

class MemberProfileConsentStepPage extends StatelessWidget {
  const MemberProfileConsentStepPage({
    super.key,
    required this.electronicConsent,
    required this.antiSocialConsent,
    required this.privacyConsent,
    this.onElectronicConsentChanged,
    this.onAntiSocialConsentChanged,
    this.onPrivacyConsentChanged,
    this.onComplete,
  });

  final bool electronicConsent;
  final bool antiSocialConsent;
  final bool privacyConsent;
  final ValueChanged<bool>? onElectronicConsentChanged;
  final ValueChanged<bool>? onAntiSocialConsentChanged;
  final ValueChanged<bool>? onPrivacyConsentChanged;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return MemberProfileEditStepScaffold(
      title: l10n.memberProfileStep6Title,
      description: l10n.memberProfileStep6Description,
      primaryButtonLabel: l10n.memberProfileAgreeAndComplete,
      primaryButtonEnabled:
          electronicConsent && antiSocialConsent && privacyConsent,
      onPrimaryPressed: onComplete,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MemberProfileInfoCard(
            icon: '📄',
            title: l10n.memberProfileElectronicDeliveryTitle,
            backgroundColor: colors.infoSoft,
            borderColor: colors.infoBorder,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.memberProfileElectronicDeliveryBody,
                  style: appText.helper.copyWith(height: 1.7),
                ),
                const SizedBox(height: 10),
                ...<String>[
                  l10n.memberProfileElectronicDeliveryItem1,
                  l10n.memberProfileElectronicDeliveryItem2,
                  l10n.memberProfileElectronicDeliveryItem3,
                  l10n.memberProfileElectronicDeliveryItem4,
                ].map<Widget>(
                  (String item) => Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 4),
                    child: Text(
                      '• $item',
                      style: appText.helper.copyWith(height: 1.7),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.memberProfileElectronicDeliveryFootnote,
                  style: appText.micro.copyWith(
                    color: colors.textSecondary.withValues(alpha: 0.86),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          MemberProfileCheckTile(
            label: l10n.memberProfileElectronicDeliveryConsent,
            value: electronicConsent,
            onChanged: onElectronicConsentChanged,
          ),
          const SizedBox(height: 14),
          MemberProfileInfoCard(
            icon: '🛡️',
            title: l10n.memberProfileAntiSocialTitle,
            titleColor: colors.textPrimary,
            body: Text(
              l10n.memberProfileAntiSocialBody,
              style: appText.helper.copyWith(height: 1.7),
            ),
          ),
          const SizedBox(height: 10),
          MemberProfileCheckTile(
            label: l10n.memberProfileAntiSocialConsent,
            value: antiSocialConsent,
            onChanged: onAntiSocialConsentChanged,
          ),
          const SizedBox(height: 14),
          MemberProfileCheckTile(
            label: l10n.memberProfilePrivacyConsent,
            value: privacyConsent,
            onChanged: onPrivacyConsentChanged,
          ),
        ],
      ),
    );
  }
}
