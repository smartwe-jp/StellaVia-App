import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/corporate_form_draft.dart';
import '../../domain/repositories/verification_entry_repository.dart';
import '../providers/verification_entry_provider.dart';
import '../providers/corporate_draft_providers.dart';
import '../support/corporate_form_fields.dart';
import 'corporate_form_page.dart';
import 'corporate_documents_page.dart';
import '../widgets/corporate_form_header.dart';
import '../widgets/corporate_review_section.dart';
import '../widgets/corporate_flow_scaffold.dart';
import 'corporate_success_page.dart';
import 'verification_entry_page.dart';
import '../support/corporate_flow_navigation.dart';

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
  bool? cleanupAccepted;
  UnconfirmedCorporateCorrection? pendingCorrection;

  Future<void> edit(CorporateSection section) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        settings: RouteSettings(
          name: '${corporateRoutePrefix}review-edit/${section.name}',
        ),
        builder: (_) => section == CorporateSection.documents
            ? CorporateDocumentsPage(draft: widget.draft, reviewEdit: true)
            : CorporateFormPage(
                draft: widget.draft,
                section: section,
                reviewEdit: true,
              ),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> returnToEntry({required bool accepted}) async {
    final account = widget.draft.localAccountKey;
    if (!widget.draft.isCorrection && account != null) {
      widget.draft.submitted = true;
      setState(() => busy = true);
      try {
        await ref.read(corporateDraftStoreProvider).clear(account);
      } catch (_) {
        if (mounted) {
          setState(() {
            cleanupAccepted = accepted;
            busy = false;
            error = context.l10n.corpDraftClearFailed;
          });
        }
        return;
      }
      if (!mounted) return;
    }
    ref.read(corporateSubmittedProvider.notifier).state = true;
    ref.invalidate(verificationEntryProvider);
    if (accepted && widget.draft.isCorrection) {
      // Keep the detail alive even when this flow was launched directly from Home.
      ref.listenManual(verificationEntryProvider, (_, __) {});
      try {
        await ref.read(verificationEntryProvider.future);
      } catch (_) {
        // Member information renders the refresh error and retries only detail.
      }
      if (mounted) {
        returnToCorporateMemberProfile(
          context,
          (_) => const VerificationEntryPage(),
        );
      }
      return;
    }
    bool atEntry(Route<dynamic> route) =>
        route.isFirst ||
        !(route.settings.name ?? '').startsWith(corporateRoutePrefix);
    final nav = Navigator.of(context);
    if (accepted) {
      final name = widget.draft.value(
        CorporateSection.company,
        CorporateField.businessName,
      );
      final handler = widget.draft.handler;
      nav.pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) =>
              CorporateSuccessPage(companyName: name, handler: handler),
        ),
        atEntry,
      );
    } else {
      nav.popUntil(atEntry);
    }
  }

  Future<void> checkStatus() async {
    if (busy || !unknown) return;
    setState(() => busy = true);
    try {
      final entry = await ref
          .read(verificationEntryRepositoryProvider)
          .load(afterSubmission: true);
      if (!mounted) return;
      if (widget.draft.isCorrection) {
        if (pendingCorrection?.confirmedBy(entry) == true) {
          await returnToEntry(accepted: true);
        } else {
          setState(() {
            busy = false;
            error = context.l10n.corpCorrectionPending;
          });
        }
        return;
      }
      if (entry.status != null &&
          entry.status!.isNotEmpty &&
          entry.status != 'DRAFT') {
        await returnToEntry(accepted: false);
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
          error = widget.draft.isCorrection
              ? context.l10n.corpCorrectionPending
              : context.l10n.uiErrorRequestFailed;
        });
      }
    }
  }

  Future<void> submit() async {
    if (busy || unknown || cleanupAccepted != null || !antiSocial || !mail) {
      return;
    }
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
    } catch (cause) {
      if (mounted) {
        setState(() {
          pendingCorrection = cause is UnconfirmedCorporateCorrection
              ? cause
              : null;
          busy = false;
          unknown = true;
          error = widget.draft.isCorrection
              ? context.l10n.corpCorrectionPending
              : context.l10n.corpReviewUnknown;
        });
      }
      return;
    }
    if (mounted) await returnToEntry(accepted: true);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, locked = busy || unknown || cleanupAccepted != null;
    return PopScope(
      canPop: !locked,
      child: CorporateFlowScaffold(
        exitPrompt: CorporateExitPrompt.draft,
        draft: widget.draft,
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
              label: cleanupAccepted != null
                  ? l.commonRetry
                  : unknown
                  ? l.corpReviewCheck
                  : l.corpReviewSubmit,
              style: const ButtonStyle(
                shape: WidgetStatePropertyAll(StadiumBorder()),
              ),
              onPressed: cleanupAccepted != null
                  ? (busy
                        ? null
                        : () => returnToEntry(accepted: cleanupAccepted!))
                  : unknown
                  ? (busy ? null : checkStatus)
                  : !busy && antiSocial && mail
                  ? submit
                  : null,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: l.profilePrevStep,
              variant: AppButtonVariant.secondary,
              style: const ButtonStyle(
                shape: WidgetStatePropertyAll(StadiumBorder()),
              ),
              onPressed: locked ? null : () => Navigator.of(context).maybePop(),
            ),
          ],
        ),
      ),
    );
  }
}
