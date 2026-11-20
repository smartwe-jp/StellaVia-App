import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/corporate_documents.dart';

String documentLabel(AppLocalizations l, CorporateDocument slot) =>
    switch (slot) {
      CorporateDocument.registry => l.corpDocsRegistry,
      CorporateDocument.sealCertificate => l.corpDocsSeal,
      CorporateDocument.delegation => l.corpDocsDelegation,
      CorporateDocument.beneficialOwnerEvidence => l.corpDocsEvidence,
      CorporateDocument.representativeIdFront =>
        '${l.corpFormRep} ・ ${l.corpDocsFront}',
      CorporateDocument.representativeIdBack =>
        '${l.corpFormRep} ・ ${l.corpDocsBack}',
      CorporateDocument.handlerIdFront =>
        '${l.corpFormHandler} ・ ${l.corpDocsFront}',
      CorporateDocument.handlerIdBack =>
        '${l.corpFormHandler} ・ ${l.corpDocsBack}',
    };

String idTypeLabel(AppLocalizations l, CorporateIdType type) => switch (type) {
  CorporateIdType.license => l.documentTypeDriversLicense,
  CorporateIdType.myNumber => l.documentTypeMyNumber,
  CorporateIdType.residence => l.documentTypeResidenceCard,
};
