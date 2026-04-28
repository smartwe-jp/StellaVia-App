import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../member_profile/presentation/providers/mypage_providers.dart';
import '../providers/wallet_providers.dart';

Future<void> refreshWalletApplicationPaymentState(
  WidgetRef ref, {
  String? projectId,
}) async {
  final normalizedProjectId = projectId?.trim();

  ref.invalidate(myPageAccountStatisticProvider);
  ref.invalidate(walletDepositPageViewDataProvider);
  ref.invalidate(walletPendingDepositListProvider);
  ref.invalidate(myPageApplyListProvider);
  ref.invalidate(myPagePendingApplyListProvider);
  if (normalizedProjectId != null && normalizedProjectId.isNotEmpty) {
    ref.invalidate(walletPendingDepositRecordProvider(normalizedProjectId));
  }

  await Future.wait<void>(<Future<void>>[
    _refreshIgnoringError(
      () => ref.refresh(myPageAccountStatisticProvider.future),
    ),
    _refreshIgnoringError(
      () => ref.refresh(walletDepositPageViewDataProvider.future),
    ),
    _refreshIgnoringError(
      () => ref.refresh(walletPendingDepositListProvider.future),
    ),
    _refreshIgnoringError(() => ref.refresh(myPageApplyListProvider.future)),
    _refreshIgnoringError(
      () => ref.refresh(myPagePendingApplyListProvider.future),
    ),
  ]);

  if (normalizedProjectId != null && normalizedProjectId.isNotEmpty) {
    await _refreshIgnoringError(
      () => ref.refresh(
        walletPendingDepositRecordProvider(normalizedProjectId).future,
      ),
    );
  }

  ref.read(myPageSectionListRefreshSignalProvider.notifier).state++;
}

Future<void> _refreshIgnoringError(Future<Object?> Function() refresh) async {
  try {
    await refresh();
  } catch (_) {
    // A successful purchase should not be rolled back by a best-effort refresh.
  }
}
