import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';

class HomeMilesCard extends StatelessWidget {
  const HomeMilesCard({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => AppCard(
    onTap: onTap,
    child: Row(
      children: [
        Icon(
          Icons.card_giftcard_outlined,
          color: context.appColors.primary,
          size: 22,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.homeHostMiles,
                style: context.appTextTheme.caption,
              ),
              const SizedBox(height: 4),
              Semantics(
                label: context.l10n.homeMilesUnavailable,
                child: ExcludeSemantics(
                  child: Text('—', style: context.appTextTheme.numericTitle),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            context.l10n.homeBookWithMiles,
            style: context.appTextTheme.link.copyWith(fontSize: 11),
          ),
        ),
        Icon(Icons.chevron_right, size: 16, color: context.appColors.primary),
      ],
    ),
  );
}
