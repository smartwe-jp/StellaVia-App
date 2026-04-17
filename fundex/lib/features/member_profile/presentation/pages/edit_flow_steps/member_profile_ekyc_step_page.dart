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
    required this.showDocumentBack,
    this.documentFrontPreviewUrl,
    this.documentBackPreviewUrl,
    this.previewActionLabel,
    this.primaryButtonEnabled = true,
    this.titleOverride,
    this.descriptionOverride,
    this.secondaryButtonLabelOverride,
    this.onSecondaryPressed,
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
  final bool showDocumentBack;
  final String? documentFrontPreviewUrl;
  final String? documentBackPreviewUrl;
  final String? previewActionLabel;
  final bool primaryButtonEnabled;
  final String? titleOverride;
  final String? descriptionOverride;
  final String? secondaryButtonLabelOverride;
  final VoidCallback? onSecondaryPressed;
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
      secondaryButtonLabel: secondaryButtonLabelOverride,
      onSecondaryPressed: onSecondaryPressed,
      primaryButtonLabel: primaryButtonLabelOverride ?? l10n.commonNext,
      onPrimaryPressed: onNext,
      primaryButtonEnabled: primaryButtonEnabled,
      child: Column(
        children: <Widget>[
          _MemberProfileDocumentGuideCard(
            title: l10n.memberProfileDocumentGuideTitle,
            body: l10n.memberProfileDocumentGuideBody,
          ),
          const SizedBox(height: 14),
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
            previewLabel: previewActionLabel,
            previewUrl: documentFrontPreviewUrl,
            inlinePreview: true,
            onTap: onUploadDocumentFront,
          ),
          if (showDocumentBack) ...<Widget>[
            const SizedBox(height: 14),
            MemberProfileUploadTile(
              icon: Icons.flip_to_back_outlined,
              title: l10n.memberProfilePhotoDocumentBackTitle,
              description: l10n.memberProfilePhotoDocumentBackDescription,
              isCompleted: documentBackUploaded,
              previewLabel: previewActionLabel,
              previewUrl: documentBackPreviewUrl,
              inlinePreview: true,
              onTap: onUploadDocumentBack,
            ),
          ],
        ],
      ),
    );
  }
}

class _MemberProfileDocumentGuideCard extends StatefulWidget {
  const _MemberProfileDocumentGuideCard({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  State<_MemberProfileDocumentGuideCard> createState() =>
      _MemberProfileDocumentGuideCardState();
}

class _MemberProfileDocumentGuideCardState
    extends State<_MemberProfileDocumentGuideCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _expanded ? colors.highlightGold : colors.border,
          width: 1.5,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color: colors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: appText.cardTitle.copyWith(
                          color: colors.primary,
                        ),
                      ),
                    ),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: colors.primary,
                    ),
                  ],
                ),
                if (_expanded) ...<Widget>[
                  const SizedBox(height: 10),
                  Text(
                    widget.body,
                    style: appText.helper.copyWith(
                      color: colors.textPrimary,
                      height: 1.65,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
