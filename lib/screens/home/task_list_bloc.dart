import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/repo/repository.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final Repository<Task> repository;
  TaskListBloc(this.repository) : super(TaskListStateInitial()) {
    on<TaskListEvent>((event, emit) async {
      if (event is TaskListEventStarted || event is TaskListEventSearch){
        final String searchTerm;
        emit(TaskListStateLoading());
        if (kDebugMode) {
          await Future.delayed(const Duration(seconds: 1));
        }
        if (event is TaskListEventSearch){
          searchTerm = event.searchTerm;
        } else {
          searchTerm = '';
        }
        try {
          // throw Exception("test Error");
          final items =  await repository.getAll(searchKeyword:searchTerm );
          if (items.isNotEmpty){
            emit(TaskListStateSuccess(items));
          }else{
            emit(TaskListStateEmpty());

          }
        } catch (e) {
          emit(TaskListStateError(e.toString()));
        }
      } else if(event is TaskListEventDeleteAll){
        await repository.deleteAll();
        emit(TaskListStateEmpty());
      }

    });
  }
}
