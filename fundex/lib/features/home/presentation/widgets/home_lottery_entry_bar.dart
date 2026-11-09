import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class HomeLotteryEntryBar extends StatelessWidget {
  const HomeLotteryEntryBar({
    super.key,
    required this.title,
    required this.body,
    required this.actionLabel,
    this.onTap,
  });

  static const String prizeWheelAssetPath = 'assets/images/prize_wheel.png';

  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final borderRadius = BorderRadius.circular(UiTokens.radius16);

    return Semantics(
      container: true,
      button: onTap != null,
      child: Material(
        color: colors.heroStart,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[colors.heroMiddle, colors.heroStart],
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: colors.scrim.withValues(alpha: 0.16),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: InkWell(
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 112),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  UiTokens.spacing16,
                  UiTokens.spacing12,
                  UiTokens.spacing8,
                  UiTokens.spacing12,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: appText.cardTitle.copyWith(
                              color: colors.onDark,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: UiTokens.spacing8),
                          Text(
                            body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: appText.micro.copyWith(
                              color: colors.onDark.withValues(alpha: 0.78),
                            ),
                          ),
                          const SizedBox(height: UiTokens.spacing12),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                UiTokens.radius20,
                              ),
                              border: Border.all(
                                color: colors.infoForeground,
                                width: 1.5,
                              ),
                              color: colors.primaryAlt.withValues(
                                alpha: 0.08,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: UiTokens.spacing16,
                                vertical: UiTokens.spacing8,
                              ),
                              child: Text(
                                actionLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: appText.chip.copyWith(
                                  color: colors.infoForeground,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: UiTokens.spacing8),
                    Image.asset(
                      prizeWheelAssetPath,
                      key: const Key('home_lottery_prize_wheel'),
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
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
