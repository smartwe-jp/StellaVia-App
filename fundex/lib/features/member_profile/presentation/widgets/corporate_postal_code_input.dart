import '../support/corporate_draft_autosave.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/corporate_form_draft.dart';
import '../providers/member_profile_providers.dart';
import '../support/member_profile_postal_address.dart';
import 'corporate_form_inputs.dart';
import 'postal_lookup_dialog.dart';

class CorporatePostalCodeInput extends ConsumerStatefulWidget {
  const CorporatePostalCodeInput({
    super.key,
    required this.draft,
    required this.section,
    required this.onResolved,
  });

  final CorporateFormDraft draft;
  final CorporateSection section;
  final VoidCallback onResolved;

  @override
  ConsumerState<CorporatePostalCodeInput> createState() =>
      _CorporatePostalCodeInputState();
}

class _CorporatePostalCodeInputState
    extends ConsumerState<CorporatePostalCodeInput> {
  static final validPostal = RegExp(r'^\d{3}-?\d{4}$');
  final postalFocus = FocusNode();

  @override
  void dispose() {
    postalFocus.dispose();
    super.dispose();
  }

  int revision = 0;
  bool searching = false;

  Future<void> lookup() async {
    if (searching) return;
    final request = ++revision;
    final postal = widget.draft
        .value(widget.section, CorporateField.postal)
        .trim();
    final l = context.l10n;
    if (!validPostal.hasMatch(postal)) {
      AppNotice.show(context, message: l.memberProfileAddressSearchZipError);
      return;
    }
    final address = widget.section == CorporateSection.company
        ? CorporateField.office
        : CorporateField.address;
    final previous = widget.draft.value(widget.section, address);
    setState(() => searching = true);
    bool stillCurrent() =>
        request == revision &&
        ModalRoute.of(context)?.isCurrent == true &&
        widget.draft.value(widget.section, address) == previous;
    try {
      final rows = await ref
          .read(fetchMemberProfileRegionsByZipUseCaseProvider)
          .call(zip: postal.replaceAll('-', ''));
      if (!mounted || !stillCurrent()) return;
      final parts = resolveMemberProfilePostalAddress(rows);
      final result = '${parts.prefecture}${parts.cityAddress}';
      if (result.isEmpty) {
        setState(() => searching = false);
        final reenter = await showPostalLookupEmptyDialog(context);
        if (mounted && reenter == true && stillCurrent()) {
          postalFocus.requestFocus();
        }
        return;
      }
      widget.draft.set(widget.section, address, result);
      autosaveCorporateDraft(context, widget.draft);
      widget.onResolved();
    } catch (_) {
      if (mounted && stillCurrent()) {
        AppNotice.show(context, message: l.uiErrorRequestFailed);
      }
    } finally {
      if (mounted && request == revision && searching) {
        setState(() => searching = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => CorporateFormInput(
    draft: widget.draft,
    section: widget.section,
    field: CorporateField.postal,
    focusNode: postalFocus,
    onStructureChanged: widget.onResolved,
    onTextChanged: (_) {
      revision++;
      if (searching) setState(() => searching = false);
    },
    trailingAction: AppButton(
      label: context.l10n.memberProfileAddressSearch,
      isLoading: searching,
      onPressed: lookup,
    ),
  );
}
