import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/custom_constants.dart';
import 'package:flutter_app/components/custom_widget.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/models/medicine.dart';
import 'package:flutter_app/services/add_medicine_service.dart';
import 'package:flutter_app/services/custom_file_service.dart';


import '../bottomsheet/time_setting_bottomsheet.dart';
import 'components/add_page_widget.dart';

// ignore: must_be_immutable
class AddAlarmPage extends StatelessWidget {
  AddAlarmPage({
    Key? key,
    required this.medicineImage,
    required this.medicineName,
    required this.updatedMedicineId,
  }) : super(key: key){
    service = AddMedicineService(updatedMedicineId);
  }

  final File? medicineImage;
  final String medicineName;
  final int updatedMedicineId;

  late AddMedicineService service;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AddPageBody(
        children: [
          Text('매일 복약 잊지 말아요!', style: Theme.of(context).textTheme.headline4),
        const SizedBox(height: largeSpace),
          // 기존에 SingleChildScrollView를 해놓아서 나머지 높이가 무제한 Expanded 되기 때문에 에러를 표시한다.
          Expanded(child: AnimatedBuilder(
            animation: service,
            builder: (context, _) {
              return ListView(
                children: alarmWidgets,
              );
            }
          ))
        ],
      ),
      bottomNavigationBar: BottomSubmitButton(
          onPressed: () async{
            final isUpdate = updatedMedicineId != -1;
            isUpdate
              ? await _onUpdateMedicine(context)
              : await _onAddMedicine(context);
          },
          text: '완료'),
    );
  }

  Future<void> _onAddMedicine(BuildContext context) async {
    // 1. add alarm
    bool result = false;

    for( var alarm in service.alarms){
      result = await notification.addNotification(
          medicineId: medicineRepository.newId,
          alarmTimeStr: alarm,
          title: '$alarm 약 먹을 시간이에요!',
          body: '$medicineName 복약했다고 알려주세요!'
      );
    }

    if(!result){
      return showPermissionDenied(context, permission: '알람');
    }

    // 2. save image (local dir)
    String? imageFilePath;
    if(medicineImage != null){
      imageFilePath = await saveImageToLocalDirectory(medicineImage!);
    }

    // 3. add medicine mode (local DB, hive)
    final medicine = Medicine(id: medicineRepository.newId, name: medicineName, imagePath: imageFilePath, alarms: service.alarms.toList());

    // hive 추가하기
    medicineRepository.addMedicine(medicine);

    // 콜백이 위젯이 퍼스트 일때까지 pop한다.
    Navigator.popUntil(context, (route) => route.isFirst);

  }

  Future<void> _onUpdateMedicine(BuildContext context) async {
    // 1-1 delete previous alarm
    final alarmIds = _updateMedicine.alarms.map((e) =>
        notification.alarmId(updatedMedicineId, e));

    await notification.deleteMultipleAlarm(alarmIds);

    // 1-2. add alarm
    bool result = false;

    for( var alarm in service.alarms){
      result = await notification.addNotification(
          medicineId: updatedMedicineId,
          alarmTimeStr: alarm,
          title: '$alarm 약 먹을 시간이에요!',
          body: '$medicineName 복약했다고 알려주세요!'
      );
    }

    if(!result){
      return showPermissionDenied(context, permission: '알람');
    }

    String? imageFilePath = _updateMedicine.imagePath;

    if(_updateMedicine.imagePath != medicineImage?.path){

      // 2-1. delete previous image
      if(_updateMedicine.imagePath != null){
       deleteImage(_updateMedicine.imagePath!);
      }

      // 2. save image (local dir)
      if(medicineImage != null){
        imageFilePath = await saveImageToLocalDirectory(medicineImage!);
      }
    }

    // 3. add medicine mode (local DB, hive)
    final medicine = Medicine(
        id: updatedMedicineId,
        name: medicineName,
        imagePath: imageFilePath,
        alarms: service.alarms.toList());

    // hive 추가하기
    medicineRepository.updateMedicine(key: _updateMedicine.key, medicine: medicine);

    // 콜백이 위젯이 퍼스트 일때까지 pop한다.
    Navigator.popUntil(context, (route) => route.isFirst);


  }

  Medicine get _updateMedicine => medicineRepository.medicineBox.values
      .singleWhere((element) => element.id == updatedMedicineId);


  List<Widget> get alarmWidgets {
    final children = <Widget>[];

    children.addAll(
      service.alarms.map((alarmTime) =>
          AlarmBox(
            time:  alarmTime,
            service: service,
      )),
    );
    children.add(
      AddAlarmButton(service: service)
      
      // AddAlarmButton(onPressedAddAlarm: (){
      //   final now = DateTime.now();
      //   final nowTime = DateFormat('HH:mm').format(now);
      //   setState(() {
      //     _alarms.add(nowTime);
      //   });
      // },
    
    );
    return children;
  }
}

class AlarmBox extends StatelessWidget {
  const AlarmBox({
    Key? key, required this.time, required this.service
  }) : super(key: key);

  final String time;
  final AddMedicineService service;

  @override
  Widget build(BuildContext context) {

    return TextButton(
      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6), textStyle: Theme.of(context).textTheme.subtitle2),
      onPressed: (){},
      child: Row(
        children: [
          Expanded(flex: 1, child: IconButton(onPressed: (){service.removeAlarm(time);}, icon: const Icon(CupertinoIcons.minus_circled))),
          Expanded(
              flex: 5,
              child: TextButton(
                onPressed: (){
                showModalBottomSheet(context: context, builder: (context){
                  return TimeSettingBottomSheet(initialDateTime: time);
                })
                // pop의 두번재 매개변수로 값을 받아온다. 리턴타입이 Future여서 그럼
                .then((value){
                  if(value == null || value is! DateTime){
                    return;
                  }
                  service.setAlarm(
                    prevTime: time,
                    setTime: value,
                  );
                });
              },
              child: Text(time)
            )
          ),
        ],
      ),
    );
  }
}


class AddAlarmButton extends StatelessWidget {
  const AddAlarmButton({
    Key? key, required this.service
  }) : super(key: key);

  final AddMedicineService service;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6), textStyle: Theme.of(context).textTheme.subtitle1),
      onPressed: service.addNowAlarm,
      child: Row(
        children: const [
          Expanded(flex: 1, child: Icon(CupertinoIcons.plus_circled)),
          Expanded(flex: 5, child: Center(child:Text('복용 시간 추가')) ,),
        ],
      ),
    );
  }
}
