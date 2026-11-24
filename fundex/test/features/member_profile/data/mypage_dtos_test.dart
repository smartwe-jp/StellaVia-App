import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/data/models/mypage_dtos.dart';

void main() {
  test('maps hiwari jobs from SDK DTO to the domain entity', () {
    final dto = UserInvestmentRecordDto.fromJson({
      'projectId': 'p-1',
      'projectName': '白馬ホテルファンド',
      'hiwariJobs': [
        {'startDate': '2026-03-10', 'endDate': '2026-03-31'},
        {
          'processId': 'proc-1',
          'fromProcessId': 'proc-2',
          'headStartDate': '2026-04-01',
          'headEndDate': '2026-06-30',
        },
      ],
    });

    final entity = dto.toEntity();

    expect(entity.hiwariJobs, hasLength(2));
    expect(entity.hiwariJobs.first.processId, isNull);
    expect(entity.hiwariJobs.first.endDate, '2026-03-31');
    expect(entity.hiwariJobs.last.fromProcessId, 'proc-2');
    expect(entity.hiwariJobs.last.headStartDate, '2026-04-01');
    expect(entity.hiwariJobs.last.headEndDate, '2026-06-30');
    expect(entity.hiwariJobs.last.processId, 'proc-1');
  });
}
