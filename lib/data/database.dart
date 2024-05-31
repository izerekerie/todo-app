import 'package:hive/hive.dart';

class TodoDataBase {
  List todoList = [];
  //reference oir box
  final _myBox = Hive.box('myBox');

  void createInitialData() {
    todoList = [
      ['Wake up', false],
      ['Do Bed', false]
    ];
  }
  //load the data from database

  void loadData() {
    todoList = _myBox.get("TODOLIST");
  }
  // update database

  void updateDatabase() {
    _myBox.put("TODOLIST", todoList);
  }
}
