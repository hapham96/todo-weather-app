import 'package:Todo_App/core/logger/logger_tracker.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/todo.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todos');
  LoggerTrackerService().startLog();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Todo',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFDF6E3),
        primaryColor: Color(0xFF5D4037),
        fontFamily: 'Georgia',
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Color(0xFF5D4037)),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(Color(0xFF5D4037)),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
