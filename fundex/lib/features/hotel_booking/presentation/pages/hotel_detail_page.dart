import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../member_profile/presentation/support/member_profile_action_guard.dart';
import '../../domain/entities/hotel_models.dart';
import '../providers/hotel_booking_providers.dart';
import '../support/hotel_booking_presenter.dart';
import '../widgets/hotel_detail_bottom_bar.dart';
import '../widgets/hotel_detail_hero_gallery.dart';
import '../widgets/hotel_detail_info_section.dart';
import '../widgets/hotel_detail_map_section.dart';
import '../widgets/hotel_detail_stay_summary_bar.dart';
import '../widgets/hotel_remaining_rooms_label.dart';
import '../widgets/hotel_room_detail_sheet.dart';
import '../widgets/hotel_room_plan_card.dart';
import '../widgets/hotel_room_list_notice_card.dart';
import '../widgets/hotel_search_condition_pickers.dart';
import '../widgets/hotel_state_views.dart';

class HotelDetailPage extends ConsumerStatefulWidget {
  const HotelDetailPage({
    super.key,
    required this.hotelId,
    required this.initialCriteria,
  });

  final String hotelId;
  final HotelSearchCriteria initialCriteria;

  @override
  ConsumerState<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends ConsumerState<HotelDetailPage> {
  final Map<String, int> _roomQuantities = <String, int>{};
  final Set<String> _expandedInfoSectionIds = <String>{};
  late HotelSearchCriteria _criteria;
  int _criteriaRevision = 0;
  bool _isAssigningOccupancy = false;
  HotelAssignOccupancyResult? _assignOccupancyResult;

  @override
  void initState() {
    super.initState();
    _criteria = widget.initialCriteria;
  }

  @override
  void didUpdateWidget(covariant HotelDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hotelId == widget.hotelId &&
        _sameCriteria(oldWidget.initialCriteria, widget.initialCriteria)) {
      return;
    }
    _criteria = widget.initialCriteria;
    _resetRoomSelection();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final presenter = HotelBookingPresenter(
      Localizations.localeOf(context).toLanguageTag(),
    );
    final query = HotelDetailQuery(
      hotelId: widget.hotelId,
      criteria: _criteria,
    );
    final detailState = ref.watch(hotelDetailProvider(query));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: colors.scrim.withValues(alpha: 0),
        systemNavigationBarColor: colors.brandWhite,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: ColoredBox(
          color: colors.surfaceAlt,
          child: detailState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => HotelFullPageError(
              onRetry: () => ref.refresh(hotelDetailProvider(query)),
            ),
            data: (detail) => _HotelDetailContent(
              detail: detail,
              criteria: _criteria,
              presenter: presenter,
              roomQuantities: _roomQuantities,
              expandedInfoSectionIds: _expandedInfoSectionIds,
              assignedPrice: _assignOccupancyResult?.price,
              isAssigningOccupancy: _isAssigningOccupancy,
              onBack: _handleBack,
              onEditDates: _editStayDates,
              onEditGuests: _editGuests,
              onInfoSectionExpandedChanged: _setInfoSectionExpanded,
              onRoomQuantityChanged: (change) =>
                  _setRoomQuantity(detail, change.key, change.value),
              onBookNow: () => _handleBookNow(detail),
            ),
          ),
        ),
      ),
    );
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go('/hotel-booking');
  }

  Future<void> _editStayDates() async {
    final nextCriteria = await pickHotelStayDates(
      context: context,
      criteria: _criteria,
    );
    if (nextCriteria == null || !mounted) {
      return;
    }
    _applyCriteria(nextCriteria);
  }

  Future<void> _editGuests() async {
    final nextCriteria = await editHotelGuests(
      context: context,
      criteria: _criteria,
      includeRooms: false,
    );
    if (nextCriteria == null || !mounted) {
      return;
    }
    _applyCriteria(nextCriteria);
  }

  void _applyCriteria(HotelSearchCriteria nextCriteria) {
    if (_sameCriteria(_criteria, nextCriteria)) {
      return;
    }
    setState(() {
      _criteria = nextCriteria;
      _resetRoomSelection();
    });
  }

  void _setInfoSectionExpanded(String sectionId, bool expanded) {
    setState(() {
      if (expanded) {
        _expandedInfoSectionIds.add(sectionId);
      } else {
        _expandedInfoSectionIds.remove(sectionId);
      }
    });
  }

  Future<void> _setRoomQuantity(
    HotelDetail detail,
    String key,
    int value,
  ) async {
    if (_isAssigningOccupancy) {
      return;
    }
    final nextQuantities = Map<String, int>.from(_roomQuantities);
    if (value <= 0) {
      nextQuantities.remove(key);
    } else {
      nextQuantities[key] = value;
    }
    final nextSelections = _selectedRoomsFor(detail, nextQuantities);
    if (nextSelections.isEmpty) {
      setState(() {
        _roomQuantities.clear();
        _assignOccupancyResult = null;
      });
      return;
    }

    final requestCriteria = _criteria;
    final requestRevision = _criteriaRevision;
    setState(() {
      _isAssigningOccupancy = true;
    });
    try {
      final result = await ref.read(assignHotelOccupancyUseCaseProvider)(
        hotelId: detail.id,
        criteria: requestCriteria,
        selectedRooms: nextSelections,
        languageCode: ref.read(hotelLocaleLanguageCodeProvider),
      );
      if (!mounted) {
        return;
      }
      if (requestRevision != _criteriaRevision) {
        return;
      }
      setState(() {
        _roomQuantities
          ..clear()
          ..addAll(nextQuantities);
        _assignOccupancyResult = result;
        _isAssigningOccupancy = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      if (requestRevision != _criteriaRevision) {
        return;
      }
      setState(() {
        _isAssigningOccupancy = false;
      });
      AppNotice.show(context, message: context.l10n.hotelAssignOccupancyFailed);
    }
  }

  Future<void> _handleBookNow(HotelDetail detail) async {
    final selectedRooms = _selectedRoomsFor(detail, _roomQuantities);
    if (selectedRooms.isEmpty) {
      AppNotice.show(context, message: context.l10n.hotelDetailSelectRoomFirst);
      return;
    }
    final isAuthenticated =
        ref.read(isAuthenticatedProvider).asData?.value ?? false;
    if (!mounted) {
      return;
    }
    if (!isAuthenticated) {
      context.push('/login');
      return;
    }
    final allowed = await ref
        .read(memberProfileActionGuardProvider)
        .ensureCompleted(context, actionLabel: context.l10n.hotelDetailBookNow);
    if (!mounted || !allowed) {
      return;
    }

    if (_isAssigningOccupancy) {
      return;
    }
    final finalAssignResult = await _runFinalAssignOccupancyCheck(
      detail,
      selectedRooms,
    );
    if (!mounted || finalAssignResult == null) {
      return;
    }
    final assignMessage = finalAssignResult.message.trim();
    if (assignMessage.isNotEmpty) {
      final shouldContinue = await _showAssignOccupancyMessageDialog(
        assignMessage,
      );
      if (!mounted || !shouldContinue) {
        return;
      }
    }

    context.push(
      '/hotel-booking/${Uri.encodeComponent(detail.id)}/confirm',
      extra: HotelBookingConfirmSeed(
        detail: detail,
        criteria: _criteria,
        selectedRooms: selectedRooms,
        assignedPrice: finalAssignResult.price,
      ),
    );
  }

  Future<HotelAssignOccupancyResult?> _runFinalAssignOccupancyCheck(
    HotelDetail detail,
    List<HotelSelectedRoom> selectedRooms,
  ) async {
    final requestCriteria = _criteria;
    final requestRevision = _criteriaRevision;
    setState(() {
      _isAssigningOccupancy = true;
    });
    try {
      final result = await ref.read(assignHotelOccupancyUseCaseProvider)(
        hotelId: detail.id,
        criteria: requestCriteria,
        selectedRooms: selectedRooms,
        languageCode: ref.read(hotelLocaleLanguageCodeProvider),
      );
      if (!mounted || requestRevision != _criteriaRevision) {
        return null;
      }
      setState(() {
        _assignOccupancyResult = result;
        _isAssigningOccupancy = false;
      });
      return result;
    } catch (_) {
      if (!mounted || requestRevision != _criteriaRevision) {
        return null;
      }
      setState(() {
        _isAssigningOccupancy = false;
      });
      AppNotice.show(context, message: context.l10n.hotelAssignOccupancyFailed);
      return null;
    }
  }

  Future<bool> _showAssignOccupancyMessageDialog(String message) async {
    final result = await AppDialogs.showAdaptiveAlert<bool>(
      context: context,
      title: context.l10n.hotelAssignOccupancyDialogTitle,
      message: message,
      actions: <AppDialogAction<bool>>[
        AppDialogAction<bool>(label: context.l10n.commonCancel, value: false),
        AppDialogAction<bool>(
          label: context.l10n.hotelAssignOccupancyDialogConfirm,
          value: true,
          isDefaultAction: true,
        ),
      ],
    );
    return result ?? false;
  }

  List<HotelSelectedRoom> _selectedRoomsFor(
    HotelDetail detail,
    Map<String, int> quantities,
  ) {
    final selectedRooms = <HotelSelectedRoom>[];
    for (var index = 0; index < detail.roomPlans.length; index++) {
      final room = detail.roomPlans[index];
      final quantity = quantities[_roomKey(room, index)] ?? 0;
      if (quantity > 0) {
        selectedRooms.add(HotelSelectedRoom(room: room, quantity: quantity));
      }
    }
    return selectedRooms;
  }

  void _resetRoomSelection() {
    _criteriaRevision += 1;
    _roomQuantities.clear();
    _assignOccupancyResult = null;
    _isAssigningOccupancy = false;
  }
}

class _HotelDetailContent extends StatelessWidget {
  const _HotelDetailContent({
    required this.detail,
    required this.criteria,
    required this.presenter,
    required this.roomQuantities,
    required this.expandedInfoSectionIds,
    required this.assignedPrice,
    required this.isAssigningOccupancy,
    required this.onBack,
    required this.onEditDates,
    required this.onEditGuests,
    required this.onInfoSectionExpandedChanged,
    required this.onRoomQuantityChanged,
    required this.onBookNow,
  });

  final HotelDetail detail;
  final HotelSearchCriteria criteria;
  final HotelBookingPresenter presenter;
  final Map<String, int> roomQuantities;
  final Set<String> expandedInfoSectionIds;
  final num? assignedPrice;
  final bool isAssigningOccupancy;
  final VoidCallback onBack;
  final VoidCallback onEditDates;
  final VoidCallback onEditGuests;
  final void Function(String sectionId, bool expanded)
  onInfoSectionExpandedChanged;
  final ValueChanged<_RoomQuantityChange> onRoomQuantityChanged;
  final VoidCallback onBookNow;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final selectedRooms = _selectedRooms;
    final amount = _payableAmount;
    final roomsForNote = _usesRoomPlanSelection
        ? selectedRooms
        : criteria.roomCount;

    return Stack(
      children: <Widget>[
        CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  HotelDetailHeroGallery(images: detail.images, onBack: onBack),
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: HotelDetailStaySummaryBar(
                        criteria: criteria,
                        presenter: presenter,
                        onDatesTap: onEditDates,
                        onGuestsTap: onEditGuests,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
              sliver: SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  _HotelDetailHeading(detail: detail),
                  const SizedBox(height: 24),
                  _AvailableRoomsHeader(detail: detail),
                  if (detail.checkInMessage.trim().isNotEmpty) ...<Widget>[
                    const SizedBox(height: 12),
                    HotelRoomListNoticeCard(message: detail.checkInMessage),
                  ],
                  const SizedBox(height: 14),
                  if (detail.roomPlans.isEmpty)
                    _NoRoomsNotice(colors: colors)
                  else
                    ...List<Widget>.generate(detail.roomPlans.length, (index) {
                      final room = detail.roomPlans[index];
                      final key = _roomKey(room, index);
                      final quantity = roomQuantities[key] ?? 0;
                      final remainingRooms = room.remainingRooms;
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == detail.roomPlans.length - 1 ? 0 : 14,
                        ),
                        child: HotelRoomPlanCard(
                          room: room,
                          presenter: presenter,
                          quantity: quantity,
                          nights: criteria.nights,
                          isBusy: isAssigningOccupancy,
                          onTap: () => showHotelRoomDetailSheet(
                            context: context,
                            detail: detail,
                            room: room,
                          ),
                          onDecrement: () => onRoomQuantityChanged(
                            _RoomQuantityChange(key, quantity - 1),
                          ),
                          onIncrement: () {
                            if (remainingRooms != null &&
                                quantity >= remainingRooms) {
                              return;
                            }
                            onRoomQuantityChanged(
                              _RoomQuantityChange(key, quantity + 1),
                            );
                          },
                        ),
                      );
                    }),
                  const SizedBox(height: 18),
                  ..._detailInfoSections(context),
                  const SizedBox(height: 122),
                ]),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: HotelDetailBottomBar(
            amount: amount,
            nights: criteria.nights,
            rooms: roomsForNote,
            presenter: presenter,
            isLoading: isAssigningOccupancy,
            onBookNow: onBookNow,
          ),
        ),
      ],
    );
  }

  int get _selectedRooms {
    var selectedRooms = 0;
    for (var index = 0; index < detail.roomPlans.length; index++) {
      selectedRooms +=
          roomQuantities[_roomKey(detail.roomPlans[index], index)] ?? 0;
    }
    return selectedRooms;
  }

  num? get _payableAmount {
    if (assignedPrice != null) {
      return assignedPrice;
    }
    num selectedTotal = 0;
    var hasSelection = false;
    for (var index = 0; index < detail.roomPlans.length; index++) {
      final room = detail.roomPlans[index];
      final quantity = roomQuantities[_roomKey(room, index)] ?? 0;
      if (quantity <= 0) {
        continue;
      }
      hasSelection = true;
      selectedTotal += (room.price ?? 0) * quantity;
    }
    if (hasSelection) {
      return selectedTotal;
    }
    if (_usesRoomPlanSelection) {
      return 0;
    }
    return detail.lowestRoomPrice;
  }

  bool get _usesRoomPlanSelection {
    return detail.bookingType == 0 || detail.roomPlans.isNotEmpty;
  }

  List<Widget> _detailInfoSections(BuildContext context) {
    final sections = <Widget>[];
    void addTextSection(
      String sectionId,
      String title,
      String body,
      IconData icon,
    ) {
      if (body.trim().isEmpty) {
        return;
      }
      sections.add(
        HotelDetailInfoSection(
          title: title,
          body: body,
          icon: icon,
          expanded: expandedInfoSectionIds.contains(sectionId),
          onExpandedChanged: (expanded) =>
              onInfoSectionExpandedChanged(sectionId, expanded),
        ),
      );
    }

    addTextSection(
      'checkInGuide',
      context.l10n.hotelDetailCheckInGuide,
      detail.checkInGuide,
      Icons.fact_check_outlined,
    );
    if (HotelDetailMapSection.canShow(detail)) {
      sections.add(HotelDetailMapSection(detail: detail));
    }
    addTextSection(
      'checkInTime',
      context.l10n.hotelDetailCheckInTime,
      _checkInOutTimeText(context),
      Icons.schedule_outlined,
    );
    if (detail.facilities.isNotEmpty) {
      sections.add(
        HotelDetailFacilitySection(
          title: context.l10n.hotelDetailFacilities,
          facilities: detail.facilities,
        ),
      );
    }
    addTextSection(
      'description',
      context.l10n.hotelDetailDescription,
      detail.detailText.isNotEmpty ? detail.detailText : detail.description,
      Icons.notes_outlined,
    );
    addTextSection(
      'surrounding',
      context.l10n.hotelDetailSurrounding,
      detail.surroundingText,
      Icons.apartment_outlined,
    );
    addTextSection(
      'travel',
      context.l10n.hotelDetailTravel,
      detail.travelText,
      Icons.route_outlined,
    );
    addTextSection(
      'policy',
      context.l10n.hotelDetailPolicy,
      detail.ruleText,
      Icons.rule_outlined,
    );
    addTextSection(
      'refundPolicy',
      context.l10n.hotelDetailRefundPolicy,
      detail.refundPolicyText,
      Icons.currency_exchange_outlined,
    );
    addTextSection(
      'contact',
      context.l10n.hotelDetailContact,
      detail.telNo,
      Icons.call_outlined,
    );

    return sections
        .expand((section) => <Widget>[section, const SizedBox(height: 12)])
        .toList(growable: false);
  }

  String _checkInOutTimeText(BuildContext context) {
    final values = <String>[
      if (detail.checkInTime.isNotEmpty)
        context.l10n.hotelDetailCheckInAfter(detail.checkInTime),
      if (detail.checkOutTime.isNotEmpty)
        context.l10n.hotelDetailCheckOutBefore(detail.checkOutTime),
    ];
    return values.join('\n');
  }
}

class _HotelDetailHeading extends StatelessWidget {
  const _HotelDetailHeading({required this.detail});

  final HotelDetail detail;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final subtitle = <String>[
      if (detail.address.isNotEmpty) detail.address,
      if (detail.description.isNotEmpty) detail.description,
    ].join(' · ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          detail.name.isEmpty ? context.l10n.hotelUnnamedProperty : detail.name,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: colors.brandPrimaryDark,
            fontWeight: FontWeight.w900,
            height: 1.08,
          ),
        ),
        if (subtitle.isNotEmpty) ...<Widget>[
          const SizedBox(height: 12),
          Text(
            subtitle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
        ],
      ],
    );
  }
}

class _AvailableRoomsHeader extends StatelessWidget {
  const _AvailableRoomsHeader({required this.detail});

  final HotelDetail detail;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final remainingRooms = detail.roomPlans
        .map((room) => room.remainingRooms)
        .whereType<int>()
        .fold<int>(0, (sum, value) => sum + value);
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            context.l10n.hotelDetailAvailableRooms,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colors.brandPrimaryDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        HotelRemainingRoomsLabel(
          count: remainingRooms,
          textAlign: TextAlign.end,
        ),
      ],
    );
  }
}

class _NoRoomsNotice extends StatelessWidget {
  const _NoRoomsNotice({required this.colors});

  final AppSemanticColorTheme colors;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.brandWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          context.l10n.hotelDetailNoRooms,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _RoomQuantityChange {
  const _RoomQuantityChange(this.key, this.value);

  final String key;
  final int value;
}

String _roomKey(HotelRoomPlan room, int index) {
  final id = room.id.trim();
  if (id.isNotEmpty) {
    return id;
  }
  return '${room.name}-$index';
}

bool _sameCriteria(HotelSearchCriteria a, HotelSearchCriteria b) {
  return a.checkInDate == b.checkInDate &&
      a.checkOutDate == b.checkOutDate &&
      a.keyword == b.keyword &&
      a.area == b.area &&
      a.bookingType == b.bookingType &&
      a.buildingCode == b.buildingCode &&
      a.priceSort == b.priceSort &&
      a.occupancy == b.occupancy &&
      a.kids == b.kids &&
      a.roomCount == b.roomCount;
}
