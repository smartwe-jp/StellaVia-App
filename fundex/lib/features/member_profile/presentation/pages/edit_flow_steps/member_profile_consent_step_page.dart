import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations_ext.dart';

class MemberProfileConsentStepPage extends StatelessWidget {
  const MemberProfileConsentStepPage({
    super.key,
    required this.electronicConsent,
    required this.antiSocialConsent,
    required this.privacyConsent,
    this.electronicDeliveryUrl,
    this.antiSocialRuleUrl,
    this.personalInformationUrl,
    this.titleOverride,
    this.descriptionOverride,
    this.secondaryButtonLabelOverride,
    this.onSecondaryPressed,
    this.primaryButtonLabelOverride,
    this.onElectronicConsentChanged,
    this.onAntiSocialConsentChanged,
    this.onPrivacyConsentChanged,
    this.onComplete,
  });

  final bool electronicConsent;
  final bool antiSocialConsent;
  final bool privacyConsent;
  final String? electronicDeliveryUrl;
  final String? antiSocialRuleUrl;
  final String? personalInformationUrl;
  final String? titleOverride;
  final String? descriptionOverride;
  final String? secondaryButtonLabelOverride;
  final VoidCallback? onSecondaryPressed;
  final String? primaryButtonLabelOverride;
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
      title: titleOverride ?? l10n.memberProfileStep6Title,
      description: descriptionOverride ?? l10n.memberProfileStep6Description,
      secondaryButtonLabel: secondaryButtonLabelOverride,
      onSecondaryPressed: onSecondaryPressed,
      primaryButtonLabel:
          primaryButtonLabelOverride ?? l10n.memberProfileAgreeAndComplete,
      primaryButtonEnabled:
          electronicConsent && antiSocialConsent && privacyConsent,
      onPrimaryPressed: onComplete,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MemberProfileInfoCard(
            title: l10n.memberProfileElectronicDeliveryTitle,
            backgroundColor: colors.infoSoft,
            borderColor: colors.infoBorder,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.memberProfileElectronicDeliveryBody,
                  style: appText.helper.copyWith(height: 1.7, fontSize: 14),
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
                      style: appText.helper.copyWith(height: 1.7, fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.memberProfileElectronicDeliveryFootnote,
                  style: appText.micro.copyWith(
                    color: colors.textSecondary.withValues(alpha: 0.86),
                    height: 1.6,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _ConsentLinkTile(
            label: l10n.memberProfileElectronicDeliveryConsent,
            value: electronicConsent,
            onChanged: onElectronicConsentChanged,
            onOpenLink: () => _openConsentPdf(
              context,
              title: l10n.memberProfileElectronicDeliveryConsent,
              url: electronicDeliveryUrl,
            ),
          ),
          const SizedBox(height: 14),
          MemberProfileInfoCard(
            title: l10n.memberProfileAntiSocialTitle,
            titleColor: colors.textPrimary,
            body: Text(
              l10n.memberProfileAntiSocialBody,
              style: appText.helper.copyWith(height: 1.7, fontSize: 13),
            ),
          ),
          const SizedBox(height: 10),
          _ConsentLinkTile(
            label: l10n.memberProfileAntiSocialConsent,
            value: antiSocialConsent,
            onChanged: onAntiSocialConsentChanged,
            onOpenLink: () => _openConsentPdf(
              context,
              title: l10n.memberProfileAntiSocialConsent,
              url: antiSocialRuleUrl,
            ),
          ),
          const SizedBox(height: 14),
          _ConsentLinkTile(
            label: l10n.memberProfilePrivacyConsent,
            value: privacyConsent,
            onChanged: onPrivacyConsentChanged,
            onOpenLink: () => _openConsentPdf(
              context,
              title: l10n.memberProfilePrivacyConsent,
              url: personalInformationUrl,
            ),
          ),
        ],
      ),
    );
  }
}

void _openConsentPdf(
  BuildContext context, {
  required String title,
  required String? url,
}) {
  final l10n = context.l10n;
  final normalizedUrl = url?.trim() ?? '';
  if (normalizedUrl.isEmpty) {
    AppNotice.show(context, message: l10n.pdfViewerInvalidUrlNotice);
    return;
  }
  openAppPdfViewer(
    context,
    url: normalizedUrl,
    title: title,
    texts: AppPdfViewerTexts(
      pageTitle: l10n.pdfViewerPageTitle,
      openExternalTooltip: l10n.pdfViewerOpenExternalTooltip,
      openExternalLabel: l10n.pdfViewerOpenExternalLabel,
      loadingLabel: l10n.pdfViewerLoadingLabel,
      loadFailedLabel: l10n.pdfViewerLoadFailedLabel,
      retryLabel: l10n.fundListRetry,
      invalidUrlNotice: l10n.pdfViewerInvalidUrlNotice,
      openExternalFailedNotice: l10n.pdfViewerOpenExternalFailedNotice,
    ),
  );
}

class _ConsentLinkTile extends StatelessWidget {
  const _ConsentLinkTile({
    required this.label,
    required this.value,
    required this.onOpenLink,
    this.onChanged,
  });

  final String label;
  final bool value;
  final VoidCallback onOpenLink;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final primary = colors.primary;

    void toggle() {
      if (onChanged == null) {
        return;
      }
      onChanged!(!value);
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: toggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: value ? primary : colors.surface,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: value ? primary : colors.border,
                  width: 2,
                ),
              ),
              child: value
                  ? Icon(Icons.check_rounded, size: 12, color: colors.onDark)
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: onOpenLink,
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: Text(
                  label,
                  style: appText.body.copyWith(
                    height: 1.5,
                    color: primary,
                    decoration: TextDecoration.underline,
                    decorationColor: primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
