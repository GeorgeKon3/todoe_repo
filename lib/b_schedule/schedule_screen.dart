import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoe/b_schedule/screens/add_task_screen.dart';
import 'package:todoe/c_notes/custom_widgets/top_bar_icon.dart';
import '../constants.dart';
import 'custom_widgets/horizontal_calendar.dart';
import 'custom_widgets/task_list.dart';
import 'drawers/schedule_drawer.dart';
import 'models/task_focus.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return StreamProvider<DocumentSnapshot>.value(
        value: FirebaseFirestore.instance.collection('schedule').doc(FirebaseAuth.instance.currentUser.uid).snapshots(),
        child: ChangeNotifierProvider<TaskFocus>(
          create: (_) => TaskFocus(),
          child: Scaffold(
            key: _scaffoldKey,
            drawer: ScheduleDrawer(),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 3),

                  /// Header Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Hamburger Menu
                      Expanded(
                        flex: 7,
                        child: Align(
                          alignment: FractionalOffset.centerLeft,
                          child: TopBarIcon(
                            icon: Icons.menu,
                            width: 70,
                            onPressedFunction: () {
                              _scaffoldKey.currentState.openDrawer();
                            },
                          ),
                        ),
                      ),

                      /// Date + Today
                      Expanded(
                        flex: 11,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${now.day} ${monthsInYear[now.month]} ${now.year}',
                              style: kCardTextStyle,
                            ),
                            Row(
                              children: [
                                Text('Todoe', style: kMainPageHeaderStyle),
                                Text('Schedule',
                                    style: TextStyle(
                                      fontFamily: 'KumbhSans',
                                      fontWeight: FontWeight.w100,
                                      fontSize: kMainPageHeaderSize,
                                      color: Colors.black,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),

                      /// + Task
                      Expanded(
                        flex: 7,
                        child: Align(
                          alignment: FractionalOffset.centerRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddTaskScreen(),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: kMainCustomizingColor,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Text(
                                '+ Task',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),

                  /// Calendar
                  HorizontalCalendar(date: now.subtract(Duration(days: 2))),
                  SizedBox(height: 10),

                  /// TaskList
                  TaskList(),
                ],
              ),
            ),
          ),
        ));
  }
}
