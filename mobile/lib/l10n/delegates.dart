import 'package:material_ui/material_ui.dart';

import 'package:nabta/l10n/gen/app_localizations.dart';

/// App strings plus material_ui's Material, Cupertino and Widgets
/// localizations. gen-l10n's own `localizationsDelegates` list still points
/// at the deprecated `flutter_localizations` Material delegate, whose types
/// material_ui widgets don't recognise, so use this list instead.
const List<LocalizationsDelegate<dynamic>> appLocalizationsDelegates = [
  AppLocalizations.delegate,
  ...GlobalMaterialLocalizations.delegates,
];
