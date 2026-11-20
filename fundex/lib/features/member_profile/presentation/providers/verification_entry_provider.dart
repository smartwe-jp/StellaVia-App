import 'dart:typed_data';
import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/network/app_network_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/verification_entry_repository_impl.dart';
import '../../domain/repositories/verification_entry_repository.dart';

final verificationEntryRepositoryProvider =
    Provider<VerificationEntryRepository>((ref) {
      final router = ref.watch(apiClusterRouterProvider);
      return VerificationEntryRepositoryImpl(
        AuthApiClient(dioForPath: router.dioForPath),
        MemberProfileApiClient(dioForPath: router.dioForPath),
      );
    });

final corporateSubmittedProvider = StateProvider.autoDispose<bool>((ref) {
  ref.watch(authSessionProvider);
  return false;
});

final verificationEntryProvider = FutureProvider.autoDispose<VerificationEntry>(
  (ref) async {
    final submitted = ref.watch(corporateSubmittedProvider);
    final session = ref.watch(authSessionProvider).asData?.value == true;
    if (!session) throw StateError('Sign in required');
    return ref
        .read(verificationEntryRepositoryProvider)
        .load(afterSubmission: submitted);
  },
);

final corporateAttachmentProvider = FutureProvider.autoDispose
    .family<Uint8List, String>((ref, url) {
      final router = ref.watch(apiClusterRouterProvider);
      return MemberProfileApiClient(
        dioForPath: router.dioForPath,
      ).fetchCorporateAttachment(url);
    });
