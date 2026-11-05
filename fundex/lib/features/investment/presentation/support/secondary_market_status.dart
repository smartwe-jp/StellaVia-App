import '../../../../l10n/app_localizations.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';

String secondaryApplicationStatus(AppLocalizations l, int? status) =>
    switch (status) {
      0 => l.secondaryMarketStateSubmitted,
      1 => l.secondaryMarketStateRejected,
      2 => l.secondaryMarketStatePayment,
      3 => l.secondaryMarketStateCompleted,
      4 => l.secondaryMarketStateExpired,
      5 => l.secondaryMarketStateWithdrawn,
      _ => l.secondaryMarketStateUnknown,
    };
String secondaryContractStatus(AppLocalizations l, int? status) =>
    switch (status) {
      0 => l.secondaryMarketContractUnsigned,
      1 => l.secondaryMarketContractSigned,
      2 => l.secondaryMarketContractPending,
      3 => l.secondaryMarketContractEffective,
      _ => l.secondaryMarketStateUnknown,
    };
bool isSecondaryApplication(MyPageApplyRecord record) =>
    record.secondaryMarketSellId?.trim().isNotEmpty == true;
bool canWithdrawSecondaryApplication(MyPageApplyRecord record) =>
    (record.status == 0 || record.status == 2) &&
    record.processId?.trim().isNotEmpty == true;
bool canCancelSecondaryListing(MyPageOrderInquiryRecord record) =>
    record.status?.toUpperCase() == 'VALID' &&
    record.id?.trim().isNotEmpty == true &&
    record.fromProcessId?.trim().isNotEmpty == true &&
    record.sellNum != null &&
    record.price != null &&
    (record.sellNum! > (record.soldNum ?? 0));
