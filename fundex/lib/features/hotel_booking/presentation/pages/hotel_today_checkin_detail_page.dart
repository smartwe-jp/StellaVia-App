import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/support/app_request_error_message_resolver.dart';
import '../providers/hotel_booking_providers.dart';
import '../widgets/hotel_state_views.dart';
import '../widgets/hotel_today_checkin_detail_widgets.dart';

class HotelTodayCheckInDetailPage extends ConsumerStatefulWidget {
  const HotelTodayCheckInDetailPage({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<HotelTodayCheckInDetailPage> createState() =>
      _HotelTodayCheckInDetailPageState();
}

class _HotelTodayCheckInDetailPageState
    extends ConsumerState<HotelTodayCheckInDetailPage> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final detailState = ref.watch(hotelOrderDetailProvider(widget.orderId));

    return Scaffold(
      appBar: AppNavigationBar(
        title: context.l10n.hotelTodayCheckInTitle,
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.go('/hotel-booking/check-in');
          },
          backgroundColor: colors.surface.withValues(alpha: 0),
          foregroundColor: colors.textPrimary,
        ),
      ),
      body: detailState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => HotelFullPageError(
          onRetry: () =>
              ref.invalidate(hotelOrderDetailProvider(widget.orderId)),
        ),
        data: (detail) => HotelTodayCheckInDetailContent(
          detail: detail,
          onCheckIn: (roomId) => _runCheckStatus(
            orderId: detail.summary.id,
            checkedIn: 1,
            roomId: roomId,
          ),
          onCheckOut: (roomId) => _runCheckStatus(
            orderId: detail.summary.id,
            checkedIn: 2,
            roomId: roomId,
          ),
        ),
      ),
    );
  }

  Future<void> _runCheckStatus({
    required String orderId,
    required int checkedIn,
    String? roomId,
  }) async {
    final trimmedOrderId = orderId.trim();
    final trimmedRoomId = roomId?.trim();
    if (trimmedOrderId.isEmpty) {
      return;
    }
    final l10n = context.l10n;
    final isCheckOut = checkedIn == 2;
    final confirmed = await AppDialogs.showAdaptiveAlert<bool>(
      context: context,
      title: isCheckOut
          ? l10n.hotelTodayCheckOutDialogTitle
          : l10n.hotelTodayCheckInDialogTitle,
      message: isCheckOut
          ? l10n.hotelTodayCheckOutDialogMessage
          : l10n.hotelTodayCheckInDialogMessage,
      barrierDismissible: false,
      actions: <AppDialogAction<bool>>[
        AppDialogAction<bool>(label: l10n.commonCancel, value: false),
        AppDialogAction<bool>(
          label: l10n.commonConfirm,
          value: true,
          isDefaultAction: true,
        ),
      ],
    );
    if (!mounted || confirmed != true) {
      return;
    }
    try {
      await AppLoadingDialog.run(
        context,
        () => ref.read(checkInHotelOrderCustomerUseCaseProvider)(
          orderId: trimmedOrderId,
          checkedIn: checkedIn,
          roomId: trimmedRoomId?.isEmpty == true ? null : trimmedRoomId,
        ),
        message: l10n.commonPleaseWait,
      );
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: isCheckOut
            ? l10n.hotelTodayCheckOutSuccess
            : l10n.hotelTodayCheckInSuccess,
      );
      ref.invalidate(hotelOrderDetailProvider(widget.orderId));
      ref.invalidate(hotelTodayCheckInControllerProvider);
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: resolveAppRequestErrorMessage(
          error,
          isCheckOut
              ? l10n.hotelTodayCheckOutFailed
              : l10n.hotelTodayCheckInFailed,
        ),
      );
    }
  }
}
