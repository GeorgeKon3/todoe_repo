import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoe/b_schedule/models/task_focus.dart';
import 'package:todoe/b_schedule/screens/add_task_screen.dart';
import 'package:todoe/constants.dart';
import 'package:todoe/utils/database.dart';

class TaskTile extends StatelessWidget {
  final task;
  final int listViewIndex;
  TaskTile({this.task, this.listViewIndex});

  @override
  Widget build(BuildContext context) {
    bool check;
    if (task != null) check = task['check'];
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        /// Left Column
        Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 0, left: 5, right: 5),
          width: 42,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Icon(
                  (Provider.of<TaskFocus>(context, listen: false).taskFocus == listViewIndex) ? Icons.fiber_manual_record : Icons.adjust,
                  color: kMainCustomizingColor,
                  size: 20,
                ),
              ),
              (Provider.of<DocumentSnapshot>(context).data()['standard_schedule'].length != listViewIndex + 1) ? SizedBox(height: 5) : Container(),
              (Provider.of<DocumentSnapshot>(context).data()['standard_schedule'].length != listViewIndex + 1)
                  ? Container(
                      color: kMainCustomizingColor,
                      width: 3,
                      height: MediaQuery.of(context).size.width * (0.20).toDouble(),
                    )
                  : Container(
                      width: 0,
                      height: MediaQuery.of(context).size.width * (0.20).toDouble(),
                    ),
            ],
          ),
        ),

        /// Main part of the Task
        Expanded(
          child: Dismissible(
            onDismissed: (direction) {
              List tempList = Provider.of<DocumentSnapshot>(context, listen: false).data()['standard_schedule'];
              tempList.removeAt(listViewIndex);
              DatabaseService().deleteTask(tempList);
            },
            key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
            direction: (Provider.of<TaskFocus>(context, listen: false).taskFocus != listViewIndex) ? DismissDirection.startToEnd : null,
            background: Container(
              margin: EdgeInsets.only(top: 8, right: 15, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.red[800],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 30,
                  ),
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            child: InkWell(
              onTap: () {
                //If it already has focus, then take the focus off.
                // Else, if it doesn't have focus, then set the focus to listViewIndex.
                if (Provider.of<TaskFocus>(context, listen: false).taskFocus == listViewIndex) {
                  Provider.of<TaskFocus>(context, listen: false).onTap(null);
                } else {
                  Provider.of<TaskFocus>(context, listen: false).onTap(listViewIndex);
                }
              },
              child: Container(
                margin: EdgeInsets.only(right: 15),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: (Provider.of<TaskFocus>(context, listen: false).taskFocus == listViewIndex) ? kMainCustomizingColor : Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// Title & Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            task['title'],
                            overflow: TextOverflow.ellipsis,
                            // The style below is the same as kCardTitleStyle
                            // we don't use that TextStyle, because we want
                            // the property
                            style: TextStyle(
                              decoration: (task['check'] == true) ? TextDecoration.lineThrough : null,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          '${convertServerTimeData(task['hour'])['hr']}:${convertServerTimeData(task['hour'])['min']} ${convertServerTimeData(task['hour'])['amPm']}',
                          style: TextStyle(
                            decoration: (task['check'] == true) ? TextDecoration.lineThrough : null,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),

                    /// Text & Check Box
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Text
                        Flexible(
                          child: Text(
                            task['text'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              decoration: (task['check'] == true) ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),

                        Row(
                          children: [
                            /// Edit Box
                            // If it has focus, then show the edit icon.
                            if (Provider.of<TaskFocus>(context).taskFocus == listViewIndex)
                              InkWell(
                                onTap: () {
                                  /// ======================   *   ======================
                                  /// Important Issue that was solved with a work around.
                                  // I don't know why, but the value [Provider.of<DocumentSnapshot>(context)]
                                  // couldn't be accessed from the [add_task_screen.dart] file.
                                  // We use the [temp] variable below, to property drill it down to
                                  // the [Trash Icon] that was created via [TopBarIcon].
                                  /// ======================   *   ======================
                                  // Since [AddTaskScreen] becomes a child Widget of [TaskTile], which
                                  // is a child of [ScheduleScreen], [Provider.of<DocumentSnapshot>(context)]
                                  // was supposed to be able to get accessed from [AddTaskScreen], but
                                  // unfortunately we cannot access it there.
                                  /// ======================   *   ======================
                                  var temp = Provider.of<DocumentSnapshot>(context, listen: false);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddTaskScreen(
                                                task: task,
                                                listViewIndex: listViewIndex,
                                                tasksSnapshot: temp,
                                              )));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                            SizedBox(width: 3),

                            /// Check Box
                            InkWell(
                              onTap: () {
                                check ? check = false : check = true;
                                DatabaseService().updateUserData(listViewIndex, task['title'], task['text'], task['hour'], check);
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: (Provider.of<TaskFocus>(context).taskFocus == listViewIndex) ? Colors.black : Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: (Provider.of<TaskFocus>(context).taskFocus == listViewIndex) ? Colors.white : Colors.black54,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
