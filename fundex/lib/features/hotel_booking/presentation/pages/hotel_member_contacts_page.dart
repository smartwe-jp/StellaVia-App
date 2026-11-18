import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../providers/hotel_booking_providers.dart';
import '../widgets/hotel_member_contact_form_page.dart';
import '../widgets/hotel_member_contact_card.dart';
import '../widgets/hotel_state_views.dart';

class HotelMemberContactsPage extends ConsumerWidget {
  const HotelMemberContactsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final contactsState = ref.watch(hotelMemberContactsProvider);
    final contacts = contactsState.valueOrNull ?? const <HotelMemberContact>[];
    return Scaffold(
      appBar: AppNavigationBar(
        title: context.l10n.hotelMemberContactsTitle,
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.go('/hotel-booking');
          },
          backgroundColor: colors.surface.withValues(alpha: 0),
          foregroundColor: colors.textPrimary,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(hotelMemberContactsProvider.future),
        child: contactsState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverFillRemaining(
                hasScrollBody: false,
                child: HotelFullPageError(
                  onRetry: () => ref.invalidate(hotelMemberContactsProvider),
                ),
              ),
            ],
          ),
          data: (contacts) {
            if (contacts.isEmpty) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyContactsView(
                      onAdd: () => _openContactForm(context, ref),
                    ),
                  ),
                ],
              );
            }
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return HotelMemberContactCard(
                  contact: contact,
                  onTap: () => _openContactForm(context, ref, contact: contact),
                  onDelete: () => _confirmDeleteContact(context, ref, contact),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: contacts.length,
            );
          },
        ),
      ),
      bottomNavigationBar: contacts.isEmpty
          ? null
          : SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: PrimaryCtaButton(
                label: context.l10n.hotelMemberContactsAddAction,
                onPressed: () => _openContactForm(context, ref),
                borderRadius: BorderRadius.circular(999),
                backgroundColor: colors.primary,
                shadowColor: colors.primary.withValues(alpha: 0.22),
              ),
            ),
    );
  }

  Future<void> _openContactForm(
    BuildContext context,
    WidgetRef ref, {
    HotelMemberContact? contact,
  }) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => HotelMemberContactFormPage(contact: contact),
        fullscreenDialog: true,
      ),
    );
    if (saved == true) {
      ref.invalidate(hotelMemberContactsProvider);
    }
  }

  Future<void> _confirmDeleteContact(
    BuildContext context,
    WidgetRef ref,
    HotelMemberContact contact,
  ) async {
    final id = contact.id.trim();
    if (id.isEmpty) {
      return;
    }
    final confirmed = await AppDialogs.showAdaptiveAlert<bool>(
      context: context,
      title: context.l10n.hotelMemberContactsDeleteConfirmTitle,
      message: context.l10n.hotelMemberContactsDeleteConfirmMessage,
      actions: <AppDialogAction<bool>>[
        AppDialogAction<bool>(label: context.l10n.commonCancel, value: false),
        AppDialogAction<bool>(
          label: context.l10n.hotelMemberContactsDeleteAction,
          value: true,
          isDestructive: true,
        ),
      ],
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    try {
      await AppLoadingDialog.run(
        context,
        () => ref.read(deleteHotelMemberContactUseCaseProvider)(id: id),
        message: context.l10n.commonPleaseWait,
      );
      ref.invalidate(hotelMemberContactsProvider);
      if (context.mounted) {
        AppNotice.show(
          context,
          message: context.l10n.hotelMemberContactsDeletedMessage,
        );
      }
    } catch (_) {
      if (context.mounted) {
        AppNotice.show(
          context,
          message: context.l10n.hotelMemberContactsDeleteFailedMessage,
        );
      }
    }
  }
}

class _EmptyContactsView extends StatelessWidget {
  const _EmptyContactsView({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            context.l10n.hotelMemberContactsEmpty,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_circle_outline_rounded),
            label: Text(context.l10n.hotelMemberContactsAddAction),
            style: TextButton.styleFrom(
              foregroundColor: colors.primary,
              textStyle: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
