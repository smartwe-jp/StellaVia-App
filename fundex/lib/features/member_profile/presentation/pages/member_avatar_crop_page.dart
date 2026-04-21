import "dart:io";
import "dart:typed_data";
import "dart:ui" as ui;

import "package:core_ui_kit/core_ui_kit.dart";
import "package:flutter/material.dart";

import "../../../../app/localization/app_localizations_ext.dart";

class MemberAvatarCropPage extends StatefulWidget {
  const MemberAvatarCropPage({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<MemberAvatarCropPage> createState() => _MemberAvatarCropPageState();
}

class _MemberAvatarCropPageState extends State<MemberAvatarCropPage> {
  final TransformationController _transformationController =
      TransformationController();

  ui.Image? _decodedImage;
  Size? _baseImageDisplaySize;
  double? _lastCropViewportSize;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _decodedImage?.dispose();
    super.dispose();
  }

  Future<void> _loadImage() async {
    final bytes = await File(widget.imagePath).readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    if (!mounted) {
      frame.image.dispose();
      return;
    }
    setState(() {
      _decodedImage?.dispose();
      _decodedImage = frame.image;
    });
  }

  Size _calculateBaseImageDisplaySize(ui.Image image, double cropViewportSize) {
    final imageWidth = image.width.toDouble();
    final imageHeight = image.height.toDouble();
    final aspectRatio = imageWidth / imageHeight;
    return aspectRatio >= 1
        ? Size(cropViewportSize * aspectRatio, cropViewportSize)
        : Size(cropViewportSize, cropViewportSize / aspectRatio);
  }

  void _configureInitialViewport(double cropViewportSize) {
    final image = _decodedImage;
    if (image == null) {
      return;
    }
    if (_lastCropViewportSize == cropViewportSize &&
        _baseImageDisplaySize != null) {
      return;
    }
    final baseImageDisplaySize = _calculateBaseImageDisplaySize(
      image,
      cropViewportSize,
    );
    final translateX = (cropViewportSize - baseImageDisplaySize.width) / 2;
    final translateY = (cropViewportSize - baseImageDisplaySize.height) / 2;
    _baseImageDisplaySize = baseImageDisplaySize;
    _lastCropViewportSize = cropViewportSize;
    _transformationController.value = Matrix4.identity()
      ..translateByDouble(translateX, translateY, 0, 1);
  }

  Matrix4 _clampedMatrix(double cropViewportSize) {
    final baseImageDisplaySize = _baseImageDisplaySize;
    if (baseImageDisplaySize == null) {
      return _transformationController.value.clone();
    }
    final matrix = _transformationController.value.clone();
    final scale = matrix.getMaxScaleOnAxis().clamp(1.0, 4.0);
    final scaledWidth = baseImageDisplaySize.width * scale;
    final scaledHeight = baseImageDisplaySize.height * scale;
    final minTranslateX = cropViewportSize - scaledWidth;
    final minTranslateY = cropViewportSize - scaledHeight;
    final currentTranslateX = matrix.storage[12];
    final currentTranslateY = matrix.storage[13];
    final clampedTranslateX = currentTranslateX.clamp(minTranslateX, 0.0);
    final clampedTranslateY = currentTranslateY.clamp(minTranslateY, 0.0);
    return Matrix4.identity()
      ..translateByDouble(clampedTranslateX, clampedTranslateY, 0, 1)
      ..scaleByDouble(scale, scale, 1, 1);
  }

  void _handleInteractionEnd(double cropViewportSize) {
    _transformationController.value = _clampedMatrix(cropViewportSize);
  }

  Future<void> _applyCrop(double cropViewportSize) async {
    if (_isProcessing) {
      return;
    }
    final image = _decodedImage;
    final baseImageDisplaySize = _baseImageDisplaySize;
    if (image == null || baseImageDisplaySize == null) {
      return;
    }
    setState(() {
      _isProcessing = true;
    });
    try {
      final matrix = _clampedMatrix(cropViewportSize);
      _transformationController.value = matrix;
      final scale = matrix.getMaxScaleOnAxis();
      final translateX = matrix.storage[12];
      final translateY = matrix.storage[13];

      final visibleLeft = (-translateX / scale).clamp(
        0.0,
        baseImageDisplaySize.width,
      );
      final visibleTop = (-translateY / scale).clamp(
        0.0,
        baseImageDisplaySize.height,
      );
      final visibleWidth = (cropViewportSize / scale).clamp(
        0.0,
        baseImageDisplaySize.width - visibleLeft,
      );
      final visibleHeight = (cropViewportSize / scale).clamp(
        0.0,
        baseImageDisplaySize.height - visibleTop,
      );

      final sourceRect = Rect.fromLTWH(
        visibleLeft * image.width / baseImageDisplaySize.width,
        visibleTop * image.height / baseImageDisplaySize.height,
        visibleWidth * image.width / baseImageDisplaySize.width,
        visibleHeight * image.height / baseImageDisplaySize.height,
      );

      final recorder = ui.PictureRecorder();
      const outputSize = 768.0;
      final canvas = Canvas(
        recorder,
        const Rect.fromLTWH(0, 0, outputSize, outputSize),
      );
      canvas.drawImageRect(
        image,
        sourceRect,
        const Rect.fromLTWH(0, 0, outputSize, outputSize),
        Paint()
          ..isAntiAlias = true
          ..filterQuality = FilterQuality.high,
      );
      final renderedImage = await recorder.endRecording().toImage(
        outputSize.toInt(),
        outputSize.toInt(),
      );
      final bytes = await renderedImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      renderedImage.dispose();
      if (bytes == null) {
        throw StateError("Unable to encode cropped avatar.");
      }

      final tempDir = await Directory.systemTemp.createTemp(
        "fundex_avatar_crop_",
      );
      final file = File("${tempDir.path}/avatar_crop.png");
      await file.writeAsBytes(Uint8List.view(bytes.buffer), flush: true);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(file.path);
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.primary,
      appBar: AppBar(
        backgroundColor: colors.primary,
        foregroundColor: colors.onDark,
        title: Text(l10n.discussionAvatarCropTitle),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final cropViewportSize = (constraints.maxWidth - 40)
                .clamp(220.0, 360.0)
                .toDouble();
            final displayImageSize = _decodedImage == null
                ? null
                : (_baseImageDisplaySize ??
                      _calculateBaseImageDisplaySize(
                        _decodedImage!,
                        cropViewportSize,
                      ));
            if (_decodedImage != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _configureInitialViewport(cropViewportSize);
                }
              });
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                children: <Widget>[
                  Text(
                    l10n.discussionAvatarCropHint,
                    textAlign: TextAlign.center,
                    style: appText.body.copyWith(
                      color: colors.onDark.withValues(alpha: 0.82),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Center(
                      child: SizedBox.square(
                        dimension: cropViewportSize,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            ClipOval(
                              child: ColoredBox(
                                color: colors.surfaceAlt,
                                child: _decodedImage == null
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: colors.highlightGold,
                                        ),
                                      )
                                    : InteractiveViewer(
                                        transformationController:
                                            _transformationController,
                                        boundaryMargin: const EdgeInsets.all(
                                          2000,
                                        ),
                                        constrained: false,
                                        minScale: 1,
                                        maxScale: 4,
                                        onInteractionEnd: (_) =>
                                            _handleInteractionEnd(
                                              cropViewportSize,
                                            ),
                                        child: SizedBox(
                                          width:
                                              displayImageSize?.width ??
                                              cropViewportSize,
                                          height:
                                              displayImageSize?.height ??
                                              cropViewportSize,
                                          child: RawImage(
                                            image: _decodedImage,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            IgnorePointer(
                              child: CustomPaint(
                                size: Size.square(cropViewportSize),
                                painter: _AvatarCropOverlayPainter(
                                  borderColor: colors.highlightGold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: (_decodedImage == null || _isProcessing)
                          ? null
                          : () => _applyCrop(cropViewportSize),
                      child: _isProcessing
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.discussionAvatarCropApplyAction),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AvatarCropOverlayPainter extends CustomPainter {
  const _AvatarCropOverlayPainter({required this.borderColor});

  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final overlayPath = Path()
      ..addRect(rect)
      ..addOval(rect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(
      overlayPath,
      Paint()..color = Colors.black.withValues(alpha: 0.28),
    );
    canvas.drawOval(
      rect.deflate(2),
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant _AvatarCropOverlayPainter oldDelegate) {
    return oldDelegate.borderColor != borderColor;
  }
}
