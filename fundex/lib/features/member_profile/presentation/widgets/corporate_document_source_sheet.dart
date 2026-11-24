import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/corporate_document_upload_provider.dart';

Future<CorporateDocumentSource?> showCorporateDocumentSourceSheet(
  BuildContext context,
) => AppBottomSheet.showAdaptive<CorporateDocumentSource>(
  context: context,
  builder: (context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ListTile(
        leading: const Icon(Icons.photo_library_outlined),
        title: Text(context.l10n.profileDocumentPickFromGallery),
        onTap: () => Navigator.pop(context, CorporateDocumentSource.gallery),
      ),
      ListTile(
        leading: const Icon(Icons.folder_open_outlined),
        title: Text(context.l10n.corpDocsPickFromFiles),
        onTap: () => Navigator.pop(context, CorporateDocumentSource.files),
      ),
    ],
  ),
);
