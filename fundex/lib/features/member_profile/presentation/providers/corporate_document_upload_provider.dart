import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:file_selector/file_selector.dart';
import 'package:image_picker/image_picker.dart' show ImagePicker, ImageSource;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/network/app_network_providers.dart';
import '../../domain/entities/corporate_documents.dart';

enum CorporateDocumentSource { gallery, files }

final corporateDocumentPickerProvider = Provider(
  (ref) => (CorporateDocument slot, CorporateDocumentSource source) {
    if (source == CorporateDocumentSource.gallery) {
      return ImagePicker().pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false,
      );
    }
    final extensions = slot.extensions;
    return openFile(
      acceptedTypeGroups: [
        XTypeGroup(
          label: extensions.join(' / '),
          extensions: extensions,
          mimeTypes: [
            if (extensions.contains('pdf')) 'application/pdf',
            if (extensions.contains('jpg')) 'image/jpeg',
            if (extensions.contains('png')) 'image/png',
          ],
          uniformTypeIdentifiers: [
            if (extensions.contains('pdf')) 'com.adobe.pdf',
            if (extensions.contains('jpg')) 'public.jpeg',
            if (extensions.contains('png')) 'public.png',
          ],
        ),
      ],
    );
  },
);

final corporateUploadProvider = Provider((ref) {
  final client = MemberProfileApiClient(
    dioForPath: ref.watch(apiClusterRouterProvider).dioForPath,
  );
  return (PendingAttachment file) => client.uploadCorporateDocument(
    filename: file.filename,
    bytes: file.bytes,
    mimeType: file.mimeType,
  );
});
