import 'package:hive/hive.dart';

// $flutter packages pub run build_runner build
part 'medicine.g.dart';

@HiveType(typeId: 1)
class Medicine{

  Medicine({ required this.id, required this.name, required this.imagePath, required this.alarms});

  // id unique ai, UUID, millisecondsSinceEpoch
  @HiveField(0)
  final int id;

  // name
  @HiveField(1)
  final String name;

  // image(optional)
  @HiveField(2)
  final String? imagePath;

  // alarms
  @HiveField(3)
  final Set<String> alarms;
}