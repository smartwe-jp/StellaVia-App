import 'dart:convert';
import 'package:core_storage/core_storage.dart';
import '../../domain/entities/beneficial_owner.dart';
import '../../domain/entities/corporate_documents.dart';
import '../../domain/entities/corporate_form_draft.dart';

class CorporateDraftStore {
  CorporateDraftStore(this.storage);
  final KeyValueStorage storage;
  String _key(String account) => 'corporate.initial.v1.$account';

  Future<void> _writes = Future.value();

  Future<void> _enqueue(Future<void> Function() operation) {
    final next = _writes.then((_) => operation());
    _writes = next.catchError((Object _) {});
    return next;
  }

  Future<void> clear(String account) =>
      _enqueue(() => storage.remove(_key(account)));

  Future<void> save(CorporateFormDraft draft) {
    final account = draft.localAccountKey;
    if (account == null || draft.isCorrection) {
      throw StateError('Not an initial account draft');
    }
    final docs = draft.documents;
    final data = {
      'fields': {
        for (final section in draft.sections)
          section.name: {
            for (final field in CorporateField.values)
              if (draft.value(section, field).isNotEmpty)
                field.name: draft.value(section, field),
          },
      },
      'handler': draft.handler?.name,
      'presence': draft.ownerPresence?.name,
      'owners': [
        for (final o in draft.owners)
          {
            'name': o.name,
            'birthdate': o.birthdate,
            'country': o.country,
            'address': o.address,
            'control': o.control?.name,
            'percentage': o.percentage,
          },
      ],
      'types': [docs.type(false)?.name, docs.type(true)?.name],
      'uploaded': {
        for (final e in docs.uploaded.entries)
          e.key.name: {
            'filename': e.value.filename,
            'fileId': e.value.fileId,
            'url': e.value.url,
          },
      },
      'pending': {
        for (final e in docs.pending.entries)
          e.key.name: {
            'filename': e.value.filename,
            'mimeType': e.value.mimeType,
            'bytes': base64Encode(e.value.bytes),
          },
      },
    };
    final encoded = jsonEncode(data);
    return _enqueue(() => storage.write(_key(account), encoded));
  }

  Future<CorporateFormDraft?> read(String account) async {
    await _writes;
    final raw = await storage.read(_key(account));
    if (raw == null) return null;
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final draft = CorporateFormDraft(localAccountKey: account);
    for (final section in draft.sections) {
      for (final field in CorporateField.values) {
        final value = data['fields'][section.name]?[field.name];
        if (value is String) draft.set(section, field, value);
      }
    }
    draft.handler = CorporateHandler.values.asNameMap()[data['handler']];
    draft.ownerPresence = OwnerPresence.values.asNameMap()[data['presence']];
    for (final o in data['owners']) {
      draft.owners.add(
        BeneficialOwner(
          name: o['name'],
          birthdate: o['birthdate'],
          country: o['country'],
          address: o['address'],
          control: OwnerControl.values.asNameMap()[o['control']],
          percentage: o['percentage'],
        ),
      );
    }
    final docs = draft.documents;
    for (final handler in [false, true]) {
      final type = CorporateIdType.values
          .asNameMap()[data['types'][handler ? 1 : 0]];
      if (type != null) docs.selectType(handler, type);
    }
    for (final slot in CorporateDocument.values) {
      final uploaded = data['uploaded'][slot.name];
      if (uploaded != null) {
        docs.uploaded[slot] = (
          filename: uploaded['filename'] as String,
          fileId: uploaded['fileId'] as String,
          url: uploaded['url'] as String,
        );
      }
      final pending = data['pending'][slot.name];
      if (pending != null) {
        docs.pending[slot] = (
          filename: pending['filename'] as String,
          mimeType: pending['mimeType'] as String,
          bytes: base64Decode(pending['bytes']),
        );
      }
    }
    return draft;
  }
}
