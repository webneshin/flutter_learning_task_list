import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/repo/repository.dart';
import 'package:task_list/screens/edit/edit.dart';
import 'package:task_list/screens/edit/edit_task_cubit.dart';
import 'package:task_list/screens/home/task_list_bloc.dart';
import 'package:task_list/widgets.dart';

import '../../main.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("To Do List"),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BlocProvider<EditTaskCubit>(
                create: (context) =>
                    EditTaskCubit(Task(), context.read<Repository<Task>>()),
                child: const EditTaskScreen(),
              ),
            ));
          },
          label: const Text("Add New Task"),
          icon: const Icon(Icons.add_circle)),
      body: BlocProvider<TaskListBloc>(
        create: (context) => TaskListBloc(context.read<Repository<Task>>()),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 110,
                decoration: const BoxDecoration(
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
                      child: Builder(builder: (context) {
                        return TextField(
                          onChanged: (value) {
                            context
                                .read<TaskListBloc>()
                                .add(TaskListEventSearch(value));
                          },
                          controller: _searchController,
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: InputBorder.none,
                            prefixIconColor: Colors.black12,
                            prefixIcon: Icon(Icons.search),
                            labelStyle: TextStyle(color: Colors.black12),
                            label: Text("Search task ..."),
                          ),
                        );
                      }),
                    ),
                  ]),
                ),
              ),
              Expanded(
                child: Consumer<Repository<Task>>(
                  builder: (context, value, child) {
                    context.read<TaskListBloc>().add(TaskListEventStarted());
                    return BlocBuilder<TaskListBloc, TaskListState>(
                      builder: (BuildContext context, state) {
                        if (state is TaskListStateSuccess) {
                          return TaskList(
                            items: state.items,
                          );
                        } else if (state is TaskListStateEmpty) {
                          return EmptyState(search: _searchController.text);
                        } else if (state is TaskListStateLoading ||
                            state is TaskListStateInitial) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is TaskListStateError) {
                          return Center(
                            child: Text(state.errorMessage),
                          );
                        } else {
                          throw Exception('state is not valid ...');
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.items,
  });

  final List<Task> items;

  @override
  Widget build(BuildContext context) {
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
                  Text("Today", style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(
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
                onPressed: () {
                  context.read<TaskListBloc>().add(TaskListEventDeleteAll());
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
            return BlocProvider<EditTaskCubit>(
              create: (context) =>  EditTaskCubit(widget.task, context.read<Repository<Task>>()),
              child: const EditTaskScreen(),
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
