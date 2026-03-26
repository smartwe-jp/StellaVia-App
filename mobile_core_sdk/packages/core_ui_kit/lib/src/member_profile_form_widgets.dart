import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_theme_extensions.dart';

class MemberProfileInputFormatters {
  const MemberProfileInputFormatters._();

  static final TextInputFormatter katakanaOnly = _KanaNormalizeFormatter();

  static final TextInputFormatter romanNameOnly = _RomanNameFormatter();
}

class _KanaNormalizeFormatter extends TextInputFormatter {
  static final RegExp _allowed = RegExp(r'[ァ-ヶー・ヴヷ-ヺヽヾ゛゜ 　]');
  static const Map<String, String> _halfWidthSingleMap = <String, String>{
    'ｱ': 'ア',
    'ｲ': 'イ',
    'ｳ': 'ウ',
    'ｴ': 'エ',
    'ｵ': 'オ',
    'ｧ': 'ァ',
    'ｨ': 'ィ',
    'ｩ': 'ゥ',
    'ｪ': 'ェ',
    'ｫ': 'ォ',
    'ｶ': 'カ',
    'ｷ': 'キ',
    'ｸ': 'ク',
    'ｹ': 'ケ',
    'ｺ': 'コ',
    'ｻ': 'サ',
    'ｼ': 'シ',
    'ｽ': 'ス',
    'ｾ': 'セ',
    'ｿ': 'ソ',
    'ﾀ': 'タ',
    'ﾁ': 'チ',
    'ﾂ': 'ツ',
    'ﾃ': 'テ',
    'ﾄ': 'ト',
    'ｯ': 'ッ',
    'ﾅ': 'ナ',
    'ﾆ': 'ニ',
    'ﾇ': 'ヌ',
    'ﾈ': 'ネ',
    'ﾉ': 'ノ',
    'ﾊ': 'ハ',
    'ﾋ': 'ヒ',
    'ﾌ': 'フ',
    'ﾍ': 'ヘ',
    'ﾎ': 'ホ',
    'ﾏ': 'マ',
    'ﾐ': 'ミ',
    'ﾑ': 'ム',
    'ﾒ': 'メ',
    'ﾓ': 'モ',
    'ﾔ': 'ヤ',
    'ﾕ': 'ユ',
    'ﾖ': 'ヨ',
    'ｬ': 'ャ',
    'ｭ': 'ュ',
    'ｮ': 'ョ',
    'ﾗ': 'ラ',
    'ﾘ': 'リ',
    'ﾙ': 'ル',
    'ﾚ': 'レ',
    'ﾛ': 'ロ',
    'ﾜ': 'ワ',
    'ｦ': 'ヲ',
    'ﾝ': 'ン',
    'ｰ': 'ー',
    '･': '・',
    ' ': ' ',
    '　': '　',
  };
  static const Map<String, String> _halfWidthDakutenMap = <String, String>{
    'ｳ': 'ヴ',
    'ｶ': 'ガ',
    'ｷ': 'ギ',
    'ｸ': 'グ',
    'ｹ': 'ゲ',
    'ｺ': 'ゴ',
    'ｻ': 'ザ',
    'ｼ': 'ジ',
    'ｽ': 'ズ',
    'ｾ': 'ゼ',
    'ｿ': 'ゾ',
    'ﾀ': 'ダ',
    'ﾁ': 'ヂ',
    'ﾂ': 'ヅ',
    'ﾃ': 'デ',
    'ﾄ': 'ド',
    'ﾊ': 'バ',
    'ﾋ': 'ビ',
    'ﾌ': 'ブ',
    'ﾍ': 'ベ',
    'ﾎ': 'ボ',
    'ﾜ': 'ヷ',
    'ｦ': 'ヺ',
  };
  static const Map<String, String> _halfWidthHandakutenMap = <String, String>{
    'ﾊ': 'パ',
    'ﾋ': 'ピ',
    'ﾌ': 'プ',
    'ﾍ': 'ペ',
    'ﾎ': 'ポ',
  };
  static const String _dakuten = 'ﾞ';
  static const String _handakuten = 'ﾟ';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.composing.isValid && !newValue.composing.isCollapsed) {
      return newValue;
    }

    final String text = _normalizeText(newValue.text);
    final int baseOffset = _normalizedOffset(
      rawText: newValue.text,
      rawOffset: newValue.selection.baseOffset,
    );
    final int extentOffset = _normalizedOffset(
      rawText: newValue.text,
      rawOffset: newValue.selection.extentOffset,
    );
    return newValue.copyWith(
      text: text,
      selection: TextSelection(
        baseOffset: baseOffset.clamp(0, text.length),
        extentOffset: extentOffset.clamp(0, text.length),
      ),
      composing: TextRange.empty,
    );
  }

  int _normalizedOffset({required String rawText, required int rawOffset}) {
    final int clampedOffset = math.max(0, math.min(rawOffset, rawText.length));
    return _normalizeText(rawText.substring(0, clampedOffset)).length;
  }

  String _normalizeText(String rawText) {
    final StringBuffer buffer = StringBuffer();

    for (int index = 0; index < rawText.length;) {
      final _KanaToken token = _normalizeKanaToken(rawText, index);
      index += token.consumedLength;
      if (token.value.isNotEmpty && _allowed.hasMatch(token.value)) {
        buffer.write(token.value);
      }
    }
    return buffer.toString();
  }

  _KanaToken _normalizeKanaToken(String rawText, int startIndex) {
    final String char = rawText[startIndex];
    if (char == _dakuten || char == _handakuten) {
      return const _KanaToken(value: '', consumedLength: 1);
    }

    final int codePoint = char.codeUnitAt(0);
    if (codePoint >= 0x3041 && codePoint <= 0x3096) {
      return _KanaToken(
        value: String.fromCharCode(codePoint + 0x60),
        consumedLength: 1,
      );
    }
    if (codePoint >= 0x309D && codePoint <= 0x309E) {
      return _KanaToken(
        value: String.fromCharCode(codePoint + 0x60),
        consumedLength: 1,
      );
    }

    final String? next = startIndex + 1 < rawText.length
        ? rawText[startIndex + 1]
        : null;
    if (next == _dakuten) {
      final mapped = _halfWidthDakutenMap[char];
      if (mapped != null) {
        return _KanaToken(value: mapped, consumedLength: 2);
      }
    }
    if (next == _handakuten) {
      final mapped = _halfWidthHandakutenMap[char];
      if (mapped != null) {
        return _KanaToken(value: mapped, consumedLength: 2);
      }
    }

    final mapped = _halfWidthSingleMap[char];
    if (mapped != null) {
      return _KanaToken(value: mapped, consumedLength: 1);
    }

    return _KanaToken(value: char, consumedLength: 1);
  }
}

class _RomanNameFormatter extends TextInputFormatter {
  static final RegExp _allowed = RegExp(r'[A-Z ]');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.composing.isValid && !newValue.composing.isCollapsed) {
      return newValue;
    }

    final String text = _normalizeText(newValue.text);
    final int baseOffset = _normalizedOffset(
      rawText: newValue.text,
      rawOffset: newValue.selection.baseOffset,
    );
    final int extentOffset = _normalizedOffset(
      rawText: newValue.text,
      rawOffset: newValue.selection.extentOffset,
    );
    return newValue.copyWith(
      text: text,
      selection: TextSelection(
        baseOffset: baseOffset.clamp(0, text.length),
        extentOffset: extentOffset.clamp(0, text.length),
      ),
      composing: TextRange.empty,
    );
  }

  int _normalizedOffset({required String rawText, required int rawOffset}) {
    final int clampedOffset = math.max(0, math.min(rawOffset, rawText.length));
    return _normalizeText(rawText.substring(0, clampedOffset)).length;
  }

  String _normalizeText(String rawText) {
    final StringBuffer buffer = StringBuffer();
    bool previousWasSpace = false;

    for (int index = 0; index < rawText.length; index += 1) {
      final String normalizedChar = rawText[index].toUpperCase();
      if (!_allowed.hasMatch(normalizedChar)) {
        continue;
      }
      if (normalizedChar == ' ') {
        if (buffer.isEmpty || previousWasSpace) {
          continue;
        }
        previousWasSpace = true;
        buffer.write(normalizedChar);
        continue;
      }
      previousWasSpace = false;
      buffer.write(normalizedChar);
    }
    return buffer.toString();
  }
}

class _KanaToken {
  const _KanaToken({required this.value, required this.consumedLength});

  final String value;
  final int consumedLength;
}

class MemberProfileFieldLabel extends StatelessWidget {
  const MemberProfileFieldLabel({
    super.key,
    required this.label,
    this.isRequired = false,
    this.color,
  });

  final String label;
  final bool isRequired;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final effectiveColor =
        color ?? colors.textSecondary.withValues(alpha: 0.82);
    return RichText(
      text: TextSpan(
        style: appText.inputLabel.copyWith(color: effectiveColor),
        children: <InlineSpan>[
          if (isRequired)
            TextSpan(
              text: '* ',
              style: appText.inputLabel.copyWith(color: colors.danger),
            ),
          TextSpan(text: label),
        ],
      ),
    );
  }
}

class MemberProfileTextField extends StatelessWidget {
  const MemberProfileTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.readOnly = false,
    this.maxLines = 1,
    this.suffixIcon,
    this.onTap,
    this.inputFormatters,
    this.isRequired = false,
    this.labelColor,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool readOnly;
  final int maxLines;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final bool isRequired;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appText = theme.appTextTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MemberProfileFieldLabel(
          label: label,
          isRequired: isRequired,
          color: labelColor,
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          maxLines: maxLines,
          onTap: onTap,
          inputFormatters: inputFormatters,
          decoration: memberProfileInputDecoration(
            context: context,
            hintText: hintText,
            suffixIcon: suffixIcon,
          ),
          style: appText.inputText,
        ),
      ],
    );
  }
}

class MemberProfileSelectField<T> extends StatelessWidget {
  const MemberProfileSelectField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    this.onChanged,
    this.isRequired = false,
    this.labelColor,
  });

  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final bool isRequired;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MemberProfileFieldLabel(
          label: label,
          isRequired: isRequired,
          color: labelColor,
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: colors.textSecondary,
          ),
          decoration: memberProfileInputDecoration(context: context),
          style: appText.inputText,
          dropdownColor: colors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
      ],
    );
  }
}

class MemberProfileBankAccountFormSection extends StatelessWidget {
  const MemberProfileBankAccountFormSection({
    super.key,
    required this.bankNameLabel,
    required this.bankNameController,
    required this.bankNameHintText,
    required this.branchNameLabel,
    required this.branchNameController,
    required this.branchNameHintText,
    required this.accountTypeLabel,
    required this.accountType,
    required this.accountTypeItems,
    this.branchNumberLabel,
    this.branchNumberController,
    this.branchNumberHintText,
    required this.accountNumberLabel,
    required this.accountNumberController,
    required this.accountNumberHintText,
    required this.accountHolderLabel,
    required this.accountHolderController,
    required this.accountHolderHintText,
    this.onAccountTypeChanged,
  });

  final String bankNameLabel;
  final TextEditingController bankNameController;
  final String? bankNameHintText;

  final String branchNameLabel;
  final TextEditingController branchNameController;
  final String? branchNameHintText;

  final String accountTypeLabel;
  final String? accountType;
  final List<DropdownMenuItem<String>> accountTypeItems;
  final ValueChanged<String?>? onAccountTypeChanged;

  final String? branchNumberLabel;
  final TextEditingController? branchNumberController;
  final String? branchNumberHintText;

  final String accountNumberLabel;
  final TextEditingController accountNumberController;
  final String? accountNumberHintText;

  final String accountHolderLabel;
  final TextEditingController accountHolderController;
  final String? accountHolderHintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MemberProfileTextField(
          label: bankNameLabel,
          controller: bankNameController,
          hintText: bankNameHintText,
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: MemberProfileTextField(
                label: branchNameLabel,
                controller: branchNameController,
                hintText: branchNameHintText,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MemberProfileSelectField<String>(
                label: accountTypeLabel,
                value: accountType,
                items: accountTypeItems,
                onChanged: onAccountTypeChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (branchNumberLabel != null &&
            branchNumberController != null) ...<Widget>[
          MemberProfileTextField(
            label: branchNumberLabel!,
            controller: branchNumberController!,
            hintText: branchNumberHintText,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 14),
        ],
        MemberProfileTextField(
          label: accountNumberLabel,
          controller: accountNumberController,
          hintText: accountNumberHintText,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 14),
        MemberProfileTextField(
          label: accountHolderLabel,
          controller: accountHolderController,
          hintText: accountHolderHintText,
        ),
      ],
    );
  }
}

class MemberProfileDualTextFieldRow extends StatelessWidget {
  const MemberProfileDualTextFieldRow({
    super.key,
    required this.startLabel,
    required this.startController,
    required this.endLabel,
    required this.endController,
    this.startHintText,
    this.endHintText,
    this.startKeyboardType,
    this.endKeyboardType,
    this.startInputFormatters,
    this.endInputFormatters,
  });

  final String startLabel;
  final TextEditingController startController;
  final String endLabel;
  final TextEditingController endController;
  final String? startHintText;
  final String? endHintText;
  final TextInputType? startKeyboardType;
  final TextInputType? endKeyboardType;
  final List<TextInputFormatter>? startInputFormatters;
  final List<TextInputFormatter>? endInputFormatters;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: MemberProfileTextField(
            label: startLabel,
            controller: startController,
            hintText: startHintText,
            keyboardType: startKeyboardType,
            inputFormatters: startInputFormatters,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MemberProfileTextField(
            label: endLabel,
            controller: endController,
            hintText: endHintText,
            keyboardType: endKeyboardType,
            inputFormatters: endInputFormatters,
          ),
        ),
      ],
    );
  }
}

class MemberProfileSegmentedDualTextFieldRow extends StatelessWidget {
  const MemberProfileSegmentedDualTextFieldRow({
    super.key,
    required this.label,
    required this.startSegmentLabel,
    required this.startController,
    required this.endSegmentLabel,
    required this.endController,
    this.startHintText,
    this.endHintText,
    this.startKeyboardType,
    this.endKeyboardType,
    this.startInputFormatters,
    this.endInputFormatters,
    this.isRequired = false,
    this.labelColor,
  });

  final String label;
  final String startSegmentLabel;
  final TextEditingController startController;
  final String endSegmentLabel;
  final TextEditingController endController;
  final String? startHintText;
  final String? endHintText;
  final TextInputType? startKeyboardType;
  final TextInputType? endKeyboardType;
  final List<TextInputFormatter>? startInputFormatters;
  final List<TextInputFormatter>? endInputFormatters;
  final bool isRequired;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MemberProfileFieldLabel(
          label: label,
          isRequired: isRequired,
          color: labelColor,
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _SegmentedTextField(
                segmentLabel: startSegmentLabel,
                controller: startController,
                hintText: startHintText,
                keyboardType: startKeyboardType,
                inputFormatters: startInputFormatters,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SegmentedTextField(
                segmentLabel: endSegmentLabel,
                controller: endController,
                hintText: endHintText,
                keyboardType: endKeyboardType,
                inputFormatters: endInputFormatters,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MemberProfileNoticeCard extends StatelessWidget {
  const MemberProfileNoticeCard({
    super.key,
    required this.title,
    required this.body,
    required this.backgroundColor,
    required this.borderColor,
    required this.foregroundColor,
    this.icon,
  });

  final Widget? icon;
  final String title;
  final String body;
  final Color backgroundColor;
  final Color borderColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appText = theme.appTextTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Padding(padding: const EdgeInsets.only(top: 1), child: icon!),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: appText.inputLabel.copyWith(color: foregroundColor),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: appText.micro.copyWith(
                    color: foregroundColor,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MemberProfileChoiceChip extends StatelessWidget {
  const MemberProfileChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final primary = colors.primary;
    return Material(
      color: selected ? colors.primarySubtle : colors.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? primary : colors.border,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: appText.chip.copyWith(
              color: selected ? primary : colors.textSecondary,
              height: 1.15,
            ),
          ),
        ),
      ),
    );
  }
}

class MemberProfileUploadTile extends StatelessWidget {
  const MemberProfileUploadTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool isCompleted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final isDark = theme.brightness == Brightness.dark;
    final primary = colors.primary;
    final completedBackgroundColor = isCompleted
        ? (isDark ? primary.withValues(alpha: 0.16) : colors.primarySubtle)
        : colors.surface.withValues(alpha: 0);
    final completedBorderColor = isCompleted
        ? (isDark
              ? primary.withValues(alpha: 0.72)
              : primary.withValues(alpha: 0.85))
        : colors.border;
    final titleColor = isCompleted
        ? (isDark ? colors.onDark : colors.primary)
        : colors.textPrimary;
    final descriptionColor = isCompleted
        ? (isDark ? colors.onDark.withValues(alpha: 0.74) : colors.primaryAlt)
        : colors.textSecondary;
    final iconColor = isCompleted ? primary : colors.textSecondary;

    return Material(
      color: completedBackgroundColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: CustomPaint(
          painter: _RoundedDashedBorderPainter(
            color: completedBorderColor,
            radius: 16,
            strokeWidth: 2,
            gap: 6,
            dash: 8,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 34),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: <Widget>[
                Icon(
                  isCompleted ? Icons.check_circle_rounded : icon,
                  size: 44,
                  color: iconColor,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: appText.cardTitle.copyWith(color: titleColor),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: appText.helper.copyWith(
                    color: descriptionColor,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MemberProfileCheckTile extends StatelessWidget {
  const MemberProfileCheckTile({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final primary = colors.primary;
    return Material(
      color: colors.surfaceAlt,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onChanged == null ? null : () => onChanged!(!value),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: value ? primary : colors.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: value ? primary : colors.border,
                    width: 2,
                  ),
                ),
                child: value
                    ? Icon(Icons.check_rounded, size: 12, color: colors.onDark)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: appText.body.copyWith(
                    height: 1.5,
                    color: colors.textPrimary.withValues(alpha: 0.88),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MemberProfileInfoCard extends StatelessWidget {
  const MemberProfileInfoCard({
    super.key,
    required this.title,
    required this.body,
    this.icon,
    this.backgroundColor,
    this.borderColor,
    this.titleColor,
  });

  final String title;
  final Widget body;
  final String? icon;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final effectiveTitleColor = titleColor ?? colors.primary;
    final iconPrefix = (icon?.trim().isNotEmpty ?? false) ? '${icon!} ' : '';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor ?? colors.border, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$iconPrefix$title',
            style: appText.cardTitle.copyWith(color: effectiveTitleColor),
          ),
          const SizedBox(height: 8),
          body,
        ],
      ),
    );
  }
}

class MemberProfilePrimaryButton extends StatelessWidget {
  const MemberProfilePrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final bool enabled = onPressed != null;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: enabled
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[colors.primary, colors.primaryAlt],
              )
            : null,
        color: enabled ? null : colors.disabled,
        borderRadius: BorderRadius.circular(14),
        boxShadow: enabled
            ? <BoxShadow>[
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ]
            : const <BoxShadow>[],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onPressed,
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: Center(
              child: Text(
                label,
                style: appText.button.copyWith(color: colors.onDark, height: 1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MemberProfileOutlineButton extends StatelessWidget {
  const MemberProfileOutlineButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.border, width: 1.5),
          ),
          child: Text(
            label,
            style: appText.inputLabel.copyWith(color: colors.textPrimary),
          ),
        ),
      ),
    );
  }
}

InputDecoration memberProfileInputDecoration({
  required BuildContext context,
  String? hintText,
  Widget? suffixIcon,
}) {
  final theme = Theme.of(context);
  final colors = theme.appColors;
  final appText = theme.appTextTheme;
  return InputDecoration(
    hintText: hintText,
    hintStyle: appText.inputText.copyWith(
      color: colors.textSecondary.withValues(alpha: 0.72),
    ),
    filled: true,
    fillColor: colors.background,
    suffixIcon: suffixIcon,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
    enabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: colors.border, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colors.primary, width: 1.5),
    ),
    border: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: colors.border, width: 1.5),
    ),
  );
}

class _SegmentedTextField extends StatefulWidget {
  const _SegmentedTextField({
    required this.segmentLabel,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.inputFormatters,
  });

  final String segmentLabel;
  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<_SegmentedTextField> createState() => _SegmentedTextFieldState();
}

class _SegmentedTextFieldState extends State<_SegmentedTextField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final borderRadius = BorderRadius.circular(12);
    final borderColor = _focusNode.hasFocus ? colors.primary : colors.border;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: borderRadius,
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: colors.surfaceAlt,
                  border: Border(right: BorderSide(color: colors.border)),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.segmentLabel,
                  style: appText.micro.copyWith(color: colors.textSecondary),
                ),
              ),
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: widget.controller,
                  keyboardType: widget.keyboardType,
                  inputFormatters: widget.inputFormatters,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: widget.hintText,
                    hintStyle: appText.inputText.copyWith(
                      color: colors.textSecondary.withValues(alpha: 0.72),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                  ),
                  style: appText.inputText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundedDashedBorderPainter extends CustomPainter {
  const _RoundedDashedBorderPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
    required this.dash,
    required this.gap,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final RRect rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Path source = Path()..addRRect(rrect);
    for (final metric in source.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final double segmentLength = math.min(dash, metric.length - distance);
        canvas.drawPath(
          metric.extractPath(distance, distance + segmentLength),
          paint,
        );
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RoundedDashedBorderPainter oldDelegate) {
    return color != oldDelegate.color ||
        radius != oldDelegate.radius ||
        strokeWidth != oldDelegate.strokeWidth ||
        dash != oldDelegate.dash ||
        gap != oldDelegate.gap;
  }
}
