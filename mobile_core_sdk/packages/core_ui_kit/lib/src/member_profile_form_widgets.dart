import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'app_color_tokens.dart';

const Color _memberProfileFieldFillColor = AppColorTokens.fundexBackground;
const Color _memberProfileFieldBorderColor = Color(0xFFDCE5EF);
const Color _memberProfileMutedTextColor = AppColorTokens.fundexTextSecondary;
const Color _memberProfileCardColor = Colors.white;
const Color _memberProfileSoftCardColor = Color(0xFFF8FAFC);

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
          style: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.25,
            color: AppColorTokens.fundexText,
          ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _FieldLabel(label: label),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: _memberProfileMutedTextColor,
          ),
          decoration: _inputDecoration(context: context),
          style: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColorTokens.fundexText,
          ),
          dropdownColor: _memberProfileCardColor,
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
    final textTheme = Theme.of(context).textTheme;
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
                  style: (textTheme.labelLarge ?? const TextStyle()).copyWith(
                    fontSize: 12,
                    color: foregroundColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: (textTheme.bodySmall ?? const TextStyle()).copyWith(
                    fontSize: 11,
                    color: foregroundColor,
                    height: 1.6,
                    fontWeight: FontWeight.w500,
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
    final primary = theme.colorScheme.primary;
    final baseTextColor =
        theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurface;
    return Material(
      color: selected ? primary.withValues(alpha: 0.10) : Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? primary : _memberProfileFieldBorderColor,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: (theme.textTheme.labelSmall ?? const TextStyle()).copyWith(
              fontSize: 11,
              color: selected ? primary : baseTextColor.withValues(alpha: 0.82),
              fontWeight: FontWeight.w700,
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
    final primary = theme.colorScheme.primary;
    final borderColor = isCompleted
        ? primary.withValues(alpha: 0.85)
        : theme.colorScheme.outline.withValues(alpha: 0.65);
    final textMuted =
        theme.textTheme.bodySmall?.color?.withValues(alpha: 0.9) ??
        theme.colorScheme.onSurface.withValues(alpha: 0.55);

    return Material(
      color: isCompleted ? primary.withValues(alpha: 0.04) : Colors.transparent,
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
                  style: (theme.textTheme.titleSmall ?? const TextStyle())
                      .copyWith(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: (theme.textTheme.bodySmall ?? const TextStyle())
                      .copyWith(fontSize: 12, color: textMuted, height: 1.35),
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
    final primary = theme.colorScheme.primary;
    return Material(
      color: _memberProfileSoftCardColor,
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
                  color: value ? primary : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: value ? primary : _memberProfileFieldBorderColor,
                    width: 2,
                  ),
                ),
                child: value
                    ? const Icon(
                        Icons.check_rounded,
                        size: 12,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: (theme.textTheme.bodyMedium ?? const TextStyle())
                      .copyWith(
                        fontSize: 13,
                        height: 1.5,
                        color:
                            theme.textTheme.bodyMedium?.color?.withValues(
                              alpha: 0.88,
                            ) ??
                            AppColorTokens.fundexText,
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
    final effectiveTitleColor = titleColor ?? theme.colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor ?? _memberProfileSoftCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? _memberProfileFieldBorderColor,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${icon ?? ''}${icon == null ? '' : ' '}$title',
            style: (theme.textTheme.titleSmall ?? const TextStyle()).copyWith(
              fontSize: 13,
              color: effectiveTitleColor,
              fontWeight: FontWeight.w700,
            ),
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
    final bool enabled = onPressed != null;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: enabled
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Color(0xFF2563EB), Color(0xFF3B82F6)],
              )
            : null,
        color: enabled ? null : const Color(0xFFCBD5E1),
        borderRadius: BorderRadius.circular(14),
        boxShadow: enabled
            ? const <BoxShadow>[
                BoxShadow(
                  color: Color(0x592563EB),
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
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1,
                ),
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
    return Material(
      color: _memberProfileCardColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _memberProfileFieldBorderColor,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: (theme.textTheme.labelLarge ?? const TextStyle()).copyWith(
              fontSize: 12,
              color: AppColorTokens.fundexText,
              fontWeight: FontWeight.w700,
            ),
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
  return InputDecoration(
    hintText: hintText,
    hintStyle: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
      fontSize: 14,
      color: _memberProfileMutedTextColor.withValues(alpha: 0.72),
      fontWeight: FontWeight.w500,
    ),
    filled: true,
    fillColor: _memberProfileFieldFillColor,
    suffixIcon: suffixIcon,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: _memberProfileFieldBorderColor, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
    ),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: _memberProfileFieldBorderColor, width: 1.5),
    ),
  );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: (theme.textTheme.labelLarge ?? const TextStyle()).copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: _memberProfileMutedTextColor.withValues(alpha: 0.82),
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
