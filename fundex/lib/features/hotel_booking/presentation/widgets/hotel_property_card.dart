import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../support/hotel_home_text_styles.dart';

class HotelPropertyCard extends StatelessWidget {
  const HotelPropertyCard({
    super.key,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.details,
    this.onTap,
    this.onMapTap,
    this.previewImageAsset,
  });

  final String name, location, imageUrl;
  final List<Widget> details;
  final VoidCallback? onTap, onMapTap;
  final String? previewImageAsset;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = Theme.of(context).textTheme;
    return AppCard(
      backgroundColor: colors.surface,
      borderColor: colors.borderSoft,
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 334 / 164,
              child: previewImageAsset != null
                  ? Image.asset(previewImageAsset!, fit: BoxFit.cover)
                  : AppRemoteImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: ColoredBox(
                        color: colors.surfaceAlt,
                        child: Icon(
                          Icons.hotel_outlined,
                          color: colors.textTertiary,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          if (location.isNotEmpty)
            InkWell(
              onTap: onMapTap,
              child: Text(
                location,
                style: text.labelMedium?.copyWith(color: colors.brandSecondary),
              ),
            ),
          const SizedBox(height: 6),
          Text(
            name.isEmpty ? context.l10n.hotelUnnamedProperty : name,
            style: HotelHomeTextStyles.hotelName(context),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          ...details,
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
