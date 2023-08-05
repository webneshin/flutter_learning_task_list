part of 'task_list_bloc.dart';

@immutable
abstract class TaskListState {}

class TaskListStateInitial extends TaskListState {}

class TaskListStateLoading extends TaskListState {}

class TaskListStateSuccess extends TaskListState {
  final List<Task> items;

  TaskListStateSuccess(this.items);
}

class TaskListStateEmpty extends TaskListState {}

class TaskListStateError extends TaskListState {
  final String errorMessage;

  TaskListStateError(this.errorMessage);
}
