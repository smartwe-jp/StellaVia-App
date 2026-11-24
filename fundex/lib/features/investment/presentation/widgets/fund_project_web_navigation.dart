import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class FundProjectWebNavigation extends StatelessWidget
    implements PreferredSizeWidget {
  const FundProjectWebNavigation({
    super.key,
    required this.visible,
    required this.isFavorite,
    required this.onBack,
    required this.onFavorite,
    this.onShare,
  });

  final bool visible;
  final bool isFavorite;
  final VoidCallback onBack;
  final VoidCallback onFavorite;
  final VoidCallback? onShare;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return IgnorePointer(
      ignoring: !visible,
      child: ExcludeSemantics(
        excluding: !visible,
        child: AnimatedSlide(
          offset: visible ? Offset.zero : const Offset(0, -1),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedOpacity(
            opacity: visible ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: AppBar(
              forceMaterialTransparency: true,
              elevation: 0,
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              systemOverlayStyle:
                  AppThemeFactory.statusBarOverlayStyleFor(
                    Brightness.light,
                  ).copyWith(
                    statusBarColor: colors.surface.withValues(alpha: 0),
                    systemStatusBarContrastEnforced: false,
                  ),
              titleSpacing: UiTokens.spacing12,
              title: IconButtonTheme(
                data: IconButtonThemeData(
                  style: IconButton.styleFrom(
                    backgroundColor: colors.surfaceAlt.withValues(alpha: 0.92),
                    foregroundColor: colors.textPrimary,
                    disabledBackgroundColor: colors.surfaceAlt.withValues(
                      alpha: 0.92,
                    ),
                    minimumSize: const Size.square(44),
                    shape: const CircleBorder(),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: context.l10n.commonBack,
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: context.l10n.fundListFilterFavorites,
                      onPressed: onFavorite,
                      icon: Icon(
                        isFavorite
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                      ),
                    ),
                    const SizedBox(width: UiTokens.spacing8),
                    IconButton(
                      tooltip: context.l10n.fundDetailShareTooltip,
                      onPressed: onShare,
                      icon: const Icon(Icons.ios_share),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
