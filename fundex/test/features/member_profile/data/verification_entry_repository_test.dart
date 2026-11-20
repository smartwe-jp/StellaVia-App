import 'package:fundex/features/member_profile/data/mappers/corporate_detail_mapper.dart';
import 'package:core_network/core_network.dart';
import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/data/repositories/verification_entry_repository_impl.dart';
import 'package:fundex/features/member_profile/domain/repositories/verification_entry_repository.dart';

void main() {
  final paths = <String>[];
  VerificationEntryRepository repository(
    Map<String, dynamic> index, {
    Object? detail,
  }) {
    paths.clear();
    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          paths.add(options.path);
          expect(options.extra['auth_required'], true);
          expect(options.method, 'GET');
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: options.path == AuthApiPaths.crowdfundingUserIndex
                  ? {'code': 200, 'data': index}
                  : detail,
            ),
          );
        },
      ),
    );
    return VerificationEntryRepositoryImpl(
      AuthApiClient(dioForPath: (_) => dio),
      MemberProfileApiClient(dioForPath: (_) => dio),
    );
  }

  test(
    'after submission reads fresh corporate detail even if index still has personal type',
    () async {
      final entry = await repository(
        {'applicantType': 'personal'},
        detail: {
          'code': 200,
          'data': {
            'application': {'verificationStatus': 'SUBMITTED'},
          },
        },
      ).load(afterSubmission: true);
      expect(paths, [MemberProfileApiPaths.corporateDetail]);
      expect(entry.status, 'SUBMITTED');
    },
  );
  for (final latest in [(82, 'SUBMITTED'), (81, 'MAILED')]) {
    test('correction rechecks id and status before posting: $latest', () async {
      final form = corporateDetailForm(
        CorporateDetailDto.fromJson({
          'application': {'id': 81, 'companyName': '元の法人'},
          'handler': {'type': 'representative'},
          'beneficialOwners': {'status': 'NO'},
          'documents': {
            'registry': {'name': '登記.pdf', 'fileId': 'abc', 'url': '/doc'},
            'representativeId_front': {
              'name': 'front.jpg',
              'fileId': '12',
              'url': '/front',
            },
          },
        }),
      ).copyForEditing(correction: true);
      final repo = repository(
        {},
        detail: {
          'code': 200,
          'data': {
            'application': {'id': latest.$1, 'verificationStatus': latest.$2},
          },
        },
      );
      await expectLater(
        repo.submit(form, antiSocial: true, mail: true),
        throwsStateError,
      );
      expect(paths, [MemberProfileApiPaths.corporateDetail]);
    });
  }

  for (final type in ['personal', 'individual', null]) {
    test(
      'unsubmitted personal type $type offers choice without fetching detail',
      () async {
        final entry = await repository({
          'baseInfo': {'applicantType': type, 'status': '1'},
        }).load();
        expect(
          entry.kind,
          type == 'personal'
              ? VerificationEntryKind.choice
              : VerificationEntryKind.personal,
        );
        expect(paths, [AuthApiPaths.crowdfundingUserIndex]);
      },
    );
  }
  test('submitted personal entry retains overview', () async {
    expect(
      (await repository({
        'applicantType': 'personal',
        'status': 4,
      }).load()).kind,
      VerificationEntryKind.personal,
    );
  });
  for (final registered in [true, false]) {
    test(
      'draft with registered bank=$registered selects application mode',
      () async {
        final entry = await repository(
          {'applicantType': 'corporate'},
          detail: {
            'code': 200,
            'data': {
              'application': {'verificationStatus': 'DRAFT'},
              'bank': registered ? {'id': 8} : {},
            },
          },
        ).load();
        expect(entry.isCorrection, registered);
      },
    );
  }
  for (final root in [true, false]) {
    test(
      'index-new root applicant type wins when root corporate=$root',
      () async {
        final entry = await repository(
          {
            'applicantType': root ? 'corporate' : 'personal',
            'status': 1,
            'baseInfo': {'applicantType': root ? 'personal' : 'corporate'},
          },
          detail: {
            'code': 200,
            'data': {
              'id': 101,
              'application': {
                if (root) 'id': '202',
                'companyName': 'Example',
                'verificationStatus': 'CONFIRMED',
              },
              'userOps': ['RECEIVED'],
              'auditLogs': [
                {
                  'id': 7,
                  'action': 'APPROVED',
                  'createdAt': '2026-11-19T15:00:00+09:00',
                  'customerMessage': '通知',
                },
              ],
            },
          },
        ).load();
        if (!root) {
          expect(paths, [AuthApiPaths.crowdfundingUserIndex]);
          expect(entry.kind, VerificationEntryKind.choice);
          return;
        }
        expect(paths, [
          AuthApiPaths.crowdfundingUserIndex,
          MemberProfileApiPaths.corporateDetail,
        ]);
        expect(entry.kind, VerificationEntryKind.corporate);
        expect(entry.companyName, 'Example');
        expect(entry.applicationId, root ? 202 : 101);
        expect(entry.status, 'CONFIRMED');
        expect(entry.userOps, {'RECEIVED'});
        expect(entry.auditLogs.single.action, 'APPROVED');
        expect(entry.auditLogs.single.createdAt, DateTime.utc(2026, 11, 19, 6));
      },
    );
  }
  test(
    'failed detail propagates instead of offering a personal entry',
    () async {
      await expectLater(
        repository(
          {'applicantType': 'corporate'},
          detail: {'code': 403},
        ).load(),
        throwsStateError,
      );
    },
  );
  test('unknown type does not expose the choice', () async {
    await expectLater(
      repository({'applicantType': 'unknown', 'status': 1}).load(),
      throwsFormatException,
    );
  });
}
