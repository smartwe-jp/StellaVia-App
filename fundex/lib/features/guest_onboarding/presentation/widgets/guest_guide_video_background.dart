import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/environment_provider.dart';
import '../../../../app/widgets/looping_video_background.dart';

class GuestGuideVideoBackground extends ConsumerWidget {
  const GuestGuideVideoBackground({super.key, required this.posterAsset});

  final String posterAsset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uri = Uri.parse(
      ref.watch(appEnvironmentProvider).oaApiBaseUrl,
    ).resolve('/vid/stella_0002.mp4');
    return LoopingVideoBackground(
      key: ValueKey(uri),
      uri: uri,
      posterAsset: posterAsset,
    );
  }
}
