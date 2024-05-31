import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/data/database.dart';
import 'package:flutter_application_1/util/dialog_box.dart';
import 'package:flutter_application_1/util/todo_tile.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//reference the hive box
  final _myBox = Hive.box('myBox');
  TodoDataBase db = TodoDataBase();
  @override
  void initState() {
    // TODO: implement initState
    if (_myBox.get('TODOLIST') == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  //text controller
  final _controller = TextEditingController();

  void checkBoxCHanged(bool? value, i) {
    setState(() {
      db.todoList[i][1] = !db.todoList[i][1];
    });
    db.updateDatabase();
  }

  void saveNewTask() {
    setState(() {
      db.todoList.add([_controller.text, false]);
    });
    db.updateDatabase();
    Navigator.of(context).pop();
  }

  void deleteTask(int index) {
    setState(() {
      db.todoList.removeAt(index);
    });
    db.updateDatabase();
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (builder) {
          return DialogBox(
            controller: _controller,
            save: saveNewTask,
            cancel: () => Navigator.of(context).pop(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[200],
        appBar: AppBar(
          backgroundColor: Colors.green[100],
          title: Text('TO DO APP'),
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.green[100],
          onPressed: createNewTask,
        ),
        body: ListView.builder(
          itemCount: db.todoList.length,
          itemBuilder: (context, i) {
            return TodoTile(
                taskName: db.todoList[i][0],
                taskCompleted: db.todoList[i][1],
                deleteFunction: (context) => deleteTask(i),
                onChanged: (value) => checkBoxCHanged(value, i));
          },
        ));
  }
}
