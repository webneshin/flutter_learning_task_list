part of 'task_list_bloc.dart';

@immutable
abstract class TaskListEvent {}

class TaskListEventStarted extends TaskListEvent{}
class TaskListEventSearch extends TaskListEvent{
  final String searchTerm;

  TaskListEventSearch(this.searchTerm);
}

class TaskListEventDeleteAll extends TaskListEvent{

}