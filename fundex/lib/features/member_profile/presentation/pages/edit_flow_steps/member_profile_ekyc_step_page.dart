import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations_ext.dart';

class MemberProfileEkycStepPage extends StatelessWidget {
  const MemberProfileEkycStepPage({
    super.key,
    required this.documentType,
    required this.documentTypeItems,
    required this.documentFrontUploaded,
    required this.documentBackUploaded,
    this.primaryButtonEnabled = true,
    this.titleOverride,
    this.descriptionOverride,
    this.primaryButtonLabelOverride,
    this.onDocumentTypeChanged,
    this.onUploadDocumentFront,
    this.onUploadDocumentBack,
    this.onNext,
  });

  final String? documentType;
  final List<DropdownMenuItem<String>> documentTypeItems;
  final bool documentFrontUploaded;
  final bool documentBackUploaded;
  final bool primaryButtonEnabled;
  final String? titleOverride;
  final String? descriptionOverride;
  final String? primaryButtonLabelOverride;
  final ValueChanged<String?>? onDocumentTypeChanged;
  final VoidCallback? onUploadDocumentFront;
  final VoidCallback? onUploadDocumentBack;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MemberProfileEditStepScaffold(
      title: titleOverride ?? l10n.memberProfileStep4Title,
      description: descriptionOverride ?? l10n.memberProfileStep4Description,
      primaryButtonLabel: primaryButtonLabelOverride ?? l10n.commonNext,
      onPrimaryPressed: onNext,
      primaryButtonEnabled: primaryButtonEnabled,
      child: Column(
        children: <Widget>[
          MemberProfileSelectField<String>(
            label: l10n.memberProfileDocumentTypeLabel,
            value: documentType,
            items: documentTypeItems,
            onChanged: onDocumentTypeChanged,
          ),
          const SizedBox(height: 14),
          MemberProfileUploadTile(
            icon: Icons.camera_alt_outlined,
            title: l10n.memberProfilePhotoDocumentFrontTitle,
            description: l10n.memberProfilePhotoDocumentFrontDescription,
            isCompleted: documentFrontUploaded,
            onTap: onUploadDocumentFront,
          ),
          const SizedBox(height: 14),
          MemberProfileUploadTile(
            icon: Icons.flip_to_back_outlined,
            title: l10n.memberProfilePhotoDocumentBackTitle,
            description: l10n.memberProfilePhotoDocumentBackDescription,
            isCompleted: documentBackUploaded,
            onTap: onUploadDocumentBack,
          ),
        ],
      ),
    );
  }
}
