import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../support/corporate_flow_navigation.dart';

import '../../../../app/localization/app_localizations_ext.dart';

enum CorporateExitPrompt { draft, submitted }

class CorporateFlowScaffold extends StatelessWidget {
  const CorporateFlowScaffold({
    super.key,
    required this.title,
    required this.child,
    this.step,
    this.exitPrompt,
    this.locked = false,
    this.refresh,
  });
  final String title;
  final Widget child;
  final int? step;
  final CorporateExitPrompt? exitPrompt;
  final bool locked;
  final VoidCallback? refresh;

  Future<void> confirmExit(BuildContext context) async {
    if (exitPrompt == null) {
      leaveCorporateFlow(context);
      return;
    }
    final l = context.l10n;
    final exit = await AppDialogs.showAdaptiveAlert<bool>(
      context: context,
      title: l.corpExitTitle,
      message: exitPrompt == CorporateExitPrompt.submitted
          ? l.corpExitSaved
          : l.corpExitDraft,
      actions: [
        AppDialogAction(
          label: l.corpExitStay,
          value: false,
          isDefaultAction: true,
        ),
        AppDialogAction(label: l.commonClose, value: true),
      ],
    );
    if (exit != true || !context.mounted) return;
    leaveCorporateFlow(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final index = step;
    return Scaffold(
      backgroundColor: theme.appColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          index == null
                              ? title
                              : '${context.l10n.corpFormStep} ${index + 1} / 7 ・ $title',
                          style: index == null
                              ? theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                )
                              : theme.textTheme.labelLarge,
                        ),
                      ),
                      if (refresh != null)
                        IconButton(
                          tooltip: context.l10n.corporateRefresh,
                          onPressed: refresh,
                          color: theme.colorScheme.primary,
                          icon: const Icon(CupertinoIcons.refresh, size: 20),
                          constraints: const BoxConstraints.tightFor(
                            width: 44,
                            height: 44,
                          ),
                        ),
                      IconButton(
                        tooltip: context.l10n.commonClose,
                        onPressed: locked ? null : () => confirmExit(context),
                        icon: const Icon(CupertinoIcons.xmark, size: 18),
                        constraints: const BoxConstraints.tightFor(
                          width: 44,
                          height: 44,
                        ),
                      ),
                    ],
                  ),
                  if (index != null)
                    AppStepProgressBar(
                      stepCount: 7,
                      spacing: 6,
                      completedColor: theme.appColors.primaryAlt,
                      currentColor: theme.colorScheme.primary,
                      currentStep: index,
                      padding: const EdgeInsets.only(bottom: 12),
                    ),
                ],
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
