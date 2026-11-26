import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_locale_providers.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/widgets/stellavia_wordmark.dart';

class GuestWelcomeHeader extends ConsumerWidget {
  const GuestWelcomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final white = context.appColors.onDark;
    final locale = Localizations.localeOf(context);
    final language = AppLanguage.fromLanguageCode(
      resolveApiLanguageTagForLocale(locale),
    );
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: StellaviaWordmark(color: white),
            ),
          ),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: white,
            backgroundColor: white.withValues(alpha: 0),
            side: BorderSide(color: white),
            minimumSize: const Size(67, 30),
            textStyle: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            shape: const StadiumBorder(),
          ),
          onPressed: () => context.push('/login'),
          child: Text(l.loginSubmit),
        ),
        const SizedBox(width: 16),
        PopupMenuButton<AppLanguage>(
          tooltip: l.menuItemLanguage,
          onSelected: (value) =>
              ref.read(appLanguageProvider.notifier).setLanguage(value),
          itemBuilder: (_) => AppLanguage.values
              .map(
                (v) => PopupMenuItem(
                  value: v,
                  child: Text(
                    v == AppLanguage.system
                        ? l.languageFollowSystem
                        : v.nativeLabel,
                  ),
                ),
              )
              .toList(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Text(language.nativeLabel, style: TextStyle(color: white)),
          ),
        ),
      ],
    );
  }
}
