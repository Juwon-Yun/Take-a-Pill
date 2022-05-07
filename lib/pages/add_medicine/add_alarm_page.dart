import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/custom_colors.dart';
import 'package:flutter_app/components/custom_constants.dart';
import 'package:flutter_app/components/custom_widget.dart';
import 'package:flutter_app/services/add_medicine_service.dart';
import 'package:intl/intl.dart';

import 'components/add_page_widget.dart';

class AddAlarmPage extends StatelessWidget {
  AddAlarmPage({Key? key, required this.medicineImage, required this.medicineName}) : super(key: key);

  final File? medicineImage;
  final String medicineName;


  final service = AddMedicineService();

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
          Expanded(child: AnimatedBuilder(
            animation: service,
            // widget parameter는 ignore
            builder: (context, _) {

              return ListView(
                children: alarmWidgets,
                // children: const [
                //   AlarmBox(),
                //   AlarmBox(),
                //   AlarmBox(),
                //   AlarmBox(),
                //   AddAlarmButton(),
                // ],
              );
            }
          ))
        ],
      ),
      bottomNavigationBar: BottomSubmitButton(onPressed: (){}, text: '완료'),
    );
  }

  List<Widget> get alarmWidgets {
    final children = <Widget>[];

    children.addAll(
      service.alarms.map((alarmTime) => AlarmBox(
          time:  alarmTime,
          service: service,
          // onPressedMinus: (){
          //   setState(() {
          //     service.alarms.remove(alarmTime);
          //   });
          // },
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
    final initTime = DateFormat('HH:mm').parse(time);

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
                  return TimePickerBottomSheet(initialDateTime: initTime);
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
class TimePickerBottomSheet extends StatelessWidget {
  const TimePickerBottomSheet({Key? key, required this.initialDateTime}) : super(key: key);

  final DateTime initialDateTime;

  @override
  Widget build(BuildContext context) {
    return BottomSheetBody(children: [
      SizedBox(
          height: 200,
          child: CupertinoDatePicker(onDateTimeChanged: (dateTime){}, mode: CupertinoDatePickerMode.time, initialDateTime: initialDateTime,)
      ),
      const SizedBox(width: regularSpace,),
      Row(
        children: [
          Expanded(
            child: SizedBox(
              height: submitButtonHeight,
              child: ElevatedButton(
                onPressed: (){},
                child: const Text('취소'),
                style: ElevatedButton.styleFrom(textStyle: Theme.of(context).textTheme.subtitle1, primary: Colors.white, onPrimary: CustomColors.primaryColor),
              ),
            ),
          ),
          // 간격 벌리기
          const SizedBox(width: smallSpace,),
          Expanded(
            child: SizedBox(
              height: submitButtonHeight,
              child: ElevatedButton(
                onPressed: (){},
                child: const Text('확인'),
                style: ElevatedButton.styleFrom(textStyle: Theme.of(context).textTheme.subtitle1),
              ),
            ),
          ),

        ],
      )
    ]);
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
