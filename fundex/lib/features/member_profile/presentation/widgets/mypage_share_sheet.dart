import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_symbols_icons/symbols.dart';

class MyPageShareSheet extends StatefulWidget {
  const MyPageShareSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.investedLabel,
    required this.investedValue,
    required this.profitLabel,
    required this.profitValue,
    required this.profitRateLabel,
    required this.profitRateValue,
    required this.shareActionLabel,
    required this.shareText,
    required this.shareFailedNotice,
  });

  final String title;
  final String subtitle;
  final String investedLabel;
  final String investedValue;
  final String profitLabel;
  final String profitValue;
  final String profitRateLabel;
  final String profitRateValue;
  final String shareActionLabel;
  final String shareText;
  final String shareFailedNotice;

  @override
  State<MyPageShareSheet> createState() => _MyPageShareSheetState();
}

class _MyPageShareSheetState extends State<MyPageShareSheet> {
  final GlobalKey _captureKey = GlobalKey();
  bool _isSharing = false;

  Future<void> _share() async {
    if (_isSharing) {
      return;
    }
    setState(() => _isSharing = true);
    try {
      await WidgetsBinding.instance.endOfFrame;
      final boundary =
          _captureKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) {
        return;
      }
      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData?.buffer.asUint8List();
      if (!mounted || bytes == null) {
        return;
      }
      await AppShare.shareImageBytes(
        context,
        bytes: Uint8List.fromList(bytes),
        fileName: 'stellavia-investment-summary.png',
        text: widget.shareText,
        title: widget.title,
        unavailableNotice: widget.shareFailedNotice,
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.maybeOf(
          context,
        )?.showSnackBar(SnackBar(content: Text(widget.shareFailedNotice)));
      }
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.textTertiary.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 16),
            RepaintBoundary(
              key: _captureKey,
              child: MediaQuery.withNoTextScaling(
                child: _MyPageShareCard(
                  title: widget.title,
                  subtitle: widget.subtitle,
                  investedLabel: widget.investedLabel,
                  investedValue: widget.investedValue,
                  profitLabel: widget.profitLabel,
                  profitValue: widget.profitValue,
                  profitRateLabel: widget.profitRateLabel,
                  profitRateValue: widget.profitRateValue,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSharing ? null : _share,
                icon: _isSharing
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.ios_share_rounded),
                label: Text(widget.shareActionLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyPageShareCard extends StatelessWidget {
  const _MyPageShareCard({
    required this.title,
    required this.subtitle,
    required this.investedLabel,
    required this.investedValue,
    required this.profitLabel,
    required this.profitValue,
    required this.profitRateLabel,
    required this.profitRateValue,
  });

  final String title;
  final String subtitle;
  final String investedLabel;
  final String investedValue;
  final String profitLabel;
  final String profitValue;
  final String profitRateLabel;
  final String profitRateValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final text = theme.appTextTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[colors.heroStart, colors.heroEnd],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -60,
              right: -40,
              child: Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primaryAlt.withValues(alpha: 0.12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'STE//AVIA',
                    style: text.cardTitle.copyWith(
                      color: AppColorTokens.brandLilac,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Text(
                    title,
                    style: text.pageTitle.copyWith(
                      color: colors.onDark,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: text.body.copyWith(
                      color: colors.onDark.withValues(alpha: 0.66),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: _ShareHeroMetric(
                          label: profitRateLabel,
                          value: profitRateValue,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Symbols.finance_mode,
                              size: 36,
                              color: colors.onDark,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _ShareMetric(
                          label: investedLabel,
                          value: investedValue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ShareMetric(
                          label: profitLabel,
                          value: profitValue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareHeroMetric extends StatelessWidget {
  const _ShareHeroMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: theme.appTextTheme.caption.copyWith(
            color: AppColorTokens.brandLilac,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.appTextTheme.heroMetricPrimary.copyWith(
            color: colors.onDark,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _ShareMetric extends StatelessWidget {
  const _ShareMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.onDark.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.onDark.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: theme.appTextTheme.caption.copyWith(
                color: colors.onDark.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: theme.appTextTheme.cardTitle.copyWith(
                  color: colors.onDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
