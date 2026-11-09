import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class HomeLicenseBar extends StatelessWidget {
  const HomeLicenseBar({super.key, required this.linkArea});

  final Widget linkArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return DecoratedBox(
      decoration: BoxDecoration(color: colors.heroStart),
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 26),
        alignment: Alignment.center,
        width: double.infinity,
        //height: 72,
        child: Column(
          spacing: 6,
          children: [
            linkArea,
            Text(
              context.l10n.myPageLicenseNotice,
              textAlign: TextAlign.center,
              style: appText.meta.copyWith(color: colors.onDark, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}
