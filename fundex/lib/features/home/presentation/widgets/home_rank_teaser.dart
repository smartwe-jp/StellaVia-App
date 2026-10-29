import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../support/home_design_theme.dart';
import 'home_data_status.dart';
import '../support/home_text_styles.dart';

class HomeRankTeaser extends StatelessWidget {
  const HomeRankTeaser({
    super.key,
    required this.onTap,
    this.names = const ['REGULAR', 'BRONZE', 'SILVER', 'GOLD', 'MASTER'],
    this.isLoading = false,
    this.hasError = false,
    this.onRetry,
  });
  final List<String> names;
  final bool isLoading;
  final bool hasError;
  final VoidCallback? onRetry;
  final VoidCallback onTap;
  // Public tier catalog, not the signed-in user's tier.
  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.homeRankEyebrow,
          style: HomeTextStyles.sectionLink(context),
        ),
        const SizedBox(height: 2),
        Text(
          context.l10n.homeRankTitle,
          style: HomeTextStyles.entryTitle(context),
        ),
        HomeDataStatus(
          isLoading: isLoading,
          hasError: hasError,
          onRetry: onRetry,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 99,
          child: LayoutBuilder(
            builder: (context, constraints) => ClipRect(
              child: Stack(
                children: [
                  for (var i = 0; i < names.length; i++)
                    Positioned(
                      left:
                          i *
                          constraints.maxWidth *
                          (names.length <= 1 ? 0 : .6 / (names.length - 1)),
                      top: 0,
                      width: 280,
                      height: 99,
                      child: ExcludeSemantics(
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color:
                                HomeDesignTheme.rankSurfaces[i %
                                    HomeDesignTheme.rankSurfaces.length],
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
                                color:
                                    HomeDesignTheme.rankHeaders[i %
                                        HomeDesignTheme.rankHeaders.length],
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'RANK ${(i + 1).toString().padLeft(2, '0')}',
                                      style:
                                          HomeTextStyles.rankPreviewEyebrow(
                                            context,
                                          ).copyWith(
                                            color: i == 0
                                                ? HomeDesignTheme.rankInk
                                                : HomeDesignTheme.rankOnDark,
                                          ),
                                    ),
                                    Text(
                                      names[i],
                                      style:
                                          HomeTextStyles.rankPreviewName(
                                            context,
                                          ).copyWith(
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
