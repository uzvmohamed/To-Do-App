# Simple To Do App

This is a simple tasks management app made with Flutter

### Using:

- sqflite database
- cubit
- conditional builder null safety
- intl
- flutter launcher icons
  
## Preview 
| New Tasks | Add task dialogue | Time Picker | Date Picker | Archive |
|  ---  |  ---  |  --- | --- | --- |
| <img src="https://github.com/user-attachments/assets/3f8600d0-4079-442a-8880-e855eee90bc2" height=400 width=200> | <img src="https://github.com/user-attachments/assets/baf0c4db-fc45-4c1f-a276-4d8651c57345" height=400 width=200> | <img src="https://github.com/user-attachments/assets/abe6f380-8882-436d-8096-c866f7656fc7" height=400 width=200> | <img src="https://github.com/user-attachments/assets/b07aecda-aee5-4071-bf09-01ab1fdd9992" height=400 width=200> | <img src="https://github.com/user-attachments/assets/07a90988-5369-41a0-8559-e9d8613f93f1" height=400 width=200> |

| New Tasks | Done Tasks | Done Tasks | Archived Tasks |
|  ---  |  ---  |  --- | --- |
| <img src="https://github.com/user-attachments/assets/4bca5a9e-50bd-42b7-9d19-5a0156d901b7" height=400 width=200> | <img src="https://github.com/user-attachments/assets/f17b13e3-1098-408b-851d-4f82078e0a9e" height=400 width=200> | <img src="https://github.com/user-attachments/assets/49d28d83-2055-4c66-821d-9e014af8d0d9" height=400 width=200> | <img src="https://github.com/user-attachments/assets/75b5fb89-672b-4ba9-b869-b033449c306e" height=400 width=200> |

## SQLite Snippets
- #### Create Database & Tables Function
```dart
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
```

- #### Insert Into Database Function
```dart
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
```

- #### Get Data From Database Function
```dart
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
```

- #### Update Database Function
```dart
void updateData({required String status, required int id}) {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      getdatafromdatabase(database);
      emit(UpdateDBState());
    });
  }
```

- #### Delete From Database Function
```dart
  void deleteData({required int id}) {
    database.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      [id],
    ).then((value) {
      getdatafromdatabase(database);
      emit(DeleteDBState());
    });
  }
```



