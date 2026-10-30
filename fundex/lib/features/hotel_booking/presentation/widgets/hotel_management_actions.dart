import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../support/hotel_management_styles.dart';

const _checkInIcon = IconData(
  0xf561,
  fontFamily: 'MaterialSymbolsOutlined',
  fontPackage: 'material_symbols_icons',
);

class HotelManagementActions extends StatelessWidget {
  const HotelManagementActions({
    super.key,
    required this.onOrders,
    required this.onCheckIn,
    required this.onCoupons,
    required this.onContacts,
  });
  final VoidCallback onOrders, onCheckIn, onCoupons, onContacts;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final items = [
      (Icons.receipt_long_outlined, l.hotelQuickActionOrders, onOrders),
      (_checkInIcon, l.hotelQuickActionCheckIn, onCheckIn),
      (Icons.confirmation_num_outlined, l.hotelQuickActionCoupons, onCoupons),
      (Icons.group_add_outlined, l.hotelQuickActionContacts, onContacts),
    ];
    return LayoutBuilder(
      builder: (context, constraints) => Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final item in items)
            SizedBox(
              width: (constraints.maxWidth - 12) / 2,
              child: AppCard(
                onTap: item.$3,
                child: Column(
                  children: [
                    Icon(item.$1, size: 30, color: context.appColors.primary),
                    const SizedBox(height: 10),
                    Text(
                      item.$2,
                      textAlign: TextAlign.center,
                      style: HotelManagementStyles.label(context),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
