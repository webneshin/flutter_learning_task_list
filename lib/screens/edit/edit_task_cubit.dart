import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/repo/repository.dart';

part 'edit_task_state.dart';

class EditTaskCubit extends Cubit<EditTaskState> {
  final Task _task;
  final Repository<Task> repository;
  EditTaskCubit(this._task, this.repository) : super(EditTaskInitial(_task));

  void onSaveChangeClick(){
    repository.createOrUpdate(_task);
  }

  void onTextChanged(String text){
    _task.name = text;
  }

  void onPriorityChanged(Priority priority){
    _task.priority = priority;
    emit(EditTaskStatePriorityChange(_task));
  }
}
