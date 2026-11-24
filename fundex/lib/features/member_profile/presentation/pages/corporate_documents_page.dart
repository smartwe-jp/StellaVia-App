import '../support/corporate_draft_autosave.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/corporate_documents.dart';
import '../../domain/entities/corporate_form_draft.dart';
import '../providers/corporate_document_upload_provider.dart';
import '../support/corporate_document_labels.dart';
import '../widgets/corporate_document_card.dart';
import '../widgets/corporate_document_source_sheet.dart';
import '../widgets/corporate_form_header.dart';
import 'corporate_attachment_page.dart';
import 'corporate_review_page.dart';
import '../widgets/corporate_flow_scaffold.dart';

class CorporateDocumentsPage extends ConsumerStatefulWidget {
  const CorporateDocumentsPage({
    super.key,
    required this.draft,
    this.identity = false,
    this.reviewEdit = false,
  });
  final CorporateFormDraft draft;
  final bool identity;
  final bool reviewEdit;
  @override
  ConsumerState<CorporateDocumentsPage> createState() =>
      _CorporateDocumentsPageState();
}

class _CorporateDocumentsPageState
    extends ConsumerState<CorporateDocumentsPage> {
  CorporateDocuments get docs => widget.draft.documents;
  bool get delegate => widget.draft.handler == CorporateHandler.delegate;
  CorporateDocument? busy;
  final errors = <CorporateDocument, String>{};

  Future<void> attach(CorporateDocument slot, {bool retry = false}) async {
    if (busy != null) return;
    final l = context.l10n;
    final documents = docs;
    setState(() {
      busy = slot;
      errors.remove(slot);
    });
    try {
      if (!retry) {
        final source = slot.extensions.contains('jpg')
            ? await showCorporateDocumentSourceSheet(context)
            : CorporateDocumentSource.files;
        if (source == null || !mounted) return;
        final selected = await ref.read(corporateDocumentPickerProvider)(
          slot,
          source,
        );
        if (selected == null || !mounted) return;
        if (await selected.length() > CorporateDocument.maxBytes) {
          errors[slot] = l.corpDocsInvalid;
          return;
        }
        final bytes = await selected.readAsBytes();
        final mime = slot.mimeType(selected.name, bytes);
        if (mime == null) {
          errors[slot] = l.corpDocsInvalid;
          return;
        }
        if (!mounted) return;
        documents.pending[slot] = (
          filename: selected.name,
          bytes: bytes,
          mimeType: mime,
        );
        autosaveCorporateDraft(context, widget.draft);
      }
      if (!mounted) return;
      final file = documents.pending[slot]!;
      final result = await ref.read(corporateUploadProvider)(file);
      final handler =
          slot == CorporateDocument.handlerIdFront ||
          slot == CorporateDocument.handlerIdBack;
      documents.uploaded[slot] = (
        filename: file.filename,
        fileId: slot.identity ? documents.type(handler)!.code : result.fileId,
        url: result.url,
      );
      documents.pending.remove(slot);
      if (mounted) autosaveCorporateDraft(context, widget.draft);
    } catch (_) {
      if (!documents.pending.containsKey(slot)) {
        errors[slot] = l.corpDocsInvalid;
      }
    } finally {
      if (mounted) setState(() => busy = null);
    }
  }

  void finishReviewEdit() {
    if (busy != null) return;
    if (!docs.complete(false, delegate) || !docs.complete(true, delegate)) {
      AppNotice.show(context, message: context.l10n.corpFormMissing);
      return;
    }
    Navigator.of(context).pop();
  }

  Widget card(CorporateDocument slot) => CorporateDocumentCard(
    key: ValueKey(slot),
    slot: slot,
    documents: docs,
    busy: busy == slot,
    error: errors[slot],
    onView: busy == null
        ? (file) => CorporateAttachmentPage.open(context, file)
        : null,
    onPick: busy == null ? () => attach(slot) : null,
    onRetry: busy == null ? () => attach(slot, retry: true) : null,
    onDiscard: busy == null
        ? () => setState(() {
            docs.pending.remove(slot);
            autosaveCorporateDraft(context, widget.draft);
            errors.remove(slot);
          })
        : null,
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, identity = widget.identity;
    return PopScope(
      canPop: busy == null,
      child: CorporateFlowScaffold(
        exitPrompt: CorporateExitPrompt.draft,
        draft: widget.draft,
        title: l.corpDocsTitle,
        onReviewBack: widget.reviewEdit ? finishReviewEdit : null,
        step: CorporateSection.documents.index,
        locked: busy != null,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            CorporateFormHeader(
              section: CorporateSection.documents,
              heading: identity ? l.corpDocsIdentity : l.corpDocsCompany,
            ),
            const SizedBox(height: 24),
            if (!identity) ...[
              for (final slot in docs.companySlots(delegate)) card(slot),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(l.corpDocsMail),
                ),
              ),
            ],
            if (identity || widget.reviewEdit) ...[
              if (widget.reviewEdit)
                Text(
                  l.corpDocsIdentity,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              for (final handler in [false, if (delegate) true]) ...[
                Text(
                  handler ? l.corpFormHandler : l.corpFormRep,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                AppFieldLabel(
                  label: l.corpDocsType,
                  requiredLabel: l.corpFormRequired,
                ),
                DropdownButtonFormField<CorporateIdType>(
                  key: ValueKey(handler),
                  initialValue: docs.type(handler),
                  isExpanded: true,
                  icon: const Icon(CupertinoIcons.chevron_down, size: 16),
                  items: [
                    for (final t in CorporateIdType.values)
                      DropdownMenuItem(
                        value: t,
                        child: Text(idTypeLabel(l, t)),
                      ),
                  ],
                  onChanged: busy != null
                      ? null
                      : (t) {
                          if (t == null) return;
                          setState(() {
                            for (final s in docs.idSlots(handler)) {
                              errors.remove(s);
                            }
                            docs.selectType(handler, t);
                            autosaveCorporateDraft(context, widget.draft);
                          });
                        },
                ),
                const SizedBox(height: 16),
                for (final slot in docs.idSlots(handler)) card(slot),
              ],
              Text(l.corpDocsSides),
            ],
            const SizedBox(height: 24),
            if (widget.reviewEdit)
              AppButton(
                label: l.corpEditDone,
                onPressed: busy == null ? finishReviewEdit : null,
              )
            else ...[
              AppButton(
                label: identity ? l.corpFormReview : l.corpDocsIdentity,
                style: const ButtonStyle(
                  shape: WidgetStatePropertyAll(StadiumBorder()),
                ),
                onPressed: busy != null || !docs.complete(identity, delegate)
                    ? null
                    : () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          settings: RouteSettings(
                            name: identity
                                ? 'corporate-verification/review'
                                : 'corporate-verification/identity',
                          ),
                          builder: (_) => identity
                              ? CorporateReviewPage(draft: widget.draft)
                              : CorporateDocumentsPage(
                                  draft: widget.draft,
                                  identity: true,
                                ),
                        ),
                      ),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: l.profilePrevStep,
                variant: AppButtonVariant.secondary,
                style: const ButtonStyle(
                  shape: WidgetStatePropertyAll(StadiumBorder()),
                ),
                onPressed: busy == null
                    ? () => Navigator.of(context).maybePop()
                    : null,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
