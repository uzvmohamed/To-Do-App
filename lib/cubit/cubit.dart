import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoo/cubit/states.dart';
import '../modules/archived_tasks/arc.dart';
import '../modules/done_tasks/done.dart';
import '../modules/new_tasks/new.dart';

class TodoCubit extends Cubit<States> {
  TodoCubit() : super(InintState());
  static TodoCubit get(BuildContext context) => BlocProvider.of(context);

  late Database database;
  int currentindex = 0;
  bool bottomsheet = false;
  IconData fabicon = Icons.edit;
  late List<Map> newTasks = [];
  late List<Map> doneTasks = [];
  late List<Map> archivedTasks = [];

  List<Widget> screens = [
    newtsk(),
    donetsk(),
    arctsk(),
  ];
  List<String> titles = [
    "New tasks",
    "Done tasks",
    "Archived tasks",
  ];

  void changeIndex(index) {
    currentindex = index;
    emit(ChangeBNBState());
  }

  void changeBS({required IconData icon, required bool BS}) {
    bottomsheet = BS;
    fabicon = icon;
    emit(ChangeBSState());
  }

  void createdatabase() {
    openDatabase(
      "todo.db",
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
                "CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)")
            .then((value) => print("db created"))
            .catchError((onError) {
          print("Erorr while creating database table ${onError.toString()}");
        });
      },
      onOpen: (database) {
        getdatafromdatabase(database);
        print("db opened");
      },
    ).then((value) {
      database = value;
      emit(CreateDBState());
    });
  }

  Future insertodatabase({
    required String task,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) => txn
            .rawInsert(
                "INSERT INTO tasks(title, date, time, status) VALUES('$task','$date','$time','new')")
            .then((value) {
          print("$value has been inserted successfully");
          emit(InsertDBState());

          getdatafromdatabase(database);
        }).catchError((onError) {
          print("Error while inserting data ${onError.toString()}");
        }));
  }

  void updateData({required String status, required int id}) {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      getdatafromdatabase(database);
      emit(UpdateDBState());
    });
  }

  void getdatafromdatabase(Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(GetDBLoadingState());
    database.rawQuery("SELECT * FROM tasks").then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(GetDBState());
    });
  }

  void deleteData({required int id}) {
    database.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      [id],
    ).then((value) {
      getdatafromdatabase(database);
      emit(DeleteDBState());
    });
  }
}
