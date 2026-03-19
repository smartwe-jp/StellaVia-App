import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/fund_project.dart';

class FundProjectDetailTitleBlock extends StatelessWidget {
  const FundProjectDetailTitleBlock({super.key, required this.project});

  final FundProject project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final titleParts = _splitProjectTitle(project.projectName);
    final titleStyle = appText.pageTitle.copyWith(
      color: colors.textPrimary,
      fontWeight: FontWeight.w900,
      height: 1.08,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (titleParts.$1 != null)
          Text(titleParts.$1!, style: titleStyle.copyWith(height: 1.04)),
        if (titleParts.$1 != null) const SizedBox(height: 2),
        Text(titleParts.$2, style: titleStyle),
      ],
    );
  }
}

(String?, String) _splitProjectTitle(String title) {
  final normalized = title.trim();
  if (normalized.isEmpty) {
    return (null, title);
  }

  final spaceIndex = normalized.indexWhere(
    (String character) => character.trim().isEmpty || character == '　',
  );
  if (spaceIndex <= 0 || spaceIndex >= normalized.length - 1) {
    return (null, normalized);
  }

  final first = normalized.substring(0, spaceIndex).trim();
  final second = normalized.substring(spaceIndex + 1).trim();
  if (first.isEmpty || second.isEmpty) {
    return (null, normalized);
  }
  return (first, second);
}

extension on String {
  int indexWhere(bool Function(String character) predicate) {
    for (var index = 0; index < length; index++) {
      if (predicate(this[index])) {
        return index;
      }
    }
    return -1;
  }
}
