import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoe/c_notes/custom_widgets/top_bar_icon.dart';

import '../../constants.dart';

class DrawerTaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DocumentSnapshot tasks = Provider.of<DocumentSnapshot>(context);

    return (tasks != null && tasks.exists)
        ? Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: tasks.data()['standard_schedule'].length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 25),
                      TopBarIcon(
                        removePadding: true,
                        icon: Icons.arrow_forward_ios,
                        buttonColor: Colors.black54,
                        //size: 20,
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          tasks.data()['standard_schedule'][index]['title'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${convertServerTimeData(tasks.data()['standard_schedule'][index]['hour'])['hr']}:${convertServerTimeData(tasks.data()['standard_schedule'][index]['hour'])['min']} ${convertServerTimeData(tasks.data()['standard_schedule'][index]['hour'])['amPm']}',
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        // Todo: Change this Text Widget with a Loading-Animation Widget (of your choice).
        : Text('Loading');
  }
}
