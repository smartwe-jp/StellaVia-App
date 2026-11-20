import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/corporate_form_draft.dart';
import '../providers/verification_entry_provider.dart';
import '../support/corporate_form_fields.dart';
import '../widgets/corporate_form_header.dart';
import '../widgets/corporate_review_section.dart';
import '../widgets/corporate_flow_scaffold.dart';
import 'corporate_success_page.dart';

class CorporateReviewPage extends ConsumerStatefulWidget {
  const CorporateReviewPage({super.key, required this.draft});
  final CorporateFormDraft draft;
  @override
  ConsumerState<CorporateReviewPage> createState() =>
      _CorporateReviewPageState();
}

class _CorporateReviewPageState extends ConsumerState<CorporateReviewPage> {
  bool antiSocial = false, mail = false, busy = false, unknown = false;
  String? error;

  void edit(CorporateSection section) {
    final route = corporateStepRoute(section);
    Navigator.of(
      context,
    ).popUntil((r) => r.settings.name == route || r.isFirst);
  }

  void returnToEntry({required bool accepted}) {
    ref.read(corporateSubmittedProvider.notifier).state = true;
    ref.invalidate(verificationEntryProvider);
    bool atEntry(Route<dynamic> route) =>
        route.isFirst ||
        !(route.settings.name ?? '').startsWith(corporateRoutePrefix);
    final nav = Navigator.of(context);
    if (accepted) {
      final name = widget.draft.value(
        CorporateSection.company,
        CorporateField.businessName,
      );
      nav.pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) => CorporateSuccessPage(companyName: name),
        ),
        atEntry,
      );
    } else {
      nav.popUntil(atEntry);
    }
  }

  Future<void> checkStatus() async {
    if (busy) return;
    setState(() => busy = true);
    try {
      final entry = await ref
          .read(verificationEntryRepositoryProvider)
          .load(afterSubmission: true);
      if (!mounted) return;
      if (entry.status != null &&
          entry.status!.isNotEmpty &&
          entry.status != 'DRAFT') {
        returnToEntry(accepted: false);
      } else {
        setState(() {
          busy = false;
          unknown = false;
          antiSocial = false;
          mail = false;
          error = context.l10n.corpReviewUnconfirmed;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          busy = false;
          error = context.l10n.uiErrorRequestFailed;
        });
      }
    }
  }

  Future<void> submit() async {
    if (busy || unknown || !antiSocial || !mail) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await ref
          .read(verificationEntryRepositoryProvider)
          .submit(widget.draft, antiSocial: antiSocial, mail: mail);
    } on StateError {
      if (mounted) {
        setState(() {
          busy = false;
          error = context.l10n.corpReviewFailed;
        });
      }
      return;
    } catch (_) {
      if (mounted) {
        setState(() {
          busy = false;
          unknown = true;
          error = context.l10n.corpReviewUnknown;
        });
      }
      return;
    }
    if (mounted) returnToEntry(accepted: true);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, locked = busy || unknown;
    return PopScope(
      canPop: !locked,
      child: CorporateFlowScaffold(
        exitPrompt: CorporateExitPrompt.draft,
        title: l.corpFormReviewTitle,
        step: 6,
        locked: locked,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            const CorporateFormHeader(
              section: CorporateSection.documents,
              review: true,
            ),
            const SizedBox(height: 16),
            for (final section in widget.draft.sections)
              CorporateReviewSection(
                draft: widget.draft,
                section: section,
                onEdit: locked ? null : () => edit(section),
              ),
            const SizedBox(height: 12),
            Text(
              l.corpReviewTerms,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            for (final first in [true, false])
              Card(
                child: CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: first ? antiSocial : mail,
                  onChanged: locked
                      ? null
                      : (v) => setState(() {
                          if (first) {
                            antiSocial = v == true;
                          } else {
                            mail = v == true;
                          }
                        }),
                  title: Text(first ? l.corpReviewAnti : l.corpReviewMail),
                  subtitle: Text(
                    first ? l.corpReviewAntiBody : l.corpReviewMailBody,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            if (error != null)
              Text(
                error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            if (busy) const LinearProgressIndicator(),
            AppButton(
              label: unknown ? l.corpReviewCheck : l.corpReviewSubmit,
              style: const ButtonStyle(
                shape: WidgetStatePropertyAll(StadiumBorder()),
              ),
              onPressed: unknown
                  ? (busy ? null : checkStatus)
                  : !busy && antiSocial && mail
                  ? submit
                  : null,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: l.corpReviewEdit,
              variant: AppButtonVariant.secondary,
              style: const ButtonStyle(
                shape: WidgetStatePropertyAll(StadiumBorder()),
              ),
              onPressed: locked ? null : () => edit(CorporateSection.company),
            ),
          ],
        ),
      ),
    );
  }
}
