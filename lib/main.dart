import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.deepPurple));
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.light(
              primary: Color(0xff794CFF), background: Color(0xffF3F5F8))),
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
      // appBar: AppBar(
      //   title: Text("To Do List"),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EditTaskScreen(),
            ));
          },
          label: Text("Add New Task"),
          icon: Icon(Icons.add_circle)),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 110,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.purpleAccent, Colors.deepPurple])),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        "To Do List",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.apply(color: Colors.white),
                      )),
                      Icon(
                        Icons.cloud_done,
                        color: Colors.white,
                      )
                    ],
                  ),
                  SizedBox(
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
                      decoration: InputDecoration(
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
                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
                    itemCount: box.values.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Today",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                                SizedBox(
                                  height: 2,
                                ),
                                Container(
                                  width: 50,
                                  height: 4,
                                  decoration: BoxDecoration(
                                      color: Colors.purple,
                                      borderRadius: BorderRadius.circular(10)),
                                )
                              ],
                            ),
                            MaterialButton(
                              color: Colors.red.shade200,
                              disabledColor: Colors.grey.shade200,
                              elevation: 0,
                              onPressed: box.values.length == 0 ? null : () {},
                              child: Row(
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
                        final Task task = box.values.toList()[index - 1];
                        return TaskItem(task: task);
                      }
                    },
                  );
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
    return InkWell(
      onTap: () {
        setState(() {
          widget.task.isCompleted = !widget.task.isCompleted;
        });
      },
      child: Container(
        height: 84,
        padding: EdgeInsets.only(left: 16, right: 16),
        margin: EdgeInsets.only(
          top: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          // boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black12)],
        ),
        child: Row(
          children: [
            MyCheckBox(
              value: widget.task.isCompleted,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                widget.task.name,
                overflow:TextOverflow.ellipsis ,
                style: TextStyle(
                    decoration: widget.task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
            ),
          ],
        ),
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

class MyCheckBox extends StatelessWidget {
  final double size = 16;
  final bool value;

  const MyCheckBox({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return !value
        ? Icon(
            Icons.circle_outlined,
            size: size,
            color: Colors.grey,
          )
        : Icon(
            Icons.check_circle,
            size: size,
            color: Colors.deepPurple,
          );
  }
}
