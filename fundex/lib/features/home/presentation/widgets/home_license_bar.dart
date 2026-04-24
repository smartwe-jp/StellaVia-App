import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class HomeLicenseBar extends StatelessWidget {
  const HomeLicenseBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return DecoratedBox(
      decoration: BoxDecoration(color: colors.highlightGold),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 72,
        child: Text(
          context.l10n.myPageLicenseNotice,
          textAlign: TextAlign.center,
          style: appText.meta.copyWith(
            color: colors.brandPrimaryDark,
            height: 1.45,
          ),
        ),
      ),
    );
  }
}
