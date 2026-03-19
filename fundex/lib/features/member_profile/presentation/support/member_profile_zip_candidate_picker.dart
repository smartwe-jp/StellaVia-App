import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/member_profile_region.dart';

class MemberProfileZipCandidatePicker {
  const MemberProfileZipCandidatePicker._();

  static Future<MemberProfileRegion?> show(
    BuildContext context, {
    required List<MemberProfileRegion> candidates,
    required String title,
    required String cancelLabel,
  }) {
    return showModalBottomSheet<MemberProfileRegion>(
      context: context,
      isScrollControlled: false,
      showDragHandle: true,
      builder: (BuildContext sheetContext) {
        final theme = Theme.of(sheetContext);
        final colors = theme.appColors;
        final appText = theme.appTextTheme;
        return SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.72,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                  child: Text(title, style: appText.pageTitle),
                ),
                Flexible(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                    itemCount: candidates.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (BuildContext itemContext, int index) {
                      final item = candidates[index];
                      final title = item.displayName;
                      final subtitle = item.roomName.trim();
                      return Material(
                        color: colors.surfaceAlt,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.of(itemContext).pop(item),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(title, style: appText.cardTitle),
                                if (subtitle.isNotEmpty && subtitle != title)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text(
                                      subtitle,
                                      style: appText.helper.copyWith(
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(sheetContext).pop(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(cancelLabel),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
