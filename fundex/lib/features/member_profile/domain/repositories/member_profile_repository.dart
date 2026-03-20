import '../entities/member_profile_details.dart';
import '../entities/member_profile_region.dart';

abstract class MemberProfileRepository {
  Future<MemberProfileDetails?> readLocalProfile();
  Future<void> saveLocalProfile(MemberProfileDetails profile);
  Future<void> syncLocalProfileFromRemote();
  Future<void> clearLocalProfile();
  Future<List<MemberProfileRegion>> fetchRegionsByZip({required String zip});
  Future<String> uploadProfilePhoto({
    required String filePath,
    required bool isSelfie,
  });
  Future<void> submitProfile(MemberProfileDetails profile);
}
