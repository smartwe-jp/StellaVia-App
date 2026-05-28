import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/status_bar/app_status_bar_providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/hotel_order_list_controller.dart';
import '../providers/hotel_booking_providers.dart';
import '../support/hotel_booking_presenter.dart';
import '../support/hotel_payment_route_args.dart';
import '../widgets/hotel_order_list_widgets.dart';
import '../widgets/hotel_payment_method_widgets.dart';
import '../widgets/hotel_state_views.dart';
import '../widgets/hotel_status_bar_preference_scope.dart';

class HotelOrderListPage extends ConsumerWidget {
  const HotelOrderListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final state = ref.watch(hotelOrderListControllerProvider);
    final controller = ref.read(hotelOrderListControllerProvider.notifier);
    final languageCode = ref.watch(hotelLocaleLanguageCodeProvider);
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(context).toLanguageTag(),
    );

    return HotelStatusBarPreferenceScope(
      immersive: false,
      immersiveOnPop: true,
      child: Scaffold(
        backgroundColor: colors.surfaceAlt,
        appBar: AppNavigationBar(
          title: context.l10n.hotelOrdersTitle,
          backgroundColor: colors.surface,
          foregroundColor: colors.textPrimary,
          leading: AppNavigationIconButton(
            icon: Icons.arrow_back_rounded,
            onTap: () {
              ref.read(appImmersiveHotelStatusBarHintProvider.notifier).state =
                  true;
              if (context.canPop()) {
                context.pop();
                return;
              }
              context.go('/hotel-booking');
            },
            backgroundColor: colors.surface.withValues(alpha: 0),
            foregroundColor: colors.textPrimary,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: controller.refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: HotelOrderStatusFilterBar(
                    selected: state.status,
                    onChanged: controller.setStatus,
                  ),
                ),
              ),
              if (state.error != null && state.hasContent)
                SliverToBoxAdapter(
                  child: HotelInlineErrorNotice(onRetry: controller.refresh),
                ),
              if (state.isLoading && !state.hasContent)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.error != null && !state.hasContent)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: HotelFullPageError(onRetry: controller.refresh),
                )
              else if (state.orders.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      context.l10n.hotelOrdersEmpty,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverList.separated(
                    itemCount: state.orders.length + (state.hasMore ? 1 : 0),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index >= state.orders.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: HotelOrderListLoadMoreButton(
                            isLoading: state.isLoadingMore,
                            onPressed: controller.loadMore,
                          ),
                        );
                      }
                      final order = state.orders[index];
                      void openDetail() {
                        if (order.id.isEmpty) {
                          return;
                        }
                        context.push(
                          '/hotel-booking/orders/${Uri.encodeComponent(order.id)}',
                        );
                      }

                      Future<void> openPayment() async {
                        if (order.id.isEmpty) {
                          return;
                        }
                        final paid = await context.push<bool>(
                          '/hotel-booking/payment',
                          extra: HotelPaymentRouteArgs(
                            orderId: order.id,
                            totalAmount: order.totalAmount ?? 0,
                            initialPaymentMethod: hotelPaymentMethodFromCode(
                              order.payCode,
                            ),
                            redirectToOrderDetailOnSuccess: false,
                          ),
                        );
                        if (paid == true) {
                          await controller.refresh();
                        }
                      }

                      return HotelOrderSummaryCard(
                        order: order,
                        presenter: presenter,
                        onTap: openDetail,
                        onCancel: () => _runCancelOrderFlow(
                          context: context,
                          ref: ref,
                          controller: controller,
                          languageCode: languageCode,
                          orderId: order.id,
                        ),
                        onPay: openPayment,
                        onPaymentCountdownExpired: () =>
                            controller.markPaymentExpired(order.id),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _runCancelOrderFlow({
  required BuildContext context,
  required WidgetRef ref,
  required HotelOrderListController controller,
  required String languageCode,
  required String orderId,
}) async {
  final trimmedOrderId = orderId.trim();
  if (trimmedOrderId.isEmpty) {
    return;
  }
  final l10n = context.l10n;
  try {
    final rule = await ref.read(fetchHotelOrderCancelRuleUseCaseProvider)(
      languageCode: languageCode,
      orderId: trimmedOrderId,
    );
    if (!context.mounted) {
      return;
    }
    final shouldCancel = await AppDialogs.showAdaptiveAlert<bool>(
      context: context,
      title: l10n.hotelOrdersCancelAction,
      message: rule.message,
      barrierDismissible: false,
      actions: rule.canCancel
          ? <AppDialogAction<bool>>[
              AppDialogAction<bool>(label: l10n.commonCancel, value: false),
              AppDialogAction<bool>(
                label: l10n.commonOk,
                value: true,
                isDefaultAction: true,
              ),
            ]
          : <AppDialogAction<bool>>[
              AppDialogAction<bool>(
                label: l10n.commonOk,
                value: false,
                isDefaultAction: true,
              ),
            ],
    );
    if (!context.mounted || !rule.canCancel || shouldCancel != true) {
      return;
    }
    final message = await ref.read(cancelHotelOrderUseCaseProvider)(
      languageCode: languageCode,
      orderId: trimmedOrderId,
    );
    if (!context.mounted) {
      return;
    }
    AppNotice.show(
      context,
      message: message.trim().isEmpty ? l10n.hotelOrdersCancelFailed : message,
    );
    await controller.refresh();
  } catch (error) {
    if (!context.mounted) {
      return;
    }
    AppNotice.show(context, message: _cancelErrorMessage(error, l10n));
  }
}

String _cancelErrorMessage(Object error, AppLocalizations l10n) {
  if (error is StateError) {
    final message = error.message.trim();
    if (message.isNotEmpty) {
      return message;
    }
  }
  return l10n.hotelOrdersCancelFailed;
}
