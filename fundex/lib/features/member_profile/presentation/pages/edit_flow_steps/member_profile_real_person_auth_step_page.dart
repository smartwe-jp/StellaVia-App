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
    return MemberProfileEditStepScaffold(
      title: l10n.memberProfileStep5RealPersonTitle,
      description: l10n.memberProfileStep5RealPersonDescription,
      primaryButtonLabel: l10n.identityAuthStartAction,
      onPrimaryPressed: onStartVerification,
      primaryButtonEnabled: !isProcessing,
      child: Column(
        children: <Widget>[
          MemberProfileInfoCard(
            icon: '🧑‍🦰',
            title: l10n.identityAuthPageTitle,
            backgroundColor: const Color(0xFFF0F9FF),
            borderColor: const Color(0xFFBAE6FD),
            body: Text(
              l10n.identityAuthPageDescription,
              style:
                  (Theme.of(context).textTheme.bodySmall ?? const TextStyle())
                      .copyWith(height: 1.65),
            ),
          ),
          if (isProcessing) ...<Widget>[
            const SizedBox(height: 14),
            const LinearProgressIndicator(minHeight: 3),
          ],
          if ((statusMessage?.trim().isNotEmpty ?? false)) ...<Widget>[
            const SizedBox(height: 14),
            MemberProfileNoticeCard(
              icon: const Icon(
                Icons.error_outline_rounded,
                size: 16,
                color: Color(0xFFB91C1C),
              ),
              title: l10n.identityAuthVerifyFailed,
              body: statusMessage!.trim(),
              backgroundColor: const Color(0xFFFFF1F2),
              borderColor: const Color(0xFFFCA5A5),
              foregroundColor: const Color(0xFFB91C1C),
            ),
          ],
        ],
      ),
    );
  }
}
