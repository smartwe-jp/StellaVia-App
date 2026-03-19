import 'package:core_identity_auth/core_identity_auth.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/identity_auth_sdk_providers.dart';
import '../support/identity_auth_message_resolver.dart';

class RealPersonAuthPage extends ConsumerStatefulWidget {
  const RealPersonAuthPage({super.key});

  @override
  ConsumerState<RealPersonAuthPage> createState() => _RealPersonAuthPageState();
}

class _RealPersonAuthPageState extends ConsumerState<RealPersonAuthPage> {
  bool _isRunning = false;
  String? _statusMessage;

  Future<void> _startVerification() async {
    if (_isRunning) {
      return;
    }
    final l10n = context.l10n;

    setState(() {
      _isRunning = true;
      _statusMessage = null;
    });

    try {
      final coordinator = ref.read(identityAuthCoordinatorProvider);
      final decision = await coordinator.evaluate(
        entryPoint: IdentityAuthEntryPoint.securityCenterRealPerson,
      );

      if (!mounted) {
        return;
      }

      if (decision.action == IdentityAuthAction.none) {
        AppNotice.show(context, message: l10n.identityAuthAlreadyVerified);
        context.pop(true);
        return;
      }

      final collector = ref.read(identityAuthLivenessCollectorProvider);
      if (collector == null) {
        setState(() {
          _statusMessage = l10n.identityAuthLivenessNotConfigured;
        });
        AppNotice.show(
          context,
          message: l10n.identityAuthLivenessNotConfigured,
        );
        return;
      }

      final collected = await collector.collect();
      if (!mounted) {
        return;
      }
      if (!collected.isSuccess) {
        final message = resolveIdentityAuthMessage(
          l10n,
          reasonCode: 'liveness_collect_failed',
          errorMessage: collected.errorMessage,
          fallbackMessage: l10n.identityAuthCollectFailed,
        );
        setState(() {
          _statusMessage = message;
        });
        AppNotice.show(context, message: message);
        return;
      }

      final result = await coordinator.verifyWithPhotoBase64(
        photoBase64: collected.photoBase64,
        entryPoint: IdentityAuthEntryPoint.securityCenterRealPerson,
      );
      if (!mounted) {
        return;
      }

      if (result.verified) {
        AppNotice.show(context, message: l10n.identityAuthVerifySuccess);
        context.pop(true);
        return;
      }

      final message = resolveIdentityAuthMessage(
        l10n,
        reasonCode: result.reasonCode,
        errorMessage: result.errorMessage,
        fallbackMessage: l10n.identityAuthVerifyFailed,
      );
      setState(() {
        _statusMessage = message;
      });
      AppNotice.show(context, message: message);
    } catch (error) {
      if (!mounted) {
        return;
      }
      final message = resolveIdentityAuthMessage(
        context.l10n,
        errorMessage: error.toString(),
        fallbackMessage: context.l10n.identityAuthVerifyFailed,
      );
      setState(() {
        _statusMessage = message;
      });
      AppNotice.show(context, message: message);
    } finally {
      if (mounted) {
        setState(() {
          _isRunning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppNavigationBar(
        title: l10n.identityAuthPageTitle,
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(false),
          backgroundColor: colors.surface.withValues(alpha: 0),
          foregroundColor: colors.textPrimary,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(UiTokens.radius16),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colors.primarySubtle,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.verified_user_rounded,
                        color: colors.primary,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      l10n.identityAuthPageDescription,
                      textAlign: TextAlign.center,
                      style: appText.bodyMuted.copyWith(height: 1.6),
                    ),
                  ],
                ),
              ),
              if (_statusMessage != null) ...<Widget>[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: colors.dangerSubtle,
                    borderRadius: BorderRadius.circular(UiTokens.radius12),
                    border: Border.all(color: colors.dangerBorder),
                  ),
                  child: Text(
                    _statusMessage!,
                    style: appText.bodyStrong.copyWith(
                      color: colors.dangerForeground,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              PrimaryCtaButton(
                label: l10n.identityAuthStartAction,
                onPressed: _isRunning ? null : _startVerification,
                isLoading: _isRunning,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
