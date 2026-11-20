import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/storage/app_storage_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/corporate_draft_store.dart';

final corporateDraftStoreProvider = Provider(
  (ref) => CorporateDraftStore(ref.watch(secureKeyValueStorageProvider)),
);

final corporateDraftAccountProvider = FutureProvider.autoDispose<String>((
  ref,
) async {
  final user = await ref.watch(currentAuthUserProvider.future);
  if (user != null) {
    if (user.userId != null) return 'uid_${user.userId}';
    if (user.memberId != null) return 'member_${user.memberId}';
    for (final (prefix, value) in [
      ('id', user.id),
      ('account', user.accountId),
      ('username', user.username),
      ('email', user.email),
    ]) {
      if (value != null && value.trim().isNotEmpty) {
        return '${prefix}_${value.trim()}';
      }
    }
  }
  throw StateError('Missing signed-in account');
});
