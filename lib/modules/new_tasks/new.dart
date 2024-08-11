import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoo/cubit/cubit.dart';
import 'package:todoo/cubit/states.dart';
import 'package:todoo/shared/components.dart';

class newtsk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, States>(
      listener: (context, state) {},
      builder: (context, state) {
        List<Map> tasks = TodoCubit.get(context).newTasks;
        return taskList(tasks, "Add Tasks", Icons.menu_rounded);
      },
    );
  }
}
