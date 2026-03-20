import 'dart:math' as math;

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import 'app_image_viewer_image_widget_stub.dart'
    if (dart.library.io) 'app_image_viewer_image_widget_io.dart'
    as app_image_widget;

class AppImageViewerItem {
  const AppImageViewerItem({required this.source, this.semanticLabel});

  final String source;
  final String? semanticLabel;
}

class AppImageViewerTexts {
  const AppImageViewerTexts({
    this.loadingLabel = 'Loading image...',
    this.loadFailedLabel = 'Failed to load image.',
    this.retryLabel = 'Retry',
    this.invalidSourceNotice = 'Invalid image source.',
    this.closeTooltip = 'Close',
  });

  final String loadingLabel;
  final String loadFailedLabel;
  final String retryLabel;
  final String invalidSourceNotice;
  final String closeTooltip;
}

Future<void> openAppImageViewer(
  BuildContext context, {
  required List<AppImageViewerItem> items,
  int initialIndex = 0,
  AppImageViewerTexts texts = const AppImageViewerTexts(),
  bool useRootNavigator = true,
}) async {
  final normalizedItems = items
      .where((AppImageViewerItem item) => item.source.trim().isNotEmpty)
      .map(
        (AppImageViewerItem item) => AppImageViewerItem(
          source: item.source.trim(),
          semanticLabel: item.semanticLabel,
        ),
      )
      .toList(growable: false);
  if (normalizedItems.isEmpty) {
    AppNotice.show(context, message: texts.invalidSourceNotice);
    return;
  }

  final safeInitialIndex = initialIndex.clamp(0, normalizedItems.length - 1);
  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  await navigator.push<void>(
    PageRouteBuilder<void>(
      settings: const RouteSettings(name: 'app_image_viewer'),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      opaque: true,
      pageBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) => AppImageViewerPage(
            items: normalizedItems,
            initialIndex: safeInitialIndex,
            texts: texts,
          ),
    ),
  );
}

class AppImageViewerPage extends StatefulWidget {
  const AppImageViewerPage({
    super.key,
    required this.items,
    this.initialIndex = 0,
    this.texts = const AppImageViewerTexts(),
  });

  final List<AppImageViewerItem> items;
  final int initialIndex;
  final AppImageViewerTexts texts;

  @override
  State<AppImageViewerPage> createState() => _AppImageViewerPageState();
}

class _AppImageViewerPageState extends State<AppImageViewerPage> {
  late final PageController _pageController;
  final Map<int, bool> _pageZoomStates = <int, bool>{};
  int _currentIndex = 0;
  bool _isChromeVisible = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.items.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final isCurrentPageZoomed = _pageZoomStates[_currentIndex] ?? false;

    return Scaffold(
      backgroundColor: colors.scrim,
      body: Stack(
        children: <Widget>[
          PageView.builder(
            controller: _pageController,
            physics: isCurrentPageZoomed
                ? const NeverScrollableScrollPhysics()
                : const PageScrollPhysics(),
            itemCount: widget.items.length,
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return _AppImageViewerZoomablePage(
                key: ValueKey<String>('${widget.items[index].source}::$index'),
                item: widget.items[index],
                texts: widget.texts,
                isActive: index == _currentIndex,
                onSingleTap: () {
                  setState(() {
                    _isChromeVisible = !_isChromeVisible;
                  });
                },
                onZoomChanged: (bool isZoomed) {
                  if (_pageZoomStates[index] == isZoomed) {
                    return;
                  }
                  setState(() {
                    _pageZoomStates[index] = isZoomed;
                  });
                },
              );
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              ignoring: !_isChromeVisible,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                opacity: _isChromeVisible ? 1 : 0,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: Row(
                      children: <Widget>[
                        _ImageViewerCircleButton(
                          tooltip: widget.texts.closeTooltip,
                          icon: Icons.close_rounded,
                          onTap: () => Navigator.of(context).maybePop(),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: colors.onDark.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: colors.onDark.withValues(alpha: 0.10),
                            ),
                          ),
                          child: Text(
                            '${_currentIndex + 1} / ${widget.items.length}',
                            style: appText.caption.copyWith(
                              color: colors.onDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppImageViewerZoomablePage extends StatefulWidget {
  const _AppImageViewerZoomablePage({
    super.key,
    required this.item,
    required this.texts,
    required this.isActive,
    required this.onSingleTap,
    required this.onZoomChanged,
  });

  final AppImageViewerItem item;
  final AppImageViewerTexts texts;
  final bool isActive;
  final VoidCallback onSingleTap;
  final ValueChanged<bool> onZoomChanged;

  @override
  State<_AppImageViewerZoomablePage> createState() =>
      _AppImageViewerZoomablePageState();
}

class _AppImageViewerZoomablePageState
    extends State<_AppImageViewerZoomablePage>
    with SingleTickerProviderStateMixin {
  late final TransformationController _transformationController;
  late final AnimationController _zoomAnimationController;
  int _reloadRevision = 0;
  bool _isZoomed = false;
  TapDownDetails? _lastDoubleTapDownDetails;
  Animation<Matrix4>? _zoomAnimation;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController()
      ..addListener(_handleTransformChanged);
    _zoomAnimationController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 220),
        )..addListener(() {
          final animation = _zoomAnimation;
          if (animation == null) {
            return;
          }
          _transformationController.value = animation.value;
        });
  }

  @override
  void didUpdateWidget(covariant _AppImageViewerZoomablePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive && !widget.isActive) {
      _resetTransform(animated: false);
    }
  }

  void _handleTransformChanged() {
    final isZoomed = _transformationController.value.getMaxScaleOnAxis() > 1.01;
    if (_isZoomed == isZoomed) {
      return;
    }
    _isZoomed = isZoomed;
    widget.onZoomChanged(isZoomed);
  }

  void _setTransform(Matrix4 target, {required bool animated}) {
    _zoomAnimationController.stop();
    if (!animated) {
      _transformationController.value = target;
      return;
    }
    _zoomAnimation =
        Matrix4Tween(
          begin: _transformationController.value.clone(),
          end: target,
        ).animate(
          CurvedAnimation(
            parent: _zoomAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );
    _zoomAnimationController
      ..reset()
      ..forward();
  }

  void _resetTransform({required bool animated}) {
    _setTransform(Matrix4.identity(), animated: animated);
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _lastDoubleTapDownDetails = details;
  }

  void _handleDoubleTap(BoxConstraints constraints) {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale > 1.01) {
      _resetTransform(animated: true);
      return;
    }

    final tapPosition =
        _lastDoubleTapDownDetails?.localPosition ??
        Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
    const targetScale = 2.5;
    final clampedDx = tapPosition.dx.clamp(0.0, constraints.maxWidth);
    final clampedDy = tapPosition.dy.clamp(0.0, constraints.maxHeight);

    final target = Matrix4.identity()
      ..translateByDouble(
        -clampedDx * (targetScale - 1),
        -clampedDy * (targetScale - 1),
        0,
        1,
      )
      ..scaleByDouble(targetScale, targetScale, targetScale, 1);
    _setTransform(target, animated: true);
  }

  @override
  void dispose() {
    _zoomAnimationController.dispose();
    _transformationController
      ..removeListener(_handleTransformChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final dpr = MediaQuery.devicePixelRatioOf(context);
        final cacheWidth = math.max(
          1,
          math.min(4096, (constraints.maxWidth * dpr * 2).round()),
        );

        final loadingWidget = Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const CircularProgressIndicator.adaptive(),
              const SizedBox(height: 12),
              Text(
                widget.texts.loadingLabel,
                style: appText.body.copyWith(color: colors.onDark),
              ),
            ],
          ),
        );

        final errorWidget = Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.broken_image_outlined,
                  color: colors.onDark.withValues(alpha: 0.82),
                  size: 36,
                ),
                const SizedBox(height: 12),
                Text(
                  widget.texts.loadFailedLabel,
                  textAlign: TextAlign.center,
                  style: appText.body.copyWith(color: colors.onDark),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    _resetTransform(animated: false);
                    setState(() {
                      _reloadRevision += 1;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.onDark,
                    side: BorderSide(
                      color: colors.onDark.withValues(alpha: 0.30),
                    ),
                  ),
                  child: Text(widget.texts.retryLabel),
                ),
              ],
            ),
          ),
        );

        return Center(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: widget.onSingleTap,
            onDoubleTapDown: _handleDoubleTapDown,
            onDoubleTap: () => _handleDoubleTap(constraints),
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: 1,
              maxScale: 4,
              boundaryMargin: const EdgeInsets.all(96),
              clipBehavior: Clip.none,
              onInteractionStart: (_) {
                _zoomAnimationController.stop();
              },
              onInteractionEnd: (_) {
                if (_transformationController.value.getMaxScaleOnAxis() <=
                    1.01) {
                  _resetTransform(animated: false);
                }
              },
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Center(
                  child: app_image_widget.buildAppImageViewerImage(
                    key: ValueKey<String>(
                      '${widget.item.source}::${_reloadRevision}',
                    ),
                    source: widget.item.source,
                    fit: BoxFit.contain,
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    cacheWidth: cacheWidth,
                    filterQuality: FilterQuality.medium,
                    loadingWidget: loadingWidget,
                    errorWidget: errorWidget,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ImageViewerCircleButton extends StatelessWidget {
  const _ImageViewerCircleButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Material(
      color: colors.onDark.withValues(alpha: 0.16),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Tooltip(
          message: tooltip,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: colors.onDark, size: 20),
          ),
        ),
      ),
    );
  }
}
