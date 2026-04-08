import 'dart:async';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/home_celebration_providers.dart';

const String _defaultCelebrationLottieAsset =
    'assets/content/home_celebration_bonus_lottie.json';
const Duration _fallbackCelebrationDuration = Duration(milliseconds: 2600);

class HomeCelebrationDialog extends StatefulWidget {
  const HomeCelebrationDialog({
    required this.event,
    required this.onDismiss,
    super.key,
  });

  final HomeCelebrationEvent event;
  final VoidCallback onDismiss;

  @override
  State<HomeCelebrationDialog> createState() => _HomeCelebrationDialogState();
}

class _HomeCelebrationDialogState extends State<HomeCelebrationDialog>
    with SingleTickerProviderStateMixin {
  static const Duration _animationStartTimeout = Duration(milliseconds: 900);

  late final AnimationController _controller = AnimationController(vsync: this)
    ..addStatusListener(_handleAnimationStatus);
  late final Timer _fallbackStartTimer = Timer(
    _animationStartTimeout,
    _triggerFallbackAnimation,
  );

  bool _showActions = false;
  bool _animationConfigured = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _fallbackStartTimer.cancel();
    _controller
      ..removeStatusListener(_handleAnimationStatus)
      ..dispose();
    super.dispose();
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || _showActions || !mounted) {
      return;
    }
    setState(() {
      _showActions = true;
    });
  }

  void _startAnimation(Duration duration) {
    if (_animationConfigured) {
      return;
    }
    _animationConfigured = true;
    _controller.duration = duration;
    _controller.forward(from: 0);
  }

  void _handleLottieLoaded(LottieComposition composition) {
    if (_animationConfigured) {
      return;
    }
    _startAnimation(composition.duration);
  }

  void _triggerFallbackAnimation() {
    if (!mounted || _animationConfigured) {
      return;
    }
    _startAnimation(_fallbackCelebrationDuration);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appText = theme.appTextTheme;
    final colors = theme.appColors;
    final l10n = context.l10n;

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: const SizedBox.expand(),
          ),
          IgnorePointer(
            child: _CelebrationLottieLayer(
              controller: _controller,
              lottieUrl: widget.event.lottieUrl,
              onLoaded: _handleLottieLoaded,
            ),
          ),
          SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                AnimatedOpacity(
                  opacity: _showActions ? 1 : 0,
                  duration: const Duration(milliseconds: 220),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, right: 12),
                      child: IconButton(
                        onPressed: _showActions
                            ? widget.onDismiss
                            : null,
                        icon: const Icon(Icons.close_rounded),
                        style: IconButton.styleFrom(
                          foregroundColor: colors.onDark,
                          backgroundColor: colors.surface.withValues(
                            alpha: 0.72,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedSlide(
                  offset: _showActions ? Offset.zero : const Offset(0, 0.2),
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  child: AnimatedOpacity(
                    opacity: _showActions ? 1 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 78),
                        child: SizedBox(
                          width: 188,
                          child: FilledButton(
                            onPressed: _showActions ? widget.onDismiss : null,
                            style: FilledButton.styleFrom(
                              backgroundColor: colors.highlightGold,
                              foregroundColor: colors.textPrimary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: const StadiumBorder(),
                            ),
                            child: Text(
                              l10n.commonOk,
                              style: appText.bodyStrong.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CelebrationLottieLayer extends StatelessWidget {
  const _CelebrationLottieLayer({
    required this.controller,
    required this.lottieUrl,
    required this.onLoaded,
  });

  final AnimationController controller;
  final String? lottieUrl;
  final ValueChanged<LottieComposition> onLoaded;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final normalizedUrl = lottieUrl?.trim();
        if (normalizedUrl != null && normalizedUrl.isNotEmpty) {
          return _wrapPlayer(
            constraints,
            Lottie.network(
              normalizedUrl,
              controller: controller,
              fit: BoxFit.fitWidth,
              alignment: Alignment.center,
              repeat: false,
              onLoaded: onLoaded,
              decoder: _decoderForUrl(normalizedUrl),
              errorBuilder: (_, __, ___) => _buildDefaultAsset(constraints),
            ),
          );
        }
        return _buildDefaultAsset(constraints);
      },
    );
  }

  Widget _buildDefaultAsset(BoxConstraints constraints) {
    return _wrapPlayer(
      constraints,
      Lottie.asset(
        _defaultCelebrationLottieAsset,
        controller: controller,
        fit: BoxFit.fitWidth,
        alignment: Alignment.center,
        repeat: false,
        onLoaded: onLoaded,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _wrapPlayer(BoxConstraints constraints, Widget child) {
    return ClipRect(
      child: SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: child,
      ),
    );
  }

  LottieDecoder? _decoderForUrl(String url) {
    if (!url.toLowerCase().endsWith('.lottie')) {
      return null;
    }
    return _decodeDotLottie;
  }
}

Future<LottieComposition?> _decodeDotLottie(List<int> bytes) {
  return LottieComposition.decodeZip(
    bytes,
    filePicker: (files) {
      for (final file in files) {
        final name = file.name;
        if (name.startsWith('animations/') && name.endsWith('.json')) {
          return file;
        }
      }
      for (final file in files) {
        if (file.name.endsWith('.json')) {
          return file;
        }
      }
      return null;
    },
  );
}
