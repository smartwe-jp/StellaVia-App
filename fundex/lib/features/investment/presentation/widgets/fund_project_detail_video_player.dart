import 'dart:async';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class FundProjectDetailVideoPlayer extends StatefulWidget {
  const FundProjectDetailVideoPlayer({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<FundProjectDetailVideoPlayer> createState() =>
      _FundProjectDetailVideoPlayerState();
}

class _FundProjectDetailVideoPlayerState
    extends State<FundProjectDetailVideoPlayer>
    with WidgetsBindingObserver {
  CachedVideoPlayerPlus? _player;
  VideoPlayerController? _controller;
  Object? _loadError;
  var _isLoading = true;
  var _loadGeneration = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializePlayer();
  }

  @override
  void didUpdateWidget(covariant FundProjectDetailVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl.trim() != widget.videoUrl.trim()) {
      _initializePlayer();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        unawaited(_controller?.pause());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _loadGeneration++;
    final controller = _controller;
    controller?.removeListener(_handleControllerChanged);
    _controller = null;
    final player = _player;
    _player = null;
    if (player != null) {
      unawaited(player.dispose());
    }
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    final generation = ++_loadGeneration;
    final previousController = _controller;
    previousController?.removeListener(_handleControllerChanged);
    _controller = null;
    final previousPlayer = _player;
    _player = null;
    if (previousPlayer != null) {
      unawaited(previousPlayer.dispose());
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadError = null;
      });
    }

    final uri = Uri.tryParse(widget.videoUrl.trim());
    if (uri == null ||
        !uri.hasScheme ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      if (!mounted || generation != _loadGeneration) {
        return;
      }
      setState(() {
        _isLoading = false;
        _loadError = const FormatException('Invalid video URL.');
      });
      return;
    }
    if (!_isDirectPlayableVideoUrl(uri)) {
      if (!mounted || generation != _loadGeneration) {
        return;
      }
      setState(() {
        _isLoading = false;
        _loadError = null;
      });
      return;
    }

    final player = CachedVideoPlayerPlus.networkUrl(
      uri,
      invalidateCacheIfOlderThan: const Duration(days: 30),
    );

    try {
      await player.initialize();
      if (!mounted || generation != _loadGeneration) {
        await player.dispose();
        return;
      }
      final controller = player.controller;
      controller.addListener(_handleControllerChanged);
      setState(() {
        _player = player;
        _controller = controller;
        _isLoading = false;
        _loadError = null;
      });
    } catch (error) {
      await player.dispose();
      if (!mounted || generation != _loadGeneration) {
        return;
      }
      setState(() {
        _isLoading = false;
        _loadError = error;
      });
    }
  }

  void _handleControllerChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _togglePlayback() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (controller.value.isPlaying) {
      await controller.pause();
      return;
    }
    if (controller.value.isCompleted) {
      await controller.seekTo(Duration.zero);
    }
    await controller.play();
  }

  Future<void> _seekToProgress(double progress) async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    final duration = controller.value.duration;
    if (duration <= Duration.zero) {
      return;
    }
    final targetMilliseconds = (duration.inMilliseconds * progress)
        .round()
        .clamp(0, duration.inMilliseconds);
    await controller.seekTo(Duration(milliseconds: targetMilliseconds));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.heroStart,
        borderRadius: BorderRadius.circular(UiTokens.radius16),
        border: Border.all(color: colors.borderSoft),
      ),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final controller = _controller;
    if (_isLoading) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }
    if (_loadError != null ||
        controller == null ||
        controller.value.hasError ||
        !controller.value.isInitialized) {
      return _FundProjectVideoErrorState(onRetry: _initializePlayer);
    }
    return _FundProjectVideoReadyState(
      controller: controller,
      onTogglePlayback: _togglePlayback,
      onSeekToProgress: _seekToProgress,
    );
  }
}

class FundProjectDetailExternalVideoLinkRow extends StatelessWidget {
  const FundProjectDetailExternalVideoLinkRow({
    super.key,
    required this.videoUrl,
  });

  final String videoUrl;

  Future<void> _openExternalVideo(BuildContext context) async {
    final uri = _parseHttpUri(videoUrl);
    if (uri == null) {
      _showOpenFailed(context);
      return;
    }
    var launched = false;
    try {
      launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      launched = false;
    }
    if (launched || !context.mounted) {
      return;
    }
    _showOpenFailed(context);
  }

  void _showOpenFailed(BuildContext context) {
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.fundDetailReferenceVideoOpenFailed)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return FundDetailContentCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              context.l10n.fundDetailReferenceVideoTitle,
              style: appText.sectionTitle.copyWith(color: colors.textPrimary),
            ),
          ),
          const SizedBox(width: UiTokens.spacing12),
          Material(
            color: colors.highlightGold,
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => _openExternalVideo(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.play_arrow_rounded,
                      color: colors.onDark,
                      size: 18,
                    ),
                    const SizedBox(width: UiTokens.spacing4),
                    Text(
                      context.l10n.fundDetailReferenceVideoPlayAction,
                      style: appText.button.copyWith(color: colors.onDark),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

bool isFundProjectDirectPlayableVideoUrl(String rawUrl) {
  final uri = _parseHttpUri(rawUrl);
  return uri != null && _isDirectPlayableVideoUrl(uri);
}

bool isFundProjectYoutubeVideoUrl(String rawUrl) =>
    extractFundProjectYoutubeVideoId(rawUrl) != null;

String? extractFundProjectYoutubeVideoId(String rawUrl) {
  final text = rawUrl.trim();
  if (text.isEmpty) {
    return null;
  }
  return YoutubePlayer.convertUrlToId(text) ??
      YoutubePlayer.convertUrlToId(text.replaceFirst('http://', 'https://'));
}

class FundProjectDetailYoutubePlayer extends StatefulWidget {
  const FundProjectDetailYoutubePlayer({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<FundProjectDetailYoutubePlayer> createState() =>
      _FundProjectDetailYoutubePlayerState();
}

class _FundProjectDetailYoutubePlayerState
    extends State<FundProjectDetailYoutubePlayer>
    with WidgetsBindingObserver {
  YoutubePlayerController? _controller;
  String? _videoId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _configureController();
  }

  @override
  void didUpdateWidget(covariant FundProjectDetailYoutubePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl.trim() != widget.videoUrl.trim()) {
      _configureController();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _controller?.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  void _configureController() {
    final videoId = extractFundProjectYoutubeVideoId(widget.videoUrl);
    final currentController = _controller;
    if (videoId == null) {
      currentController?.dispose();
      setState(() {
        _videoId = null;
        _controller = null;
      });
      return;
    }
    if (_videoId == videoId && currentController != null) {
      return;
    }
    final nextController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        controlsVisibleAtStart: true,
        enableCaption: false,
      ),
    );
    currentController?.dispose();
    setState(() {
      _videoId = videoId;
      _controller = nextController;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) {
      return _FundProjectVideoErrorState(onRetry: _configureController);
    }

    final theme = Theme.of(context);
    final colors = theme.appColors;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.heroStart,
        borderRadius: BorderRadius.circular(UiTokens.radius16),
        border: Border.all(color: colors.borderSoft),
      ),
      child: YoutubePlayer(
        controller: controller,
        aspectRatio: 16 / 9,
        showVideoProgressIndicator: true,
        bottomActions: const <Widget>[
          SizedBox(width: 14),
          CurrentPosition(),
          SizedBox(width: 8),
          ProgressBar(isExpanded: true),
          RemainingDuration(),
          SizedBox(width: 14),
        ],
        progressIndicatorColor: colors.highlightGold,
        progressColors: ProgressBarColors(
          playedColor: colors.highlightGold,
          handleColor: colors.highlightGold,
          bufferedColor: colors.onDark.withValues(alpha: 0.42),
          backgroundColor: colors.onDark.withValues(alpha: 0.22),
        ),
        bufferIndicator: Center(
          child: SizedBox.square(
            dimension: 34,
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(colors.highlightGold),
            ),
          ),
        ),
      ),
    );
  }
}

class _FundProjectVideoReadyState extends StatelessWidget {
  const _FundProjectVideoReadyState({
    required this.controller,
    required this.onTogglePlayback,
    required this.onSeekToProgress,
  });

  final VideoPlayerController controller;
  final VoidCallback onTogglePlayback;
  final ValueChanged<double> onSeekToProgress;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final value = controller.value;
    final position = _normalizedPosition(value);
    final duration = value.duration;
    final progress = _progressValue(position: position, duration: duration);

    return AspectRatio(
      aspectRatio: _safeAspectRatio(value.aspectRatio),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const ColoredBox(color: Colors.black),
          VideoPlayer(controller),
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTogglePlayback,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Colors.transparent, Color(0x8C000000)],
                  ),
                ),
              ),
            ),
          ),
          if (value.isBuffering)
            Center(
              child: SizedBox.square(
                dimension: 34,
                child: CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colors.highlightGold,
                  ),
                ),
              ),
            ),
          if (!value.isPlaying)
            Center(
              child: _FundProjectVideoCenterButton(onPressed: onTogglePlayback),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _FundProjectVideoControls(
              isPlaying: value.isPlaying,
              progress: progress,
              position: position,
              duration: duration,
              onTogglePlayback: onTogglePlayback,
              onSeekToProgress: duration > Duration.zero
                  ? onSeekToProgress
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

Uri? _parseHttpUri(String rawUrl) {
  final uri = Uri.tryParse(rawUrl.trim());
  if (uri == null ||
      !uri.hasScheme ||
      (uri.scheme != 'http' && uri.scheme != 'https')) {
    return null;
  }
  return uri;
}

bool _isDirectPlayableVideoUrl(Uri uri) {
  const playableExtensions = <String>{
    'mp4',
    'm4v',
    'mov',
    'webm',
    'm3u8',
    'mpd',
    '3gp',
    '3gpp',
  };
  final pathSegments = uri.pathSegments;
  if (pathSegments.isEmpty) {
    return false;
  }
  final fileName = pathSegments.last.toLowerCase();
  final dotIndex = fileName.lastIndexOf('.');
  if (dotIndex < 0 || dotIndex == fileName.length - 1) {
    return false;
  }
  final extension = fileName.substring(dotIndex + 1);
  return playableExtensions.contains(extension);
}

class _FundProjectVideoCenterButton extends StatelessWidget {
  const _FundProjectVideoCenterButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Material(
      color: colors.heroStart.withValues(alpha: 0.76),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox.square(
          dimension: 58,
          child: Icon(
            Icons.play_arrow_rounded,
            color: colors.highlightGold,
            size: 38,
          ),
        ),
      ),
    );
  }
}

class _FundProjectVideoControls extends StatelessWidget {
  const _FundProjectVideoControls({
    required this.isPlaying,
    required this.progress,
    required this.position,
    required this.duration,
    required this.onTogglePlayback,
    required this.onSeekToProgress,
  });

  final bool isPlaying;
  final double progress;
  final Duration position;
  final Duration duration;
  final VoidCallback onTogglePlayback;
  final ValueChanged<double>? onSeekToProgress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 26, 10, 8),
      child: Row(
        children: <Widget>[
          IconButton(
            visualDensity: VisualDensity.compact,
            color: colors.onDark,
            onPressed: onTogglePlayback,
            icon: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              ),
              child: Slider(
                value: progress,
                min: 0,
                max: 1,
                activeColor: colors.highlightGold,
                inactiveColor: colors.onDark.withValues(alpha: 0.30),
                onChanged: onSeekToProgress,
              ),
            ),
          ),
          const SizedBox(width: UiTokens.spacing8),
          Text(
            '${_formatDuration(position)} / ${_formatDuration(duration)}',
            style: appText.micro.copyWith(color: colors.onDark),
          ),
        ],
      ),
    );
  }
}

class _FundProjectVideoErrorState extends StatelessWidget {
  const _FundProjectVideoErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ColoredBox(
        color: colors.heroStart,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.play_disabled_rounded,
                  color: colors.onDark.withValues(alpha: 0.72),
                  size: 32,
                ),
                const SizedBox(height: UiTokens.spacing8),
                Text(
                  context.l10n.fundDetailReferenceVideoLoadError,
                  textAlign: TextAlign.center,
                  style: appText.bodyMuted.copyWith(color: colors.onDark),
                ),
                const SizedBox(height: UiTokens.spacing12),
                TextButton(
                  onPressed: onRetry,
                  child: Text(
                    context.l10n.fundListRetry,
                    style: appText.button.copyWith(color: colors.highlightGold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Duration _normalizedPosition(VideoPlayerValue value) {
  if (value.duration <= Duration.zero) {
    return Duration.zero;
  }
  if (value.position < Duration.zero) {
    return Duration.zero;
  }
  if (value.position > value.duration) {
    return value.duration;
  }
  return value.position;
}

double _progressValue({
  required Duration position,
  required Duration duration,
}) {
  if (duration <= Duration.zero) {
    return 0;
  }
  return (position.inMilliseconds / duration.inMilliseconds)
      .clamp(0, 1)
      .toDouble();
}

double _safeAspectRatio(double aspectRatio) {
  if (aspectRatio.isNaN || aspectRatio.isInfinite || aspectRatio <= 0) {
    return 16 / 9;
  }
  return aspectRatio.clamp(0.75, 2.35).toDouble();
}

String _formatDuration(Duration duration) {
  final totalSeconds = duration.inSeconds < 0 ? 0 : duration.inSeconds;
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;
  final seconds = totalSeconds % 60;
  final secondsText = seconds.toString().padLeft(2, '0');
  if (hours > 0) {
    final minutesText = minutes.toString().padLeft(2, '0');
    return '$hours:$minutesText:$secondsText';
  }
  return '$minutes:$secondsText';
}
