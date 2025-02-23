import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/l10n_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import '../application/core/entities/game_entity.dart';

import '../application/core/enumerations/l10n_enumeration.dart';
import '../application/core/enumerations/palette_enumeration.dart';

import '../application/presenter/library/details/details_handler.dart';
import '../application/presenter/library/launcher/launcher_handler.dart';
import '../application/presenter/library/search/search_handler.dart';

import '../globals.dart';

// APPLICATION WIDGET 🧩: ======================================================================================================================================================= //

/// The root widget of the application.
///
/// Configures application routes, theme data, and global settings.
class Application extends StatefulWidget {

  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {

  @override
  void initState() {

    // Sets the application to show the device navigation bar only.
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: <SystemUiOverlay> [SystemUiOverlay.bottom],
    );

    // Set the orientation mode to freeze at portrait mode only.
    SystemChrome.setPreferredOrientations(<DeviceOrientation> [DeviceOrientation.portraitUp]);

    // Set the navigation bar color.
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: ColorEnumeration.background.value,
    ));
  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: localeState,
      builder: (BuildContext context, Locale? locale, Widget? _) {
        return MaterialApp.router(
        
          // Freeze the text scaler regardless of the device's font size.
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: child!,
            );
          },
          locale: locale,
          localizationsDelegates: const <LocalizationsDelegate> [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: _router,
          supportedLocales: <Locale> [
            L10nEnumeration.english.locale,
            L10nEnumeration.brazilianPortuguese.locale,
            L10nEnumeration.bahasaIndonesia.locale,
          ],
          theme: _theme,
        );
      }
    );
  }

  // ROUTES 🧩: ================================================================================================================================================================= //

  /// The application's routes.
  /// 
  /// When redirecting a view never use the default navigator, always use this router from [GoRouter] navigator.
  /// Check the architecture document for more information.
  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase> [
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const Launcher();
        },
      ),
      GoRoute(
        path: '/details',
        builder: (BuildContext context, GoRouterState state) {
          final Game game = state.extra as Game;
          return Details(game);
        },
      ),
      GoRoute(
        path: '/search',
        builder: (BuildContext context, GoRouterState state) {
          final String? publisher = state.extra as String?;
          return Search(
            publisher: publisher,
          );
        },
      ),
    ],
  );

  // THEME CONFIGURATION 🧩: ==================================================================================================================================================== //

  /// The application's theme.
  ///
  /// This theme is applied to the root widget of the application.
  /// It's used to configure the colors, typography, and other design elements of the application.
  final ThemeData _theme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: ColorEnumeration.background.value,
      toolbarHeight: 70,
      titleSpacing: 15,
      shape: Border(
        bottom: BorderSide(
          color: ColorEnumeration.divider.value,
          width: 1,
        ),
      ),
      surfaceTintColor: ColorEnumeration.background.value,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: ColorEnumeration.background.value,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      surfaceTintColor: ColorEnumeration.background.value,
    ),
    highlightColor: ColorEnumeration.elements.value.withAlpha(25),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder> {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
    scaffoldBackgroundColor: ColorEnumeration.background.value,
    splashColor: ColorEnumeration.splash.value,
  );
}