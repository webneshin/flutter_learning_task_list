part of 'edit_task_cubit.dart';

@immutable
abstract class EditTaskState {
  final Task task;

  EditTaskState(this.task);
}

class EditTaskInitial extends EditTaskState {
  EditTaskInitial(super.task);
}

class EditTaskStatePriorityChange extends EditTaskState{
  EditTaskStatePriorityChange(super.task);
}