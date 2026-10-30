import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../support/hotel_management_styles.dart';

class HotelManagementCapacity extends StatelessWidget {
  const HotelManagementCapacity({
    super.key,
    required this.current,
    required this.maximum,
    required this.loading,
    required this.hasError,
    required this.onRetry,
  });
  final int? current, maximum;
  final bool loading, hasError;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.all(18),
    backgroundColor: HotelManagementStyles.capacityBackground(context),
    borderColor: HotelManagementStyles.capacityBorder(context),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.hotelManagementCapacity,
                    style: HotelManagementStyles.label(
                      context,
                    ).copyWith(color: context.appColors.primary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.l10n.hotelManagementCapacityHint,
                    style: HotelManagementStyles.caption(context),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (loading && current == null && maximum == null)
              const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: current?.toString() ?? '—',
                      style: HotelManagementStyles.count(context),
                    ),
                    TextSpan(
                      text: ' / ${maximum?.toString() ?? '—'}',
                      style: context.appTextTheme.numericBody.copyWith(
                        fontSize: 14,
                        color: context.appColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        if (hasError)
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.hotelManagementLoadFailed,
                  style: HotelManagementStyles.caption(context),
                ),
              ),
              TextButton(
                onPressed: onRetry,
                child: Text(context.l10n.commonRetry),
              ),
            ],
          ),
      ],
    ),
  );
}

class HotelManagementNextTrip extends StatelessWidget {
  const HotelManagementNextTrip({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.all(18),
    onTap: onTap,
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: context.appColors.surfaceAlt,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/images/hotel-management-next-trip.svg',
            width: 22,
            height: 22,
            colorFilter: ColorFilter.mode(
              context.appColors.textPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.hotelManagementNextTrip,
                style: HotelManagementStyles.nextTitle(context),
              ),
              Text(
                context.l10n.hotelManagementNextTripHint,
                style: HotelManagementStyles.caption(context),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SvgPicture.asset(
          'assets/images/hotel-management-chevron.svg',
          width: 8,
          height: 14,
          colorFilter: ColorFilter.mode(
            context.appColors.textSecondary,
            BlendMode.srcIn,
          ),
        ),
      ],
    ),
  );
}
