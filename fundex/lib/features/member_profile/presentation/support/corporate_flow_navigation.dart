import 'package:flutter/material.dart';

const _corporateModalSettings = RouteSettings(name: '/corporate-verification');

MaterialPageRoute<void> corporateVerificationModalRoute(
  WidgetBuilder builder,
) => MaterialPageRoute<void>(
  settings: _corporateModalSettings,
  fullscreenDialog: true,
  builder: builder,
);

void leaveCorporateFlow(BuildContext context) {
  final navigator = Navigator.of(context, rootNavigator: true);
  navigator.popUntil(
    (route) =>
        route.settings.name == _corporateModalSettings.name ||
        route.settings is Page ||
        route.isFirst,
  );
  if (navigator.canPop()) navigator.pop();
}
