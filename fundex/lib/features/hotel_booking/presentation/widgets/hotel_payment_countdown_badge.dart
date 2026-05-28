import 'dart:async';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class HotelPaymentCountdownBadge extends StatefulWidget {
  const HotelPaymentCountdownBadge({
    super.key,
    required this.baseTime,
    this.duration = const Duration(minutes: 15),
    this.large = false,
    this.onExpired,
  });

  final String baseTime;
  final Duration duration;
  final bool large;
  final VoidCallback? onExpired;

  @override
  State<HotelPaymentCountdownBadge> createState() =>
      _HotelPaymentCountdownBadgeState();
}

class _HotelPaymentCountdownBadgeState
    extends State<HotelPaymentCountdownBadge> {
  Timer? _timer;
  late Duration _remaining = _calculateRemaining();
  bool _expiredNotified = false;

  @override
  void initState() {
    super.initState();
    _startTimerIfNeeded();
  }

  @override
  void didUpdateWidget(covariant HotelPaymentCountdownBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.baseTime != widget.baseTime ||
        oldWidget.duration != widget.duration) {
      _timer?.cancel();
      _expiredNotified = false;
      _remaining = _calculateRemaining();
      _startTimerIfNeeded();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimerIfNeeded() {
    if (_parseBaseTime() == null) {
      return;
    }
    if (_remaining == Duration.zero) {
      _notifyExpired();
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      final next = _calculateRemaining();
      setState(() => _remaining = next);
      if (next == Duration.zero) {
        _timer?.cancel();
        _notifyExpired();
      }
    });
  }

  void _notifyExpired() {
    if (_expiredNotified) {
      return;
    }
    _expiredNotified = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      widget.onExpired?.call();
    });
  }

  Duration _calculateRemaining() {
    final base = _parseBaseTime();
    if (base == null) {
      return Duration.zero;
    }
    final remaining = base.add(widget.duration).difference(DateTime.now());
    if (remaining.isNegative) {
      return Duration.zero;
    }
    return remaining;
  }

  DateTime? _parseBaseTime() {
    final trimmed = widget.baseTime.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return DateTime.tryParse(trimmed) ??
        DateTime.tryParse(trimmed.replaceFirst(' ', 'T'));
  }

  @override
  Widget build(BuildContext context) {
    if (_parseBaseTime() == null || _remaining == Duration.zero) {
      return const SizedBox.shrink();
    }
    final colors = Theme.of(context).appColors;
    final label = _formatRemaining(_remaining);
    if (widget.large) {
      return DecoratedBox(
        decoration: ShapeDecoration(
          color: colors.dangerSubtle,
          shape: CircleBorder(side: BorderSide(color: colors.dangerBorder)),
        ),
        child: SizedBox.square(
          dimension: 86,
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colors.dangerForeground,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      );
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.dangerSubtle,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.dangerBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: colors.dangerForeground,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

String _formatRemaining(Duration remaining) {
  final totalSeconds = remaining.inSeconds.clamp(0, 15 * 60);
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:'
      '${seconds.toString().padLeft(2, '0')}';
}
