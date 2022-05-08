import 'package:flutter_app/models/medicine.dart';
import 'package:flutter_app/models/medicine_history.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MedicineHive{
  Future<void> initializeHive() async{
    await Hive.initFlutter();

    Hive.registerAdapter<Medicine>(MedicineAdapter());
    Hive.registerAdapter<MedicineHistory>(MedicineHistoryAdapter());

    await Hive.openBox<Medicine>(CustomHiveBox.medicine);
    await Hive.openBox<MedicineHistory>(CustomHiveBox.medicineHistory);
  }
}

class CustomHiveBox{
  static const String medicine = 'medicine';
  static const String medicineHistory = 'medicine_history';
}