import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations_ext.dart';

class MemberProfileRealPersonAuthStepPage extends StatelessWidget {
  const MemberProfileRealPersonAuthStepPage({
    super.key,
    required this.isProcessing,
    this.statusMessage,
    this.onStartVerification,
  });

  final bool isProcessing;
  final String? statusMessage;
  final VoidCallback? onStartVerification;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return MemberProfileEditStepScaffold(
      title: l10n.memberProfileStep5RealPersonTitle,
      description: l10n.memberProfileStep5RealPersonDescription,
      primaryButtonLabel: l10n.identityAuthStartAction,
      onPrimaryPressed: onStartVerification,
      primaryButtonEnabled: !isProcessing,
      child: Column(
        children: <Widget>[
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
