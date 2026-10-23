import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';
import 'app_button.dart';
import 'ui_tokens.dart';

class PrimaryCtaButton extends StatelessWidget {
  const PrimaryCtaButton({
    super.key,
    this.label,
    this.child,
    this.onPressed,
    this.isLoading = false,
    this.height = UiTokens.controlHeight,
    this.fullWidth = true,
    this.borderRadius,
    this.horizontalPadding = UiTokens.spacing16,
    this.loadingIndicatorSize = 18,
    this.backgroundColor,
    this.shadowColor,
    this.textStyle,
    this.disabledOpacity = 0.42,
    this.threeSideShadow = false,
  }) : assert(label != null || child != null, 'label or child is required');

  final String? label;
  final Widget? child;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final bool fullWidth;
  final BorderRadius? borderRadius;
  final double horizontalPadding;
  final double loadingIndicatorSize;
  final Color? backgroundColor;
  final Color? shadowColor;
  final TextStyle? textStyle;
  final double disabledOpacity;
  final bool threeSideShadow;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    Widget button = AppButton(
      label: label,
      child: child,
      onPressed: onPressed,
      isLoading: isLoading,
      minHeight: height,
      fullWidth: fullWidth,
      loadingIndicatorSize: loadingIndicatorSize,
      style: ButtonStyle(
        backgroundColor: backgroundColor == null
            ? null
            : WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.disabled) && !isLoading
                    ? backgroundColor!.withValues(alpha: disabledOpacity)
                    : backgroundColor,
              ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled) && !isLoading
              ? null
              : colors.onDark,
        ),
        textStyle: textStyle == null ? null : WidgetStatePropertyAll(textStyle),
        shape: borderRadius == null
            ? null
            : WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: borderRadius!),
              ),
      ),
    );
    // Keep the legacy inset contract while new callers use AppButton directly.
    if (fullWidth) {
      button = Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: button,
      );
    }
    return button;
  }
}

class CompactActionButton extends StatelessWidget {
  const CompactActionButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.width = 124,
    this.height = 52,
    this.backgroundColor,
    this.foregroundColor,
    this.filledBackground = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double width;
  final double height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool filledBackground;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: AppButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      minHeight: height,
      variant: filledBackground
          ? AppButtonVariant.primary
          : AppButtonVariant.secondary,
      style: ButtonStyle(
        backgroundColor: backgroundColor == null
            ? null
            : WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.disabled) && !isLoading
                    ? null
                    : backgroundColor,
              ),
        foregroundColor: foregroundColor == null
            ? null
            : WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.disabled) && !isLoading
                    ? null
                    : foregroundColor,
              ),
      ),
    ),
  );
}

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.size = 44,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final double size;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final hotelTheme = Theme.of(context).extension<AppFTKTheme>()!;
    final radius = BorderRadius.circular(size / 2);

    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor ?? hotelTheme.floatingIconBackgroundColor,
          borderRadius: radius,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: hotelTheme.floatingIconShadowColor,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            borderRadius: radius,
            child: Padding(
              padding: padding ?? EdgeInsets.all(size * 0.22),
              child: IconTheme(
                data: IconThemeData(
                  color:
                      foregroundColor ?? hotelTheme.floatingIconForegroundColor,
                  size: size * 0.45,
                ),
                child: Center(child: icon),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AccentSquareIconButton extends StatelessWidget {
  const AccentSquareIconButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.size = 40,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final hotelTheme = Theme.of(context).extension<AppFTKTheme>()!;
    final radius = BorderRadius.circular(9);

    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: hotelTheme.hostActionButtonBackgroundColor,
          borderRadius: radius,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: hotelTheme.hostActionButtonShadowColor,
              blurRadius: 25,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            borderRadius: radius,
            child: IconTheme(
              data: IconThemeData(color: colors.onDark, size: 20),
              child: Center(child: icon),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryTileButton extends StatelessWidget {
  const CategoryTileButton({
    required this.icon,
    required this.label,
    super.key,
    this.isSelected = false,
    this.onPressed,
    this.width = 77,
    this.height = 102,
  });

  final Widget icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onPressed;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final hotelTheme = Theme.of(context).extension<AppFTKTheme>()!;
    final borderRadius = BorderRadius.circular(hotelTheme.tileCornerRadius);
    final foregroundColor = isSelected
        ? hotelTheme.categorySelectedForegroundColor
        : hotelTheme.categoryIdleIconColor;

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected
              ? hotelTheme.categorySelectedBackgroundColor
              : hotelTheme.categoryIdleBackgroundColor,
          borderRadius: borderRadius,
          border: isSelected
              ? null
              : Border.all(
                  color: hotelTheme.categoryIdleBorderColor,
                  width: 1.5,
                ),
          boxShadow: isSelected
              ? <BoxShadow>[
                  BoxShadow(
                    color: hotelTheme.categoryShadowColor,
                    blurRadius: 24,
                    offset: const Offset(12, 25),
                  ),
                ]
              : const <BoxShadow>[],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            borderRadius: borderRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconTheme(
                    data: IconThemeData(color: foregroundColor, size: 28),
                    child: Center(child: icon),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: isSelected
                        ? hotelTheme.categorySelectedLabelStyle
                        : hotelTheme.categoryIdleLabelStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AmenityTileCard extends StatelessWidget {
  const AmenityTileCard({
    required this.icon,
    required this.label,
    super.key,
    this.highlighted = false,
    this.onPressed,
    this.width = 70,
    this.height = 84,
  });

  final Widget icon;
  final String label;
  final bool highlighted;
  final VoidCallback? onPressed;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final hotelTheme = Theme.of(context).extension<AppFTKTheme>()!;
    final borderRadius = BorderRadius.circular(hotelTheme.tileCornerRadius);

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: hotelTheme.categoryIdleBackgroundColor,
          borderRadius: borderRadius,
          border: Border.all(color: hotelTheme.cardBorderColor, width: 1.5),
          boxShadow: highlighted
              ? <BoxShadow>[
                  BoxShadow(
                    color: hotelTheme.amenityHighlightedShadowColor,
                    blurRadius: 31,
                    offset: const Offset(5, 10),
                  ),
                ]
              : const <BoxShadow>[],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            borderRadius: borderRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconTheme(
                    data: IconThemeData(
                      color: hotelTheme.categoryIdleIconColor,
                      size: 22,
                    ),
                    child: Center(child: icon),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: hotelTheme.categoryIdleLabelStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PillChip extends StatelessWidget {
  const PillChip({
    required this.child,
    super.key,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    this.borderRadius,
  });

  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final hotelTheme = Theme.of(context).extension<AppFTKTheme>()!;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? hotelTheme.photoCountChipBackgroundColor,
        borderRadius:
            borderRadius ?? BorderRadius.circular(hotelTheme.chipCornerRadius),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
