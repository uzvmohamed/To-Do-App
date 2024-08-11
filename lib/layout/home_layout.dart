import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todoo/cubit/cubit.dart';
import 'package:todoo/cubit/states.dart';

class Home extends StatelessWidget {
  var Scaffoldkey = GlobalKey<ScaffoldState>();
  var taskTitleController = TextEditingController();
  var taskTimeController = TextEditingController();
  var taskDateController = TextEditingController();
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit()..createdatabase(),
      child: BlocConsumer<TodoCubit, States>(
        listener: (context, state) {
          if (state is InsertDBState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          TodoCubit cubit = TodoCubit.get(context);
          return Scaffold(
            key: Scaffoldkey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentindex],
                textScaleFactor: 1.4,
              ),
            ),
            body: ConditionalBuilder(
              condition: state != GetDBLoadingState,
              builder: (context) => cubit.screens[cubit.currentindex],
              fallback: (context) => Center(
                  child: CircularProgressIndicator(
                color: Colors.black,
              )),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.bottomsheet) {
                  if (formkey.currentState!.validate()) {
                    cubit.insertodatabase(
                      task: taskTitleController.text,
                      time: taskTimeController.text,
                      date: taskDateController.text,
                    );
                  }
                } else {
                  cubit.changeBS(icon: Icons.add, BS: true);
                  Scaffoldkey.currentState!
                      .showBottomSheet(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(40))),
                          (context) => Container(
                                color: Colors.grey[100],
                                padding: EdgeInsets.all(20),
                                width: double.infinity,
                                child: Form(
                                  key: formkey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Task title field must not be empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                        controller: taskTitleController,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.title,
                                          ),
                                          labelText: "Task Title",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        readOnly: true,
                                        onTap: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((value) => taskTimeController
                                              .text = value!.format(context));
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Task time field must not be empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                        controller: taskTimeController,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.watch_later),
                                          labelText: "Task Time",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        readOnly: true,
                                        onTap: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime.now().add(
                                                      Duration(days: 3650)))
                                              .then((value) =>
                                                  taskDateController.text =
                                                      DateFormat.yMMMd()
                                                          .format(value!));
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Task Date field must not be empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                        controller: taskDateController,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                        decoration: InputDecoration(
                                          prefixIcon:
                                              Icon(Icons.calendar_month),
                                          labelText: "Task Date",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                      .closed
                      .then((value) {
                    cubit.changeBS(icon: Icons.edit, BS: false);
                  });
                }
              },
              child: Icon(cubit.fabicon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: "Tasks",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: "Done",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: "Archive",
                ),
              ],
              currentIndex: cubit.currentindex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
            ),
          );
        },
      ),
    );
  }
}
