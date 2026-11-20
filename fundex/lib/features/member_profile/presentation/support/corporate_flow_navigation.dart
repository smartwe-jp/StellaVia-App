import 'package:flutter/material.dart';

const _corporateModalSettings = RouteSettings(name: '/corporate-verification');

MaterialPageRoute<void> corporateVerificationModalRoute(
  WidgetBuilder builder,
) => MaterialPageRoute<void>(
  settings: _corporateModalSettings,
  fullscreenDialog: true,
  builder: builder,
);

bool _atCorporateEntry(Route<dynamic> route) =>
    route.settings.name == _corporateModalSettings.name ||
    route.settings is Page ||
    route.isFirst;

void returnToCorporateMemberProfile(
  BuildContext context,
  WidgetBuilder profile,
) {
  final navigator = Navigator.of(context);
  var standaloneModal = false;
  navigator.popUntil((route) {
    standaloneModal = route.settings.name == _corporateModalSettings.name;
    return _atCorporateEntry(route);
  });
  // A standalone flow (e.g. from Home) has preparation at its root.
  // A flow opened from member information already has the profile below it.
  if (standaloneModal) {
    navigator.pushReplacement(corporateVerificationModalRoute(profile));
  }
}

void leaveCorporateFlow(BuildContext context) {
  final navigator = Navigator.of(context, rootNavigator: true);
  navigator.popUntil(_atCorporateEntry);
  if (navigator.canPop()) navigator.pop();
}
