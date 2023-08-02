import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_list/data.dart';

class BoxNames {
  static const task = 'tasks';
}

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<Task>(BoxNames.task);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Task>(BoxNames.task);
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do List"),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EditTaskScreen(),
            ));
          },
          label: Text("Add New Task"),
          icon: Icon(Icons.add_circle)),
      body: ValueListenableBuilder<Box<Task>>(
        valueListenable: box.listenable(),
        builder: (context, box, child) {
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final Task task = box.values.toList()[index];
              return Container(
                child: Text(task.name),
              );
            },
          );
        },
      ),
    );
  }
}

class EditTaskScreen extends StatelessWidget {
  // const EditTaskScreen({super.key});
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Task"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Task task = Task();
          task.name = _controller.text;
          task.priority = Priority.low;
          if (task.isInBox) {
            task.save();
          } else {
            final Box<Task> box = Hive.box(BoxNames.task);
            box.add(task);
          }
          Navigator.of(context).pop();
        },
        label: Text("Save Change"),
        icon: Icon(Icons.check_circle),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration:
            InputDecoration(label: Text("Add a task for today ...")),
          )
        ],
      ),
    );
  }
}
