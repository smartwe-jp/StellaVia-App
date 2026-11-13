import 'dart:typed_data';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:hand_signature/signature.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class SecondaryContractSignaturePad extends StatefulWidget {
  const SecondaryContractSignaturePad({super.key, required this.onConfirm});
  final Future<void> Function(Uint8List) onConfirm;
  @override
  State<SecondaryContractSignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SecondaryContractSignaturePad> {
  final control = HandSignatureControl();
  bool busy = false;
  @override
  void dispose() {
    control.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (busy || !control.isFilled) return;
    setState(() => busy = true);
    try {
      const width = 512, height = 256;
      final strokes = control.toPicture(
        width: width,
        height: height,
        border: 32,
        fit: true,
      );
      if (strokes == null) return;

      // The contract service expects landscape strokes turned clockwise in the PNG.
      // HandSignature already records points in the pad's local coordinates.
      final recorder = ui.PictureRecorder();
      ui.Canvas(recorder)
        ..translate(height.toDouble(), 0)
        ..rotate(math.pi / 2)
        ..drawPicture(strokes);
      final rotated = recorder.endRecording();
      late final ui.Image image;
      try {
        image = await rotated.toImage(height, width);
      } finally {
        rotated.dispose();
        strokes.dispose();
      }
      try {
        final png = await image.toByteData(format: ui.ImageByteFormat.png);
        if (mounted && png != null) {
          await widget.onConfirm(
            png.buffer.asUint8List(png.offsetInBytes, png.lengthInBytes),
          );
        }
      } finally {
        image.dispose();
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AbsorbPointer(
      absorbing: busy,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l.secondaryMarketSignatureHint),
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: HandSignature(
                  control: control,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: control.clear,
                child: Text(l.secondaryMarketClearSignature),
              ),
              Expanded(
                child: ListenableBuilder(
                  listenable: control,
                  builder: (context, _) => AppButton(
                    label: l.secondaryMarketConfirmSignature,
                    onPressed: !busy && control.isFilled ? submit : null,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
