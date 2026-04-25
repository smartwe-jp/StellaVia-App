import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../localization/app_localizations_ext.dart';
import 'app_push_action.dart';
import 'app_push_dialog_providers.dart';

class AppPushDialogHost extends ConsumerWidget {
  const AppPushDialogHost({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appPushDialogControllerProvider);
    final blockingCommand = state.activeBlockingCommand;
    if (blockingCommand != null) {
      return _PushActionOverlay(
        command: blockingCommand,
        dismissible: false,
        onPrimaryPressed: () => _openExternalTarget(context, blockingCommand),
      );
    }

    final dialogCommand = state.activeDialogCommand;
    if (dialogCommand == null) {
      return const SizedBox.shrink();
    }

    return _PushActionOverlay(
      command: dialogCommand,
      dismissible: dialogCommand.dismissible,
      onPrimaryPressed: () async {
        if (dialogCommand.action == AppPushAction.appUpdate) {
          await _openExternalTarget(context, dialogCommand);
          if (!context.mounted || !dialogCommand.dismissible) {
            return;
          }
        }
        await ref
            .read(appPushDialogControllerProvider.notifier)
            .dismissDialog(dialogCommand);
      },
      onSecondaryPressed: dialogCommand.dismissible
          ? () => ref
                .read(appPushDialogControllerProvider.notifier)
                .dismissDialog(dialogCommand)
          : null,
    );
  }
}

class _PushActionOverlay extends StatelessWidget {
  const _PushActionOverlay({
    required this.command,
    required this.dismissible,
    required this.onPrimaryPressed,
    this.onSecondaryPressed,
  });

  final AppPushCommand command;
  final bool dismissible;
  final VoidCallback onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: () async {
        if (dismissible && onSecondaryPressed != null) {
          onSecondaryPressed!();
        }
        return true;
      },
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ModalBarrier(
              color: Colors.black.withValues(alpha: 0.48),
              dismissible: false,
            ),
            SafeArea(
              child: Center(
                child: switch (command.action) {
                  AppPushAction.appBlock => _AppBlockDialog(
                    command: command,
                    onPrimaryPressed: onPrimaryPressed,
                  ),
                  AppPushAction.appUpdate => _AppUpdateDialog(
                    command: command,
                    onPrimaryPressed: onPrimaryPressed,
                    onSecondaryPressed: onSecondaryPressed,
                  ),
                  AppPushAction.campaignDialog => _CampaignDialog(
                    command: command,
                    onPrimaryPressed: onPrimaryPressed,
                  ),
                  AppPushAction.homeCelebration => const SizedBox.shrink(),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBlockDialog extends StatelessWidget {
  const _AppBlockDialog({
    required this.command,
    required this.onPrimaryPressed,
  });

  final AppPushCommand command;
  final VoidCallback onPrimaryPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _PushDialogCard(
      maxWidth: 340,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const _PushDialogIcon(icon: Icons.lock_rounded),
          const SizedBox(height: 16),
          _PushDialogTitle(
            command.title,
            fallback: l10n.pushDialogDefaultBlockTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          _PushDialogBody(
            command.body,
            fallback: l10n.pushDialogDefaultBlockBody,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 22),
          _PushPrimaryButton(
            label: command.primaryLabel ?? l10n.pushDialogOpenStore,
            onPressed: onPrimaryPressed,
          ),
        ],
      ),
    );
  }
}

class _AppUpdateDialog extends StatelessWidget {
  const _AppUpdateDialog({
    required this.command,
    required this.onPrimaryPressed,
    this.onSecondaryPressed,
  });

  final AppPushCommand command;
  final VoidCallback onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _PushDialogCard(
      maxWidth: 340,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const _PushDialogIcon(icon: Icons.system_update_alt_rounded),
          const SizedBox(height: 16),
          _PushDialogTitle(
            command.title,
            fallback: l10n.pushDialogDefaultUpdateTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 220),
            child: SingleChildScrollView(
              child: _PushDialogBody(
                command.body,
                fallback: l10n.pushDialogDefaultUpdateBody,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: <Widget>[
              if (onSecondaryPressed != null) ...<Widget>[
                Expanded(
                  child: _PushSecondaryButton(
                    label: command.secondaryLabel ?? l10n.pushDialogUpdateLater,
                    onPressed: onSecondaryPressed!,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: _PushPrimaryButton(
                  label: command.primaryLabel ?? l10n.pushDialogUpdateNow,
                  onPressed: onPrimaryPressed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CampaignDialog extends StatelessWidget {
  const _CampaignDialog({
    required this.command,
    required this.onPrimaryPressed,
  });

  final AppPushCommand command;
  final VoidCallback onPrimaryPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final imageUrl = command.imageUrl?.trim();
    return _PushDialogCard(
      maxWidth: 360,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.72,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _PushDialogTitle(
              command.title,
              fallback: l10n.pushDialogDefaultCampaignTitle,
            ),
            if (imageUrl != null && imageUrl.isNotEmpty) ...<Widget>[
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                ),
              ),
            ],
            const SizedBox(height: 14),
            Flexible(
              child: SingleChildScrollView(
                child: _PushDialogBody(command.body, fallback: ''),
              ),
            ),
            const SizedBox(height: 22),
            _PushPrimaryButton(
              label: command.primaryLabel ?? l10n.pushDialogClose,
              onPressed: onPrimaryPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class _PushDialogCard extends StatelessWidget {
  const _PushDialogCard({required this.child, required this.maxWidth});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _PushDialogIcon extends StatelessWidget {
  const _PushDialogIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: colors.highlightGold.withValues(alpha: 0.18),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: colors.brandPrimary, size: 28),
    );
  }
}

class _PushDialogTitle extends StatelessWidget {
  const _PushDialogTitle(
    this.text, {
    required this.fallback,
    this.textAlign = TextAlign.start,
  });

  final String text;
  final String fallback;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final appText = Theme.of(context).appTextTheme;
    final colors = Theme.of(context).appColors;
    final resolved = text.trim().isEmpty ? fallback : text.trim();
    return Text(
      resolved,
      textAlign: textAlign,
      style: appText.sectionTitle.copyWith(color: colors.textPrimary),
    );
  }
}

class _PushDialogBody extends StatelessWidget {
  const _PushDialogBody(
    this.text, {
    required this.fallback,
    this.textAlign = TextAlign.start,
  });

  final String text;
  final String fallback;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final appText = Theme.of(context).appTextTheme;
    final colors = Theme.of(context).appColors;
    final resolved = text.trim().isEmpty ? fallback : text.trim();
    return Text(
      resolved,
      textAlign: textAlign,
      style: appText.body.copyWith(color: colors.textSecondary, height: 1.55),
    );
  }
}

class _PushPrimaryButton extends StatelessWidget {
  const _PushPrimaryButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(label),
    );
  }
}

class _PushSecondaryButton extends StatelessWidget {
  const _PushSecondaryButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.textPrimary,
        side: BorderSide(color: colors.border),
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(label),
    );
  }
}

Future<void> _openExternalTarget(
  BuildContext context,
  AppPushCommand command,
) async {
  final target = _platformUri(command);
  final fallback = _uriOrNull(command.webUrl);
  final launched = await _launchExternal(target);
  if (launched || !context.mounted) {
    return;
  }
  final fallbackLaunched = target == fallback
      ? false
      : await _launchExternal(fallback);
  if (fallbackLaunched || !context.mounted) {
    return;
  }
  AppNotice.show(context, message: context.l10n.pushDialogOpenFailed);
}

Uri? _platformUri(AppPushCommand command) {
  if (kIsWeb) {
    return _uriOrNull(command.webUrl);
  }
  final platformUri = switch (defaultTargetPlatform) {
    TargetPlatform.iOS || TargetPlatform.macOS => _uriOrNull(command.iosUrl),
    TargetPlatform.android => _uriOrNull(command.androidUrl),
    _ => null,
  };
  return platformUri ?? _uriOrNull(command.webUrl);
}

Uri? _uriOrNull(String? raw) {
  final text = raw?.trim() ?? '';
  if (text.isEmpty) {
    return null;
  }
  return Uri.tryParse(text);
}

Future<bool> _launchExternal(Uri? uri) async {
  if (uri == null) {
    return false;
  }
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}
