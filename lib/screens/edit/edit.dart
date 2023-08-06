import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/helper.dart';
import 'package:task_list/screens/edit/edit_task_cubit.dart';

class EditTaskScreen extends StatefulWidget {

  const EditTaskScreen({super.key});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: context
        .read<EditTaskCubit>()
        .state
        .task
        .name);
    super.initState();
  }

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
          context.read<EditTaskCubit>().onSaveChangeClick();

          Navigator.of(context).pop();
        },
        label: const Text("Save Change"),
        icon: const Icon(Icons.check_circle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BlocBuilder<EditTaskCubit, EditTaskState>(
              builder: (context, state) {
                final priority=state.task.priority;
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      flex: 1,
                      child: PriorityCheckbox(
                          onTap: () {
                            context.read<EditTaskCubit>().onPriorityChanged(Priority.low);
                          },
                          label: Priority.low.name,
                          color: Colors.blue,
                          isSelected: priority == Priority.low),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      flex: 1,
                      child: PriorityCheckbox(
                          onTap: () {
                            context.read<EditTaskCubit>().onPriorityChanged(Priority.normal);
                          },
                          label: Priority.normal.name,
                          color: Colors.green,
                          isSelected: priority == Priority.normal),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      flex: 1,
                      child: PriorityCheckbox(
                          onTap: () {
                            context.read<EditTaskCubit>().onPriorityChanged(Priority.high);
                          },
                          label: Priority.high.name,
                          color: Colors.red,
                          isSelected: priority == Priority.high),
                    ),
                  ],
                );
              },
            ),
            TextField(
              controller: _controller,
              onChanged: (value) {
                context.read<EditTaskCubit>().onTextChanged(value);
              },
              decoration: const InputDecoration(
                  label: Text("Add a task for today ...")),
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

  const PriorityCheckbox({super.key,
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
