import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todoo/cubit/cubit.dart';
import 'package:todoo/shared/constants.dart';

Widget taskbuilder(Map model, context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    onDismissed: (direction) {
      TodoCubit.get(context).deleteData(id: model['id']);
    },
    child: Row(
      children: [
        CircleAvatar(
          radius: 40,
          child: Center(
              child: Text(
            "${model['time']}",
          )),
        ),
        SizedBox(
          width: 20,
        ),
        Flexible(
          child: SizedBox(
            width: 115,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${model['title']}",
                  textScaleFactor: 1.6,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "${model['date']}",
                  textScaleFactor: 1.2,
                )
              ],
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        IconButton(
            constraints: BoxConstraints(
                minHeight: 50, maxHeight: 50, minWidth: 50, maxWidth: 50),
            padding: EdgeInsets.zero,
            splashRadius: 30,
            splashColor: Colors.transparent,
            onPressed: () {
              TodoCubit.get(context)
                  .updateData(status: "done", id: model['id']);
            },
            icon: Icon(
              Icons.check_circle_outline_rounded,
              size: 50,
            )),
        SizedBox(
          width: 11,
        ),
        IconButton(
            constraints: BoxConstraints(
                minHeight: 50, maxHeight: 50, minWidth: 50, maxWidth: 50),
            padding: EdgeInsets.zero,
            splashRadius: 30,
            splashColor: Colors.transparent,
            onPressed: () {
              TodoCubit.get(context)
                  .updateData(status: "archived", id: model['id']);
            },
            icon: Icon(
              Icons.archive_outlined,
              size: 50,
            ))
      ],
    ),
  );
}

Widget taskList(List<Map> tasks, String txt, IconData icon) {
  return ConditionalBuilder(
    condition: tasks.isNotEmpty,
    builder: (context) => Padding(
      padding: const EdgeInsets.all(20),
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView.separated(
          itemBuilder: (context, index) {
            return taskbuilder(tasks[index], context);
          },
          separatorBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Container(
                color: Colors.black,
                height: 1,
              ),
            );
          },
          itemCount: tasks.length,
        ),
      ),
    ),
    fallback: (context) => Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 100,
        ),
        Text(
          txt,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    )),
  );
}
