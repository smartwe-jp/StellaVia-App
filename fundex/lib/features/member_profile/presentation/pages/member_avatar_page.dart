import "dart:io";
import "dart:typed_data";

import "package:core_ui_kit/core_ui_kit.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "../../../../app/localization/app_localizations_ext.dart";
import "../../../../app/support/app_request_error_message_resolver.dart";
import "../../../auth/presentation/providers/auth_providers.dart";
import "../providers/member_profile_providers.dart";
import "member_avatar_crop_page.dart";
import "../support/profile_document_image_picker.dart";

class MemberAvatarPage extends ConsumerStatefulWidget {
  const MemberAvatarPage({super.key});

  @override
  ConsumerState<MemberAvatarPage> createState() => _MemberAvatarPageState();
}

class _MemberAvatarPageState extends ConsumerState<MemberAvatarPage> {
  int? _selectedPresetIndex;
  String? _selectedGallerySourcePath;
  String? _selectedGalleryPath;
  bool _isPreparingEdit = false;
  bool _isSaving = false;

  static const List<_AvatarPreset> _presets = <_AvatarPreset>[
    _AvatarPreset(
      id: "bear_avatar",
      assetPath: "assets/images/avatars/bear_avatar.png",
    ),
    _AvatarPreset(
      id: "cat_avatar",
      assetPath: "assets/images/avatars/cat_avatar.png",
    ),
    _AvatarPreset(
      id: "corgi_avatar",
      assetPath: "assets/images/avatars/corgi_avatar.png",
    ),
    _AvatarPreset(
      id: "fox_avatar",
      assetPath: "assets/images/avatars/fox_avatar.png",
    ),
    _AvatarPreset(
      id: "koala_avatar",
      assetPath: "assets/images/avatars/koala_avatar.png",
    ),
    _AvatarPreset(
      id: "panda_avatar",
      assetPath: "assets/images/avatars/panda_avatar.png",
    ),
    _AvatarPreset(
      id: "penguin_avatar",
      assetPath: "assets/images/avatars/penguin_avatar.png",
    ),
    _AvatarPreset(
      id: "rabbit_avatar",
      assetPath: "assets/images/avatars/rabbit_avatar.png",
    ),
  ];

  bool get _hasPendingSelection {
    return _selectedPresetIndex != null ||
        ((_selectedGalleryPath?.trim().isNotEmpty ?? false));
  }

  Future<void> _pickFromGallery() async {
    if (_isSaving || _isPreparingEdit) {
      return;
    }
    final l10n = context.l10n;
    final result = await ref
        .read(profileDocumentImagePickerProvider)
        .pick(ProfileDocumentImageSource.gallery);
    if (!mounted) {
      return;
    }

    switch (result.status) {
      case ProfileDocumentImagePickStatus.success:
        setState(() {
          _selectedGallerySourcePath = result.path;
          _selectedGalleryPath = result.path;
          _selectedPresetIndex = null;
        });
        await _editSelectedGalleryAvatar(result.path);
        return;
      case ProfileDocumentImagePickStatus.canceled:
        return;
      case ProfileDocumentImagePickStatus.permissionDenied:
        AppNotice.show(
          context,
          message: l10n.discussionAvatarPhotoLibraryPermissionRequired,
        );
        return;
      case ProfileDocumentImagePickStatus.permissionSettingsRequired:
        AppNotice.show(context, message: l10n.permissionSettingsPhotosMessage);
        return;
      case ProfileDocumentImagePickStatus.failed:
        AppNotice.show(
          context,
          message: result.errorMessage?.trim().isNotEmpty == true
              ? result.errorMessage!.trim()
              : l10n.discussionAvatarPickFailed,
        );
        return;
    }
  }

  Future<void> _saveAvatar() async {
    if (_isSaving || _isPreparingEdit || !_hasPendingSelection) {
      return;
    }
    final l10n = context.l10n;
    setState(() {
      _isSaving = true;
    });

    try {
      final filePath = await _resolveSelectedAvatarFilePath();
      final uploadedUrl = await ref
          .read(uploadMemberAvatarUseCaseProvider)
          .call(filePath: filePath);
      final authLocal = ref.read(authLocalDataSourceProvider);
      final currentUser = await authLocal.readCurrentUser();
      if (currentUser != null) {
        await authLocal.saveCurrentUser(
          currentUser.copyWith(avatar: uploadedUrl),
        );
      }
      await ref.refresh(currentAuthUserProvider.future).catchError((Object _) {
        return null;
      });
      if (!mounted) {
        return;
      }
      AppNotice.show(context, message: l10n.discussionAvatarSaveSuccess);
      context.pop(uploadedUrl);
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: resolveAppRequestErrorMessage(
          error,
          l10n.uiErrorRequestFailed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _editSelectedGalleryAvatar([String? initialPath]) async {
    if (_isSaving || _isPreparingEdit) {
      return;
    }
    final sourcePath =
        (initialPath ?? _selectedGallerySourcePath ?? _selectedGalleryPath)
            ?.trim() ??
        "";
    if (sourcePath.isEmpty) {
      return;
    }
    await _openAvatarCropPage(sourcePath);
  }

  Future<void> _openAvatarCropPage(String sourcePath) async {
    final croppedPath = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (BuildContext context) =>
            MemberAvatarCropPage(imagePath: sourcePath),
      ),
    );
    if (!mounted || (croppedPath?.trim().isNotEmpty ?? false) == false) {
      return;
    }
    setState(() {
      _selectedGalleryPath = croppedPath!.trim();
      _selectedPresetIndex = null;
    });
  }

  Future<void> _editCurrentRemoteAvatar(String imageUrl) async {
    if (_isSaving || _isPreparingEdit) {
      return;
    }
    final normalizedUrl = imageUrl.trim();
    if (normalizedUrl.isEmpty) {
      return;
    }
    final l10n = context.l10n;
    setState(() {
      _isPreparingEdit = true;
    });
    try {
      final bytes = await _downloadRemoteAvatarBytes(normalizedUrl);
      final tempDir = await Directory.systemTemp.createTemp(
        "fundex_avatar_remote_",
      );
      final extension = _resolveImageExtensionFromUrl(normalizedUrl);
      final sourceFile = File("${tempDir.path}/remote_avatar.$extension");
      await sourceFile.writeAsBytes(bytes, flush: true);
      if (!mounted) {
        return;
      }
      setState(() {
        _selectedGallerySourcePath = sourceFile.path;
        _selectedGalleryPath = sourceFile.path;
        _selectedPresetIndex = null;
      });
      await _openAvatarCropPage(sourceFile.path);
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(context, message: l10n.uiErrorRequestFailed);
    } finally {
      if (mounted) {
        setState(() {
          _isPreparingEdit = false;
        });
      }
    }
  }

  String _resolveImageExtensionFromUrl(String url) {
    final uri = Uri.tryParse(url);
    final lastSegment = uri?.pathSegments.isNotEmpty == true
        ? uri!.pathSegments.last
        : url.split("/").last;
    final extension = lastSegment.contains(".")
        ? lastSegment.split(".").last.toLowerCase()
        : "png";
    const supportedExtensions = <String>{"png", "jpg", "jpeg", "webp"};
    return supportedExtensions.contains(extension) ? extension : "png";
  }

  Future<List<int>> _downloadRemoteAvatarBytes(String imageUrl) async {
    final uri = Uri.parse(imageUrl);
    final client = HttpClient();
    try {
      final request = await client.getUrl(uri);
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException(
          "Avatar download failed with status ${response.statusCode}",
          uri: uri,
        );
      }
      final builder = BytesBuilder(copy: false);
      await for (final chunk in response) {
        builder.add(chunk);
      }
      final bytes = builder.takeBytes();
      if (bytes.isEmpty) {
        throw StateError("Avatar download returned no bytes.");
      }
      return bytes;
    } finally {
      client.close(force: true);
    }
  }

  Future<String> _resolveSelectedAvatarFilePath() async {
    final galleryPath = _selectedGalleryPath?.trim() ?? "";
    if (galleryPath.isNotEmpty) {
      return galleryPath;
    }
    final selectedIndex = _selectedPresetIndex;
    if (selectedIndex == null) {
      throw StateError("No avatar selection.");
    }
    return _writePresetAvatarFile(_presets[selectedIndex]);
  }

  Future<String> _writePresetAvatarFile(_AvatarPreset preset) async {
    final bytes = await rootBundle.load(preset.assetPath);
    final tempDir = await Directory.systemTemp.createTemp("fundex_avatar_");
    final extension = preset.assetPath.split(".").last;
    final file = File("${tempDir.path}/${preset.id}.$extension");
    await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    return file.path;
  }

  int? _resolveCurrentUserSeed() {
    final currentUser = ref.watch(currentAuthUserProvider).asData?.value;
    if (currentUser?.userId != null) {
      return currentUser!.userId;
    }
    if (currentUser?.memberId != null) {
      return currentUser!.memberId;
    }
    final normalized =
        currentUser?.id?.trim() ??
        currentUser?.accountId?.trim() ??
        currentUser?.username.trim() ??
        "";
    if (normalized.isEmpty) {
      return null;
    }
    return normalized.hashCode;
  }

  ImageProvider<Object>? _resolvePreviewImageProvider(
    _AvatarPreset? selectedPreset,
  ) {
    final galleryPath = _selectedGalleryPath?.trim() ?? "";
    if (galleryPath.isNotEmpty) {
      return FileImage(File(galleryPath));
    }
    if (selectedPreset != null) {
      return AssetImage(selectedPreset.assetPath);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final currentUser = ref.watch(currentAuthUserProvider).asData?.value;
    final currentAvatarUrl = currentUser?.avatar?.trim() ?? "";
    final selectedPreset = _selectedPresetIndex == null
        ? null
        : _presets[_selectedPresetIndex!];
    final previewImageProvider = _resolvePreviewImageProvider(selectedPreset);
    final canEditCurrentAvatar =
        currentAvatarUrl.isNotEmpty &&
        _selectedPresetIndex == null &&
        (_selectedGalleryPath?.trim().isEmpty ?? true) &&
        !_isSaving &&
        !_isPreparingEdit;
    final canEditSelectedGalleryAvatar =
        (_selectedGalleryPath?.trim().isNotEmpty ?? false) &&
        !_isSaving &&
        !_isPreparingEdit;
    final previewImageUrl =
        previewImageProvider == null && selectedPreset == null
        ? currentAvatarUrl
        : null;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(l10n.discussionAvatarPageTitle)),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  children: <Widget>[
                    FundDetailContentCard(
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
                      child: Column(
                        children: <Widget>[
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: canEditSelectedGalleryAvatar
                                  ? _editSelectedGalleryAvatar
                                  : canEditCurrentAvatar
                                  ? () => _editCurrentRemoteAvatar(
                                      currentAvatarUrl,
                                    )
                                  : null,
                              child: AppUserAvatar(
                                avatarUrl: previewImageUrl,
                                imageProvider: previewImageProvider,
                                avatarSeed: _resolveCurrentUserSeed(),
                                size: 112,
                                fontSize: 40,
                              ),
                            ),
                          ),
                          if (canEditSelectedGalleryAvatar ||
                              canEditCurrentAvatar) ...<Widget>[
                            const SizedBox(height: 12),
                            TextButton.icon(
                              onPressed: canEditSelectedGalleryAvatar
                                  ? _editSelectedGalleryAvatar
                                  : () => _editCurrentRemoteAvatar(
                                      currentAvatarUrl,
                                    ),
                              icon: _isPreparingEdit
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.tune_rounded),
                              label: Text(l10n.commonEditText),
                            ),
                          ],
                          const SizedBox(height: 16),
                          Text(
                            l10n.discussionAvatarPreviewHint,
                            textAlign: TextAlign.center,
                            style: appText.body.copyWith(
                              color: colors.textSecondary,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    FundDetailContentCard(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            l10n.discussionAvatarDefaultSectionTitle,
                            style: appText.sectionTitle,
                          ),
                          const SizedBox(height: 14),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _presets.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 1,
                                ),
                            itemBuilder: (BuildContext context, int index) {
                              final preset = _presets[index];
                              final isSelected = _selectedPresetIndex == index;
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: _isSaving
                                      ? null
                                      : () {
                                          setState(() {
                                            _selectedPresetIndex = index;
                                            _selectedGallerySourcePath = null;
                                            _selectedGalleryPath = null;
                                          });
                                        },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 120),
                                    decoration: BoxDecoration(
                                      color: colors.surfaceAlt,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected
                                            ? colors.primary
                                            : colors.borderSoft,
                                        width: isSelected ? 2 : 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: ClipOval(
                                        child: Image.asset(
                                          preset.assetPath,
                                          width: 58,
                                          height: 58,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _isSaving ? null : _pickFromGallery,
                              icon: const Icon(Icons.photo_library_outlined),
                              label: Text(l10n.profileDocumentPickFromGallery),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: (_isSaving || !_hasPendingSelection)
                      ? null
                      : _saveAvatar,
                  child: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.discussionAvatarSaveAction),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarPreset {
  const _AvatarPreset({required this.id, required this.assetPath});

  final String id;
  final String assetPath;
}
