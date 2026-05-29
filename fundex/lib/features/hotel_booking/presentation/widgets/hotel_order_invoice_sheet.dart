import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import 'hotel_booking_section_card.dart';

enum HotelOrderDetailMoreAction { invoice }

class HotelOrderInvoiceFormData {
  const HotelOrderInvoiceFormData({
    required this.receiptTitle,
    required this.email,
  });

  final String receiptTitle;
  final String email;
}

Future<HotelOrderInvoiceFormData?> showHotelOrderInvoiceSheet({
  required BuildContext context,
  required String initialReceiptTitle,
  required String initialEmail,
}) {
  return AppBottomSheet.showAdaptive<HotelOrderInvoiceFormData>(
    context: context,
    useRootNavigator: true,
    builder: (BuildContext context) {
      return SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: HotelOrderInvoiceSheet(
            initialReceiptTitle: initialReceiptTitle,
            initialEmail: initialEmail,
          ),
        ),
      );
    },
  );
}

class HotelOrderInvoiceSheet extends StatefulWidget {
  const HotelOrderInvoiceSheet({
    super.key,
    required this.initialReceiptTitle,
    required this.initialEmail,
  });

  final String initialReceiptTitle;
  final String initialEmail;

  @override
  State<HotelOrderInvoiceSheet> createState() => _HotelOrderInvoiceSheetState();
}

class _HotelOrderInvoiceSheetState extends State<HotelOrderInvoiceSheet> {
  late final TextEditingController _receiptTitleController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _receiptTitleController = TextEditingController(
      text: widget.initialReceiptTitle.trim(),
    );
    _emailController = TextEditingController(text: widget.initialEmail.trim());
  }

  @override
  void dispose() {
    _receiptTitleController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          context.l10n.hotelOrderInvoiceReceiptTitleLabel,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        HotelBookingTextField(controller: _receiptTitleController),
        const SizedBox(height: 18),
        Text(
          context.l10n.hotelOrderInvoiceEmailLabel,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        HotelBookingTextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UiTokens.radius16),
              ),
              textStyle: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            icon: const Icon(Icons.download_rounded),
            label: Text(context.l10n.hotelOrderInvoiceDownloadAction),
            onPressed: _submit,
          ),
        ),
      ],
    );
  }

  void _submit() {
    final receiptTitle = _receiptTitleController.text.trim();
    final email = _emailController.text.trim();
    if (receiptTitle.isEmpty || email.isEmpty) {
      AppNotice.show(
        context,
        message: context.l10n.hotelOrderInvoiceValidationMessage,
      );
      return;
    }
    Navigator.of(
      context,
    ).pop(HotelOrderInvoiceFormData(receiptTitle: receiptTitle, email: email));
  }
}
