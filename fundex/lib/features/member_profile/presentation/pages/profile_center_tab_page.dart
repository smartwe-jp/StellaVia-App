import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../app/navigation/app_root_tab_refresh.dart';
import '../../../../app/network/app_network_connectivity_providers.dart';
import '../../../main_shell/presentation/providers/main_shell_providers.dart';
import '../../../main_shell/presentation/widgets/main_shell_tab_refresh_scope.dart';
import '../../../notifications/presentation/providers/notifications_providers.dart';
import '../providers/member_profile_providers.dart';
import '../widgets/my_page_identity_header.dart';
import '../widgets/my_page_asset_summary.dart';
import '../widgets/my_page_shortcuts.dart';
import '../widgets/my_page_chart_refresh_scope.dart';
import '../widgets/my_page_membership_section.dart';
import '../providers/mypage_membership_providers.dart';

class ProfileCenterTabPage extends ConsumerStatefulWidget {
  const ProfileCenterTabPage({super.key});

  @override
  ConsumerState<ProfileCenterTabPage> createState() =>
      _ProfileCenterTabPageState();
}

class _ProfileCenterTabPageState extends ConsumerState<ProfileCenterTabPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final unreadNotificationCount = ref.watch(
      notificationsControllerProvider.select((state) => state.unreadCount),
    );
    return MainShellTabRefreshScope(
      tabIndex: MainShellTab.profile.index,
      onRefresh: (_) => _refreshPage(),
      scrollController: _scrollController,
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: _refreshPage,
            child: ListView(
              key: const Key('profile_tab_content'),
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 16),
              children: <Widget>[
                MyPageIdentityHeader(
                  actions: [
                    MyPageHeaderAction(
                      icon: Symbols.notifications,
                      unreadCount: unreadNotificationCount,
                      onTap: () => context.push('/profile/notifications'),
                    ),
                    MyPageHeaderAction(
                      icon: Symbols.settings,
                      onTap: () => context.push('/profile/settings'),
                    ),
                  ],
                ),
                const MyPageChartRefreshScope(child: MyPageMembershipSection()),
                MyPageShortcuts(
                  onSummary: () => context.push('/profile/summary'),
                  onFunds: () => context.push('/profile/host-funds'),
                  onTrades: () => context.push('/profile/my/secondary-market'),
                  onMiles: () => context.push('/profile/miles'),
                  onMember: () => context.push('/member-profile/edit'),
                  onDocuments: () =>
                      context.push('/profile/settings/contracts'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshPage() async {
    if (shouldSkipAppNetworkRefresh(ref)) {
      return;
    }
    await Future.wait<void>([
      refreshMemberProfileVerificationState(ref, isMounted: () => mounted),
      refreshRootTabSharedData(ref),
      ref.read(myPageTierProvider.notifier).refresh(),
      ref.read(myPageMilesAccountProvider.notifier).refresh(),
    ]);
  }
}
