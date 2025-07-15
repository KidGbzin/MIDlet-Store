import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../l10n/l10n_localizations.dart';

import '../../core/enumerations/palette_enumeration.dart';
import '../../core/enumerations/progress_enumeration.dart';
import '../../core/enumerations/typographies_enumeration.dart';

import '../widgets/loading_widget.dart';


class Handler extends StatefulWidget {

  final ValueNotifier<({Progresses state, Object? error})> nProgress;

  final Widget onReady;

  const Handler({
    required this.nProgress,
    required this.onReady,
    super.key,
  });

  @override
  State<Handler> createState() => _HandlerState();
}

class _HandlerState extends State<Handler> {
  late final AppLocalizations l10n;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    l10n = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: builder(),
    );
  }

  ValueListenableBuilder<({Object? error, Progresses state})> builder() {
    return ValueListenableBuilder(
      valueListenable: widget.nProgress,
      builder: (BuildContext context, ({Progresses state, Object? error}) progress, Widget? _) {
        if (progress.state == Progresses.isReady) return widget.onReady;
        if (progress.state == Progresses.isLoading) return onLoading();
        if (progress.state == Progresses.hasError) return onError(progress.error);

        return onError(progress.error);
      }
    );
  }

  Widget onLoading() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
      child: Align(
        alignment: Alignment.center,
        child: LoadingAnimation(),
      ),
    );
  }

  Widget onError(Object? error) {
    error ??= StateError("Error was null!");

    final (String title, String message) = localizeError(error);

    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 15,
          children: <Widget> [
            Text(
              title.toUpperCase(),
              style: TypographyEnumeration.headline(Palettes.elements).style,
            ),
            HugeIcon(
              icon: HugeIcons.strokeRoundedBug02,
              color: Palettes.grey.value,
            ),
            Text(
              message,
              style: TypographyEnumeration.body(Palettes.elements).style,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  (String title, String message) localizeError(Object error) {
    if (error is StateError) return (l10n.exStateErrorTitle, l10n.exStateErrorMessage);
    if (error is AuthException) return (l10n.exAuthExceptionTitle, l10n.exAuthExceptionMessage);
    if (error is PostgrestException) return (l10n.exPostgrestExceptionTitle, l10n.exPostgrestExceptionMessage);
    if (error is FormatException) return (l10n.exFormatExceptionTitle, l10n.exFormatExceptionMessage);
    if (error is HttpException) return (l10n.exHttpExceptionTitle, l10n.exHttpExceptionMessage);
    if (error is ClientException) return (l10n.exClientExceptionTitle, l10n.exClientExceptionMessage);
  
    return (l10n.exUnknownExceptionTitle, l10n.exUnknownExceptionMessage);
  }
}