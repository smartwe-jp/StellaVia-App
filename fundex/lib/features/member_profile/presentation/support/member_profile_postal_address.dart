import '../../domain/entities/member_profile_region.dart';

({String prefecture, String cityAddress}) resolveMemberProfilePostalAddress(
  List<MemberProfileRegion> rows,
) {
  final String resolvedPrefecture = rows
      .where((MemberProfileRegion row) => row.regionType == 0)
      .map((MemberProfileRegion row) => row.displayName)
      .firstWhere((String value) => value.trim().isNotEmpty, orElse: () => '')
      .trim();

  final String resolvedCityAddress = rows
      .where(
        (MemberProfileRegion row) => row.regionType == 1 || row.regionType == 2,
      )
      .map((MemberProfileRegion row) => row.displayName.trim())
      .where((String value) => value.isNotEmpty)
      .join(' ')
      .trim();

  return (prefecture: resolvedPrefecture, cityAddress: resolvedCityAddress);
}
