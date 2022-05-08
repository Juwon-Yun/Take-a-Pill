import 'package:flutter/material.dart';
import 'package:flutter_app/components/custom_constants.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/models/medicine_alarm.dart';
import 'package:flutter_app/pages/today/today_take_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

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

    medicineAlarms.sort((a,b) =>
        DateFormat('HH:mm')
            .parse(a.alarmTime)
            .compareTo(DateFormat('HH:mm')
              .parse(b.alarmTime))
    );

    return Column(
      children : [
        const Divider(height: 1, thickness: 1.0),
        Expanded(
          child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: smallSpace),
          // scroll overflow 방지
          itemCount: medicineAlarms.length,
          itemBuilder:   (context, idx){
            return _buildIsTile(medicineAlarms[idx]);
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

  Widget _buildIsTile(MedicineAlarm medicineAlarm){
    return ValueListenableBuilder(
      valueListenable: historyRepository.historyBox.listenable(),
      builder: (context, Box<MedicineHistory> historyBox, _) {
        if(historyBox.values.isEmpty){
          return BeforeTakeTile(medicineAlarm: medicineAlarm);
        }
        // where는 복수위젯을 리턴함
        final todayTakeHistory = historyBox.values.singleWhere(
                (history) =>
                  history.id == medicineAlarm.id &&
                  history.medicineKey == medicineAlarm.key &&
                  history.alarmTime == medicineAlarm.alarmTime &&
                  isToday(history.takeTime, DateTime.now()),
          orElse: () => MedicineHistory(
                          id: -1,
                          alarmTime: '',
                          takeTime: DateTime.now(),
                          medicineKey : -1,
                          imagePath: null,
                          name: ''
                      ),
        );

        if(todayTakeHistory.id == -1 && todayTakeHistory.alarmTime == ''){
          return BeforeTakeTile(medicineAlarm: medicineAlarm);
        }

        return AfterTakeTile(medicineAlarm: medicineAlarm, history: todayTakeHistory);

      }
    );
  }
}

bool isToday(DateTime source, DateTime destination){
  return source.year == destination.year &&
  source.month == destination.month &&
  source.day == destination.day;
}



