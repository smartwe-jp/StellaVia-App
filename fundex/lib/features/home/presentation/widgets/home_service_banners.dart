import 'dart:async';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/home_miles_providers.dart';
import '../support/home_miles_display.dart';
import 'home_brand_intro.dart';
import 'home_service_features_card.dart';

class HomeServiceBanners extends ConsumerStatefulWidget {
  const HomeServiceBanners({super.key});

  @override
  ConsumerState<HomeServiceBanners> createState() => _HomeServiceBannersState();
}

class _HomeServiceBannersState extends ConsumerState<HomeServiceBanners>
    with WidgetsBindingObserver {
  // The two outer slots mirror the opposite end for seamless swiping.
  final _pages = PageController(initialPage: 1, keepPage: false);
  Timer? _timer;
  bool _visible = false;
  bool _foreground = true;
  bool _touching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    _foreground = lifecycle == null || lifecycle == AppLifecycleState.resumed;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _visible =
        TickerMode.valuesOf(context).enabled &&
        (ModalRoute.isCurrentOf(context) ?? true);
    _schedule();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    _schedule();
  }

  void _schedule() {
    _timer?.cancel();
    if (!_visible || !_foreground || _touching) return;
    _timer = Timer(const Duration(seconds: 10), () {
      if (!_pages.hasClients || _pages.position.isScrollingNotifier.value) {
        return;
      }
      _pages.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification.depth != 0) return false;
    if (notification is ScrollStartNotification) _timer?.cancel();
    if (notification is ScrollEndNotification) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted ||
            !_pages.hasClients ||
            _pages.position.isScrollingNotifier.value) {
          return;
        }
        final slot = _pages.page!.round();
        if (slot == 0 || slot == 3) _pages.jumpToPage(slot == 0 ? 2 : 1);
        final selected = (slot + 1) % 2;
        if (selected != _selected) setState(() => _selected = selected);
        _schedule();
      });
    }
    return false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _pages.dispose();
    super.dispose();
  }

  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            void openFeatures() => context.push('/home/features');
            void openBenefits() => context.push('/home/miles');
            final ranks = homeRankNames(ref.watch(homeMilesRulesProvider).data);
            return Listener(
              onPointerDown: (_) {
                _touching = true;
                _timer?.cancel();
              },
              onPointerUp: (_) {
                _touching = false;
                _schedule();
              },
              onPointerCancel: (_) {
                _touching = false;
                _schedule();
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: _onScroll,
                child: SingleChildScrollView(
                  controller: _pages,
                  scrollDirection: Axis.horizontal,
                  physics: const PageScrollPhysics(),
                  child: Table(
                    defaultColumnWidth: FixedColumnWidth(width),
                    defaultVerticalAlignment:
                        TableCellVerticalAlignment.intrinsicHeight,
                    children: [
                      TableRow(
                        children: [
                          for (final features in [false, true, false, true])
                            if (features)
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: openFeatures,
                                child: HomeServiceFeaturesCard(
                                  onTap: openFeatures,
                                ),
                              )
                            else
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: openBenefits,
                                child: HomeBrandIntro(
                                  ranks: ranks,
                                  onServiceTap: openBenefits,
                                ),
                              ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 6,
          children: [
            for (var i = 0; i < 2; i++)
              Container(
                width: i == _selected ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: i == _selected
                      ? colors.primary
                      : colors.textSecondary.withValues(alpha: .35),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
