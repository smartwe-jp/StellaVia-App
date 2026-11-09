import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../host_miles/presentation/providers/host_miles_providers.dart';
import '../support/mypage_miles_history.dart';
import 'mypage_membership_providers.dart';

final myPageMilesHistoryProvider = FutureProvider.autoDispose
    .family<MyPageMilesHistory, ({int page, int limit})>((ref, query) async {
      if (ref.watch(myPageMembershipIdentityProvider) == null) {
        throw StateError('Authenticated user required');
      }
      final result = await ref
          .watch(hostMilesRepositoryProvider)
          .fetchTransactions(startPage: query.page, limit: query.limit);
      return MyPageMilesHistory(result, query.page, query.limit);
    });
