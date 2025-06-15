import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../l10n/l10n_localizations.dart';

import '../../core/enumerations/palette_enumeration.dart';
import '../../core/enumerations/typographies_enumeration.dart';

class ErrorMessage extends StatefulWidget {

  final Object error;

  const ErrorMessage(this.error, {super.key});

  @override
  State<ErrorMessage> createState() => _ErrorMessageState();
}

class _ErrorMessageState extends State<ErrorMessage> {
  late String title;
  late String message;

  late AppLocalizations localizations;

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context)!;
    _handleErrorMessage();

    super.didChangeDependencies();
  }

  void _handleErrorMessage() {
    if (widget.error is ClientException) {
      message = localizations.exClientExceptionMessage;
      title = localizations.exClientExceptionTitle;
    }
    else if (widget.error is FormatException) {
      message = localizations.exFormatExceptionMessage;
      title = localizations.exFormatExceptionTitle;
    }
    else if (widget.error is HttpException) {
      title = localizations.exHttpExceptionMessage;
      message = localizations.exHttpExceptionTitle;
    }
    else {
      message = localizations.exUnknownExceptionMessage;
      title = localizations.exUnknownExceptionTitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
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
            icon: HugeIcons.strokeRoundedAlert01,
            color: Palettes.grey.value,
          ),
          Text(
            message,
            style: TypographyEnumeration.body(Palettes.elements).style,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}