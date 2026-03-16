import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_locale_providers.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/theme/app_theme_mode_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/providers/identity_auth_sdk_providers.dart';

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
    final currentThemePreference = ref.watch(appThemePreferenceProvider);
    final currentLanguage = ref.watch(appLanguageProvider);
    final isIdentityAuthEnabled = ref.watch(identityAuthFeatureEnabledProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppNavigationBar(
        title: l10n.menuTitle,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              AppColorTokens.fundexPrimaryDark,
              AppColorTokens.fundexPrimaryDarkDradient,
            ],
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
                iconBackgroundColor: const Color(0xFFDBEAFE),
                iconForegroundColor: AppColorTokens.fundexAccent,
                onTap: () => context.push('/member-profile/edit'),
              ),
              AppMenuItem(
                icon: Icons.account_balance_wallet_rounded,
                label: l10n.menuItemBankSettings,
                iconBackgroundColor: AppColorTokens.fundexSuccessLight,
                iconForegroundColor: AppColorTokens.fundexSuccess,
                onTap: () => context.push('/wallet/deposit'),
              ),
            ],
          ),
          AppMenuSection(
            title: l10n.menuSectionSecurity,
            children: <Widget>[
              AppMenuItem(
                icon: Icons.lock_rounded,
                label: l10n.menuItemChangePassword,
                iconBackgroundColor: const Color(0xFFFEF3C7),
                iconForegroundColor: AppColorTokens.fundexWarning,
                onTap: () => _showComingSoon(l10n.menuItemChangePassword),
              ),
              AppMenuItem(
                icon: Icons.verified_user_rounded,
                label: l10n.menuItemTwoFactor,
                iconBackgroundColor: AppColorTokens.fundexVioletLight,
                iconForegroundColor: const Color(0xFF7C3AED),
                onTap: () => isIdentityAuthEnabled
                    ? context.push('/auth/real-person')
                    : _showComingSoon(l10n.menuItemTwoFactor),
              ),
            ],
          ),
          AppMenuSection(
            title: l10n.menuSectionDocsTax,
            children: <Widget>[
              AppMenuItem(
                icon: Icons.description_rounded,
                label: l10n.menuItemAnnualReport,
                iconBackgroundColor: AppColorTokens.fundexDangerLight,
                iconForegroundColor: AppColorTokens.fundexDanger,
                onTap: () => _showComingSoon(l10n.menuItemAnnualReport),
              ),
              AppMenuItem(
                icon: Icons.article_rounded,
                label: l10n.menuItemContractList,
                iconBackgroundColor: const Color(0xFFF1F5F9),
                iconForegroundColor: AppColorTokens.fundexTextSecondary,
                onTap: () => _showComingSoon(l10n.menuItemContractList),
              ),
              AppMenuItem(
                icon: Icons.badge_rounded,
                label: l10n.menuItemMyNumber,
                iconBackgroundColor: const Color(0xFFFEF3C7),
                iconForegroundColor: AppColorTokens.fundexWarning,
                onTap: () => _showComingSoon(l10n.menuItemMyNumber),
              ),
            ],
          ),
          AppMenuSection(
            title: l10n.menuSectionPreferences,
            children: <Widget>[
              AppMenuItem(
                icon: Icons.dark_mode_rounded,
                label: l10n.menuItemTheme,
                iconBackgroundColor: const Color(0xFFEDE9FE),
                iconForegroundColor: AppColorTokens.fundexViolet,
                trailing: Text(
                  _themeLabel(currentThemePreference),
                  style:
                      (Theme.of(context).textTheme.bodySmall ??
                              const TextStyle())
                          .copyWith(
                            color: AppColorTokens.fundexTextSecondary,
                            fontWeight: FontWeight.w600,
                          ),
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(UiTokens.radius16),
                      border: Border.all(color: AppColorTokens.fundexBorder),
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
                iconBackgroundColor: const Color(0xFFE0F2FE),
                iconForegroundColor: AppColorTokens.fundexAccent,
                trailing: Text(
                  _languageLabel(currentLanguage),
                  style:
                      (Theme.of(context).textTheme.bodySmall ??
                              const TextStyle())
                          .copyWith(
                            color: AppColorTokens.fundexTextSecondary,
                            fontWeight: FontWeight.w600,
                          ),
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(UiTokens.radius16),
                      border: Border.all(color: AppColorTokens.fundexBorder),
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
                iconBackgroundColor: const Color(0xFFDBEAFE),
                iconForegroundColor: AppColorTokens.fundexAccent,
                onTap: () => _showComingSoon(l10n.menuItemFaqHelp),
              ),
              AppMenuItem(
                icon: Icons.chat_bubble_rounded,
                label: l10n.menuItemChatSupport,
                iconBackgroundColor: AppColorTokens.fundexSuccessLight,
                iconForegroundColor: AppColorTokens.fundexSuccess,
                onTap: () => _showComingSoon(l10n.menuItemChatSupport),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 20),
            child: Text(
              l10n.menuVersionFootnote,
              textAlign: TextAlign.center,
              style:
                  (Theme.of(context).textTheme.labelSmall ?? const TextStyle())
                      .copyWith(color: AppColorTokens.fundexTextTertiary),
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
              style:
                  (Theme.of(context).textTheme.bodySmall ?? const TextStyle())
                      .copyWith(
                        color: const Color.fromARGB(255, 27, 12, 12),
                        //decoration: TextDecoration.underline,
                      ),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: isLast
                ? null
                : const Border(
                    bottom: BorderSide(color: AppColorTokens.fundexBorder),
                  ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  style:
                      (Theme.of(context).textTheme.bodyMedium ??
                              const TextStyle())
                          .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_rounded,
                  size: 18,
                  color: AppColorTokens.fundexAccent,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
