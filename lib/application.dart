import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../application/core/enumerations/l10n_enumeration.dart';
import '../application/core/enumerations/palette_enumeration.dart';

import '../application/core/configuration/router_configuration.dart';
import '../application/core/configuration/theme_configuration.dart';

import '../l10n/l10n_localizations.dart';

// APPLICATION'S ROOT 🧩: ======================================================================================================================================================= //

/// The root widget of the application.
///
/// Configures application routes, theme data, and global settings
class Application extends StatefulWidget {

  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: <SystemUiOverlay> [SystemUiOverlay.bottom], // Sets the application to show the device navigation bar only.
    );
    SystemChrome.setPreferredOrientations(<DeviceOrientation> [DeviceOrientation.portraitUp]); // Set the orientation mode to freeze at portrait mode only.
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Palettes.background.value,
    ));
  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0), // Freeze the text scaler regardless of the device's font size.
          ),
          child: child!,
        );
      },
      localizationsDelegates: const <LocalizationsDelegate> [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      supportedLocales: <Locale> [
        L10nEnumeration.english.locale,
        L10nEnumeration.brazilianPortuguese.locale,
        L10nEnumeration.bahasaIndonesia.locale,
      ],
      theme: theme,
    );
  }
}