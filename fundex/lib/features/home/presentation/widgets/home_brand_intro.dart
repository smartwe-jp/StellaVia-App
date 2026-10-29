import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../support/home_design_theme.dart';

class HomeBrandIntro extends StatelessWidget {
  const HomeBrandIntro({
    super.key,
    required this.isAuthenticated,
    required this.onServiceTap,
    this.displayName = '',
  });
  final bool isAuthenticated;
  final String displayName;
  final VoidCallback onServiceTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final text = context.appTextTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isAuthenticated) ...[
          Text(
            l10n.homeMemberGreeting(displayName),
            style: text.sectionTitle.copyWith(fontSize: 19),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.homeMemberIntro,
            style: text.caption.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 16),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              Positioned.fill(
                child: isAuthenticated
                    ? Image.asset(
                        'assets/images/home_member_hero.png',
                        fit: BoxFit.cover,
                      )
                    : const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: HomeDesignTheme.guestGradient,
                          ),
                        ),
                      ),
              ),
              if (isAuthenticated)
                Positioned.fill(
                  child: ColoredBox(color: colors.scrim.withValues(alpha: .42)),
                ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: double.infinity,
                  minHeight: isAuthenticated ? 166 : 112,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAuthenticated
                            ? l10n.homeMemberEyebrow
                            : l10n.homeGuestEyebrow,
                        style: text.numericCaption.copyWith(
                          color: colors.onDark,
                          fontSize: 10,
                          letterSpacing: isAuthenticated ? 0 : 3,
                        ),
                      ),
                      SizedBox(height: isAuthenticated ? 18 : 4),
                      Text(
                        isAuthenticated
                            ? l10n.homeMemberHeroTitle
                            : l10n.homeGuestBenefitsTitle,
                        style: text.sectionTitle.copyWith(
                          color: colors.onDark,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (isAuthenticated)
                        Text(
                          l10n.homeMemberHeroBody,
                          style: text.caption.copyWith(
                            color: colors.onDark,
                            fontSize: 12,
                          ),
                        )
                      else
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 4,
                            runSpacing: 4,
                            children: [
                              Text(
                                l10n.homeGuestBenefitsBody,
                                style: text.caption.copyWith(
                                  color: colors.onDark,
                                  fontSize: 12,
                                ),
                              ),
                              AppButton(
                                fullWidth: false,
                                minHeight: 24,
                                variant: AppButtonVariant.secondary,
                                onPressed: onServiceTap,
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: colors.surface,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  textStyle: text.micro.copyWith(fontSize: 11),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(l10n.homeLearnService),
                                    const SizedBox(width: 4),
                                    Image.asset(
                                      'assets/images/home_service_arrow.png',
                                      width: 6,
                                      height: 10,
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
            ],
          ),
        ),
      ],
    );
  }
}
