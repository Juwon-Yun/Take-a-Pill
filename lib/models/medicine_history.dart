import 'package:hive/hive.dart';

// $flutter packages pub run build_runner build
part 'medicine_history.g.dart';

@HiveType(typeId: 2)
class MedicineHistory extends HiveObject{

  MedicineHistory({ required this.id, required this.alarmTime, required this.takeTime});

  // id unique ai, UUID, millisecondsSinceEpoch
  @HiveField(0)
  final int id;

  // name
  @HiveField(1)
  final String alarmTime;

  // image(optional)
  @HiveField(2)
  final DateTime takeTime;

  @override
  String toString() {
    return '{id : $id, alarmTime : $alarmTime, takeTime : $takeTime}';
  }
}