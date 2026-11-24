import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/corporate_form_draft.dart';
import '../providers/corporate_draft_providers.dart';

Future<void> autosaveCorporateDraft(
  BuildContext context,
  CorporateFormDraft draft,
) async {
  if (draft.localAccountKey == null || draft.isCorrection || draft.submitted) {
    return;
  }
  try {
    await ProviderScope.containerOf(
      context,
      listen: false,
    ).read(corporateDraftStoreProvider).save(draft);
  } catch (_) {
    if (context.mounted) {
      AppNotice.show(context, message: context.l10n.corpDraftSaveFailed);
    }
  }
}
