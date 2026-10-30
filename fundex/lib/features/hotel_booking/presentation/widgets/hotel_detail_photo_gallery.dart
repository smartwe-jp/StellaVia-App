import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import 'hotel_detail_image_placeholder.dart';

class HotelDetailPhotoGallery extends StatefulWidget {
  const HotelDetailPhotoGallery({super.key, required this.images});
  final List<HotelDetailImage> images;
  @override
  State<HotelDetailPhotoGallery> createState() =>
      _HotelDetailPhotoGalleryState();
}

class _HotelDetailPhotoGalleryState extends State<HotelDetailPhotoGallery> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final urls = widget.images
        .map((e) => e.url.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    return SizedBox(
      height: 260,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (urls.isEmpty)
            const HotelDetailImagePlaceholder()
          else
            PageView.builder(
              itemCount: urls.length,
              onPageChanged: (i) => setState(() => index = i),
              itemBuilder: (context, i) => GestureDetector(
                onTap: () => openAppImageViewer(
                  context,
                  initialIndex: i,
                  items: [
                    for (final url in urls) AppImageViewerItem(source: url),
                  ],
                  texts: AppImageViewerTexts(
                    loadingLabel: context.l10n.imageViewerLoadingLabel,
                    loadFailedLabel: context.l10n.imageViewerLoadFailedLabel,
                    retryLabel: context.l10n.imageViewerRetryLabel,
                    invalidSourceNotice:
                        context.l10n.imageViewerInvalidSourceNotice,
                    closeTooltip: context.l10n.imageViewerCloseTooltip,
                  ),
                ),
                child: AppRemoteImage(
                  imageUrl: urls[i],
                  fit: BoxFit.cover,
                  placeholder: const HotelDetailImagePlaceholder(),
                  errorWidget: const HotelDetailImagePlaceholder(),
                ),
              ),
            ),
          if (urls.isNotEmpty)
            Positioned(
              right: 16,
              bottom: 16,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.appColors.scrim.withValues(alpha: .55),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/images/hotel-detail-gallery.svg',
                        width: 14,
                        height: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${index + 1}/${urls.length}',
                        style: context.appTextTheme.caption.copyWith(
                          color: context.appColors.onDark,
                        ),
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
