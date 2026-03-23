import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_locale_providers.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/theme/app_theme_mode_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _showThemeOptions = false;
  bool _showLanguageOptions = false;
  bool _isLoggingOut = false;

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

  Future<void> _confirmDeleteAccount() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.menuDeleteAccountConfirmTitle),
          content: Text(l10n.menuDeleteAccountConfirmBody),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.profileGuardCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.menuDeleteAccountAction),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    AppNotice.show(context, message: l10n.menuDeleteAccountComingSoon);
  }

  void _showComingSoon(String label) {
    AppNotice.show(context, message: context.l10n.menuFeatureComingSoon(label));
  }

  String _languageLabel(AppLanguage language) {
    final l10n = context.l10n;
    return switch (language) {
      AppLanguage.system => l10n.languageFollowSystem,
      AppLanguage.zh => l10n.languageChinese,
      AppLanguage.zhHant => l10n.languageTraditionalChinese,
      AppLanguage.en => l10n.languageEnglish,
      AppLanguage.ja => l10n.languageJapanese,
    };
  }

  String _themeLabel(AppThemePreference preference) {
    final l10n = context.l10n;
    return switch (preference) {
      AppThemePreference.system => l10n.menuThemeSystem,
      AppThemePreference.light => l10n.menuThemeLight,
      AppThemePreference.dark => l10n.menuThemeDark,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final currentThemePreference = ref.watch(appThemePreferenceProvider);
    final currentLanguage = ref.watch(appLanguageProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: l10n.menuTitle,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[colors.heroStart, colors.heroMiddle],
          ),
        ),
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      body: ListView(
        key: const Key('settings_tab_content'),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
        children: <Widget>[
          AppMenuSection(
            title: l10n.menuSectionAccount,
            children: <Widget>[
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
                iconBackgroundColor: colors.successSubtle,
                iconForegroundColor: colors.success,
                onTap: () => context.push('/profile/wallet/bank-settings'),
              ),
            ],
          ),
          AppMenuSection(
            title: l10n.menuSectionSecurity,
            children: <Widget>[
              // AppMenuItem(
              //   icon: Icons.lock_rounded,
              //   label: l10n.menuItemChangePassword,
              //   iconBackgroundColor: colors.warningSubtle,
              //   iconForegroundColor: colors.warning,
              //   onTap: () => _showComingSoon(l10n.menuItemChangePassword),
              // ),
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
              AppMenuItem(
                icon: Icons.description_rounded,
                label: l10n.menuItemAnnualReport,
                iconBackgroundColor: colors.dangerSubtle,
                iconForegroundColor: colors.danger,
                onTap: () => _showComingSoon(l10n.menuItemAnnualReport),
              ),
              AppMenuItem(
                icon: Icons.article_rounded,
                label: l10n.menuItemContractList,
                iconBackgroundColor: colors.surfaceAlt,
                iconForegroundColor: colors.textSecondary,
                onTap: () => _showComingSoon(l10n.menuItemContractList),
              ),
              // AppMenuItem(
              //   icon: Icons.badge_rounded,
              //   label: l10n.menuItemMyNumber,
              //   iconBackgroundColor: colors.warningSubtle,
              //   iconForegroundColor: colors.warning,
              //   onTap: () => _showComingSoon(l10n.menuItemMyNumber),
              // ),
            ],
          ),
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
                  style: appText.helper.copyWith(color: colors.textSecondary),
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
                  style: appText.helper.copyWith(color: colors.textSecondary),
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
              AppMenuItem(
                icon: Icons.chat_bubble_rounded,
                label: l10n.menuItemChatSupport,
                iconBackgroundColor: colors.successSubtle,
                iconForegroundColor: colors.success,
                onTap: () => _showComingSoon(l10n.menuItemChatSupport),
              ),
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
              l10n.menuVersionFootnote,
              textAlign: TextAlign.center,
              style: appText.meta,
            ),
          ),
          OutlinedButton(
            onPressed: _isLoggingOut ? null : _logout,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: _isLoggingOut
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.homeLogout),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: _confirmDeleteAccount,
            child: Text(
              l10n.menuDeleteAccountAction,
              style: appText.helper.copyWith(color: colors.dangerForeground),
            ),
          ),
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
