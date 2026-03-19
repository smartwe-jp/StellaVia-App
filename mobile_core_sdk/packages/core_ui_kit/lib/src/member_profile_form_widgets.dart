import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';

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
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool readOnly;
  final int maxLines;
  final Widget? suffixIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appText = theme.appTextTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _FieldLabel(label: label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          maxLines: maxLines,
          onTap: onTap,
          decoration: _inputDecoration(
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
  });

  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _FieldLabel(label: label),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: colors.textSecondary,
          ),
          decoration: _inputDecoration(context: context),
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

class MemberProfileNoticeCard extends StatelessWidget {
  const MemberProfileNoticeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    required this.backgroundColor,
    required this.borderColor,
    required this.foregroundColor,
  });

  final Widget icon;
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
          Padding(padding: const EdgeInsets.only(top: 1), child: icon),
          const SizedBox(width: 8),
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
    final primary = colors.primary;
    final borderColor = isCompleted
        ? primary.withValues(alpha: 0.85)
        : colors.border;
    final textMuted = colors.textSecondary;

    return Material(
      color: isCompleted
          ? colors.primarySubtle
          : colors.surface.withValues(alpha: 0),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: CustomPaint(
          painter: _RoundedDashedBorderPainter(
            color: borderColor,
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
                  color: isCompleted ? primary : textMuted,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: appText.cardTitle,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: appText.helper.copyWith(
                    color: textMuted,
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
            '${icon ?? ''}${icon == null ? '' : ' '}$title',
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

InputDecoration _inputDecoration({
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Text(
      label,
      style: appText.inputLabel.copyWith(
        color: colors.textSecondary.withValues(alpha: 0.82),
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
