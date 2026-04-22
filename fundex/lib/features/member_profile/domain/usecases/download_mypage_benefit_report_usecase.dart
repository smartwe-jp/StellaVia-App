import 'dart:typed_data';

import '../repositories/mypage_repository.dart';

class DownloadMyPageBenefitReportUseCase {
  const DownloadMyPageBenefitReportUseCase(this._repository);

  final MyPageRepository _repository;

  Future<Uint8List> call({required String benefitId}) {
    return _repository.downloadBenefitReport(benefitId: benefitId);
  }
}
