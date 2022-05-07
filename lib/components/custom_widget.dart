import 'package:flutter/material.dart';

import 'custom_constants.dart';

class BottomSheetBody extends StatelessWidget {
  const BottomSheetBody({Key? key, required this.children}) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
        padding: pagePadding,
        child: SafeArea(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children),),),);
  }
}
