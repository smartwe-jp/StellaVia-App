import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class GuestWelcomeHero extends StatelessWidget {
  const GuestWelcomeHero({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.appColors;
    final type = Theme.of(context).textTheme;
    final white = colors.onDark;
    const purple = AppColorTokens.brandPurple;
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (l.guestWelcomeReading.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 6),
                  child: Text(
                    l.guestWelcomeReading,
                    style: type.titleSmall?.copyWith(
                      color: white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                ),
              Text(
                l.homeGuestBenefitsTitle,
                style: type.displayLarge?.copyWith(
                  color: white,
                  fontSize: 70,
                  height: 1.12,
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
          decoration: BoxDecoration(
            color: purple,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            l.homeGuestBenefitsBody,
            textAlign: TextAlign.center,
            style: type.titleMedium?.copyWith(
              color: white,
              fontSize: 19,
              height: 1.3,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 9),
        Text(
          l.guestWelcomeDisclaimer,
          textAlign: TextAlign.center,
          style: type.bodySmall?.copyWith(color: white, fontSize: 11),
        ),
        const SizedBox(height: 42),
        FilledButton(
          onPressed: () => context.push('/guest-guide/register'),
          style: FilledButton.styleFrom(
            backgroundColor: white,
            foregroundColor: purple,
            minimumSize: const Size(238, 56),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            shape: const StadiumBorder(),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  l.homeRegisterFree,
                  textAlign: TextAlign.center,
                  style: type.titleMedium?.copyWith(
                    color: purple,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              DecoratedBox(
                decoration: const BoxDecoration(
                  color: purple,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.arrow_forward, size: 16, color: white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        TextButton(
          onPressed: () => context.push('/guest-guide/discover'),
          style: TextButton.styleFrom(foregroundColor: white),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  l.guestGuideLearn,
                  textAlign: TextAlign.center,
                  style: type.titleMedium?.copyWith(
                    color: white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.chevron_right, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}
