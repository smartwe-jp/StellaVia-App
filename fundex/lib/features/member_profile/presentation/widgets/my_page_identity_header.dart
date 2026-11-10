import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/member_profile_providers.dart';
import '../support/my_page_identity_display.dart';
import '../support/mypage_summary_styles.dart';

class MyPageIdentityHeader extends ConsumerWidget {
  const MyPageIdentityHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(memberBasicProfileProvider);
    final user = ref.watch(currentAuthUserProvider).asData?.value;
    if (profile == null || user == null) return const SizedBox.shrink();
    final badge = myPageVerificationBadge(
      context.l10n,
      user.status,
      profile.email,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            myPageDisplayName(Localizations.localeOf(context), profile),
            style: MyPageSummaryStyles(context).heading,
          ),
          if (badge != null) AppStatusBadge(label: badge.$1, tone: badge.$2),
        ],
      ),
    );
  }
}
