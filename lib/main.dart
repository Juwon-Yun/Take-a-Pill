import 'package:flutter/material.dart';
import 'package:flutter_app/components/custom_themes.dart';
import 'package:flutter_app/pages/home_page.dart';
import 'package:flutter_app/services/custom_notification_service.dart';

final notification = CustomNotificationService();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  notification.initializeTimeZone();
  notification.initializeNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: CustomThemes.lightTheme,
      home: const HomePage(),
      // 기기에서 설정한 사이즈만큼 사용하는 것
      builder: (context, child) => MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0)
      ),
    );
  }
}
