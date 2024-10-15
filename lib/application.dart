import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../application/core/enumerations/palette_enumeration.dart';

import '../application/presenter/library/details/details_handler.dart';
import '../application/presenter/library/home/home_handler.dart';
import '../application/presenter/library/launcher/launcher_handler.dart';
import '../application/presenter/library/search/search_handler.dart';

import '../application/core/enumerations/typographies_enumeration.dart';

class Application extends StatelessWidget {

  Application({super.key});

  @override
  Widget build(BuildContext context) {
    /// Sets the application to show the device navigation bar only.
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: <SystemUiOverlay> [SystemUiOverlay.bottom],
    );

    /// Set the orientation mode to freeze at portrait mode only.
    SystemChrome.setPreferredOrientations(<DeviceOrientation> [DeviceOrientation.portraitUp]);

    /// Set the navigation bar color.
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Palette.background.color,
    ));
    return MaterialApp.router(
      /// Freeze the text scaler regardless of the device's font size.
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
      routerConfig: _router,
      theme: _theme,
    );
  }

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
        path: '/details/:title',
        builder: (BuildContext context, GoRouterState state) {
          return Details(state.pathParameters['title']!);
        },
      ),
      GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) {
          return const Home();
        },
      ),
      GoRoute(
        path: '/search',
        builder: (BuildContext context, GoRouterState state) {
          return const Search();
        },
      ),
    ],
  );

  /// The application's theme style.
  /// 
  /// The global configuration, set everything related to [ThemeData] here.
  final ThemeData _theme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: Palette.background.color,
      toolbarHeight: 70,
      titleSpacing: 15,
      shape: Border(
        bottom: BorderSide(
          color: Palette.divider.color,
          width: 1,
        ),
      ),
      surfaceTintColor: Palette.background.color,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Palette.background.color,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      surfaceTintColor: Palette.background.color,
    ),
    highlightColor: Palette.elements.color.withOpacity(0.10),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder> {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
    scaffoldBackgroundColor: Palette.background.color,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Palette.foreground.color,
      insetPadding: EdgeInsets.zero,
    ),
    splashColor: Palette.elements.color.withOpacity(0.10),
    tabBarTheme: TabBarTheme(
      dividerColor: Palette.divider.color,
      dividerHeight: 1,
      indicatorColor: Palette.primary.color,
      labelStyle: Typographies.numbers(Palette.elements).style,
      overlayColor: WidgetStatePropertyAll(Palette.primary.color.withOpacity(0.10)),
      unselectedLabelStyle: Typographies.numbers(Palette.disabled).style,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Palette.primary.color,
      selectionColor: Palette.primary.color.withOpacity(0.50),
      selectionHandleColor: Palette.primary.color,
    ),
  );
}