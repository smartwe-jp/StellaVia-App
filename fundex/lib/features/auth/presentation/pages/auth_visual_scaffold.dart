import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

const String _authBrandLockupAssetPath =
    'assets/images/stellavia.logoAndText.light.png';

class AuthVisualScaffold extends StatelessWidget {
  const AuthVisualScaffold({
    super.key,
    required this.pageKey,
    required this.title,
    required this.subtitle,
    required this.child,
    this.footer,
  });

  final Key pageKey;
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final authVisualTheme = theme.extension<AppAuthVisualTheme>();
    final travelTheme = theme.extension<AppFTKTheme>();

    assert(
      authVisualTheme != null,
      'AppAuthVisualTheme must be configured in theme',
    );
    assert(travelTheme != null, 'AppFTKTheme must be configured in theme');

    final authTheme = authVisualTheme!;
    final hotelTheme = travelTheme!;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      key: pageKey,
      body: Stack(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  theme.scaffoldBackgroundColor,
                  theme.colorScheme.surface.withValues(
                    alpha: isDark ? 0.84 : 0.98,
                  ),
                  hotelTheme.primaryButtonColor.withValues(
                    alpha: isDark ? 0.05 : 0.08,
                  ),
                ],
              ),
            ),
            child: const SizedBox.expand(),
          ),
          _AmbientOrb(
            alignment: const Alignment(-1.15, -0.9),
            color: hotelTheme.primaryButtonColor.withValues(
              alpha: isDark ? 0.14 : 0.16,
            ),
            radius: 240,
          ),
          _AmbientOrb(
            alignment: const Alignment(1.1, -0.65),
            color: hotelTheme.discountChipBackgroundColor.withValues(
              alpha: isDark ? 0.10 : 0.12,
            ),
            radius: 220,
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset(
                              _authBrandLockupAssetPath,
                              width: 148,
                              fit: BoxFit.contain,
                            ),
                            const Spacer(),
                            PillChip(
                              backgroundColor: hotelTheme.primaryButtonColor
                                  .withValues(alpha: isDark ? 0.18 : 0.12),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              child: Text(
                                'Member',
                                style:
                                    (textTheme.labelMedium ?? const TextStyle())
                                        .copyWith(
                                          color: hotelTheme.primaryButtonColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // const SizedBox(
                        //   height: 182,
                        //   child: Stack(
                        //     clipBehavior: Clip.none,
                        //     children: <Widget>[
                        //       Positioned.fill(
                        //         child: DealBannerCard(
                        //           title: 'BaLi Motel Vung Tau',
                        //           location: 'Indonesia',
                        //           priceText: '\$580/night',
                        //           ratingText: '4.9',
                        //           discountText: 'Member',
                        //           height: 182,
                        //         ),
                        //       ),
                        //       Positioned(
                        //         right: 12,
                        //         bottom: -16,
                        //         child: PhotoCountBadge(
                        //           label: 'Hotel Style',
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface.withValues(
                              alpha: isDark ? 0.92 : 0.98,
                            ),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: isDark ? 0.22 : 0.08,
                                ),
                                blurRadius: 28,
                                offset: const Offset(0, 14),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                title,
                                style: textTheme.displaySmall?.copyWith(
                                  fontSize: 30,
                                  height: 1.08,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(subtitle, style: authTheme.subtitleStyle),
                              const SizedBox(height: 18),
                              child,
                              if (footer != null) ...<Widget>[
                                const SizedBox(height: 14),
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

class _AmbientOrb extends StatelessWidget {
  const _AmbientOrb({
    required this.alignment,
    required this.color,
    required this.radius,
  });

  final Alignment alignment;
  final Color color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: radius,
          height: radius,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: <Color>[color, color.withValues(alpha: 0)],
            ),
          ),
        ),
      ),
    );
  }
}
