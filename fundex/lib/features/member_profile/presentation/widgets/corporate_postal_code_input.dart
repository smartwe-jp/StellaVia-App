import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/corporate_form_draft.dart';
import '../providers/member_profile_providers.dart';
import '../support/member_profile_postal_address.dart';
import 'corporate_form_inputs.dart';

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
  int revision = 0;
  bool searching = false;

  Future<void> lookup(String raw, {bool automatic = false}) async {
    final request = ++revision;
    final postal = raw.trim();
    final l = context.l10n;
    if (!validPostal.hasMatch(postal)) {
      if (searching) setState(() => searching = false);
      if (!automatic) {
        AppNotice.show(context, message: l.memberProfileAddressSearchZipError);
      }
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
        AppNotice.show(context, message: l.memberProfileAddressSearchEmpty);
        return;
      }
      widget.draft.set(widget.section, address, result);
      widget.onResolved();
    } catch (_) {
      if (mounted && stillCurrent()) {
        AppNotice.show(context, message: l.uiErrorRequestFailed);
      }
    } finally {
      if (mounted && request == revision) setState(() => searching = false);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CorporateFormInput(
        draft: widget.draft,
        section: widget.section,
        field: CorporateField.postal,
        onStructureChanged: widget.onResolved,
        onTextChanged: (value) => lookup(value, automatic: true),
      ),
      TextButton(
        onPressed: searching
            ? null
            : () => lookup(
                widget.draft.value(widget.section, CorporateField.postal),
              ),
        child: Text(context.l10n.memberProfileAddressSearch),
      ),
    ],
  );
}
