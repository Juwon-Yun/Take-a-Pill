import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

// 변화 되었을때 디자인, setState 대신 쓰고 본문에서는 stateless로 다시 설정
class AddMedicineService with ChangeNotifier{
  final _alarms = <String>{
    '00:00',
    '13:00',
    '18:00',
  };

  Set<String> get alarms => _alarms;

  void addNowAlarm(){
    final now = DateTime.now();
    final nowTime = DateFormat('HH:mm').format(now);

    _alarms.add(nowTime);
    notifyListeners();
  }

  void removeAlarm(String alarmTime){
    _alarms.remove(alarmTime);
    notifyListeners();
  }

  // timer를 수정하는 기능, update다.
  void setAlarm({required String prevTime, required DateTime setTime}){
    _alarms.remove(prevTime);
    _alarms.add(DateFormat('HH:mm').format(setTime));
    notifyListeners();
  }
}