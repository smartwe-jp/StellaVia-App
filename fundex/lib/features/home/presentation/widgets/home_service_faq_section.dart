import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';

class HomeServiceFaqSection extends StatefulWidget {
  const HomeServiceFaqSection({super.key});
  @override
  State<HomeServiceFaqSection> createState() => _HomeServiceFaqSectionState();
}

class _HomeServiceFaqSectionState extends State<HomeServiceFaqSection> {
  int? open = 0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.appColors;
    final t = context.appTextTheme;
    final questions = [
      (l.featuresFaq1Q, l.featuresFaq1A),
      (l.featuresFaq2Q, l.featuresFaq2A),
      (l.featuresFaq3Q, l.featuresFaq3A),
      (l.featuresFaq4Q, l.featuresFaq4A),
      (l.featuresFaq5Q, l.featuresFaq5A),
    ];
    return Container(
      color: c.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 64),
      child: Column(
        children: [
          AppBrandHeading(
            eyebrow: l.featuresFaqEyebrow,
            title: l.featuresFaqTitle,
          ),
          const SizedBox(height: 24),
          for (final (i, item) in questions.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: c.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: c.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Semantics(
                      expanded: open == i,
                      button: true,
                      child: InkWell(
                        onTap: () =>
                            setState(() => open = open == i ? null : i),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 18,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(item.$1, style: t.bodyStrong),
                              ),
                              const SizedBox(width: 16),
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: AppColorTokens.brandPurple,
                                child: Icon(
                                  open == i ? Icons.remove : Icons.add,
                                  color: AppColorTokens.brandWhite,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 250),
                      alignment: Alignment.topCenter,
                      child: open == i
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(22, 0, 22, 18),
                              child: Text(
                                item.$2,
                                style: t.body.copyWith(
                                  height: 1.8,
                                  color: c.textSecondary,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          AppButton(
            label: l.featuresFaqCta,
            onPressed: () => context.push('/profile/settings/faq'),
          ),
        ],
      ),
    );
  }
}
