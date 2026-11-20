import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../app/localization/app_localizations_ext.dart';

class VerificationEntryScaffold extends StatelessWidget {
  const VerificationEntryScaffold({
    super.key,
    required this.child,
    this.resultPage = false,
  });
  final Widget child;
  final bool resultPage;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: resultPage ? Theme.of(context).appColors.surface : null,
    appBar: resultPage
        ? AppNavigationBar(
            title: '',
            height: 52,
            showDivider: false,
            horizontalPadding: 12,
            backgroundColor: Theme.of(context).appColors.surface,
            leading: TextButton.icon(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(CupertinoIcons.chevron_back, size: 16),
              label: Text(context.l10n.menuItemEditProfile),
            ),
          )
        : AppNavigationBar(
            title: context.l10n.menuItemEditProfile,
            leading: AppNavigationIconButton(
              icon: Icons.arrow_back_rounded,
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ),
    body: SafeArea(child: child),
  );
}
