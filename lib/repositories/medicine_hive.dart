import 'package:flutter_app/models/medicine.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MedicineHive{
  Future<void> initializeHive() async{
    await Hive.initFlutter();

    Hive.registerAdapter<Medicine>(MedicineAdapter());

    await Hive.openBox<Medicine>(CustomHiveBox.medicine);
  }
}

class CustomHiveBox{
  static const String medicine = 'medicine';
}