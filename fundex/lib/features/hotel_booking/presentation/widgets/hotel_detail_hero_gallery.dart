import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/hotel_models.dart';
import 'hotel_detail_image_placeholder.dart';

class HotelDetailHeroGallery extends StatefulWidget {
  const HotelDetailHeroGallery({
    super.key,
    required this.images,
    required this.onBack,
    this.onFavorite,
    this.aspectRatio = 1,
  });

  final List<HotelDetailImage> images;
  final VoidCallback onBack;
  final VoidCallback? onFavorite;
  final double aspectRatio;

  @override
  State<HotelDetailHeroGallery> createState() => _HotelDetailHeroGalleryState();
}

class _HotelDetailHeroGalleryState extends State<HotelDetailHeroGallery> {
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
  void didUpdateWidget(covariant HotelDetailHeroGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    final imageCount = _imageUrls.length;
    if (imageCount == 0) {
      _currentIndex = 0;
      return;
    }
    if (_currentIndex >= imageCount) {
      setState(() => _currentIndex = 0);
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    }
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
    final topPadding = MediaQuery.paddingOf(context).top;

    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (imageUrls.isEmpty)
            const HotelDetailImagePlaceholder(iconSize: 44)
          else
            PageView.builder(
              controller: _pageController,
              itemCount: imageUrls.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                return AppRemoteImage(
                  imageUrl: imageUrls[index],
                  fit: BoxFit.cover,
                  placeholder: const HotelDetailImagePlaceholder(iconSize: 44),
                  errorWidget: const HotelDetailImagePlaceholder(iconSize: 44),
                );
              },
            ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  colors.scrim.withValues(alpha: 0.25),
                  colors.scrim.withValues(alpha: 0.08),
                  colors.brandPrimaryDark.withValues(alpha: 0.42),
                ],
              ),
            ),
          ),
          Positioned(
            top: topPadding + 12,
            left: 16,
            child: _HeroCircleButton(
              icon: Icons.arrow_back_rounded,
              onPressed: widget.onBack,
            ),
          ),
          Positioned(
            top: topPadding + 12,
            right: 16,
            child: _HeroCircleButton(
              icon: Icons.favorite_border_rounded,
              onPressed: widget.onFavorite,
            ),
          ),
          if (imageUrls.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 64,
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
                    width: selected ? 18 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: selected
                          ? colors.brandSecondary
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
}

class _HeroCircleButton extends StatelessWidget {
  const _HeroCircleButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Material(
      color: colors.brandWhite.withValues(alpha: 0.20),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 54,
          height: 54,
          child: Icon(icon, color: colors.onDark, size: 28),
        ),
      ),
    );
  }
}
