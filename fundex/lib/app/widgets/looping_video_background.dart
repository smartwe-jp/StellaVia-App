import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LoopingVideoBackground extends StatefulWidget {
  const LoopingVideoBackground({
    super.key,
    required this.posterAsset,
    required this.uri,
  });
  final String posterAsset;
  final Uri uri;

  @override
  State<LoopingVideoBackground> createState() => _LoopingVideoBackgroundState();
}

class _LoopingVideoBackgroundState extends State<LoopingVideoBackground>
    with WidgetsBindingObserver {
  VideoPlayerController? _player;
  bool _visible = false;
  bool _foreground = true;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final state = WidgetsBinding.instance.lifecycleState;
    _foreground = state == null || state == AppLifecycleState.resumed;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _visible =
        ModalRoute.isCurrentOf(context) == true &&
        !MediaQuery.disableAnimationsOf(context);
    if (_visible && _player == null) {
      _initialize();
    } else {
      _sync();
    }
  }

  Future<void> _initialize() async {
    final player = VideoPlayerController.networkUrl(
      widget.uri,
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
        allowBackgroundPlayback: true,
      ),
    );
    _player = player;
    try {
      await player.initialize();
      if (!mounted) return;
      await player.setVolume(0);
      if (!mounted) return;
      await player.setLooping(true);
      if (!mounted) return;
      setState(() => _ready = true);
      _sync();
    } catch (_) {
      // The bundled poster remains usable when the remote video is unavailable.
    }
  }

  void _sync() {
    if (!_ready) return;
    if (_visible && _foreground) {
      _player!.play();
    } else {
      _player!.pause();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    _sync();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _player?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      Image.asset(
        widget.posterAsset,
        fit: BoxFit.cover,
        excludeFromSemantics: true,
      ),
      if (_ready && _visible)
        ValueListenableBuilder<VideoPlayerValue>(
          valueListenable: _player!,
          builder: (_, value, video) => value.hasError || value.size.isEmpty
              ? const SizedBox.shrink()
              : ClipRect(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox.fromSize(size: value.size, child: video),
                  ),
                ),
          child: VideoPlayer(_player!),
        ),
    ],
  );
}
