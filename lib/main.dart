import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/repo/repository.dart';
import 'package:task_list/data/source/hive_task_source.dart';
import 'package:task_list/screens/home/home.dart';

class BoxNames {
  static const task = 'tasks';
}

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<Task>(BoxNames.task);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.deepPurple));
  runApp(ChangeNotifierProvider<Repository<Task>>(
      create: (BuildContext context) {
        return Repository<Task>(HiveTaskDataSource(Hive.box(BoxNames.task)));
      },
      child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: const ColorScheme.light(
              primary: Color(0xff794CFF), background: Color(0xffF3F5F8))),
      home: HomeScreen(),
    );
  }
}
