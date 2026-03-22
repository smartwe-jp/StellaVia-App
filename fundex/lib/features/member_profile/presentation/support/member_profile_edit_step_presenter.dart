import '../../../../l10n/app_localizations.dart';
import 'member_profile_edit_step.dart';

String memberProfileEditStepTitle(
  AppLocalizations l10n,
  MemberProfileEditStep step, {
  bool plain = false,
}) {
  final title = switch (step) {
    MemberProfileEditStep.basicInfo => l10n.memberProfileStep1Title,
    MemberProfileEditStep.addressInfo => l10n.memberProfileStep2Title,
    MemberProfileEditStep.suitability => l10n.memberProfileStep3Title,
    MemberProfileEditStep.ekyc => l10n.memberProfileStep4Title,
    MemberProfileEditStep.realPersonAuth => l10n.memberProfileStep5RealPersonTitle,
    MemberProfileEditStep.bankAccount => l10n.memberProfileStep5Title,
    MemberProfileEditStep.consent => l10n.memberProfileStep6Title,
  };
  if (!plain) {
    return title;
  }
  return title.replaceFirst(RegExp(r'^Step\s*\d+\s*[:：]\s*'), '');
}

String memberProfileEditStepDescription(
  AppLocalizations l10n,
  MemberProfileEditStep step,
) {
  return switch (step) {
    MemberProfileEditStep.basicInfo => l10n.memberProfileStep1Description,
    MemberProfileEditStep.addressInfo => l10n.memberProfileStep2Description,
    MemberProfileEditStep.suitability => l10n.memberProfileStep3Description,
    MemberProfileEditStep.ekyc => l10n.memberProfileStep4Description,
    MemberProfileEditStep.realPersonAuth => l10n.memberProfileStep5RealPersonDescription,
    MemberProfileEditStep.bankAccount => l10n.memberProfileStep5Description,
    MemberProfileEditStep.consent => l10n.memberProfileStep6Description,
  };
}
