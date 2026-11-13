import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';

class AppShare {
  const AppShare._();

  static Future<void> shareText(
    BuildContext context, {
    required String text,
    String? title,
    String? subject,
    String? unavailableNotice,
  }) async {
    final normalizedText = text.trim();
    if (normalizedText.isEmpty) {
      return;
    }

    final box = context.findRenderObject() as RenderBox?;
    final result = await SharePlus.instance.share(
      ShareParams(
        text: normalizedText,
        title: title?.trim().isEmpty == true ? null : title?.trim(),
        subject: subject?.trim().isEmpty == true ? null : subject?.trim(),
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
    if (!context.mounted || result.status != ShareResultStatus.unavailable) {
      return;
    }

    final message = unavailableNotice?.trim();
    if (message == null || message.isEmpty) {
      return;
    }
    ScaffoldMessenger.maybeOf(
      context,
    )?.showSnackBar(SnackBar(content: Text(message)));
  }

  static Future<void> shareImageBytes(
    BuildContext context, {
    required Uint8List bytes,
    required String fileName,
    String? text,
    String? title,
    String? subject,
    String? unavailableNotice,
  }) async {
    return shareFileBytes(
      context,
      bytes: bytes,
      fileName: fileName,
      mimeType: 'image/png',
      title: title,
      subject: subject,
      text: text,
      unavailableNotice: unavailableNotice,
    );
  }

  static Future<void> shareFileBytes(
    BuildContext context, {
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
    String? text,
    String? title,
    String? subject,
    String? unavailableNotice,
  }) async {
    if (bytes.isEmpty) {
      return;
    }

    final box = context.findRenderObject() as RenderBox?;
    final result = await SharePlus.instance.share(
      ShareParams(
        files: <XFile>[
          XFile.fromData(bytes, mimeType: mimeType, name: fileName),
        ],
        text: text?.trim().isEmpty == true ? null : text?.trim(),
        title: title?.trim().isEmpty == true ? null : title?.trim(),
        subject: subject?.trim().isEmpty == true ? null : subject?.trim(),
        fileNameOverrides: <String>[fileName],
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
    if (!context.mounted || result.status != ShareResultStatus.unavailable) {
      return;
    }

    final message = unavailableNotice?.trim();
    if (message == null || message.isEmpty) {
      return;
    }
    ScaffoldMessenger.maybeOf(
      context,
    )?.showSnackBar(SnackBar(content: Text(message)));
  }
}
