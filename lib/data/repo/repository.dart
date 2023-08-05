import 'package:flutter/cupertino.dart';
import 'package:task_list/data/source/source.dart';

class Repository<T> with ChangeNotifier implements DataSource<T> {
  final DataSource<T> localDataSource;

  Repository(this.localDataSource);

  @override
  Future<T> createOrUpdate(T obj) async {
    final T resualt = await localDataSource.createOrUpdate(obj);
    notifyListeners();
    return resualt;
  }

  @override
  Future<void> delete(T obj) async {
    await localDataSource.delete(obj);
    notifyListeners();
  }

  @override
  Future<void> deleteAll() async {
    await localDataSource.deleteAll();
    notifyListeners();
  }

  @override
  Future<void> deleteById(id) async {
    await localDataSource.deleteById(id);
    notifyListeners();
  }

  @override
  Future<T> findById(id) {
    return localDataSource.findById(id);
  }

  @override
  Future<List<T>> getAll({String searchKeyword = ''}) {
    return localDataSource.getAll(searchKeyword: searchKeyword);
  }
}
