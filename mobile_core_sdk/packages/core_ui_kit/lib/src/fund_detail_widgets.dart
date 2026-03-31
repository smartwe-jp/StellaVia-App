import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';
import 'fund_favorite_button.dart';
import 'ui_buttons.dart';
import 'ui_tokens.dart';

class FundDetailBadgeData {
  const FundDetailBadgeData({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
}

class FundDetailInfoItemData {
  const FundDetailInfoItemData({
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;
}

class FundDetailDisclosureItemData {
  const FundDetailDisclosureItemData({required this.title, required this.body});

  final String title;
  final String body;
}

class FundDetailKeyValueRowData {
  const FundDetailKeyValueRowData({required this.label, required this.value});

  final String label;
  final String value;
}

class FundDetailDocumentItemData {
  const FundDetailDocumentItemData({
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onTap;
}

class FundHeroMediaBackground extends StatefulWidget {
  const FundHeroMediaBackground({
    super.key,
    required this.gradientColors,
    this.imageUrls = const <String>[],
    this.pageController,
    this.onPageChanged,
    this.onImageTap,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 4),
  });

  final List<Color> gradientColors;
  final List<String> imageUrls;
  final PageController? pageController;
  final ValueChanged<int>? onPageChanged;
  final ValueChanged<int>? onImageTap;
  final bool autoPlay;
  final Duration autoPlayInterval;

  @override
  State<FundHeroMediaBackground> createState() =>
      _FundHeroMediaBackgroundState();
}

class _FundHeroMediaBackgroundState extends State<FundHeroMediaBackground>
    with WidgetsBindingObserver {
  PageController? _internalController;
  Timer? _autoPlayTimer;
  int _currentIndex = 0;
  bool _isPointerInteracting = false;
  bool _isAppActive = true;
  bool _isRouteVisible = true;

  List<String> get _normalizedImageUrls => widget.imageUrls
      .map((String url) => url.trim())
      .where((String url) => url.isNotEmpty)
      .toList(growable: false);

  PageController get _effectiveController {
    return widget.pageController ?? (_internalController ??= PageController());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final lifecycleState = WidgetsBinding.instance.lifecycleState;
    _isAppActive =
        lifecycleState == null || lifecycleState == AppLifecycleState.resumed;
    _configureAutoPlay();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isRouteVisible = ModalRoute.of(context)?.isCurrent ?? true;
    if (_isRouteVisible == isRouteVisible) {
      return;
    }
    _isRouteVisible = isRouteVisible;
    _configureAutoPlay();
  }

  @override
  void didUpdateWidget(covariant FundHeroMediaBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.autoPlay != widget.autoPlay ||
        oldWidget.autoPlayInterval != widget.autoPlayInterval ||
        oldWidget.pageController != widget.pageController ||
        oldWidget.imageUrls != widget.imageUrls) {
      final imageCount = _normalizedImageUrls.length;
      if (_currentIndex >= imageCount) {
        _currentIndex = 0;
      }
      _configureAutoPlay();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final isAppActive = state == AppLifecycleState.resumed;
    if (_isAppActive == isAppActive) {
      return;
    }
    _isAppActive = isAppActive;
    _configureAutoPlay();
  }

  bool get _shouldAutoPlay =>
      widget.autoPlay &&
      _normalizedImageUrls.length > 1 &&
      !_isPointerInteracting &&
      _isAppActive &&
      _isRouteVisible;

  void _configureAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
    if (!_shouldAutoPlay) {
      return;
    }
    _autoPlayTimer = Timer(widget.autoPlayInterval, _handleAutoPlayTick);
  }

  void _pauseAutoPlay() {
    _isPointerInteracting = true;
    _configureAutoPlay();
  }

  void _resumeAutoPlay() {
    _isPointerInteracting = false;
    _configureAutoPlay();
  }

  Future<void> _handleAutoPlayTick() async {
    _autoPlayTimer = null;
    await _animateToNextPage();
    if (!mounted) {
      return;
    }
    _configureAutoPlay();
  }

  Future<void> _animateToNextPage() async {
    final images = _normalizedImageUrls;
    if (!mounted || images.length <= 1) {
      return;
    }
    final controller = _effectiveController;
    if (!controller.hasClients) {
      return;
    }
    final nextIndex = (_currentIndex + 1) % images.length;
    try {
      await controller.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOutCubic,
      );
    } catch (_) {
      // Ignore transient page controller lifecycle failures during disposal.
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = _normalizedImageUrls;
    if (images.isEmpty) {
      return _FundDetailHeroFallbackBackground(
        gradientColors: widget.gradientColors,
      );
    }

    return Listener(
      onPointerDown: (_) => _pauseAutoPlay(),
      onPointerUp: (_) => _resumeAutoPlay(),
      onPointerCancel: (_) => _resumeAutoPlay(),
      child: PageView.builder(
        controller: _effectiveController,
        physics: const PageScrollPhysics(),
        itemCount: images.length,
        onPageChanged: (int index) {
          _currentIndex = index;
          widget.onPageChanged?.call(index);
          if (!_isPointerInteracting) {
            _configureAutoPlay();
          }
        },
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onImageTap == null
                ? null
                : () => widget.onImageTap!(index),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                _FundDetailHeroFallbackBackground(
                  gradientColors: widget.gradientColors,
                ),
                Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  loadingBuilder:
                      (
                        BuildContext context,
                        Widget child,
                        ImageChunkEvent? loadingProgress,
                      ) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return const SizedBox.shrink();
                      },
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FundDetailHeroHeader extends StatefulWidget {
  const FundDetailHeroHeader({
    super.key,
    required this.gradientColors,
    required this.badges,
    this.imageUrls = const <String>[],
    this.onImageTap,
    this.onBackTap,
    this.onFavoriteTap,
    this.isFavorite = false,
    this.favoriteAddedMessage,
    this.favoriteRemovedMessage,
    this.height = 260,
  });

  final List<Color> gradientColors;
  final List<FundDetailBadgeData> badges;
  final List<String> imageUrls;
  final ValueChanged<int>? onImageTap;
  final VoidCallback? onBackTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;
  final String? favoriteAddedMessage;
  final String? favoriteRemovedMessage;
  final double height;

  @override
  State<FundDetailHeroHeader> createState() => _FundDetailHeroHeaderState();
}

class _FundDetailHeroHeaderState extends State<FundDetailHeroHeader> {
  static const int _maxVisibleIndicators = 5;
  late final PageController _pageController;
  int _currentIndex = 0;

  List<String> get _normalizedImageUrls => widget.imageUrls
      .map((String url) => url.trim())
      .where((String url) => url.isNotEmpty)
      .toList(growable: false);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didUpdateWidget(covariant FundDetailHeroHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    final imageCount = _normalizedImageUrls.length;
    if (imageCount == 0 && _currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
      return;
    }
    if (imageCount > 0 && _currentIndex >= imageCount) {
      setState(() {
        _currentIndex = 0;
      });
      _pageController.jumpToPage(0);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<int> _visibleIndicatorIndices(int imageCount) {
    if (imageCount <= _maxVisibleIndicators) {
      return List<int>.generate(imageCount, (int index) => index);
    }
    final halfWindow = _maxVisibleIndicators ~/ 2;
    final maxStart = imageCount - _maxVisibleIndicators;
    final start = math.max(
      0,
      math.min(_currentIndex - halfWindow, maxStart),
    );
    return List<int>.generate(
      _maxVisibleIndicators,
      (int offset) => start + offset,
    );
  }

  Widget _buildPageIndicator(BuildContext context, int imageCount) {
    final colors = Theme.of(context).appColors;
    final visibleIndices = _visibleIndicatorIndices(imageCount);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.scrim.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(visibleIndices.length, (int dotIndex) {
          final index = visibleIndices[dotIndex];
          final selected = index == _currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: EdgeInsets.only(
              right: dotIndex == visibleIndices.length - 1 ? 0 : 5,
            ),
            width: selected ? 16 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: selected
                  ? colors.onDark
                  : colors.onDark.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(999),
            ),
          );
        }, growable: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appText = Theme.of(context).appTextTheme;
    final colors = Theme.of(context).appColors;
    final topInset = MediaQuery.paddingOf(context).top + 12;
    final images = _normalizedImageUrls;
    final hasIndicator = images.length > 1;

    return SizedBox(
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FundHeroMediaBackground(
            gradientColors: widget.gradientColors,
            imageUrls: images,
            pageController: _pageController,
            onImageTap: widget.onImageTap,
            onPageChanged: (int index) {
              if (_currentIndex == index) {
                return;
              }
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    colors.scrim.withValues(alpha: 0.12),
                    colors.scrim.withValues(alpha: 0.42),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: topInset,
            left: 12,
            child: _DetailGlassIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: widget.onBackTap,
            ),
          ),
          Positioned(
            top: topInset,
            right: 12,
            child: FundFavoriteButton(
              selected: widget.isFavorite,
              onTap: widget.onFavoriteTap,
              style: FundFavoriteButtonStyle.overlay,
              selectedToastMessage: widget.favoriteAddedMessage,
              unselectedToastMessage: widget.favoriteRemovedMessage,
            ),
          ),
          if (widget.badges.isNotEmpty)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: IgnorePointer(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: widget.badges
                      .map(
                        (FundDetailBadgeData badge) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: badge.backgroundColor,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            badge.label,
                            style: appText.chip.copyWith(
                              color: badge.foregroundColor,
                            ),
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
            ),
          if (hasIndicator)
            Positioned(
              left: 0,
              right: 0,
              bottom: widget.badges.isEmpty ? 14 : 48,
              child: IgnorePointer(
                child: Center(
                  child: _buildPageIndicator(context, images.length),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class FundDetailSection extends StatelessWidget {
  const FundDetailSection({
    super.key,
    required this.title,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: UiTokens.spacing16),
  });

  final String title;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final appText = Theme.of(context).appTextTheme;
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: appText.sectionTitle),
          const SizedBox(height: UiTokens.spacing8),
          child,
        ],
      ),
    );
  }
}

class FundDetailContentCard extends StatelessWidget {
  const FundDetailContentCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.backgroundColor,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.surface,
        borderRadius: BorderRadius.circular(UiTokens.radius16),
        border: Border.all(color: borderColor ?? colors.borderSoft),
      ),
      child: child,
    );
  }
}

class FundDetailMediaPreview extends StatelessWidget {
  const FundDetailMediaPreview({
    super.key,
    this.imageUrl,
    this.height = 164,
    this.overlayLabel,
    this.placeholder,
  });

  final String? imageUrl;
  final double height;
  final String? overlayLabel;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(UiTokens.radius16),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[colors.infoSubtle, colors.primarySubtle],
                ),
              ),
            ),
            if (imageUrl != null && imageUrl!.trim().isNotEmpty)
              Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    placeholder ?? const _DefaultMediaPlaceholder(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return placeholder ?? const _DefaultMediaPlaceholder();
                },
              )
            else
              placeholder ?? const _DefaultMediaPlaceholder(),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.transparent,
                    colors.scrim.withValues(alpha: 0.16),
                  ],
                ),
              ),
            ),
            if (overlayLabel != null && overlayLabel!.trim().isNotEmpty)
              Positioned(
                left: 12,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    overlayLabel!,
                    style: appText.chip.copyWith(color: colors.textPrimary),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class FundDetailInfoGrid extends StatelessWidget {
  const FundDetailInfoGrid({super.key, required this.items, this.spacing = 10});

  final List<FundDetailInfoItemData> items;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final itemWidth = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: items
              .map(
                (FundDetailInfoItemData item) => SizedBox(
                  width: itemWidth,
                  child: FundDetailContentCard(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.label,
                          style: appText.inputLabel.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(item.value, style: appText.bodyStrong),
                      ],
                    ),
                  ),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

class FundDetailInfoTable extends StatelessWidget {
  const FundDetailInfoTable({
    super.key,
    required this.items,
    this.borderColor,
    this.columns = 2,
    this.minRowHeight = 0,
  });

  final List<FundDetailInfoItemData> items;
  final Color? borderColor;
  final int columns;
  final double minRowHeight;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    final colors = Theme.of(context).appColors;
    final effectiveBorderColor = borderColor ?? colors.border;

    final safeColumns = columns < 1 ? 1 : columns;
    final placeholdersNeeded =
        (safeColumns - (items.length % safeColumns)) % safeColumns;
    final normalizedItems = <FundDetailInfoItemData?>[
      ...items,
      ...List<FundDetailInfoItemData?>.filled(placeholdersNeeded, null),
    ];
    final rowCount = normalizedItems.length ~/ safeColumns;

    final radius = BorderRadius.circular(UiTokens.radius16);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: effectiveBorderColor,
        borderRadius: radius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(UiTokens.radius16 - 1),
          child: ColoredBox(
            color: colors.surface,
            child: Table(
              border: TableBorder(
                horizontalInside: BorderSide(color: effectiveBorderColor),
                verticalInside: BorderSide(color: effectiveBorderColor),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: List<TableRow>.generate(rowCount, (int rowIndex) {
                return TableRow(
                  children: List<Widget>.generate(safeColumns, (int colIndex) {
                    final item =
                        normalizedItems[rowIndex * safeColumns + colIndex];
                    return _FundDetailTableCell(
                      item: item,
                      minHeight: minRowHeight < 0 ? 0 : minRowHeight,
                    );
                  }, growable: false),
                );
              }, growable: false),
            ),
          ),
        ),
      ),
    );
  }
}

class _FundDetailTableCell extends StatelessWidget {
  const _FundDetailTableCell({required this.item, required this.minHeight});

  final FundDetailInfoItemData? item;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return SizedBox(height: minHeight <= 0 ? 0 : minHeight);
    }

    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final labelStyle = appText.tableLabel.copyWith(color: colors.textTertiary);
    final valueStyle = appText.tableValue.copyWith(color: colors.textPrimary);
    final isInteractive = item!.onTap != null;

    final child = Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Text(
                  item!.label,
                  style: labelStyle.copyWith(
                    color: isInteractive ? colors.primary : colors.textTertiary,
                  ),
                ),
              ),
              if (isInteractive) ...<Widget>[
                const SizedBox(width: 6),
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 2),
          Text(item!.value, style: valueStyle),
        ],
      ),
    );

    final wrappedChild = isInteractive
        ? InkWell(onTap: item!.onTap, child: child)
        : child;

    if (minHeight <= 0) {
      return wrappedChild;
    }

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: wrappedChild,
    );
  }
}

class FundDetailDisclosureList extends StatelessWidget {
  const FundDetailDisclosureList({super.key, required this.items});

  final List<FundDetailDisclosureItemData> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: <Widget>[
        for (var index = 0; index < items.length; index++) ...<Widget>[
          _DisclosureTile(item: items[index]),
          if (index < items.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class FundDetailTextCard extends StatelessWidget {
  const FundDetailTextCard({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return FundDetailContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: appText.cardTitle),
          const SizedBox(height: 6),
          Text(
            body,
            style: appText.bodyMuted.copyWith(
              color: colors.textSecondary,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

class FundDetailKeyValueCard extends StatelessWidget {
  const FundDetailKeyValueCard({
    super.key,
    required this.title,
    required this.rows,
  });

  final String title;
  final List<FundDetailKeyValueRowData> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return FundDetailContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: appText.cardTitle),
          const SizedBox(height: 6),
          for (var index = 0; index < rows.length; index++) ...<Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    rows[index].label,
                    style: appText.bodyMuted.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: UiTokens.spacing8),
                Text(rows[index].value, style: appText.bodyStrong),
              ],
            ),
            if (index < rows.length - 1) const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}

class FundDetailDocumentList extends StatelessWidget {
  const FundDetailDocumentList({super.key, required this.items});

  final List<FundDetailDocumentItemData> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Column(
      children: <Widget>[
        for (var index = 0; index < items.length; index++) ...<Widget>[
          FundDetailContentCard(
            padding: EdgeInsets.zero,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: items[index].onTap,
                borderRadius: BorderRadius.circular(UiTokens.radius16),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: colors.primarySubtle,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.description_outlined,
                          color: colors.primary,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: UiTokens.spacing12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(items[index].title, style: appText.bodyStrong),
                            const SizedBox(height: 2),
                            Text(
                              items[index].subtitle,
                              style: appText.caption.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: UiTokens.spacing8),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: colors.textTertiary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (index < items.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class FundDetailStickyActionBar extends StatelessWidget {
  const FundDetailStickyActionBar({
    super.key,
    required this.label,
    this.onTap,
    this.enabled = true,
    this.buttonColor,
    this.buttonShadowColor,
  });

  final String label;
  final VoidCallback? onTap;
  final bool enabled;
  final Color? buttonColor;
  final Color? buttonShadowColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.5),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.surface,
            blurRadius: 10,
            offset: const Offset(0, -12),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 14,
            child: IgnorePointer(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          colors.surface.withValues(alpha: 0.42),
                          colors.surface.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SafeArea(
              top: false,
              child: PrimaryCtaButton(
                label: label,
                onPressed: enabled ? onTap : null,
                height: 52,
                borderRadius: BorderRadius.circular(14),
                horizontalPadding: 0,
                backgroundColor: buttonColor,
                shadowColor: buttonShadowColor,
                threeSideShadow: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DefaultMediaPlaceholder extends StatelessWidget {
  const _DefaultMediaPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                colors.heroStart.withValues(alpha: 0.92),
                colors.primary.withValues(alpha: 0.82),
              ],
            ),
          ),
        ),
        const _FundDetailArtworkLayer(),
      ],
    );
  }
}

class _FundDetailHeroFallbackBackground extends StatelessWidget {
  const _FundDetailHeroFallbackBackground({required this.gradientColors});

  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
          ),
        ),
        const _FundDetailArtworkLayer(),
      ],
    );
  }
}

class _DetailGlassIconButton extends StatelessWidget {
  const _DetailGlassIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Material(
      color: colors.scrim.withValues(alpha: 0.24),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: colors.onDark, size: 18),
        ),
      ),
    );
  }
}

class _DisclosureTile extends StatelessWidget {
  const _DisclosureTile({required this.item});

  final FundDetailDisclosureItemData item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(UiTokens.radius16),
      child: Material(
        color: colors.surface,
        child: Theme(
          data: theme.copyWith(
            dividerColor: Colors.transparent,
            splashColor: colors.primary.withValues(alpha: 0.08),
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 2,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UiTokens.radius16),
              side: BorderSide(color: colors.border),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UiTokens.radius16),
              side: BorderSide(color: colors.border),
            ),
            title: Text(item.title, style: appText.bodyStrong),
            children: <Widget>[
              Text(
                item.body,
                style: appText.bodyMuted.copyWith(
                  color: colors.textSecondary,
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FundDetailArtworkLayer extends StatelessWidget {
  const _FundDetailArtworkLayer();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 26),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <Widget>[
              _HeroBlock(height: 112, width: 30),
              _HeroBlock(height: 142, width: 38),
              _HeroBlock(height: 96, width: 28),
              _HeroBlock(height: 126, width: 34),
              _HeroBlock(height: 84, width: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroBlock extends StatelessWidget {
  const _HeroBlock({required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.onDark.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        children: List<Widget>.generate(
          6,
          (int index) => Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              width: width * 0.28,
              height: 4,
              decoration: BoxDecoration(
                color: colors.onDark.withValues(alpha: 0.24),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          growable: false,
        ),
      ),
    );
  }
}
