import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/beneficial_owner.dart';

String ownerPresenceLabel(AppLocalizations l, OwnerPresence status) =>
    switch (status) {
      OwnerPresence.yes => l.corpOwnerYes,
      OwnerPresence.no => l.corpOwnerNo,
      OwnerPresence.unknown => l.corpOwnerUnknown,
    };
String ownerControlLabel(AppLocalizations l, OwnerControl? control) =>
    control == null
    ? l.corpFormMissing
    : control == OwnerControl.ownershipOver25
    ? l.corpOwnerOwnership
    : l.corpOwnerInfluence;
