import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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

// BuildContext type을 받아야함
void showPermissionDenied(BuildContext context, {required String permission}){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // SnackBar 유지시간 설정 할 수 있음
        // duration: Duration(seconds: 10),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$permission 권한이 없습니다.'),
              const TextButton(
                  onPressed: openAppSettings,
                  child: Text('설정창으로 이동'))
            ],
          )));
}
