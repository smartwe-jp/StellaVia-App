import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';

const String _heroBrandLockupAssetPath =
    'assets/images/stellavia.logoAndText.light.png';

class AuthEntryPage extends StatelessWidget {
  const AuthEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _AuthMarketingEntryScaffold(
      pageKey: const Key('auth_entry_page'),
      headline: l10n.authEntryHeadline,
      description: l10n.authEntryDescription,
      imageUrl:
          'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=1200&q=80',
      primaryActions: <Widget>[
        PrimaryCtaButton(
          key: const Key('auth_before_member_login_button'),
          label: l10n.authBeforeMemberDirectLogin,
          horizontalPadding: 0,
          onPressed: () => context.push('/login-legacy'),
        ),
        const SizedBox(height: UiTokens.spacing12),
        PrimaryCtaButton(
          key: const Key('auth_before_register_button'),
          label: l10n.authBeforeNonMemberRegister,
          horizontalPadding: 0,
          onPressed: () => context.push('/register/email'),
        ),
      ],
      footer: null,
    );
  }
}

class RegisterEntryPage extends StatelessWidget {
  const RegisterEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _AuthMarketingEntryScaffold(
      pageKey: const Key('register_entry_page'),
      headline: l10n.authRegisterEntryHeadline,
      description: l10n.authRegisterEntryDescription,
      imageUrl:
          'https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=1200&q=80',
      primaryActions: <Widget>[
        PrimaryCtaButton(
          key: const Key('register_entry_mobile_button'),
          label: l10n.authEntryPhoneRegister,
          horizontalPadding: 0,
          onPressed: () => context.push('/register/mobile'),
        ),
        const SizedBox(height: UiTokens.spacing12),
        PrimaryCtaButton(
          key: const Key('register_entry_email_button'),
          label: l10n.authEntryEmailRegister,
          horizontalPadding: 0,
          onPressed: () => context.push('/register/email'),
        ),
      ],
      footer: TextButton(
        key: const Key('register_entry_back_login_button'),
        onPressed: () => context.go('/login'),
        child: Text(l10n.commonBackToLogin),
      ),
    );
  }
}

class _AuthMarketingEntryScaffold extends StatelessWidget {
  const _AuthMarketingEntryScaffold({
    required this.pageKey,
    required this.headline,
    required this.description,
    required this.imageUrl,
    required this.primaryActions,
    this.footer,
  });

  final Key pageKey;
  final String headline;
  final String description;
  final String imageUrl;
  final List<Widget> primaryActions;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hotelTheme = theme.extension<AppFTKTheme>()!;
    final isDark = theme.brightness == Brightness.dark;
    final panelColor = theme.colorScheme.surface.withValues(
      alpha: isDark ? 0.94 : 0.98,
    );

    return Scaffold(
      key: pageKey,
      body: Stack(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  hotelTheme.primaryButtonColor.withValues(
                    alpha: isDark ? 0.85 : 0.92,
                  ),
                  hotelTheme.primaryButtonColor.withValues(
                    alpha: isDark ? 0.75 : 0.84,
                  ),
                  hotelTheme.discountChipBackgroundColor.withValues(
                    alpha: isDark ? 0.32 : 0.22,
                  ),
                ],
              ),
            ),
            child: const SizedBox.expand(),
          ),
          Positioned(
            top: -140,
            right: -60,
            child: _DecorOrb(
              color: theme.colorScheme.surface.withValues(alpha: 0.16),
              size: 340,
            ),
          ),
          Positioned(
            top: 70,
            right: -90,
            child: _DecorOrb(
              color: hotelTheme.primaryButtonColor.withValues(alpha: 0.4),
              size: 300,
            ),
          ),
          Positioned(
            top: 120,
            left: -120,
            child: _DecorOrb(
              color: Colors.black.withValues(alpha: isDark ? 0.42 : 0.28),
              size: 360,
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 22),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: 8),
                        //Text('FUNDEX', style: authTheme.brandLabelStyle),
                        const SizedBox(height: 120),
                        //icon or image
                        //_HeroMediaCard(imageUrl: imageUrl),
                        const Center(child: _HeroLogoCard()),

                        const SizedBox(height: 80),
                        Text(
                          headline,
                          style:
                              (theme.textTheme.headlineMedium ??
                                      const TextStyle())
                                  .copyWith(
                                    color: theme.colorScheme.onPrimary,
                                    fontWeight: FontWeight.w800,
                                    height: 1.12,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          description,
                          style:
                              (theme.textTheme.bodyLarge ?? const TextStyle())
                                  .copyWith(
                                    color: theme.colorScheme.onPrimary
                                        .withValues(alpha: 0.92),
                                    height: 1.35,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),
                        Container(
                          decoration: BoxDecoration(
                            color: panelColor,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: isDark ? 0.2 : 0.1,
                                ),
                                blurRadius: 26,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ...primaryActions,
                              if (footer != null) ...<Widget>[
                                const SizedBox(height: UiTokens.spacing8),
                                footer!,
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroLogoCard extends StatelessWidget {
  const _HeroLogoCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.12),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Image.asset(
        _heroBrandLockupAssetPath,
        width: 220,
        fit: BoxFit.contain,
      ),
    );
  }
}

// ignore: unused_element
class _HeroMediaCard extends StatelessWidget {
  const _HeroMediaCard({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AspectRatio(
      aspectRatio: 0.84,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Colors.black.withValues(alpha: isDark ? 0.42 : 0.24),
                      theme.colorScheme.surface.withValues(alpha: 0.06),
                      theme.colorScheme.surface.withValues(alpha: 0.14),
                    ],
                  ),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            theme.colorScheme.surface.withValues(alpha: 0.16),
                            theme.colorScheme.surface.withValues(alpha: 0.06),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.hotel_class_rounded,
                          size: 84,
                          color: theme.colorScheme.onPrimary.withValues(
                            alpha: 0.86,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: -20,
            right: -14,
            child: _DecorOrb(
              color: theme.colorScheme.surface.withValues(alpha: 0.18),
              size: 160,
            ),
          ),
          Positioned(
            bottom: -30,
            left: -18,
            child: _DecorOrb(
              color: Colors.black.withValues(alpha: isDark ? 0.32 : 0.22),
              size: 210,
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorOrb extends StatelessWidget {
  const _DecorOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
