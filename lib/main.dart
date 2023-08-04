import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_list/data.dart';
import 'package:task_list/edit.dart';

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
  runApp(const MainApp());
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

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _serchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Task>(BoxNames.task);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("To Do List"),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  EditTaskScreen(
                    task: Task(),
                  ),
            ));
          },
          label: const Text("Add New Task"),
          icon: const Icon(Icons.add_circle)),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 110,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.purpleAccent, Colors.deepPurple])),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                            "To Do List",
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleLarge
                                ?.apply(color: Colors.white),
                          )),
                      const Icon(
                        Icons.cloud_done,
                        color: Colors.white,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 38,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(38 / 2),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 20,
                              color: Colors.black.withOpacity(0.1)),
                        ]),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {

                        });
                      },
                      controller: _serchController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIconColor: Colors.black12,
                        prefixIcon: Icon(Icons.search),
                        labelStyle: TextStyle(color: Colors.black12),
                        label: Text("Search task ..."),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<Box<Task>>(
                valueListenable: box.listenable(),
                builder: (context, box, child) {
                  final items;
                  if (_serchController.text.isEmpty) {
                    items = box.values.toList();
                  } else {
                    items = box.values.where((task) =>
                        task.name.contains(_serchController.text)).toList();
                  }
                  if (items.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                      itemCount: items.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Today",
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyLarge),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Container(
                                    width: 50,
                                    height: 4,
                                    decoration: BoxDecoration(
                                        color: Colors.purple,
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                  )
                                ],
                              ),
                              MaterialButton(
                                color: Colors.red.shade200,
                                disabledColor: Colors.grey.shade200,
                                elevation: 0,
                                onPressed: box.values.isEmpty
                                    ? null
                                    : () {
                                  box.clear();
                                },
                                child: const Row(
                                  children: [
                                    Text(
                                      "Delet all",
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Icon(
                                      Icons.delete,
                                      size: 16,
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        } else {
                          final Task task = items.toList()[index - 1];
                          return TaskItem(task: task);
                        }
                      },
                    );
                  } else {
                    return EmptyState(search: _serchController.text,);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    const double radiusSize = 8;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return EditTaskScreen(
              task: widget.task,
            );
          },
        ));
      },
      onLongPress: () {
        widget.task.delete();
      },
      child: Container(
        height: 55,
        padding: const EdgeInsets.only(
          left: 16,
        ),
        margin: const EdgeInsets.only(
          top: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radiusSize),
          color: Colors.white,
          boxShadow: const [BoxShadow(blurRadius: 20, color: Colors.black12)],
        ),
        child: Row(
          children: [
            MyCheckBox(
              value: widget.task.isCompleted,
              onTap: () {
                setState(() {
                  widget.task.isCompleted = !widget.task.isCompleted;
                  widget.task.save();
                });
              },
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                widget.task.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    decoration: widget.task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
            ),
            Container(
              // height: 10,
              decoration: BoxDecoration(
                  color: widget.task.priority == Priority.high
                      ? Colors.red
                      : widget.task.priority == Priority.low
                      ? Colors.blue
                      : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(radiusSize),
                    bottomRight: Radius.circular(radiusSize),
                  )),
              width: radiusSize,
            )
          ],
        ),
      ),
    );
  }
}

class MyCheckBox extends StatelessWidget {
  final double size = 20;
  final bool value;
  final GestureTapCallback onTap;

  const MyCheckBox({super.key, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: !value
          ? Icon(
        Icons.circle_outlined,
        size: size,
        color: Colors.grey,
      )
          : Icon(
        Icons.check_circle,
        size: size,
        color: Colors.deepPurple,
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final String search;
  const EmptyState({super.key, required this.search});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hourglass_empty,
            size: 40,
          ),
          SizedBox(
            height: 12,
          ),
          Text(search.isNotEmpty?"Your Search task list is empty!":"Your task list is empty!"),
        ],
      ),
    );
  }
}
