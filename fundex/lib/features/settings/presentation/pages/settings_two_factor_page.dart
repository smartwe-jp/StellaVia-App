import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/settings_two_factor_providers.dart';

class SettingsTwoFactorPage extends ConsumerWidget {
  const SettingsTwoFactorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final emailVerified = ref.watch(settingsEmailVerifiedProvider);
    final verifiedEmail = ref.watch(settingsVerifiedEmailProvider);
    final emailVerifiedAt = ref.watch(
      settingsEmailVerificationUpdatedAtProvider,
    );
    final phoneVerified = ref.watch(settingsPhoneVerifiedProvider);
    final verifiedPhone = ref.watch(settingsVerifiedPhoneNumberProvider);
    final phoneVerifiedAt = ref.watch(
      settingsPhoneVerificationUpdatedAtProvider,
    );
    final faceVerified = ref.watch(settingsRealPersonVerifiedProvider);
    final faceVerifiedAt = ref.watch(
      settingsRealPersonVerificationUpdatedAtProvider,
    );
    final canOpenEmailVerification = emailVerified.asData?.value != true;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: l10n.menuItemTwoFactor,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              borderRadius: BorderRadius.circular(UiTokens.radius16),
              border: Border.all(color: colors.border),
            ),
            child: Text(
              l10n.settingsTwoFactorDescription,
              style: appText.body.copyWith(
                color: colors.textSecondary,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppMenuSection(
            title: l10n.menuSectionSecurity,
            children: <Widget>[
              AppMenuItem(
                icon: Icons.mark_email_read_rounded,
                label: l10n.settingsEmailVerificationTitle,
                iconBackgroundColor: colors.primarySubtle,
                iconForegroundColor: colors.primary,
                trailing: _VerificationStatusText(
                  verified: emailVerified.asData?.value == true,
                  verifiedValueLabel: l10n.settingsVerificationEmailLabel,
                  verifiedValue: verifiedEmail.asData?.value,
                  verifiedAt: emailVerifiedAt.asData?.value,
                  showVerifiedValueLabel: false,
                  showVerifiedAt: false,
                  isLoading:
                      emailVerified.isLoading ||
                      verifiedEmail.isLoading ||
                      emailVerifiedAt.isLoading,
                ),
                showChevron: canOpenEmailVerification,
                onTap: canOpenEmailVerification
                    ? () => context.push('/profile/settings/two-factor/email')
                    : null,
              ),
              AppMenuItem(
                icon: Icons.sms_rounded,
                label: l10n.settingsPhoneVerificationTitle,
                iconBackgroundColor: colors.infoSubtle,
                iconForegroundColor: colors.info,
                trailing: _VerificationStatusText(
                  verified: phoneVerified.asData?.value == true,
                  verifiedValueLabel: l10n.settingsVerificationPhoneLabel,
                  verifiedValue: verifiedPhone.asData?.value,
                  verifiedAt: phoneVerifiedAt.asData?.value,
                  isLoading:
                      phoneVerified.isLoading ||
                      verifiedPhone.isLoading ||
                      phoneVerifiedAt.isLoading,
                ),
                onTap: () => context.push('/profile/settings/two-factor/phone'),
              ),
              AppMenuItem(
                icon: Icons.verified_user_rounded,
                label: l10n.settingsFaceVerificationTitle,
                iconBackgroundColor: colors.communitySecondary.withValues(
                  alpha: 0.16,
                ),
                iconForegroundColor: colors.communitySecondary,
                trailing: _VerificationStatusText(
                  verified: faceVerified.asData?.value == true,
                  verifiedAt: faceVerifiedAt.asData?.value,
                  isLoading: faceVerified.isLoading || faceVerifiedAt.isLoading,
                ),
                onTap: () => context.push('/profile/settings/two-factor/face'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VerificationStatusText extends StatelessWidget {
  const _VerificationStatusText({
    required this.verified,
    this.verifiedValueLabel,
    this.verifiedValue,
    required this.verifiedAt,
    this.showVerifiedValueLabel = true,
    this.showVerifiedAt = true,
    required this.isLoading,
  });

  final bool verified;
  final String? verifiedValueLabel;
  final String? verifiedValue;
  final DateTime? verifiedAt;
  final bool showVerifiedValueLabel;
  final bool showVerifiedAt;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;

    if (isLoading) {
      return SizedBox(
        width: 14,
        height: 14,
        child: CircularProgressIndicator(strokeWidth: 2, color: colors.primary),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          verified
              ? l10n.settingsVerificationStatusVerified
              : l10n.settingsVerificationStatusUnverified,
          style: appText.helper.copyWith(
            color: verified ? colors.success : colors.textSecondary,
          ),
        ),
        if (verified && (verifiedValue?.trim().isNotEmpty ?? false))
          Text(
            showVerifiedValueLabel &&
                    (verifiedValueLabel?.trim().isNotEmpty ?? false)
                ? '${verifiedValueLabel!.trim()} ${verifiedValue!.trim()}'
                : verifiedValue!.trim(),
            style: appText.micro.copyWith(color: colors.textSecondary),
          ),
        if (showVerifiedAt && verified && verifiedAt != null)
          Text(
            '${l10n.settingsVerificationLastUpdatedLabel} ${_formatDateTime(verifiedAt!)}',
            style: appText.micro.copyWith(color: colors.textTertiary),
          ),
      ],
    );
  }

  String _formatDateTime(DateTime value) {
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$year/$month/$day $hour:$minute';
  }
}
