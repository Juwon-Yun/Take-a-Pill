
import 'dart:io';

import 'package:flutter/material.dart';

import '../../models/medicine_alarm.dart';

class ImageDetailWidget extends StatelessWidget {
  const ImageDetailWidget({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const CloseButton(),
        ),
        body: Center(
            child: Image.file(
                File(imagePath)
            )
        )
    );
  }
}