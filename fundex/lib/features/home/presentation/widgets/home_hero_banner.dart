import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import 'home_register_bonus_campaign_bar.dart';

const String _homeHeroBannerBaseUrl = 'https://stellavia.co.jp/img';
const int _homeHeroBannerImageCount = 4;
final String _homeHeroBannerCacheVersion = DateTime.now().millisecondsSinceEpoch
    .toString();

class HomeHeroBanner extends StatelessWidget {
  const HomeHeroBanner({
    super.key,
    required this.registerBonusTitle,
    required this.registerBonusBody,
    required this.registerLabel,
    required this.loginLabel,
    required this.showGuestActions,
    required this.onNotificationTap,
    required this.notificationUnreadCount,
    required this.onSettingsTap,
    this.onRegisterTap,
    this.onLoginTap,
  });

  final String registerBonusTitle;
  final String registerBonusBody;
  final String registerLabel;
  final String loginLabel;
  final bool showGuestActions;
  final int notificationUnreadCount;
  final VoidCallback? onRegisterTap;
  final VoidCallback? onLoginTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSettingsTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    const arcLift = 12.0;
    const arcDepth = 12.0;

    return ClipPath(
      clipper: showGuestActions
          ? const _HomeHeroBannerArcClipper(
              edgeLift: arcLift,
              arcDepth: arcDepth,
            )
          : null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[colors.heroStart, colors.heroMiddle],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: showGuestActions ? 6.0 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const _HomeHeroVisual(),
                  Positioned(
                    top: 55,
                    right: 25,
                    child: showGuestActions
                        ? AppNavigationIconButton(
                            icon: Icons.menu_rounded,
                            size: 40,
                            borderRadius: 12,
                            backgroundColor: colors.onDark.withValues(
                              alpha: 0.08,
                            ),
                            onTap: onSettingsTap,
                          )
                        : _HomeHeroNotificationButton(
                            unreadCount: notificationUnreadCount,
                            onTap: onNotificationTap,
                          ),
                  ),
                ],
              ),
              if (showGuestActions)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 92,
                        child: HomeRegisterBonusCampaignBar(
                          title: registerBonusTitle,
                          body: registerBonusBody,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 52,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: _HomeHeroActionButton(
                                label: registerLabel,
                                onTap: onRegisterTap,
                                isPrimary: true,
                              ),
                            ),
                            const SizedBox(width: UiTokens.spacing12),
                            Expanded(
                              child: _HomeHeroActionButton(
                                label: loginLabel,
                                onTap: onLoginTap,
                                isPrimary: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeHeroTopBar extends StatelessWidget {
  const HomeHeroTopBar({
    super.key,
    required this.showGuestActions,
    this.notificationUnreadCount = 0,
    this.onSettingsTap,
    this.onNotificationTap,
  });

  final bool showGuestActions;
  final int notificationUnreadCount;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[colors.heroStart, colors.heroMiddle],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
        child: Row(
          children: <Widget>[
            const Image(
              image: AssetImage('assets/images/stellavia.nav.logo.png'),
              height: 34,
            ),
            const Spacer(),
            if (showGuestActions)
              AppNavigationIconButton(
                icon: Icons.menu_rounded,
                size: 40,
                borderRadius: 12,
                backgroundColor: colors.onDark.withValues(alpha: 0.08),
                onTap: onSettingsTap,
              )
            else
              _HomeHeroNotificationButton(
                unreadCount: notificationUnreadCount,
                onTap: onNotificationTap,
              ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeroBannerArcClipper extends CustomClipper<Path> {
  const _HomeHeroBannerArcClipper({
    required this.edgeLift,
    required this.arcDepth,
  });

  final double edgeLift;
  final double arcDepth;

  @override
  Path getClip(Size size) {
    final shoulderY = size.height - edgeLift - 20;
    final centerY = shoulderY + arcDepth + 16;

    final leftCornerY = shoulderY + 20;
    final rightCornerY = shoulderY + 20;

    final centerX = size.width * 0.5;
    final midLeftX = size.width * 0.32;
    final midRightX = size.width * 0.68;

    return Path()
      ..moveTo(0, 0)
      ..lineTo(0, shoulderY)
      ..cubicTo(0, leftCornerY, midLeftX, centerY, centerX, centerY)
      ..cubicTo(
        midRightX,
        centerY,
        size.width,
        rightCornerY,
        size.width,
        shoulderY,
      )
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant _HomeHeroBannerArcClipper oldClipper) {
    return oldClipper.edgeLift != edgeLift || oldClipper.arcDepth != arcDepth;
  }
}

class _HomeHeroNotificationButton extends StatelessWidget {
  const _HomeHeroNotificationButton({
    required this.unreadCount,
    required this.onTap,
  });

  final int unreadCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned.fill(
            child: AppNavigationIconButton(
              icon: Icons.notifications_none_rounded,
              size: 40,
              borderRadius: 999,
              backgroundColor: colors.onDark.withValues(alpha: 0.18),
              onTap: onTap,
            ),
          ),
          if (unreadCount > 0)
            Positioned(
              left: 24,
              top: 3,
              child: AppNotificationCountBadge(
                count: unreadCount,
                borderColor: colors.heroStart,
              ),
            ),
        ],
      ),
    );
  }
}

class _HomeHeroVisual extends StatelessWidget {
  const _HomeHeroVisual();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final imageUrls = _resolveHomeHeroImageUrls(
      Localizations.localeOf(context),
    );

    return Container(
      decoration: BoxDecoration(color: colors.background),
      child: AspectRatio(
        aspectRatio: 782 / 500,
        child: FundHeroMediaBackground(
          gradientColors: <Color>[colors.heroMiddle, colors.primaryAlt],
          imageUrls: imageUrls,
          showArtworkOverlay: false,
          autoPlay: imageUrls.length > 1,
          autoPlayInterval: const Duration(seconds: 25),
        ),
      ),
    );
  }
}

List<String> _resolveHomeHeroImageUrls(Locale locale) {
  final localeSuffix = _resolveHomeHeroLocaleSuffix(locale);
  return List<String>.generate(
    _homeHeroBannerImageCount,
    (index) =>
        '$_homeHeroBannerBaseUrl/newbanner.${index + 1}.$localeSuffix.jpg'
        '?v=$_homeHeroBannerCacheVersion',
    growable: false,
  );
}

String _resolveHomeHeroLocaleSuffix(Locale locale) {
  final languageCode = locale.languageCode.toLowerCase();
  if (languageCode == 'ja') {
    return 'ja';
  }
  if (languageCode == 'zh') {
    final scriptCode = locale.scriptCode?.toLowerCase();
    return scriptCode == 'hant' ? 'zh-hant' : 'zh-hans';
  }
  return 'en';
}

class _HomeHeroActionButton extends StatelessWidget {
  const _HomeHeroActionButton({
    required this.label,
    required this.isPrimary,
    this.onTap,
  });

  final String label;
  final bool isPrimary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    final backgroundColor = isPrimary ? colors.primary : colors.surface;
    final foregroundColor = isPrimary ? colors.onDark : colors.infoForeground;
    final borderColor = colors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(UiTokens.radius8),
        child: Ink(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(UiTokens.radius8),
            border: Border.all(color: borderColor, width: 1.4),
          ),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                label,
                style: appText.button.copyWith(color: foregroundColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
