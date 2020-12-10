import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoe/b_schedule/custom_widgets/task_tile.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    final DocumentSnapshot tasks = Provider.of<DocumentSnapshot>(context);

    return (tasks != null && tasks.exists)
        ? Expanded(
            child: ListView.builder(
              itemCount: tasks.data()['standard_schedule'].length,
              itemBuilder: (context, index) {
                return TaskTile(
                  task: tasks.data()['standard_schedule'][index],
                  listViewIndex: index,
                );
              },
            ),
          )
        // Todo: Change this Text Widget with a Loading-Animation Widget (of your choice).
        : Text('Loading');
  }
}
