import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class HotelDesignShowcasePage extends StatelessWidget {
  const HotelDesignShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hotelTheme = theme.extension<AppFTKTheme>()!;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Hotel UI Showcase')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: <Widget>[
            Text(
              'Figma inspired palette (extracted)',
              style: hotelTheme.sectionTitleStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 12),
            const Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                _PaletteSwatch(
                  'Primary',
                  '#1AA7FF',
                  AppColorTokens.travelPrimaryBlue,
                ),
                _PaletteSwatch(
                  'Primary Alt',
                  '#18A8FE',
                  AppColorTokens.travelPrimaryBlueAlt,
                ),
                _PaletteSwatch(
                  'Rating',
                  '#FE8814',
                  AppColorTokens.travelRatingOrange,
                ),
                _PaletteSwatch(
                  'FAB',
                  '#FF930C',
                  AppColorTokens.travelFabOrange,
                ),
                _PaletteSwatch(
                  'Discount',
                  '#FF7D56',
                  AppColorTokens.travelDiscountCoral,
                ),
                _PaletteSwatch(
                  'Link',
                  '#D99221',
                  AppColorTokens.travelLinkGold,
                ),
                _PaletteSwatch(
                  'Muted',
                  '#75747A',
                  AppColorTokens.travelTextMuted,
                ),
                _PaletteSwatch(
                  'Border',
                  '#F4F4F4',
                  AppColorTokens.travelBorderSoft,
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text('Buttons', style: hotelTheme.sectionTitleStyle),
            const SizedBox(height: 14),
            const Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 320,
                child: PrimaryCtaButton(label: 'Get Started', fullWidth: false),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: <Widget>[
                CircleIconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {},
                ),
                const SizedBox(width: 10),
                CircleIconButton(
                  icon: const Icon(Icons.search_rounded),
                  onPressed: () {},
                ),
                const SizedBox(width: 10),
                CircleIconButton(
                  icon: const Icon(Icons.ios_share_rounded),
                  size: 38,
                  onPressed: () {},
                ),
                const SizedBox(width: 10),
                FundFavoriteButton(
                  selected: false,
                  onTap: () {},
                  style: FundFavoriteButtonStyle.overlay,
                  size: 38,
                  iconSize: 20,
                ),
                const Spacer(),
                AccentSquareIconButton(
                  icon: const Icon(Icons.chat_bubble_outline_rounded),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 18),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  CategoryTileButton(
                    icon: const Icon(Icons.apartment_rounded),
                    label: 'Hotel',
                    isSelected: true,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 14),
                  CategoryTileButton(
                    icon: const Icon(Icons.flight_rounded),
                    label: 'Flight',
                    onPressed: () {},
                  ),
                  const SizedBox(width: 14),
                  CategoryTileButton(
                    icon: const Icon(Icons.place_outlined),
                    label: 'Place',
                    onPressed: () {},
                  ),
                  const SizedBox(width: 14),
                  CategoryTileButton(
                    icon: const Icon(Icons.room_service_outlined),
                    label: 'Food',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text('Cards', style: hotelTheme.sectionTitleStyle),
            const SizedBox(height: 14),
            Row(
              children: <Widget>[
                Text('Popular Hotels', style: hotelTheme.sectionTitleStyle),
                const Spacer(),
                Text(
                  'See all',
                  style: textTheme.bodyMedium?.copyWith(
                    color: hotelTheme.sectionActionColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  ImageCard(
                    title: 'Santorini',
                    location: 'Greece',
                    priceText: '\$488/night',
                    ratingText: '4.9',
                    overlayGradientColors: <Color>[
                      Colors.transparent,
                      Color(0xCC333941),
                      Color(0xF0000000),
                    ],
                  ),
                  SizedBox(width: 14),
                  ImageCard(
                    title: 'Hotel Royal',
                    location: 'Spain',
                    priceText: '\$280/night',
                    ratingText: '4.8',
                    overlayGradientColors: <Color>[
                      Color(0x00D1C4B4),
                      Color(0xD0333941),
                      Color(0xF0000000),
                    ],
                  ),
                  SizedBox(width: 14),
                  ImageCard(
                    title: 'BaLi Motel',
                    location: 'Indonesia',
                    priceText: '\$580/night',
                    ratingText: '4.9',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const DealBannerCard(
              title: 'BaLi Motel Vung Tau',
              location: 'Indonesia',
              priceText: '\$580/night',
              ratingText: '4.9',
              discountText: '25%OFF',
            ),
            const SizedBox(height: 22),
            Text(
              'Amenities',
              style: hotelTheme.sectionTitleStyle.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  AmenityTileCard(
                    icon: const Icon(Icons.bed_outlined),
                    label: '2 Bed',
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),
                  AmenityTileCard(
                    icon: const Icon(Icons.restaurant_outlined),
                    label: 'Dinner',
                    highlighted: true,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),
                  AmenityTileCard(
                    icon: const Icon(Icons.hot_tub_outlined),
                    label: 'Hot Tub',
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),
                  AmenityTileCard(
                    icon: const Icon(Icons.ac_unit_rounded),
                    label: '1 AC',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            Text(
              'List / Detail Cards',
              style: hotelTheme.sectionTitleStyle.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 12),
            ListItemCard(
              title: 'Hotel Royal Santorini',
              location: 'Santorini, Greece',
              subtitle: 'Ocean view • Free breakfast • Flexible check-in',
              priceText: '\$320/night',
              ratingText: '4.8',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            const DetailSummaryCard(
              title: 'BaLi Motel Vung Tau',
              location: 'Indonesia',
              priceText: '\$580',
              ratingText: '4.9',
              description:
                  'Set in Vung Tau, 100 metres from Front Beach, with garden, private parking and family-friendly stay options.',
              tags: <String>['Front Beach', 'Parking', 'Breakfast', 'Family'],
            ),
            const SizedBox(height: 12),
            SurfacePanelCard(
              title: 'Segment Panel Card',
              subtitle:
                  'Reusable soft panel for auth forms and grouped actions',
              leading: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: hotelTheme.primaryButtonColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.grid_view_rounded,
                  color: hotelTheme.primaryButtonColor,
                  size: 20,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Use this panel to build segmented form sections with a softer Figma-style surface instead of bordered blocks.',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CompactActionButton(
                      label: 'Action',
                      onPressed: () {},
                      width: 96,
                      height: 44,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            Text(
              'Detail Page Micro-Elements',
              style: hotelTheme.sectionTitleStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleIconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        size: 38,
                        onPressed: () {},
                      ),
                      const Spacer(),
                      CircleIconButton(
                        icon: const Icon(Icons.ios_share_rounded),
                        size: 38,
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      FundFavoriteButton(
                        selected: false,
                        onTap: () {},
                        style: FundFavoriteButtonStyle.overlay,
                        size: 38,
                        iconSize: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const PhotoCountBadge(label: '124 Photos'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaletteSwatch extends StatelessWidget {
  const _PaletteSwatch(this.name, this.hex, this.color);

  final String name;
  final String hex;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: 112,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.22),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 8),
          Text(name, style: textTheme.bodySmall),
          const SizedBox(height: 2),
          Text(hex, style: textTheme.labelMedium),
        ],
      ),
    );
  }
}
