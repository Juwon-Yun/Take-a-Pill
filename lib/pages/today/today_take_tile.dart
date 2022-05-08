
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/bottomsheet/more_action_bottomsheet.dart';
import 'package:intl/intl.dart';

import '../../components/custom_constants.dart';
import '../../components/custom_page_route.dart';
import '../../main.dart';
import '../../models/medicine_alarm.dart';
import '../../models/medicine_history.dart';
import '../add_medicine/add_medicine_page.dart';
import '../bottomsheet/time_setting_bottomsheet.dart';
import 'image_detail_page.dart';

class BeforeTakeTile extends StatelessWidget {
  const BeforeTakeTile({Key? key, required this.medicineAlarm}) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;

    return Row(children: [
      MedicineImageButton(imagePath: medicineAlarm.imagePath),
      const SizedBox(width: smallSpace),
      // 스크롤 디테일
      const Divider(height: 1, thickness: 2.0),
      Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildTileBody(textStyle, context),
          )),
      _MoreButton(medicineAlarm: medicineAlarm),
    ],
    );
  }

  List<Widget> _buildTileBody(TextStyle? textStyle, BuildContext context) {
    return [
            Text('🕑 ${medicineAlarm.alarmTime}', style: textStyle),
            const SizedBox(height: 6),
            Wrap(
              // wrap 전용 배치
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('${medicineAlarm.name},', style: textStyle,),
                  TileActionButton(title: '지금', onTap: () {
                    historyRepository.addHistory(MedicineHistory(
                        id: medicineAlarm.id,
                        takeTime: DateTime.now(),
                        alarmTime: medicineAlarm.alarmTime,
                        medicineKey: medicineAlarm.key, imagePath: medicineAlarm.imagePath, name: medicineAlarm.name,
                    ));
                  },),
                  Text('|',style: textStyle,),
                  TileActionButton(
                      title: '아까',
                      onTap: () => _onPreviousTake(context)
                  ),
                  Text('먹었어요!', style: textStyle,),
                ]
            )
          ];
  }

  void _onPreviousTake(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) => TimeSettingBottomSheet(
            initialDateTime: medicineAlarm.alarmTime
        )).then((takeDateTime) {
      if( takeDateTime != null || takeDateTime is! DateTime){
        historyRepository.addHistory(MedicineHistory(
            id: medicineAlarm.id,
            takeTime: takeDateTime,
            alarmTime: medicineAlarm.alarmTime,
            medicineKey: medicineAlarm.key, imagePath: medicineAlarm.imagePath, name: medicineAlarm.name,
        ));
      }
    });
  }
}

class AfterTakeTile extends StatelessWidget {
  const AfterTakeTile({Key? key, required this.medicineAlarm, required this.history}) : super(key: key);

  final MedicineAlarm medicineAlarm;
  final MedicineHistory history;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;

    return Row(children: [
      Stack(
        children:[
          MedicineImageButton(imagePath: medicineAlarm.imagePath!),
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.green.withOpacity(0.7),
            child: const Icon(
              CupertinoIcons.check_mark,
              color: Colors.white,
            ),
          )
        ]
      ),
      const SizedBox(width: smallSpace),
      // 스크롤 디테일
      const Divider(height: 1, thickness: 2.0),
      Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildTileBody(textStyle, context),
          )),
      _MoreButton(medicineAlarm: medicineAlarm),
    ],
    );
  }

  List<Widget> _buildTileBody(TextStyle? textStyle, BuildContext context) {
    return [
      Text.rich(
        TextSpan(
          text: '✅ ${medicineAlarm.alarmTime} → ',
          style: textStyle,
          children: [
            TextSpan(
              text: DateFormat('HH:mm').format(history.takeTime),
              style: textStyle?.copyWith(fontWeight: FontWeight.w500),
            )
          ]
        )
      ),
      const SizedBox(height: 6),
      Wrap(
        // wrap 전용 배치
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('${medicineAlarm.name},', style: textStyle,),
            TileActionButton(
              title: DateFormat('HH시 mm분에').format(history.takeTime),
              onTap: () => _onTab(context),
            ),
            Text('먹었어요!', style: textStyle,),
          ]
      )
    ];
  }

  get takeTimeStr => DateFormat('HH:mm').format(history.takeTime);

  void _onTab(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) => TimeSettingBottomSheet(
            initialDateTime: takeTimeStr,
            submitTitle: '수정',
            bottomWidget: TextButton(
                onPressed: (){
                  historyRepository.deleteHistory(history.medicineKey);
                  Navigator.pop(context);
                },
                child: Text(
                    '복약 시간을 지우고 싶어요.',
                    style: Theme.of(context).textTheme.bodyText2
                )
            ),
        )).then((takeDateTime) {
      if( takeDateTime != null || takeDateTime is! DateTime){
        historyRepository.updateHistory(
            key : history.medicineKey,
            history : MedicineHistory(
                        id: medicineAlarm.id,
                        takeTime: takeDateTime,
                        alarmTime: medicineAlarm.alarmTime,
                        medicineKey: medicineAlarm.key, imagePath: medicineAlarm.imagePath, name: medicineAlarm.name,

            )
        );
      }
    });
  }
}

class _MoreButton extends StatelessWidget {
  const _MoreButton({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        onPressed: (){
          // medicineRepository.deleteMedicine(medicineAlarm.key);
          showModalBottomSheet(context: context, builder: (context)=>
              MoreActionBottomSheet(
                onPressedModify: () { 
                  Navigator.push(
                      context,
                      FadePageRoute(
                        page: AddPage(updateMedicineId: medicineAlarm.id)
                      )
                  ).then((value) => Navigator.maybePop(context));
                },
                onPressedDeleteOnlyMedicine: () {
                  // 1. 알람 삭제
                  notification.deleteMultipleAlarm(alarmIds);
                  // 2. hive 데이터 삭제
                  medicineRepository.deleteMedicine(medicineAlarm.key);
                  // 3. pop
                  Navigator.pop(context);
                },
                onPressedDeleteAll: () {
                  // 1. 알람 삭제
                  notification.deleteMultipleAlarm(alarmIds);
                  // 2. hive history 데이터 삭제
                  historyRepository.deleteAllHistory(keys);
                  // 3. hive medicine 데이터 삭제
                  medicineRepository.deleteMedicine(medicineAlarm.key);
                  // 4. pop
                  Navigator.pop(context);

                },
              )
          );

        } ,
        child: const Icon(CupertinoIcons.ellipsis_vertical));
  }
  List<String> get alarmIds{
    final medicine = medicineRepository.medicineBox.values.singleWhere((element) => element.id == medicineAlarm.id);
    final alarmIds = medicine.alarms.map((el) => notification.alarmId(medicineAlarm.id, el)).toList();
    return alarmIds;
  }

  Iterable<int> get keys {
    final histories = historyRepository.historyBox.values.where((element) =>
      element.id == medicineAlarm.id &&
      element.medicineKey == medicineAlarm.key
    );
    final keys = histories.map((e) => e.key as int);
    return keys;
  }
}

class MedicineImageButton extends StatelessWidget {
  const MedicineImageButton({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: EdgeInsets.zero ,
        onPressed: (){
          imagePath == null
              ? null
              : Navigator.push(context, FadePageRoute(
              page: ImageDetailWidget(imagePath: imagePath!)
          )
          );
        },
        child: CircleAvatar(
          radius: 40,
          foregroundImage: imagePath == null ? null : FileImage(File(imagePath!)),
          child: imagePath == null ? const Icon(CupertinoIcons.alarm_fill) : null,

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