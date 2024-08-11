import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoo/cubit/cubit.dart';
import 'package:todoo/cubit/states.dart';
import 'package:todoo/shared/components.dart';

class donetsk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, States>(
      listener: (context, state) {},
      builder: (context, state) {
        List<Map> tasks = TodoCubit.get(context).doneTasks;
        return taskList(tasks, "Done Tasks", Icons.done_outline_rounded);
      },
    );
  }
}
