import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/investment/presentation/providers/fund_project_providers.dart';
import '../../features/member_profile/presentation/providers/member_profile_providers.dart';
import '../../features/member_profile/presentation/providers/mypage_providers.dart';
import '../../features/notifications/presentation/providers/notifications_providers.dart';
import '../../features/wallet/presentation/providers/wallet_providers.dart';

void invalidateAuthenticatedRealtimeProviders(WidgetRef ref) {
  ref.invalidate(fundProjectListProvider);
  ref.invalidate(memberProfileDetailsProvider);
  ref.invalidate(isMemberProfileCompletedProvider);
  ref.invalidate(myPageAccountStatisticProvider);
  ref.invalidate(myPageApplyListProvider);
  ref.invalidate(myPagePendingApplyListProvider);
  ref.invalidate(myPageOrderInquiryListProvider);
  ref.invalidate(secondaryMarketMarketplaceListProvider);
  ref.invalidate(myPageInvestmentListProvider);
  ref.invalidate(walletDepositPageViewDataProvider);
  ref.invalidate(walletHistoryProvider);
  ref.invalidate(walletBankAccountListProvider);
  ref.invalidate(walletWithdrawHistoryProvider);
  ref.invalidate(walletWithdrawingListProvider);
  ref.invalidate(notificationsControllerProvider);
}
