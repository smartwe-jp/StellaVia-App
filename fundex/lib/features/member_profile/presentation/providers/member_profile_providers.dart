import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/network/app_network_providers.dart';
import '../../../../app/storage/app_storage_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/member_profile_local_data_source.dart';
import '../../data/datasources/member_profile_remote_data_source.dart';
import '../../data/repositories/member_profile_repository_impl.dart';
import '../../domain/entities/member_profile_details.dart';
import '../../domain/repositories/member_profile_repository.dart';
import '../../domain/usecases/fetch_member_profile_regions_by_zip_usecase.dart';
import '../../domain/usecases/is_member_profile_completed_usecase.dart';
import '../../domain/usecases/load_member_profile_details_usecase.dart';
import '../../domain/usecases/mark_member_profile_skipped_usecase.dart';
import '../../domain/usecases/save_member_profile_details_usecase.dart';
import '../../domain/usecases/submit_member_profile_usecase.dart';
import '../../domain/usecases/sync_member_profile_from_remote_usecase.dart';
import '../../domain/usecases/upload_member_profile_photo_usecase.dart';
import '../support/profile_document_image_picker.dart';

final memberProfileLocalDataSourceProvider =
    Provider<MemberProfileLocalDataSource>((ref) {
      return MemberProfileLocalDataSourceImpl(
        ref.watch(largeDataStoreProvider),
        ref.watch(authLocalDataSourceProvider),
      );
    });

final memberProfileRepositoryProvider = Provider<MemberProfileRepository>((
  ref,
) {
  return MemberProfileRepositoryImpl(
    local: ref.watch(memberProfileLocalDataSourceProvider),
    remote: ref.watch(memberProfileRemoteDataSourceProvider),
    authLocal: ref.watch(authLocalDataSourceProvider),
  );
});

final memberProfileRemoteDataSourceProvider =
    Provider<MemberProfileRemoteDataSource>((ref) {
      return MemberProfileRemoteDataSourceImpl(
        ref.watch(oaCoreHttpClientProvider),
        memberClient: ref.watch(memberCoreHttpClientProvider),
        clusterRouter: ref.watch(apiClusterRouterProvider),
      );
    });

final loadMemberProfileDetailsUseCaseProvider =
    Provider<LoadMemberProfileDetailsUseCase>((ref) {
      return LoadMemberProfileDetailsUseCase(
        ref.watch(memberProfileRepositoryProvider),
      );
    });

final saveMemberProfileDetailsUseCaseProvider =
    Provider<SaveMemberProfileDetailsUseCase>((ref) {
      return SaveMemberProfileDetailsUseCase(
        ref.watch(memberProfileRepositoryProvider),
      );
    });

final syncMemberProfileFromRemoteUseCaseProvider =
    Provider<SyncMemberProfileFromRemoteUseCase>((ref) {
      return SyncMemberProfileFromRemoteUseCase(
        ref.watch(memberProfileRepositoryProvider),
      );
    });

final submitMemberProfileUseCaseProvider = Provider<SubmitMemberProfileUseCase>(
  (ref) {
    return SubmitMemberProfileUseCase(
      ref.watch(memberProfileRepositoryProvider),
    );
  },
);

final uploadMemberProfilePhotoUseCaseProvider =
    Provider<UploadMemberProfilePhotoUseCase>((ref) {
      return UploadMemberProfilePhotoUseCase(
        ref.watch(memberProfileRepositoryProvider),
      );
    });

final fetchMemberProfileRegionsByZipUseCaseProvider =
    Provider<FetchMemberProfileRegionsByZipUseCase>((ref) {
      return FetchMemberProfileRegionsByZipUseCase(
        ref.watch(memberProfileRepositoryProvider),
      );
    });

final isMemberProfileCompletedUseCaseProvider =
    Provider<IsMemberProfileCompletedUseCase>((ref) {
      return IsMemberProfileCompletedUseCase(
        ref.watch(memberProfileRepositoryProvider),
      );
    });

final markMemberProfileSkippedUseCaseProvider =
    Provider<MarkMemberProfileSkippedUseCase>((ref) {
      return MarkMemberProfileSkippedUseCase(
        ref.watch(memberProfileRepositoryProvider),
      );
    });

final memberProfileDetailsProvider = FutureProvider<MemberProfileDetails?>((
  ref,
) async {
  ref.watch(authSessionProvider);
  final user = await ref
      .watch(currentAuthUserProvider.future)
      .catchError((Object _) => null);
  if (user == null) {
    return null;
  }
  return ref.watch(loadMemberProfileDetailsUseCaseProvider).call();
});

final isMemberProfileCompletedProvider = FutureProvider<bool>((ref) async {
  ref.watch(authSessionProvider);
  final user = await ref
      .watch(currentAuthUserProvider.future)
      .catchError((Object _) => null);
  if (user == null) {
    return false;
  }
  final status = user.status;
  if (status != null) {
    return status != 1 && status != 3;
  }
  return ref.watch(isMemberProfileCompletedUseCaseProvider).call();
});

final profileDocumentImagePickerProvider = Provider<ProfileDocumentImagePicker>(
  (ref) {
    return DeviceProfileDocumentImagePicker();
  },
);
