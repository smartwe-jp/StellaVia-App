import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/network/app_network_providers.dart';

import '../../../member_profile/presentation/providers/mypage_membership_providers.dart';

final secondaryContractDetailProvider = FutureProvider.autoDispose
    .family<ElectronicContractDetail, String>((ref, id) {
      if (ref.watch(myPageMembershipIdentityProvider) == null) {
        throw StateError('Sign in required');
      }
      return ref.watch(secondaryContractClientProvider).detail(id);
    });

final secondaryContractClientProvider = Provider(
  (ref) =>
      ElectronicContractApiClient(ref.watch(memberCoreHttpClientProvider).dio),
);
