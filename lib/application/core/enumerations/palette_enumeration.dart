import 'package:flutter/material.dart';

enum Palettes {
  accent(Color(0xFF7B83C0)),
  background(Color(0xff1c1d22)),
  divider(Color(0xff2a2a32)),
  disabled(Color(0xFF757575)),
  elements(Color(0xffe4e5e9)),
  foreground(Color(0xff26262e)),
  gold(Color(0xFFFAD400)),
  grey(Color(0xFFBDBDBD)),
  primary(Color(0xff50599e)),
  splash(Color(0x20e4e5e9)),
  googleBlue(Color(0xff4285F4)),
  pink(Color(0xFFE91E63)),
  red(Colors.red),
  green(Colors.green),
  transparent(Color(0x00000000));

  const Palettes(this.value);

  final Color value;
}