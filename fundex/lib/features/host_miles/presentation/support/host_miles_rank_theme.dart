import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

/// Shared membership palette; colors do not determine booking eligibility.
abstract final class HostMilesRankTheme {
  static Color surface(BuildContext context, String rank) =>
      switch (rank.trim().toUpperCase()) {
        'REGULAR' => const Color(0xFF070E2B),
        'BRONZE' => const Color(0xFFA85929),
        'SILVER' => const Color(0xFF687184),
        'GOLD' => const Color(0xFF91723D),
        'MASTER' => const Color(0xFF65358B),
        _ => context.appColors.primary,
      };
}
