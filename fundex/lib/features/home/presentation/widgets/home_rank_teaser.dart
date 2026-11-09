import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../host_miles/presentation/support/host_miles_rank_theme.dart';
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
                      child: _RankPreview(name: names[i]),
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

class _RankPreview extends StatelessWidget {
  const _RankPreview({required this.name});
  final String name;
  @override
  Widget build(BuildContext context) {
    final palette = HostMilesRankTheme.of(name);
    return ExcludeSemantics(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(11.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 56),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: palette.headerDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    palette.number == null ? 'RANK' : 'RANK ${palette.number}',
                    style: HomeTextStyles.rankPreviewEyebrow(
                      context,
                    ).copyWith(color: palette.headerInk.withValues(alpha: .75)),
                  ),
                  Text(
                    name,
                    style: HomeTextStyles.rankPreviewName(
                      context,
                    ).copyWith(color: palette.headerInk),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
