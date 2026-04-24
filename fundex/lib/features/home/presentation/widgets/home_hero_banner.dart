import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

const String _homeHeroBannerBaseUrl = 'https://stellavia.co.jp/img';
const int _homeHeroBannerImageCount = 3;

class HomeHeroBanner extends StatelessWidget {
  const HomeHeroBanner({
    super.key,
    required this.registerBonusTitle,
    required this.registerBonusBody,
    required this.registerLabel,
    required this.loginLabel,
    required this.showGuestActions,
    this.showNotificationDot = false,
    this.onSettingsTap,
    this.onNotificationTap,
    this.onRegisterTap,
    this.onLoginTap,
  });

  final String registerBonusTitle;
  final String registerBonusBody;
  final String registerLabel;
  final String loginLabel;
  final bool showGuestActions;
  final bool showNotificationDot;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onRegisterTap;
  final VoidCallback? onLoginTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    const arcLift = 12.0;
    const arcDepth = 12.0;

    return ClipPath(
      clipper: showGuestActions ? const _HomeHeroBannerArcClipper(
        edgeLift: arcLift,
        arcDepth: arcDepth,
      ):null,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'StellaVia',
                        style: theme.appTextTheme.pageTitle.copyWith(
                          color: colors.onDark,
                          fontSize: 20,
                        ),
                      ),
                    ),
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
                        showDot: showNotificationDot,
                        onTap: onNotificationTap,
                      ),
                  ],
                ),
              ),
              const _HomeHeroVisual(),
              if (showGuestActions)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 52,
                        child: _HomeHeroRegisterBonusCard(
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
                )
            ],
          ),
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
    required this.showDot,
    required this.onTap,
  });

  final bool showDot;
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
              borderRadius: 12,
              backgroundColor: colors.onDark.withValues(alpha: 0.08),
              onTap: onTap,
            ),
          ),
          if (showDot)
            Positioned(
              right: 7,
              top: 7,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: colors.danger,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.heroStart, width: 1.5),
                ),
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
        aspectRatio: 11 / 5,
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
    (index) => '$_homeHeroBannerBaseUrl/banner.${index + 1}.$localeSuffix.jpg',
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

class _HomeHeroRegisterBonusCard extends StatelessWidget {
  const _HomeHeroRegisterBonusCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: colors.heroMiddle.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(UiTokens.radius8),
        border: Border.all(
          color: colors.highlightGold.withValues(alpha: 0.7),
          width: 1.25,
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colors.brandSecondary.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.card_giftcard_rounded,
              size: 20,
              color: colors.highlightGold,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: appText.bodyStrong.copyWith(
                  color: colors.onDark,
                  height: 1.35,
                ),
              ),
              Text(
                body,
                style: appText.bodyStrong.copyWith(
                  color: colors.highlightGold,
                  height: 1.35,
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
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

    final backgroundColor = isPrimary
        ? colors.highlightGold
        : Colors.transparent;
    final foregroundColor = isPrimary ? colors.onDark : colors.highlightGold;
    final borderColor = colors.highlightGold;

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
