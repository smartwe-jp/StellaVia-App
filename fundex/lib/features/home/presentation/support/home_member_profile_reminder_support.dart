import '../../../auth/domain/entities/auth_user.dart';

bool shouldShowHomeMemberProfileReminder(
  AuthUser? user, {
  bool? isMemberProfileCompleted,
}) {
  final status = user?.status;
  if (status == null) {
    if (isMemberProfileCompleted != null) {
      return !isMemberProfileCompleted;
    }
    return false;
  }
  return status == 0 || status == 1 || status == 3;
}
