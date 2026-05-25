import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../providers/hotel_booking_providers.dart';
import '../widgets/hotel_member_profile_edit_sheet.dart';
import '../widgets/hotel_member_profile_fields.dart';
import '../widgets/hotel_state_views.dart';

class HotelMemberProfilePage extends ConsumerStatefulWidget {
  const HotelMemberProfilePage({super.key});

  @override
  ConsumerState<HotelMemberProfilePage> createState() =>
      _HotelMemberProfilePageState();
}

class _HotelMemberProfilePageState
    extends ConsumerState<HotelMemberProfilePage> {
  bool _isSaving = false;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> _saveProfile(HotelMemberProfile profile) async {
    if (_isSaving) {
      return;
    }
    setState(() => _isSaving = true);
    try {
      await ref.read(updateHotelMemberProfileUseCaseProvider)(profile);
      ref.invalidate(hotelMemberProfileProvider);
      if (mounted) {
        AppNotice.show(
          context,
          message: context.l10n.hotelMemberProfileSaveSuccess,
        );
      }
    } catch (_) {
      if (mounted) {
        AppNotice.show(
          context,
          message: context.l10n.hotelMemberProfileSaveFailed,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _editTextField({
    required HotelMemberProfile profile,
    required String title,
    required String label,
    required String initialValue,
    required TextInputType keyboardType,
    required HotelMemberProfile Function(String value) update,
  }) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).appColors.brandWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => HotelMemberProfileTextEditSheet(
        title: title,
        label: label,
        initialValue: initialValue,
        keyboardType: keyboardType,
      ),
    );
    if (!mounted || result == null) {
      return;
    }
    await _saveProfile(update(result));
  }

  Future<void> _editPhone(HotelMemberProfile profile) async {
    final result =
        await showModalBottomSheet<HotelMemberProfilePhoneEditResult>(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          backgroundColor: Theme.of(context).appColors.brandWhite,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          builder: (_) => HotelMemberProfilePhoneEditSheet(
            initialCountryCode: profile.phoneCountryCode,
            initialPhoneNumber: profile.phoneNumber,
          ),
        );
    if (!mounted || result == null) {
      return;
    }
    await _saveProfile(
      profile.copyWith(
        phoneCountryCode: result.countryCode,
        phoneNumber: result.phoneNumber,
      ),
    );
  }

  Future<void> _editGender(HotelMemberProfile profile) async {
    final result = await showModalBottomSheet<int>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).appColors.brandWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) =>
          HotelMemberProfileGenderEditSheet(initialGender: profile.gender),
    );
    if (!mounted || result == null) {
      return;
    }
    await _saveProfile(profile.copyWith(gender: result));
  }

  Future<void> _editBirthday(HotelMemberProfile profile) async {
    final now = DateTime.now();
    final parsed = DateTime.tryParse(profile.birthday);
    final picked = await showDatePicker(
      context: context,
      initialDate: parsed ?? DateTime(now.year - 30, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year, now.month, now.day),
    );
    if (!mounted || picked == null) {
      return;
    }
    await _saveProfile(profile.copyWith(birthday: _dateFormat.format(picked)));
  }

  void _showMemberLevelNotice() {
    AppNotice.show(
      context,
      message: context.l10n.menuFeatureComingSoon(
        context.l10n.hotelMemberProfileAboutLevel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final profileState = ref.watch(hotelMemberProfileProvider);

    return Scaffold(
      backgroundColor: colors.surfaceAlt,
      appBar: AppBar(
        backgroundColor: colors.surfaceAlt,
        foregroundColor: colors.textPrimary,
        title: Text(context.l10n.hotelMemberProfileTitle),
      ),
      body: Stack(
        children: <Widget>[
          RefreshIndicator(
            onRefresh: () => ref.refresh(hotelMemberProfileProvider.future),
            child: profileState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.22),
                  HotelFullPageError(
                    onRetry: () => ref.invalidate(hotelMemberProfileProvider),
                  ),
                ],
              ),
              data: (profile) => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: <Widget>[
                  HotelMemberProfileFields(
                    profile: profile,
                    onEditName: () => _editTextField(
                      profile: profile,
                      title: context.l10n.hotelMemberProfileNickname,
                      label: context.l10n.hotelMemberProfileNickname,
                      initialValue: profile.memberName,
                      keyboardType: TextInputType.name,
                      update: (value) => profile.copyWith(memberName: value),
                    ),
                    onEditEmail: () => _editTextField(
                      profile: profile,
                      title: context.l10n.hotelMemberProfileEmail,
                      label: context.l10n.hotelMemberProfileEmail,
                      initialValue: profile.email,
                      keyboardType: TextInputType.emailAddress,
                      update: (value) => profile.copyWith(email: value),
                    ),
                    onEditPhone: () => _editPhone(profile),
                    onEditGender: () => _editGender(profile),
                    onEditBirthday: () => _editBirthday(profile),
                    onMemberLevelInfoTap: _showMemberLevelNotice,
                  ),
                ],
              ),
            ),
          ),
          if (_isSaving)
            Positioned.fill(
              child: ColoredBox(
                color: colors.scrim.withValues(alpha: 0.10),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
