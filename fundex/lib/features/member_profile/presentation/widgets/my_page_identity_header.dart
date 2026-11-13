import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../home/presentation/support/home_text_styles.dart';
import '../providers/member_profile_providers.dart';
import '../support/my_page_identity_display.dart';

class MyPageIdentityHeader extends ConsumerWidget {
  const MyPageIdentityHeader({super.key, required this.actions});
  final List<Widget> actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(memberBasicProfileProvider);
    final user = ref.watch(currentAuthUserProvider).asData?.value;
    final locale = Localizations.localeOf(context);
    final name = profile == null || user == null
        ? context.l10n.mainTabProfile
        : myPageDisplayName(locale, profile);
    final badge = myPageVerificationBadge(
      context.l10n,
      user?.status,
      profile?.email,
    );
    const suffix = ' さん';
    final honorific = locale.languageCode == 'ja' && name.endsWith(suffix);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Semantics(
                  header: true,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: honorific
                              ? name.substring(0, name.length - suffix.length)
                              : name,
                        ),
                        if (honorific)
                          TextSpan(
                            text: suffix,
                            style: context.appTextTheme.body,
                          ),
                      ],
                    ),
                    style: HomeTextStyles.greeting(context),
                  ),
                ),
                if (badge != null)
                  AppStatusBadge(label: badge.$1, tone: badge.$2),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ...actions.map(
            (action) => SizedBox.square(dimension: 44, child: action),
          ),
        ],
      ),
    );
  }
}
