import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import 'hotel_detail_image_placeholder.dart';

Future<void> showHotelRoomDetailSheet({
  required BuildContext context,
  required HotelDetail detail,
  required HotelRoomPlan room,
}) {
  final colors = Theme.of(context).appColors;
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: colors.scrim.withValues(alpha: 0),
    builder: (sheetContext) {
      final topPadding = MediaQuery.paddingOf(sheetContext).top;
      return Padding(
        padding: EdgeInsets.only(top: topPadding + 12),
        child: FractionallySizedBox(
          heightFactor: 0.88,
          alignment: Alignment.bottomCenter,
          child: _HotelRoomDetailSheet(detail: detail, room: room),
        ),
      );
    },
  );
}

class _HotelRoomDetailSheet extends StatelessWidget {
  const _HotelRoomDetailSheet({required this.detail, required this.room});

  final HotelDetail detail;
  final HotelRoomPlan room;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final description = _plainTextFromHtml(room.description);
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Material(
        color: colors.brandWhite,
        child: Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: _RoomGallery(
                    images: room.images.isEmpty ? detail.images : room.images,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 24, 18, 22),
                    child: _RoomHeader(detail: detail, room: room),
                  ),
                ),
                SliverToBoxAdapter(child: _SectionDivider(colors: colors)),
                if (room.facilityCategories.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _FacilitySection(
                      categories: room.facilityCategories,
                    ),
                  ),
                if (description.isNotEmpty) ...<Widget>[
                  SliverToBoxAdapter(child: _SectionDivider(colors: colors)),
                  SliverToBoxAdapter(
                    child: _DescriptionSection(description: description),
                  ),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 28)),
              ],
            ),
            Positioned(
              top: 12,
              right: 12,
              child: _CloseButton(onPressed: () => Navigator.of(context).pop()),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomGallery extends StatefulWidget {
  const _RoomGallery({required this.images});

  final List<HotelDetailImage> images;

  @override
  State<_RoomGallery> createState() => _RoomGalleryState();
}

class _RoomGalleryState extends State<_RoomGallery> {
  late final PageController _pageController;
  int _currentIndex = 0;

  List<String> get _imageUrls => widget.images
      .map((image) => image.url.trim())
      .where((url) => url.isNotEmpty)
      .toList(growable: false);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final imageUrls = _imageUrls;
    final dotCount = imageUrls.length > 5 ? 5 : imageUrls.length;
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (imageUrls.isEmpty)
            const HotelDetailImagePlaceholder(iconSize: 44)
          else
            FundHeroMediaBackground(
              gradientColors: <Color>[colors.heroMiddle, colors.primaryAlt],
              imageUrls: imageUrls,
              showArtworkOverlay: false,
              pageController: _pageController,
              autoPlay: false,
              onImageTap: (index) => _openImageViewer(context, index),
              onPageChanged: (index) => setState(() => _currentIndex = index),
            ),
          if (imageUrls.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 18,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(dotCount, (index) {
                  final selectedIndex = _currentIndex >= dotCount
                      ? dotCount - 1
                      : _currentIndex;
                  final selected = index == selectedIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: selected ? 12 : 8,
                    height: selected ? 12 : 8,
                    decoration: BoxDecoration(
                      color: selected
                          ? colors.brandWhite
                          : colors.brandWhite.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openImageViewer(BuildContext context, int initialIndex) {
    final imageUrls = _imageUrls;
    return openAppImageViewer(
      context,
      initialIndex: initialIndex,
      items: imageUrls
          .map((url) => AppImageViewerItem(source: url))
          .toList(growable: false),
      texts: AppImageViewerTexts(
        loadingLabel: context.l10n.imageViewerLoadingLabel,
        loadFailedLabel: context.l10n.imageViewerLoadFailedLabel,
        retryLabel: context.l10n.imageViewerRetryLabel,
        invalidSourceNotice: context.l10n.imageViewerInvalidSourceNotice,
        closeTooltip: context.l10n.imageViewerCloseTooltip,
      ),
    );
  }
}

class _RoomHeader extends StatelessWidget {
  const _RoomHeader({required this.detail, required this.room});

  final HotelDetail detail;
  final HotelRoomPlan room;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final facts = _roomFacts(context, room);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          room.name.isEmpty ? context.l10n.hotelUnnamedProperty : room.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w800,
            height: 1.16,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          detail.name.isEmpty ? context.l10n.hotelUnnamedProperty : detail.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: colors.textTertiary,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (facts.isNotEmpty) ...<Widget>[
          const SizedBox(height: 16),
          Wrap(
            spacing: 14,
            runSpacing: 12,
            children: facts
                .map((fact) => _FactItem(icon: fact.icon, label: fact.label))
                .toList(growable: false),
          ),
        ],
      ],
    );
  }
}

class _FacilitySection extends StatelessWidget {
  const _FacilitySection({required this.categories});

  final List<HotelRoomFacilityCategory> categories;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final visibleCategories = categories
        .where((category) => category.items.isNotEmpty)
        .toList(growable: false);
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 26, 18, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.l10n.hotelRoomFacilitiesTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          for (var index = 0; index < visibleCategories.length; index++) ...[
            _FacilityCategoryBlock(category: visibleCategories[index]),
            if (index != visibleCategories.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Divider(height: 1, color: colors.borderSoft),
              ),
          ],
        ],
      ),
    );
  }
}

class _FacilityCategoryBlock extends StatelessWidget {
  const _FacilityCategoryBlock({required this.category});

  final HotelRoomFacilityCategory category;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final title = category.name.trim().isNotEmpty
        ? category.name.trim()
        : _fallbackCategoryName(context, category.code);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(_categoryIcon(category.code), color: colors.textPrimary),
            const SizedBox(width: 6),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: category.items
              .map((label) => _FacilityChip(label: label))
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 26, 18, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.l10n.hotelRoomDescriptionTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colors.textPrimary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _FactItem extends StatelessWidget {
  const _FactItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 24, color: colors.textTertiary),
        const SizedBox(width: 5),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _FacilityChip extends StatelessWidget {
  const _FacilityChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(UiTokens.radius8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Material(
      color: colors.brandWhite.withValues(alpha: 0.70),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(Icons.close_rounded, color: colors.textPrimary, size: 30),
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider({required this.colors});

  final AppSemanticColorTheme colors;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: colors.surfaceAlt,
      child: const SizedBox(height: 12),
    );
  }
}

class _RoomFact {
  const _RoomFact(this.icon, this.label);

  final IconData icon;
  final String label;
}

List<_RoomFact> _roomFacts(BuildContext context, HotelRoomPlan room) {
  return <_RoomFact>[
    if (room.occupancy != null)
      _RoomFact(
        Icons.people_alt_outlined,
        context.l10n.hotelDetailRoomCapacity(room.occupancy!),
      ),
    if (room.baseOccupancy != null)
      _RoomFact(
        Icons.person_outline_rounded,
        context.l10n.hotelDetailRoomBaseOccupancy(room.baseOccupancy!),
      ),
    if (room.roomSize.isNotEmpty)
      _RoomFact(
        Icons.square_foot_outlined,
        context.l10n.hotelDetailRoomArea(room.roomSize),
      ),
    if (room.bedroomCount != null)
      _RoomFact(
        Icons.bed_outlined,
        context.l10n.hotelDetailBedrooms(room.bedroomCount!),
      ),
    if (room.bathroomCount != null)
      _RoomFact(
        Icons.bathtub_outlined,
        context.l10n.hotelDetailBathrooms(room.bathroomCount!),
      ),
    ...room.beds
        .where((bed) => bed.name.trim().isNotEmpty)
        .map(
          (bed) => _RoomFact(Icons.king_bed_outlined, _formatBed(context, bed)),
        ),
  ];
}

String _formatBed(BuildContext context, HotelRoomBed bed) {
  final unit = _isFuton(bed.name)
      ? context.l10n.hotelRoomBedUnitFuton
      : context.l10n.hotelRoomBedUnitDefault;
  final summary = context.l10n.hotelRoomBedSummary(
    bed.name.trim(),
    bed.quantity ?? 1,
    unit,
  );
  final width = _normalizeBedWidth(bed.width);
  if (width.isEmpty) {
    return summary;
  }
  return context.l10n.hotelRoomBedSummaryWithWidth(
    summary,
    context.l10n.hotelRoomBedWidth(width),
  );
}

String _fallbackCategoryName(BuildContext context, String code) {
  return switch (code.trim()) {
    'bathroomAmenities' => context.l10n.hotelRoomFacilityBathroomAmenities,
    'supplies' => context.l10n.hotelRoomFacilitySupplies,
    'lending' => context.l10n.hotelRoomFacilityLending,
    _ => context.l10n.hotelRoomFacilityGuestRoom,
  };
}

IconData _categoryIcon(String code) {
  return switch (code.trim()) {
    'bathroomAmenities' => Icons.bathtub_outlined,
    'supplies' => Icons.dry_cleaning_outlined,
    'lending' => Icons.dashboard_customize_outlined,
    _ => Icons.local_laundry_service_outlined,
  };
}

String _plainTextFromHtml(String raw) {
  return raw
      .trim()
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'</p\s*>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .join('\n');
}

String _normalizeBedWidth(String raw) {
  return raw
      .trim()
      .replaceAll(RegExp(r'cm$', caseSensitive: false), '')
      .replaceAll(RegExp(r'^(幅|宽|寬)'), '')
      .trim();
}

bool _isFuton(String name) {
  final lower = name.toLowerCase();
  return name.contains('布団') || name.contains('布团') || lower.contains('futon');
}
