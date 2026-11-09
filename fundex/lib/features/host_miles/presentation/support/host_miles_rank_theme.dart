import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

/// Figma 06 membership card colors. Tier codes come from the API.
enum HostMilesRankTheme {
  regular(
    Color(0xFFE6E1D8),
    Color(0xFFF6F4F0),
    accent: AppColorTokens.brandNavy,
  ),
  bronze(Color(0xFFA85A2A), Color(0xFFF6ECE5)),
  silver(Color(0xFF8D9096), Color(0xFFEFF0F2)),
  gold(Color(0xFF9C6A10), Color(0xFFF4EDE1)),
  master(Color(0xFF3A0A5C), Color(0xFFEFE8F4)),
  unknown(AppColorTokens.fundexTextSecondary, AppColorTokens.brandWhite);

  const HostMilesRankTheme(this.header, this.surface, {Color? accent})
    : marker = accent ?? header;
  final Color header, surface, marker;
  static const ink = AppColorTokens.brandNavy;
  static const muted = AppColorTokens.fundexTextSecondary;
  String? get number =>
      this == unknown ? null : (index + 1).toString().padLeft(2, '0');
  Color get headerInk => this == regular ? ink : AppColorTokens.brandWhite;

  static HostMilesRankTheme of(String code) =>
      switch (code.trim().toUpperCase()) {
        'REGULAR' => regular,
        'BRONZE' => bronze,
        'SILVER' => silver,
        'GOLD' => gold,
        'MASTER' => master,
        _ => unknown,
      };

  BoxDecoration get headerDecoration => BoxDecoration(
    color: header,
    gradient: this == master
        ? const LinearGradient(
            begin: Alignment(-0.33, -0.94),
            end: Alignment(0.33, 0.94),
            stops: [0, 0.71429],
            colors: [Color(0xFF1E0533), Color(0xFF3A0A5C)],
          )
        : null,
    border: switch (this) {
      master => const Border(
        bottom: BorderSide(color: AppColorTokens.brandViolet, width: 2),
      ),
      regular => Border(bottom: BorderSide(color: ink.withValues(alpha: .12))),
      _ => null,
    },
  );
}
