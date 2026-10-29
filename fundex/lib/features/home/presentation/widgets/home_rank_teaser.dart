import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../support/home_design_theme.dart';

class HomeRankTeaser extends StatelessWidget {
  const HomeRankTeaser({super.key, required this.onTap});
  final VoidCallback onTap;
  // Proper names from the design; these cards illustrate tiers, not user status.
  static const _names = ['REGULAR', 'BRONZE', 'SILVER', 'GOLD', 'MASTER'];
  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.homeRankEyebrow,
          style: context.appTextTheme.link.copyWith(fontSize: 13),
        ),
        const SizedBox(height: 2),
        Text(
          context.l10n.homeRankTitle,
          style: context.appTextTheme.bodyStrong.copyWith(fontSize: 15),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 99,
          child: LayoutBuilder(
            builder: (context, constraints) => ClipRect(
              child: Stack(
                children: [
                  for (var i = 0; i < _names.length; i++)
                    Positioned(
                      left: i * constraints.maxWidth * .15,
                      top: 0,
                      width: 280,
                      height: 99,
                      child: ExcludeSemantics(
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: HomeDesignTheme.rankSurfaces[i],
                            borderRadius: BorderRadius.circular(11.2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                height: 56,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                color: HomeDesignTheme.rankHeaders[i],
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'RANK 0${i + 1}',
                                      style: context.appTextTheme.numericCaption
                                          .copyWith(
                                            fontSize: 8,
                                            letterSpacing: 1.2,
                                            color: i == 0
                                                ? HomeDesignTheme.rankInk
                                                : HomeDesignTheme.rankOnDark,
                                          ),
                                    ),
                                    Text(
                                      _names[i],
                                      style: context.appTextTheme.numericBody
                                          .copyWith(
                                            fontSize: 14,
                                            color: i == 0
                                                ? HomeDesignTheme.rankInk
                                                : HomeDesignTheme.rankOnDark,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    right: 3,
                    bottom: 0,
                    child: AppButton(
                      label: context.l10n.homeRankDetails,
                      onPressed: onTap,
                      variant: AppButtonVariant.secondary,
                      fullWidth: false,
                      minHeight: 34,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: context.appColors.surface,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        textStyle: context.appTextTheme.micro,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
