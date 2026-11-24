import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../support/corporate_flow_navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/corporate_form_draft.dart';
import '../providers/corporate_draft_providers.dart';

import '../../../../app/localization/app_localizations_ext.dart';

enum CorporateExitPrompt { draft, submitted }

class CorporateFlowScaffold extends ConsumerStatefulWidget {
  const CorporateFlowScaffold({
    super.key,
    required this.title,
    required this.child,
    this.step,
    this.exitPrompt,
    this.draft,
    this.exitSnapshot,
    this.onReviewBack,
    this.locked = false,
    this.refresh,
  });
  final VoidCallback? onReviewBack;
  final CorporateFormDraft? draft;
  final CorporateFormDraft Function()? exitSnapshot;
  final String title;
  final Widget child;
  final int? step;
  final CorporateExitPrompt? exitPrompt;
  final bool locked;
  final VoidCallback? refresh;

  @override
  ConsumerState<CorporateFlowScaffold> createState() =>
      _CorporateFlowScaffoldState();
}

class _CorporateFlowScaffoldState extends ConsumerState<CorporateFlowScaffold> {
  bool saving = false;

  Future<void> confirmExit(BuildContext context) async {
    if (widget.exitPrompt == null) {
      leaveCorporateFlow(context);
      return;
    }
    final l = context.l10n;
    final exit = await AppDialogs.showAdaptiveAlert<bool>(
      context: context,
      title: l.corpExitTitle,
      message: widget.draft?.localAccountKey != null
          ? l.corpDraftExitSave
          : widget.exitPrompt == CorporateExitPrompt.submitted
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
    if (widget.draft?.localAccountKey != null) {
      setState(() => saving = true);
      try {
        final snapshot = widget.exitSnapshot?.call() ?? widget.draft!;
        await ref.read(corporateDraftStoreProvider).save(snapshot);
      } catch (_) {
        if (context.mounted) {
          setState(() => saving = false);
          AppNotice.show(context, message: l.corpDraftSaveFailed);
        }
        return;
      }
      if (!context.mounted) return;
    }
    leaveCorporateFlow(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final index = widget.step;
    final title = widget.title;
    final reviewBack = widget.onReviewBack;
    if (reviewBack != null) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop && !widget.locked) reviewBack();
        },
        child: Scaffold(
          backgroundColor: theme.appColors.surface,
          appBar: AppBar(
            title: Text(title),
            leading: IconButton(
              icon: const BackButtonIcon(),
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: widget.locked ? null : reviewBack,
            ),
          ),
          body: SafeArea(top: false, child: widget.child),
        ),
      );
    }
    return PopScope(
      canPop: !saving,
      child: AbsorbPointer(
        absorbing: saving,
        child: Scaffold(
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
                          if (widget.refresh != null)
                            IconButton(
                              tooltip: context.l10n.corporateRefresh,
                              onPressed: widget.refresh,
                              color: theme.colorScheme.primary,
                              icon: const Icon(
                                CupertinoIcons.refresh,
                                size: 20,
                              ),
                              constraints: const BoxConstraints.tightFor(
                                width: 44,
                                height: 44,
                              ),
                            ),
                          IconButton(
                            tooltip: context.l10n.commonClose,
                            onPressed: widget.locked
                                ? null
                                : () => confirmExit(context),
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
                Expanded(child: widget.child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
