import 'dart:io';

import 'package:path_provider/path_provider.dart';

// path provider로 이미지 파일 경로 받아오기
Future<String> saveImageToLocalDirectory(File image) async {
  final documentDirectory = await getApplicationDocumentsDirectory();
  final folderPath = documentDirectory.path + '/medicine/images';
  // 항상 유니크한 파일명
  final filePath = folderPath + '/${DateTime.now().millisecondsSinceEpoch}.png';

  await Directory(folderPath).create(recursive: true);

  final newFile = File(filePath);
  newFile.writeAsBytesSync(image.readAsBytesSync());

  return filePath;
}