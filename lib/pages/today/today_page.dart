import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/custom_constants.dart';
import 'package:flutter_app/components/custom_page_route.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/models/medicine_alarm.dart';
import 'package:flutter_app/pages/bottomsheet/time_setting_bottomsheet.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/medicine.dart';
import '../../models/medicine_history.dart';
import 'today_empty_widget.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      // default가 center임
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('오늘 복용할 약은?', style: Theme.of(context).textTheme.headline4,),
        const SizedBox(height:  regularSpace),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: medicineRepository.medicineBox.listenable(),
            builder: _builderMedicineListView,
          ),
        ),
      ],
    );
  }

  Widget _builderMedicineListView(context, Box<Medicine> box, _) {
    final medicines = box.values.toList();
    final medicineAlarms = <MedicineAlarm>[];

    if(medicines.isEmpty){
      return const TodayEmpty();
    }

    for(var medicine in medicines){
      for(var alarm in medicine.alarms){
        medicineAlarms.add(MedicineAlarm(medicine.id, medicine.name, medicine.imagePath, alarm, medicine.key));
      }
    }

    return Column(
      children : [
        const Divider(height: 1, thickness: 1.0),
        Expanded(
          child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: smallSpace),
          // scroll overflow 방지
          itemCount: medicineAlarms.length,
          itemBuilder: (context, idx){
            return MedicineListTile(medicineAlarm: medicineAlarms[idx]);
          },
          // 구분할 위젯을 반복할수 있다.
          separatorBuilder: (BuildContext context, int index) {
            // return const SizedBox(height: regularSpace);
            // 높이를 알아서 먹는다. 근데 20만큼 더 높여줌
            return const Divider(height: regularSpace);
          },
      ),
        ),
      const Divider(height: 1, thickness: 1.0),
      ],
    );
  }

}

class MedicineListTile extends StatelessWidget {
  const MedicineListTile({Key? key, required this.medicineAlarm}) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;

    return Row(children: [
      CupertinoButton(
          padding: EdgeInsets.zero ,
          onPressed: (){
            medicineAlarm.imagePath == null
            ? null
            : Navigator.push(context, FadePageRoute(
                page: ImageDetailWidget(medicineAlarm: medicineAlarm)
              )
            );
          },
          child: CircleAvatar(
            radius: 40,
            foregroundImage: medicineAlarm.imagePath == null ? null : FileImage(File(medicineAlarm.imagePath!)),
          )
      ),
      const SizedBox(width: smallSpace),
      // 스크롤 디테일
      const Divider(height: 1, thickness: 2.0),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🕑 ${medicineAlarm.alarmTime}', style: textStyle),
            const SizedBox(height: 6),
            Wrap(
              // wrap 전용 배치
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('${medicineAlarm.name},', style: textStyle,),
                TileActionButton(title: '지금', onTap: () {

                },),
                Text('|',style: textStyle,),
                TileActionButton(title: '아까', onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => TimeSettingBottomSheet(
                          initialDateTime: medicineAlarm.alarmTime
                      )).then((takeDateTime) {
                        if( takeDateTime == null || takeDateTime! is DateTime){
                          historyRepository.addHistory(MedicineHistory(
                            id: medicineAlarm.id,
                            takeTime: takeDateTime,
                            alarmTime: medicineAlarm.alarmTime
                          ));
                        }
                    });
                },),
                Text('먹었어요!', style: textStyle,),
              ]
            )
          ],
        )),
      CupertinoButton(
          onPressed: (){
            medicineRepository.deleteMedicine(medicineAlarm.key);
          } ,
          child: const Icon(CupertinoIcons.ellipsis_vertical)),
    ],
    );
  }
}

class ImageDetailWidget extends StatelessWidget {
  const ImageDetailWidget({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
      ),
      body: Center(
        child: Image.file(
            File(medicineAlarm.imagePath!)
        )
        )
    );
  }
}

class TileActionButton extends StatelessWidget {
  const TileActionButton({
    Key? key, required this.onTap, required this.title
  }) : super(key: key);

  final VoidCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
  final textStyle = Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w500);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(title, style: textStyle),
      ),
    );
  }
}

