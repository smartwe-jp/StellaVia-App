import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../member_profile/presentation/support/member_profile_action_guard.dart';
import '../../domain/entities/hotel_models.dart';
import '../controllers/hotel_detail_selection_controller.dart';
import '../providers/hotel_booking_providers.dart';
import '../providers/hotel_detail_membership_provider.dart';
import '../providers/hotel_management_providers.dart';
import '../support/hotel_detail_route_args.dart';
import '../widgets/hotel_detail_redesign_content.dart';
import '../widgets/hotel_search_condition_pickers.dart';
import '../widgets/hotel_state_views.dart';
import 'legacy_hotel_detail_page.dart';

class HotelDetailPage extends ConsumerStatefulWidget {
  const HotelDetailPage({
    super.key,
    required this.hotelId,
    required this.initialCriteria,
    this.buildingCode,
    this.mode = HotelBookingMode.regular,
  });
  final String hotelId;
  final HotelSearchCriteria initialCriteria;
  final String? buildingCode;
  final HotelBookingMode mode;
  @override
  ConsumerState<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends ConsumerState<HotelDetailPage>
    with SingleTickerProviderStateMixin {
  late final AppScrollChromeController _chrome;
  late HotelSearchCriteria _criteria;
  @override
  void initState() {
    super.initState();
    _criteria = widget.initialCriteria;
    _chrome = AppScrollChromeController(vsync: this);
  }

  @override
  void dispose() {
    _chrome.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HotelDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hotelId != widget.hotelId ||
        oldWidget.initialCriteria != widget.initialCriteria ||
        oldWidget.mode != widget.mode) {
      _criteria = widget.initialCriteria;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mode == HotelBookingMode.regular && _criteria.stayBenefit) {
      return LegacyHotelDetailPage(
        hotelId: widget.hotelId,
        initialCriteria: _criteria,
        buildingCode: widget.buildingCode,
      );
    }
    final query = HotelDetailQuery(
      hotelId: widget.hotelId,
      criteria: _criteria,
    );
    final detail = ref.watch(hotelDetailProvider(query));
    final identity = ref.watch(hotelManagementIdentityProvider);
    final language = ref.watch(hotelLocaleLanguageCodeProvider);
    final navigationBar = AppNavigationBar(
      title: context.l10n.hotelHomeTitle,
      backgroundColor: context.appColors.surface,
      foregroundColor: context.appColors.textPrimary,
      leading: AppNavigationIconButton(
        icon: Icons.arrow_back_rounded,
        backgroundColor: context.appColors.surface.withValues(alpha: 0),
        foregroundColor: context.appColors.textPrimary,
        onTap: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/hotel-booking');
          }
        },
      ),
    );
    final content = detail.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => HotelFullPageError(
        onRetry: () => ref.invalidate(hotelDetailProvider(query)),
      ),
      data: (value) => HotelDetailSession(
        key: ValueKey((value, _criteria, identity, language, widget.mode)),
        detail: value,
        criteria: _criteria,
        mode: widget.mode,
        onDates: () async {
          final next = await pickHotelStayDates(
            context: context,
            criteria: _criteria,
            priceCalendarByDate: value.priceCalendarByDate,
            selectionMode: HotelStayDateSelectionMode.range,
          );
          if (next != null && mounted) setState(() => _criteria = next);
        },
        onGuests: () async {
          final next = await editHotelGuests(
            context: context,
            criteria: _criteria,
            includeRooms: false,
          );
          if (next != null && mounted) setState(() => _criteria = next);
        },
      ),
    );
    return AppScrollChromeScope(
      controller: _chrome,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.depth == 0) {
            _chrome.handleScrollNotification(notification);
          }
          return false;
        },
        child: AnimatedBuilder(
          animation: _chrome,
          child: content,
          builder: (context, child) => Scaffold(
            appBar: AppScrollNavigationBar(
              navigationBar: navigationBar,
              reveal: _chrome.value,
              backgroundColor: context.appColors.surface,
            ),
            body: child,
          ),
        ),
      ),
    );
  }
}

class HotelDetailSession extends ConsumerStatefulWidget {
  const HotelDetailSession({
    super.key,
    required this.detail,
    required this.criteria,
    required this.mode,
    required this.onDates,
    required this.onGuests,
  });
  final HotelDetail detail;
  final HotelSearchCriteria criteria;
  final HotelBookingMode mode;
  final VoidCallback onDates;
  final VoidCallback onGuests;
  @override
  ConsumerState<HotelDetailSession> createState() => _HotelDetailSessionState();
}

class _HotelDetailSessionState extends ConsumerState<HotelDetailSession> {
  late final HotelDetailSelectionController selection;
  bool _openingConfirmation = false;
  @override
  void initState() {
    super.initState();
    selection = HotelDetailSelectionController(
      detail: widget.detail,
      criteria: widget.criteria,
      mode: widget.mode,
      languageCode: ref.read(hotelLocaleLanguageCodeProvider),
      assign: (rooms) => ref.read(assignHotelOccupancyUseCaseProvider)(
        hotelId: widget.detail.id,
        criteria: widget.criteria,
        selectedRooms: rooms,
        languageCode: ref.read(hotelLocaleLanguageCodeProvider),
      ),
      quote: (request) =>
          ref.read(quoteHotelBookingPriceUseCaseProvider)(request),
    );
  }

  @override
  void dispose() {
    selection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final identity = ref.watch(hotelManagementIdentityProvider);
    final miles = widget.mode == HotelBookingMode.hostMiles;
    final tier = miles && identity != null
        ? ref.watch(hotelManagementTierResourceProvider(identity))
        : null;
    final account = miles && identity != null
        ? ref.watch(hotelDetailAccountProvider(identity))
        : null;
    return ListenableBuilder(
      listenable: selection,
      builder: (context, _) => HotelDetailRedesignContent(
        detail: widget.detail,
        criteria: widget.criteria,
        selection: selection,
        tier: tier?.valueOrNull,
        account: account?.valueOrNull,
        membershipFailed:
            (tier?.hasError ?? false) || (account?.hasError ?? false),
        onMembershipRetry: () {
          if (identity == null) {
            context.push('/login');
            return;
          }
          ref.invalidate(hotelManagementTierResourceProvider(identity));
          ref.invalidate(hotelDetailAccountProvider(identity));
        },
        onDates: widget.onDates,
        onGuests: widget.onGuests,
        openingConfirmation: _openingConfirmation,
        onBook: _book,
      ),
    );
  }

  Future<void> _book() async {
    if (widget.mode != HotelBookingMode.regular ||
        selection.busy ||
        _openingConfirmation ||
        selection.roomCount == 0) {
      return;
    }
    if (ref.read(isAuthenticatedProvider).asData?.value != true) {
      context.push('/login');
      return;
    }
    setState(() => _openingConfirmation = true);
    try {
      final allowed = await ref
          .read(memberProfileActionGuardProvider)
          .ensureCompleted(
            context,
            actionLabel: context.l10n.hotelDetailBookNow,
          );
      if (!mounted || !allowed) return;
      await selection.refreshQuote();
      if (!mounted) return;
      final assigned = selection.assignment;
      if (selection.failed || assigned == null || (assigned.price ?? 0) <= 0) {
        AppNotice.show(
          context,
          message: context.l10n.hotelAssignOccupancyFailed,
        );
        return;
      }
      if (assigned.message.trim().isNotEmpty) {
        final confirmed = await AppDialogs.showAdaptiveAlert<bool>(
          context: context,
          title: context.l10n.hotelAssignOccupancyDialogTitle,
          message: assigned.message,
          actions: [
            AppDialogAction<bool>(
              label: context.l10n.commonCancel,
              value: false,
            ),
            AppDialogAction<bool>(
              label: context.l10n.hotelAssignOccupancyDialogConfirm,
              value: true,
              isDefaultAction: true,
            ),
          ],
        );
        if (!mounted || confirmed != true) return;
      }
      await context.push(
        '/hotel-booking/${Uri.encodeComponent(widget.detail.id)}/confirm',
        extra: HotelBookingConfirmSeed(
          detail: widget.detail,
          criteria: widget.criteria.copyWith(stayBenefit: false),
          selectedRooms: selection.selections,
          assignedPrice: assigned.price,
          roomTypeCustNums: assigned.roomTypeCustNums,
        ),
      );
    } finally {
      if (mounted) setState(() => _openingConfirmation = false);
    }
  }
}
