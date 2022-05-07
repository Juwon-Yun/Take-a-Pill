import 'dart:io';

import 'package:flutter/material.dart';

import 'components/add_page_widget.dart';

class AddAlarmPage extends StatelessWidget {
  const AddAlarmPage({Key? key, required this.medicineImage, required this.medicineName}) : super(key: key);

  final File? medicineImage;
  final String medicineName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AddPageBody(
        children: [
          medicineImage == null ? Container() : Image.file(medicineImage!),
          Text(medicineName),
        ],
      ),
    );
  }
}
