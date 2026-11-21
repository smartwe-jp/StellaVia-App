import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../investment/presentation/widgets/fund_project_detail_video_player.dart';

class HomeServiceVideo extends StatelessWidget {
  const HomeServiceVideo({
    super.key,
    this.videoUrl = const String.fromEnvironment(
      'HOME_SERVICE_VIDEO_URL',
      defaultValue: 'https://testoa.gutingjun.com/vid/stella_0002.mp4',
    ),
  });

  final String videoUrl;

  @override
  Widget build(BuildContext context) {
    final url = videoUrl.trim();
    if (url.isNotEmpty) {
      if (isFundProjectDirectPlayableVideoUrl(url)) {
        return FundProjectDetailVideoPlayer(videoUrl: url);
      }
      if (isFundProjectYoutubeVideoUrl(url)) {
        return FundProjectDetailYoutubePlayer(videoUrl: url);
      }
      return FundProjectDetailExternalVideoLinkRow(videoUrl: url);
    }

    final colors = context.appColors;
    return ClipRRect(
      borderRadius: BorderRadius.circular(UiTokens.radius16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/home_service_about.png',
              fit: BoxFit.cover,
              excludeFromSemantics: true,
            ),
            ColoredBox(color: colors.scrim.withValues(alpha: 0.4)),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.ondemand_video_rounded,
                    color: colors.onDark,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.homeServiceVideoPending,
                    style: context.appTextTheme.caption.copyWith(
                      color: colors.onDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
