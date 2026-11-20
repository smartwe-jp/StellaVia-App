import 'dart:typed_data';
import 'package:core_storage/core_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/data/datasources/corporate_draft_store.dart';
import 'package:fundex/features/member_profile/domain/entities/beneficial_owner.dart';
import 'package:fundex/features/member_profile/domain/entities/corporate_documents.dart';
import 'package:fundex/features/member_profile/domain/entities/corporate_form_draft.dart';

void main() {
  test(
    'partial initial application survives reopening only for its account',
    () async {
      final storage = InMemoryKeyValueStorage();
      final store = CorporateDraftStore(storage);
      final draft = CorporateFormDraft(localAccountKey: 'uid_1')
        ..handler = CorporateHandler.delegate
        ..ownerPresence = OwnerPresence.yes
        ..set(CorporateSection.bank, CorporateField.accountNumber, '0012345')
        ..set(CorporateSection.handler, CorporateField.department, '営業');
      draft.owners.add(
        const BeneficialOwner(
          name: '山田',
          birthdate: '',
          address: '',
          country: '',
          percentage: '',
          control: null,
        ),
      );
      draft.documents.selectType(true, CorporateIdType.residence);
      draft.documents.uploaded[CorporateDocument.registry] = (
        filename: '登記.pdf',
        fileId: '411',
        url: '/uploaded',
      );
      draft.documents.pending[CorporateDocument.handlerIdFront] = (
        filename: 'front.png',
        mimeType: 'image/png',
        bytes: Uint8List.fromList([1, 2, 3]),
      );
      await store.save(draft);
      final reopened = CorporateDraftStore(storage);
      expect(await reopened.read('uid_2'), isNull);
      final restored = (await reopened.read('uid_1'))!;
      expect(restored.isCorrection, isFalse);
      expect(restored.handler, CorporateHandler.delegate);
      expect(restored.ownerPresence, OwnerPresence.yes);
      expect(restored.owners.single.name, '山田');
      expect(restored.ownersComplete, isFalse);
      expect(
        restored.value(CorporateSection.bank, CorporateField.accountNumber),
        '0012345',
      );
      expect(
        restored.value(CorporateSection.handler, CorporateField.department),
        '営業',
      );
      expect(restored.documents.type(true), CorporateIdType.residence);
      expect(
        restored.documents.uploaded[CorporateDocument.registry],
        draft.documents.uploaded[CorporateDocument.registry],
      );
      expect(
        restored.documents.pending[CorporateDocument.handlerIdFront]?.bytes,
        [1, 2, 3],
      );
      await reopened.clear('uid_1');
      expect(await store.read('uid_1'), isNull);
    },
  );
}
