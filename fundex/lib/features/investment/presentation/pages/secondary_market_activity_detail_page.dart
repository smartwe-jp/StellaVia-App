import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../../../member_profile/presentation/support/mypage_withdraw_action.dart';
import '../controllers/secondary_market_controller.dart';
import '../support/secondary_market_status.dart';
import '../widgets/secondary_market_activity_cards.dart';
import '../widgets/secondary_market_refresh_scope.dart';
import '../widgets/secondary_market_contract_actions.dart';

class SecondaryMarketActivityDetailPage extends ConsumerStatefulWidget {
  const SecondaryMarketActivityDetailPage({
    super.key,
    required this.id,
    required this.sale,
  });
  final String id;
  final bool sale;
  @override
  ConsumerState<SecondaryMarketActivityDetailPage> createState() =>
      _SecondaryMarketActivityDetailPageState();
}

class _SecondaryMarketActivityDetailPageState
    extends ConsumerState<SecondaryMarketActivityDetailPage> {
  bool busy = false;
  Future<void> _refresh() async {
    if (widget.sale) {
      await ref
          .refresh(secondaryMarketOrderProvider(widget.id).future)
          .catchError((Object _) => null);
    } else {
      await ref
          .refresh(secondaryMarketApplicationProvider(widget.id).future)
          .catchError((Object _) => null);
    }
  }

  Future<void> _cancel({
    MyPageOrderInquiryRecord? order,
    MyPageApplyRecord? application,
  }) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      bool success;
      if (order != null) {
        success = await confirmAndSubmitMyPageSecondaryMarketInvalidate(
          context,
          ref,
          id: order.id!,
          fromProcessId: order.fromProcessId!,
          sellNum: order.sellNum!,
          price: order.price!.toInt(),
          thisTimeSoldNum: order.soldNum ?? 0,
          confirmBody: context.l10n.myPageWithdrawOrderConfirmBody,
        );
      } else {
        success = await confirmAndSubmitMyPageWithdraw(
          context,
          ref,
          processId: application!.processId!,
          confirmBody: context.l10n.myPageWithdrawApplyConfirmBody,
        );
      }
      if (success && mounted) {
        refreshSecondaryMarket(ref);
        await _refresh();
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final order = widget.sale
        ? ref.watch(secondaryMarketOrderProvider(widget.id))
        : null;
    final application = widget.sale
        ? null
        : ref.watch(secondaryMarketApplicationProvider(widget.id));
    final user = ref.watch(currentAuthUserProvider).asData?.value;
    final loading = order?.isLoading ?? application!.isLoading;
    final error = order?.hasError ?? application!.hasError;
    // Never display another seller's private activity via an arbitrary route ID.
    final sale = order?.asData?.value;
    final ownSale =
        sale != null && user?.userId != null && sale.memberId == user!.userId
        ? sale
        : null;
    final purchase = application?.asData?.value;
    return SecondaryMarketRefreshScope(
      onRefresh: _refresh,
      child: Scaffold(
        appBar: AppNavigationBar(
          title: widget.sale
              ? l.secondaryMarketSales
              : l.secondaryMarketApplicationDetail,
          leading: AppNavigationIconButton(
            icon: Icons.arrow_back,
            onTap: () => context.canPop()
                ? context.pop()
                : context.go('/profile/my/secondary-market?tab=${widget.sale ? 'sales' : 'buy'}'),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              if (loading || busy) const LinearProgressIndicator(),
              if (error) Text(l.fundListLoadError),
              if (!loading && !error && ownSale == null && purchase == null)
                Text(l.secondaryMarketDetailUnavailable),
              TextButton(
                onPressed: busy ? null : _refresh,
                child: Text(l.secondaryMarketRefresh),
              ),
              if (ownSale != null) ...[
                SecondaryMarketListingCard(
                  record: ownSale,
                  onTap: null,
                  onCancel:
                      !busy &&
                          !loading &&
                          !error &&
                          canCancelSecondaryListing(ownSale)
                      ? () => _cancel(order: ownSale)
                      : null,
                ),
                Text(
                  l.secondaryMarketApplications,
                  style: context.appTextTheme.sectionTitle,
                ),
                if (ownSale.applyList.isEmpty)
                  Text(l.secondaryMarketNoApplications),
                for (final item in ownSale.applyList) ...[
                  SecondaryMarketApplicationCard(record: item),
                  SecondaryMarketContractActions(record: item, seller: true),
                ],
              ],
              if (purchase != null) ...[
                SecondaryMarketApplicationCard(
                  record: purchase,
                  onCancel:
                      !busy &&
                          !loading &&
                          !error &&
                          canWithdrawSecondaryApplication(purchase)
                      ? () => _cancel(application: purchase)
                      : null,
                ),
                SecondaryMarketContractActions(record: purchase, seller: false),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
