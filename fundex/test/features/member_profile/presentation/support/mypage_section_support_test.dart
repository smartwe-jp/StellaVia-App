import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/domain/entities/mypage_models.dart';
import 'package:fundex/features/member_profile/presentation/support/mypage_section_support.dart';

void main() {
  group('filterInvestmentRecordsByActiveFundFilter', () {
    test('selects operating and ended records by project status', () {
      final records = <MyPageInvestmentRecord>[
        _record(projectId: 'operating', projectStatus: 4),
        _record(projectId: 'ended', projectStatus: 5),
        _record(projectId: 'closed', projectStatus: 3),
      ];

      final operating = filterInvestmentRecordsByActiveFundFilter(
        records,
        MyPageActiveFundFilter.operating,
      );
      final ended = filterInvestmentRecordsByActiveFundFilter(
        records,
        MyPageActiveFundFilter.ended,
      );

      expect(operating.map((record) => record.projectId), <String>[
        'operating',
      ]);
      expect(ended.map((record) => record.projectId), <String>['ended']);
    });
  });

  group('groupActiveInvestmentRecords', () {
    test('keeps the latest record project status on the grouped item', () {
      final records = <MyPageInvestmentRecord>[
        _record(
          projectId: 'p1',
          projectStatus: 4,
          createTime: '2026-01-01T00:00:00Z',
        ),
        _record(
          projectId: 'p1',
          projectStatus: 5,
          createTime: '2026-02-01T00:00:00Z',
        ),
      ];

      final groups = groupActiveInvestmentRecords(records);

      expect(groups, hasLength(1));
      expect(groups.single.projectStatus, 5);
    });
  });
}

MyPageInvestmentRecord _record({
  required String projectId,
  required int projectStatus,
  String createTime = '2026-01-01T00:00:00Z',
}) {
  return MyPageInvestmentRecord(
    projectId: projectId,
    projectName: 'Fund $projectId',
    projectStatus: projectStatus,
    createTime: createTime,
  );
}
