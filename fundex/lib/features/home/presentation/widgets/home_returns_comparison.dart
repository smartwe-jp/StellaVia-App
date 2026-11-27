import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class HomeReturnsComparison extends StatelessWidget {
  const HomeReturnsComparison({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    const future = _ReturnPanel(financial: true);
    const now = _ReturnPanel(financial: false);
    const connector = CircleAvatar(
      radius: 18,
      backgroundColor: AppColorTokens.brandWhite,
      child: Icon(Icons.close, size: 20, color: AppColorTokens.brandViolet),
    );
    return ColoredBox(
      color: context.appColors.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          children: [
            AppBrandHeading(
              eyebrow: l.homeServiceReturnsEyebrow,
              title: l.homeServiceReturnsTitle,
            ),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1144),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= 680) {
                    return const Stack(
                      alignment: Alignment.center,
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: future),
                              SizedBox(width: 20),
                              Expanded(child: now),
                            ],
                          ),
                        ),
                        connector,
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      future,
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: now,
                          ),
                          Transform.translate(
                            offset: const Offset(0, -10),
                            child: connector,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReturnPanel extends StatelessWidget {
  const _ReturnPanel({required this.financial});
  final bool financial;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final text = context.appTextTheme;
    final ink = financial
        ? AppColorTokens.brandWhite
        : AppColorTokens.brandNavy;
    final accent = financial
        ? AppColorTokens.brandViolet
        : AppColorTokens.brandPurple;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: financial
            ? AppColorTokens.brandNavy
            : AppColorTokens.brandBaseCream,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Text(
                      financial
                          ? l.homeServiceFutureEyebrow
                          : l.homeServiceNowEyebrow,
                      style: text.bodyStrong.copyWith(
                        color: AppColorTokens.brandWhite,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ),
                ),
              ),
              CircleAvatar(
                radius: 21,
                backgroundColor: accent,
                child: Icon(
                  financial ? Icons.trending_up : Icons.flight_outlined,
                  color: AppColorTokens.brandWhite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            financial
                ? l.homeServiceFinancialEyebrow
                : l.homeServiceExperienceEyebrow,
            style: AppTypographyTokens.numericStyle(
              size: 26,
              weight: FontWeight.w600,
              height: 1.12,
              color: financial ? ink : accent,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            financial ? l.featuresReturnsFutureH : l.featuresReturnsNowH,
            style: text.sectionTitle.copyWith(color: ink),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              width: 40,
              height: 2,
              child: ColoredBox(color: accent),
            ),
          ),
          Text(
            financial ? l.featuresReturnsFutureBody : l.featuresReturnsNowBody,
            style: text.body.copyWith(
              color: ink.withValues(alpha: .88),
              height: 1.8,
            ),
          ),
          if (financial) ...[
            const SizedBox(height: 16),
            Text(
              l.featuresReturnsFutureNote,
              style: text.caption.copyWith(
                color: ink.withValues(alpha: .72),
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
