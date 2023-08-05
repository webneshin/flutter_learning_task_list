import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/source/source.dart';

class HiveTaskDataSource implements DataSource<Task> {
  final Box<Task> box;

  HiveTaskDataSource(this.box);

  @override
  Future<Task> createOrUpdate(Task obj) async {
    if (obj.isInBox) {
      obj.save();
    } else {
      obj.id = await box.add(obj);
    }
    return obj;
  }

  @override
  Future<void> delete(Task obj) {
    // return box.delete(obj.id);
    return obj.delete();
  }

  @override
  Future<void> deleteAll() {
    return box.clear();
  }

  @override
  Future<void> deleteById(id) {
    return box.delete(id);
  }

  @override
  Future<Task> findById(id) async {
    return box.values.firstWhere((element) => element.id = id);
  }

  @override
  Future<List<Task>> getAll({String searchKeyword = ''}) async {
    List<Task> l;
    if (searchKeyword.isNotEmpty) {
      l = box.values
          .where((task) => task.name.contains(searchKeyword))
          .toList();
    } else {
      l = box.values.toList();
    }
    return List<Task>.from(l.reversed);
  }
}
