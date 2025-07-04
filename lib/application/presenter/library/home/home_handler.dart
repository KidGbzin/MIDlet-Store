import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';

import '../../../core/extensions/router_extension.dart';

import '../../widgets/button_widget.dart';

part '../home/home_controller.dart';
part '../home/home_view.dart';

class Home extends StatefulWidget {

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return const _View();
  }
}