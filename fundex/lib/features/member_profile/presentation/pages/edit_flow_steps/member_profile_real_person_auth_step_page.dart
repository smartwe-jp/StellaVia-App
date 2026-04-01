import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations_ext.dart';

class MemberProfileRealPersonAuthStepPage extends StatelessWidget {
  const MemberProfileRealPersonAuthStepPage({
    super.key,
    required this.isProcessing,
    required this.selfieUploaded,
    this.selfiePreviewUrl,
    this.previewActionLabel,
    this.primaryButtonEnabled = true,
    this.showSkip = false,
    this.titleOverride,
    this.descriptionOverride,
    this.secondaryButtonLabelOverride,
    this.onSecondaryPressed,
    this.primaryButtonLabelOverride,
    this.statusMessage,
    this.onUploadSelfie,
    this.onStartVerification,
    this.onSkip,
  });

  final bool isProcessing;
  final bool selfieUploaded;
  final String? selfiePreviewUrl;
  final String? previewActionLabel;
  final bool primaryButtonEnabled;
  final bool showSkip;
  final String? titleOverride;
  final String? descriptionOverride;
  final String? secondaryButtonLabelOverride;
  final VoidCallback? onSecondaryPressed;
  final String? primaryButtonLabelOverride;
  final String? statusMessage;
  final VoidCallback? onUploadSelfie;
  final VoidCallback? onStartVerification;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return MemberProfileEditStepScaffold(
      title: titleOverride ?? l10n.memberProfileStep5RealPersonTitle,
      description:
          descriptionOverride ?? l10n.memberProfileStep5RealPersonDescription,
      secondaryButtonLabel: secondaryButtonLabelOverride,
      onSecondaryPressed: onSecondaryPressed,
      primaryButtonLabel:
          primaryButtonLabelOverride ?? l10n.identityAuthStartAction,
      onPrimaryPressed: onStartVerification,
      primaryButtonEnabled: primaryButtonEnabled,
      showSkip: showSkip,
      skipLabel: l10n.commonSkipChevron,
      onSkip: onSkip,
      child: Column(
        children: <Widget>[
          MemberProfileUploadTile(
            icon: Icons.person_outline_rounded,
            title: l10n.memberProfileSelfieTitle,
            description: l10n.memberProfileSelfieDescription,
            isCompleted: selfieUploaded,
            previewLabel: previewActionLabel,
            previewUrl: selfiePreviewUrl,
            onTap: onUploadSelfie,
          ),
          const SizedBox(height: 14),
          MemberProfileInfoCard(
            title: l10n.identityAuthPageTitle,
            backgroundColor: colors.infoSoft,
            borderColor: colors.infoBorder,
            body: Text(
              l10n.identityAuthPageDescription,
              style: appText.helper.copyWith(height: 1.65),
            ),
          ),
          if (isProcessing) ...<Widget>[
            const SizedBox(height: 14),
            LinearProgressIndicator(
              minHeight: 3,
              color: colors.primary,
              backgroundColor: colors.borderSoft,
            ),
          ],
          if ((statusMessage?.trim().isNotEmpty ?? false)) ...<Widget>[
            const SizedBox(height: 14),
            MemberProfileNoticeCard(
              icon: Icon(
                Icons.error_outline_rounded,
                size: 16,
                color: colors.dangerForeground,
              ),
              title: l10n.identityAuthVerifyFailed,
              body: statusMessage!.trim(),
              backgroundColor: colors.dangerSoft,
              borderColor: colors.dangerBorder,
              foregroundColor: colors.dangerForeground,
            ),
          ],
        ],
      ),
    );
  }
}
