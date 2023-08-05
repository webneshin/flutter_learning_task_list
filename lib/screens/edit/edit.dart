import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/helper.dart';
import 'package:task_list/main.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.task.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Task"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Task task = ;
          widget.task.name = _controller.text;
          widget.task.priority = widget.task.priority;
          if (widget.task.isInBox) {
            widget.task.name = _controller.text;
            widget.task.save();
          } else {
            final Box<Task> box = Hive.box(BoxNames.task);
            box.add(widget.task);
          }
          Navigator.of(context).pop();
        },
        label: const Text("Save Change"),
        icon: const Icon(Icons.check_circle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                  flex: 1,
                  child: PriorityCheckbox(
                      onTap: () {
                        setState(() {
                          widget.task.priority = Priority.low;
                          debugPrint(widget.task.toString());
                        });
                      },
                      label: Priority.low.name,
                      color: Colors.blue,
                      isSelected: widget.task.priority == Priority.low),
                ),
                const SizedBox(width: 8),
                Flexible(
                  flex: 1,
                  child: PriorityCheckbox(
                      onTap: () {
                        setState(() {
                          widget.task.priority = Priority.normal;
                        });
                      },
                      label: Priority.normal.name,
                      color: Colors.green,
                      isSelected: widget.task.priority == Priority.normal),
                ),
                const SizedBox(width: 8),
                Flexible(
                  flex: 1,
                  child: PriorityCheckbox(
                      onTap: () {
                        setState(() {
                          widget.task.priority = Priority.high;
                        });
                      },
                      label: Priority.high.name,
                      color: Colors.red,
                      isSelected: widget.task.priority == Priority.high),
                ),
              ],
            ),
            TextField(
              controller: _controller,
              decoration:
                  const InputDecoration(label: Text("Add a task for today ...")),
            )
          ],
        ),
      ),
    );
  }
}

class PriorityCheckbox extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;

  const PriorityCheckbox(
      {super.key,
      required this.label,
      required this.color,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(width: 2, color: Colors.black12),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(label.capitalize()),
            ),
            Positioned(
                right: 4,
                child: Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  size: 18,
                  color: color,
                ))
          ],
        ),
      ),
    );
  }
}
