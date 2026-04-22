import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/config/environment_provider.dart';
import '../../../../app/localization/app_locale_providers.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/theme/app_theme_mode_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/settings_content_providers.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _showThemeOptions = false;
  bool _showLanguageOptions = false;
  bool _isLoggingOut = false;

  Future<void> _openAvatarEditor() async {
    final uploadedUrl = await context.push<String>('/profile/avatar');
    if (!mounted || (uploadedUrl?.trim().isNotEmpty ?? false) == false) {
      return;
    }
    await ref.refresh(currentAuthUserProvider.future).catchError((Object _) {
      return null;
    });
  }

  Future<void> _switchThemePreference(AppThemePreference preference) async {
    await ref
        .read(appThemePreferenceProvider.notifier)
        .setPreference(preference);
    if (!mounted) {
      return;
    }
    setState(() {
      _showThemeOptions = false;
    });
  }

  Future<void> _switchLanguage(AppLanguage language) async {
    await ref.read(appLanguageProvider.notifier).setLanguage(language);
    if (!mounted) {
      return;
    }
    setState(() {
      _showLanguageOptions = false;
    });
  }

  Future<void> _logout() async {
    if (_isLoggingOut) {
      return;
    }

    setState(() {
      _isLoggingOut = true;
    });

    try {
      await ref.read(logoutUseCaseProvider).call();
      await ref.read(authSessionProvider.notifier).markUnauthenticated();
      if (mounted) {
        context.go('/login');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  Future<void> _confirmLogout() async {
    if (_isLoggingOut) {
      return;
    }

    final l10n = context.l10n;
    final confirmed = await AppDialogs.showAdaptiveAlert<bool>(
      context: context,
      title: l10n.settingsLogoutConfirmTitle,
      message: l10n.settingsLogoutConfirmBody,
      actions: <AppDialogAction<bool>>[
        AppDialogAction<bool>(label: l10n.profileGuardCancel, value: false),
        AppDialogAction<bool>(
          label: l10n.homeLogout,
          value: true,
          isDefaultAction: true,
        ),
      ],
    );

    if (confirmed == true) {
      await _logout();
    }
  }

  String _normalizeDialUriPhone(String phone) {
    return phone.replaceAll(RegExp(r'[^0-9+]'), '');
  }

  String _formatSupportPhoneDisplay(String phone) {
    final trimmed = phone.trim();
    if (trimmed.isEmpty) {
      return '';
    }
    if (trimmed.startsWith('+')) {
      return trimmed;
    }
    if (trimmed.startsWith('0')) {
      return '+81 ${trimmed.substring(1)}';
    }
    return '+81 $trimmed';
  }

  Future<void> _callSupportPhone(String phone) async {
    final normalized = phone.trim();
    if (normalized.isEmpty) {
      return;
    }
    final dialTarget = _normalizeDialUriPhone(normalized);
    if (dialTarget.isEmpty) {
      return;
    }
    final launched = await launchUrl(Uri.parse('tel:$dialTarget'));
    if (!mounted || launched) {
      return;
    }
    AppNotice.show(context, message: context.l10n.uiErrorRequestFailed);
  }

  Future<void> _showDeleteAccountDialog(String supportPhone) async {
    final l10n = context.l10n;
    final displayPhone = _formatSupportPhoneDisplay(supportPhone);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final hasPhone = displayPhone.isNotEmpty;
        return AlertDialog(
          title: Text(l10n.settingsDeleteAccountSupportTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(l10n.settingsDeleteAccountSupportMessage),
              if (hasPhone) ...<Widget>[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () async {
                    Navigator.of(dialogContext).pop();
                    await _callSupportPhone(supportPhone);
                  },
                  child: Text(displayPhone),
                ),
              ],
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: hasPhone
                  ? () async {
                      Navigator.of(dialogContext).pop();
                      await _callSupportPhone(supportPhone);
                    }
                  : null,
              child: Text(l10n.settingsDeleteAccountCallAction),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.profileGuardCancel),
            ),
          ],
        );
      },
    );
  }

  String _languageLabel(AppLanguage language) {
    return language.nativeLabel;
  }

  String _themeLabel(AppThemePreference preference) {
    final l10n = context.l10n;
    return switch (preference) {
      AppThemePreference.system => l10n.menuThemeSystem,
      AppThemePreference.light => l10n.menuThemeLight,
      AppThemePreference.dark => l10n.menuThemeDark,
    };
  }

  String _buildFooterText({
    required String fallback,
    required String appName,
    required String? version,
    required String? licenseNumber,
  }) {
    final trimmedAppName = appName.trim();
    final trimmedVersion = version?.trim() ?? '';
    final compactLicenseNumber =
        licenseNumber?.replaceAll(RegExp(r'\s+'), ' ').trim() ?? '';

    final appInfo = switch ((trimmedAppName.isEmpty, trimmedVersion.isEmpty)) {
      (false, false) => '$trimmedAppName v$trimmedVersion',
      (false, true) => trimmedAppName,
      (true, false) => 'v$trimmedVersion',
      _ => '',
    };

    if (appInfo.isEmpty && compactLicenseNumber.isEmpty) {
      return fallback;
    }
    if (appInfo.isEmpty) {
      return compactLicenseNumber;
    }
    if (compactLicenseNumber.isEmpty) {
      return appInfo;
    }
    return '$appInfo ・ $compactLicenseNumber';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final environment = ref.watch(appEnvironmentProvider);
    final currentThemePreference = ref.watch(appThemePreferenceProvider);
    final currentLanguage = ref.watch(appLanguageProvider);
    final isAuthenticated =
        ref.watch(isAuthenticatedProvider).asData?.value ?? false;
    final currentUser = ref.watch(currentAuthUserProvider).asData?.value;
    final currentAvatarUrl = currentUser?.avatar?.trim() ?? '';
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final appVersionAsync = ref.watch(settingsAppVersionProvider);
    final operatingCompanyAsync = ref.watch(
      settingsOperatingCompanyContentProvider(localeTag),
    );
    final footerText = _buildFooterText(
      fallback: l10n.menuVersionFootnote,
      appName: environment.appName,
      version: appVersionAsync.asData?.value,
      licenseNumber: operatingCompanyAsync.asData?.value.licenseNumber,
    );
    final supportPhone = operatingCompanyAsync.asData?.value.tel.trim() ?? '';

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: l10n.menuTitle,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //     colors: <Color>[colors.heroStart, colors.heroMiddle],
        //   ),
        // ),
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
          backgroundColor: colors.surface.withValues(alpha: 0),
          foregroundColor: colors.textPrimary,
        ),
      ),
      body: ListView(
        key: const Key('settings_tab_content'),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
        children: <Widget>[
          if (isAuthenticated) ...<Widget>[
            AppMenuSection(
              title: l10n.menuSectionAccount,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Material(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(UiTokens.radius12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(UiTokens.radius12),
                      onTap: _openAvatarEditor,
                      child: Ink(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            UiTokens.radius12,
                          ),
                          border: Border.all(color: colors.border),
                        ),
                        child: Row(
                          children: <Widget>[
                            AppUserAvatar(
                              avatarUrl: currentAvatarUrl,
                              size: 34,
                              fontSize: 14,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.discussionAvatarPageTitle,
                                style: appText.cardTitle.copyWith(
                                  color: colors.textPrimary,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 18,
                              color: colors.textTertiary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                AppMenuItem(
                  icon: Icons.person_rounded,
                  label: l10n.menuItemEditProfile,
                  iconBackgroundColor: colors.primarySubtle,
                  iconForegroundColor: colors.primary,
                  onTap: () => context.push('/member-profile/edit'),
                ),
                AppMenuItem(
                  icon: Icons.account_balance_wallet_rounded,
                  label: l10n.menuItemBankSettings,
                  iconBackgroundColor: colors.primarySubtle,
                  iconForegroundColor: colors.primary,
                  onTap: () => context.push('/profile/wallet/bank-settings'),
                ),
              ],
            ),
            AppMenuSection(
              title: l10n.menuSectionSecurity,
              children: <Widget>[
                AppMenuItem(
                  icon: Icons.verified_user_rounded,
                  label: l10n.menuItemTwoFactor,
                  iconBackgroundColor: colors.communitySecondary.withValues(
                    alpha: 0.16,
                  ),
                  iconForegroundColor: colors.communitySecondary,
                  onTap: () => context.push('/profile/settings/two-factor'),
                ),
              ],
            ),
            AppMenuSection(
              title: l10n.menuSectionDocsTax,
              children: <Widget>[
                // AppMenuItem(
                //   icon: Icons.description_rounded,
                //   label: l10n.menuItemAnnualReport,
                //   iconBackgroundColor: colors.dangerSubtle,
                //   iconForegroundColor: colors.danger,
                //   onTap: () => _showComingSoon(l10n.menuItemAnnualReport),
                // ),
                AppMenuItem(
                  icon: Icons.article_rounded,
                  label: l10n.menuItemContractList,
                  iconBackgroundColor: colors.surfaceAlt,
                  iconForegroundColor: colors.textSecondary,
                  onTap: () => context.push('/profile/settings/contracts'),
                ),
              ],
            ),
          ],
          AppMenuSection(
            title: l10n.menuSectionPreferences,
            children: <Widget>[
              AppMenuItem(
                icon: Icons.dark_mode_rounded,
                label: l10n.menuItemTheme,
                iconBackgroundColor: colors.communitySecondary.withValues(
                  alpha: 0.16,
                ),
                iconForegroundColor: colors.communitySecondary,
                trailing: Text(
                  _themeLabel(currentThemePreference),
                  style: appText.cellValue,
                ),
                onTap: () {
                  setState(() {
                    _showThemeOptions = !_showThemeOptions;
                    _showLanguageOptions = false;
                  });
                },
              ),
              if (_showThemeOptions)
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 6),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(UiTokens.radius16),
                      border: Border.all(color: colors.border),
                    ),
                    child: Column(
                      children: AppThemePreference.values
                          .map(
                            (preference) => _SettingsOptionTile(
                              label: _themeLabel(preference),
                              selected: currentThemePreference == preference,
                              isLast:
                                  preference == AppThemePreference.values.last,
                              onTap: () => _switchThemePreference(preference),
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ),
                ),
              AppMenuItem(
                icon: Icons.language_rounded,
                label: l10n.menuItemLanguage,
                iconBackgroundColor: colors.infoSubtle,
                iconForegroundColor: colors.info,
                trailing: Text(
                  _languageLabel(currentLanguage),
                  style: appText.cellValue,
                ),
                onTap: () {
                  setState(() {
                    _showThemeOptions = false;
                    _showLanguageOptions = !_showLanguageOptions;
                  });
                },
              ),
              if (_showLanguageOptions)
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 6),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(UiTokens.radius16),
                      border: Border.all(color: colors.border),
                    ),
                    child: Column(
                      children: AppLanguage.values
                          .map(
                            (language) => _SettingsOptionTile(
                              label: _languageLabel(language),
                              selected: currentLanguage == language,
                              isLast: language == AppLanguage.values.last,
                              onTap: () => _switchLanguage(language),
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ),
                ),
            ],
          ),
          AppMenuSection(
            title: l10n.menuSectionSupport,
            children: <Widget>[
              AppMenuItem(
                icon: Icons.help_rounded,
                label: l10n.menuItemFaqHelp,
                iconBackgroundColor: colors.primarySubtle,
                iconForegroundColor: colors.primary,
                onTap: () => context.push('/profile/settings/faq'),
              ),
              // AppMenuItem(
              //   icon: Icons.chat_bubble_rounded,
              //   label: l10n.menuItemChatSupport,
              //   iconBackgroundColor: colors.successSubtle,
              //   iconForegroundColor: colors.success,
              //   onTap: () => _showComingSoon(l10n.menuItemChatSupport),
              // ),
              AppMenuItem(
                icon: Icons.email_rounded,
                label: l10n.menuItemContactUs,
                iconBackgroundColor: colors.infoSubtle,
                iconForegroundColor: colors.info,
                onTap: () => context.push('/profile/settings/contact'),
              ),
              AppMenuItem(
                icon: Icons.business_rounded,
                label: l10n.menuItemOperatingCompany,
                iconBackgroundColor: colors.communitySecondary.withValues(
                  alpha: 0.12,
                ),
                iconForegroundColor: colors.communitySecondary,
                onTap: () => context.push('/profile/settings/company'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 20),
            child: Text(
              footerText,
              textAlign: TextAlign.center,
              style: appText.meta,
            ),
          ),
          if (isAuthenticated) ...<Widget>[
            OutlinedButton(
              onPressed: _isLoggingOut ? null : _confirmLogout,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                foregroundColor: colors.textPrimary,
                side: BorderSide(color: colors.border),
                textStyle: appText.bodyStrong,
              ),
              child: _isLoggingOut
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.homeLogout),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => _showDeleteAccountDialog(supportPhone),
                style: TextButton.styleFrom(
                  foregroundColor: colors.danger,
                  textStyle: appText.meta,
                ),
                child: Text(l10n.menuDeleteAccountAction),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SettingsOptionTile extends StatelessWidget {
  const _SettingsOptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.isLast,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: isLast
                ? null
                : Border(bottom: BorderSide(color: colors.border)),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  style: appText.bodyStrong.copyWith(color: colors.textPrimary),
                ),
              ),
              if (selected)
                Icon(Icons.check_rounded, size: 18, color: colors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
