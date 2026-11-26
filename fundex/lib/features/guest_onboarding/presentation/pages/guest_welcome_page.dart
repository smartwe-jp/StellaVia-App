import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../widgets/guest_welcome_hero.dart';
import '../widgets/guest_welcome_header.dart';
import '../widgets/guest_welcome_arrow.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../widgets/guest_guide_video_background.dart';

class GuestWelcomePage extends StatefulWidget {
  const GuestWelcomePage({super.key});

  @override
  State<GuestWelcomePage> createState() => _GuestWelcomePageState();
}

class _GuestWelcomePageState extends State<GuestWelcomePage> {
  final _scroll = ScrollController();
  PointerDownEvent? _start;
  double _remainingScroll = 0;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _openGuestHome() {
    if (ModalRoute.isCurrentOf(context) == true) {
      context.push('/guest-guide/discover');
    }
  }

  void _finishSwipe(PointerUpEvent event) {
    final start = _start;
    _start = null;
    if (start == null || start.pointer != event.pointer) return;
    final delta = start.position - event.position;
    if (delta.dy >= _remainingScroll + 100 && delta.dy > delta.dx.abs()) {
      _openGuestHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.appColors;
    final white = colors.onDark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colors.surface.withValues(alpha: 0),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
      ),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            const GuestGuideVideoBackground(
              posterAsset: 'assets/images/guest_welcome_poster.jpg',
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0, .32, .58, 1],
                  colors: [
                    AppColorTokens.brandNavy.withValues(alpha: .08),
                    AppColorTokens.brandNavy.withValues(alpha: .03),
                    AppColorTokens.brandNavy.withValues(alpha: .265),
                    AppColorTokens.brandNavy.withValues(alpha: .425),
                  ],
                ),
              ),
            ),
            SafeArea(
              minimum: const EdgeInsets.fromLTRB(20, 16, 20, 22),
              child: Listener(
                onPointerDown: (event) {
                  _start = event;
                  _remainingScroll = _scroll.position.extentAfter;
                },
                onPointerCancel: (_) => _start = null,
                onPointerUp: _finishSwipe,
                child: CustomScrollView(
                  controller: _scroll,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        children: [
                          const GuestWelcomeHeader(),
                          const Spacer(flex: 2),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: GuestWelcomeHero(),
                          ),
                          const Spacer(),
                          Text(
                            l.guestGuideTagline,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: white,
                                  fontFamily: 'Jost',
                                  fontSize: 15,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 16),
                          GuestWelcomeArrow(onPressed: _openGuestHome),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
