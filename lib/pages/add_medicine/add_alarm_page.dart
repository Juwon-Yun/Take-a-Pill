import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/custom_constants.dart';

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
          Text('매일 복약 잊지 말아요!', style: Theme.of(context).textTheme.headline4),
          // medicineImage == null ? Container() : Image.file(medicineImage!),
          // Text(medicineName),
        const SizedBox(height: largeSpace),
          // 기존에 SingleChildScrollView를 해놓아서 나머지 높이가 무제한 Expanded 되기 때문에 에러를 표시한다.
          Expanded(child: ListView(
            children: const [
              AlarmBox(),
              AlarmBox(),
              AlarmBox(),
              AlarmBox(),
              AddAlarmButton(),
            ],
          ))
        ],
        
      ),
    );
  }
}

class AlarmBox extends StatelessWidget {
  const AlarmBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6), textStyle: Theme.of(context).textTheme.subtitle2),
      onPressed: (){},
      child: Row(
        children: [
          Expanded(flex: 1, child: IconButton(onPressed: (){}, icon: const Icon(CupertinoIcons.minus_circled))),
          Expanded(flex: 5, child: TextButton(onPressed: (){}, child: const Text('18:00'))),
        ],
      ),
    );
  }
}

class AddAlarmButton extends StatelessWidget {
  const AddAlarmButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6), textStyle: Theme.of(context).textTheme.subtitle1),
      onPressed: (){},
      child: Row(
        children: const [
          Expanded(flex: 1, child: Icon(CupertinoIcons.plus_circled)),
          Expanded(flex: 5, child: Center(child:Text('복용 시간 추가')) ,),
        ],
      ),
    );
  }
}
