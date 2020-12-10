import 'package:flutter/material.dart';
import 'package:todoe/b_schedule/custom_widgets/drawer_task_list.dart';
import 'package:todoe/b_schedule/screens/add_task_screen.dart';
import 'package:todoe/c_notes/custom_widgets/top_bar_icon.dart';
import 'package:todoe/z_cross_app_widgets/drawer_logo.dart';
import 'package:todoe/z_cross_app_widgets/settings_and_logout.dart';

class ScheduleDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 15),
            //Title / Logo
            drawerLogo('Schedule'),

            /// TaskList
            DrawerTaskList(),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTaskScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 10),
                child: Row(
                  children: [
                    TopBarIcon(icon: Icons.add),
                    SizedBox(width: 5),
                    Text('Daily Task'),
                  ],
                ),
              ),
            ),
            //Add Label
            settingsAndLogout(),
          ],
        ),
      ),
    );
  }
}
