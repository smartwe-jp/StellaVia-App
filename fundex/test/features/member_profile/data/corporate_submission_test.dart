import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/data/mappers/corporate_submission_mapper.dart';
import 'package:fundex/features/member_profile/domain/entities/beneficial_owner.dart';
import 'package:fundex/features/member_profile/domain/entities/corporate_documents.dart';
import 'package:fundex/features/member_profile/domain/entities/corporate_form_draft.dart';

void main() {
  for (final correction in [true, false]) {
    test('maps confirmed application with correction=$correction', () {
      final draft = CorporateFormDraft(isCorrection: correction)
        ..handler = CorporateHandler.representative
        ..ownerPresence = OwnerPresence.no;
      draft.set(CorporateSection.company, CorporateField.postal, '001-2345');
      draft.set(CorporateSection.bank, CorporateField.bankName, 'other');
      draft.set(CorporateSection.bank, CorporateField.manualBankName, '京都銀行');
      draft.set(CorporateSection.bank, CorporateField.accountNumber, '0000023');
      final docs = draft.documents;
      docs.selectType(false, CorporateIdType.myNumber);
      docs.uploaded[CorporateDocument.representativeIdFront] = (
        filename: 'face.jpg',
        url: '/id',
        fileId: '12',
      );
      const attachment = (filename: 'r.pdf', url: '/r', fileId: '12ab');
      docs.uploaded[CorporateDocument.registry] = attachment;
      docs.uploaded[CorporateDocument.delegation] = attachment;
      expect(
        () => corporateSubmission(draft, antiSocial: false, mail: true),
        throwsStateError,
      );
      final p = corporateSubmission(draft, antiSocial: true, mail: true);
      expect(p.containsKey('bank'), !correction);
      if (!correction) {
        expect(p['bank']['bankName'], '京都銀行');
        expect(p['bank']['bankNumber'], '0000023');
      }
      expect(p['company']['postalCode'], '0012345');
      expect(p['handler'], {'type': 'representative'});
      expect(p['beneficialOwners'], {'status': 'NO', 'people': []});
      expect(p['documents']['registry'], {
        'name': 'r.pdf',
        'url': '/r',
        'fileId': '12ab',
      });
      expect(p['documents']['representativeId_front'], {
        'name': 'representativeId_front',
        'url': '/id',
        'fileId': '12',
      });
      expect(p['documents']['representativeId_back'], isNull);
      expect(p['documents']['delegation'], isNull);
      expect(p['declarations'], {'antiSocial': true, 'mail': true});
    });
  }
}
