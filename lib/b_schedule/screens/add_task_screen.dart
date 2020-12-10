import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoe/c_notes/custom_widgets/top_bar_icon.dart';
import 'package:todoe/utils/database.dart';
import '../../constants.dart';

class AddTaskScreen extends StatefulWidget {
  final task;
  final listViewIndex;
  final tasksSnapshot;
  AddTaskScreen({this.task, this.listViewIndex, this.tasksSnapshot});
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddTaskScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contextController = TextEditingController();
  Map temp; // Temporary Map of the data that will be added/edited on this screen
  String title = ' ';
  String text = ' ';
  int tempHrs = 1;
  String tempMins = '00';
  String tempAmPm = 'AM';

  @override
  void initState() {
    if (widget.task != null) {
      title = widget.task['title'];
      text = widget.task['text'];

      _titleController = TextEditingController(text: title);
      _contextController = TextEditingController(text: text);

      tempHrs = convertServerTimeData(widget.task['hour'])['hr'];
      tempMins = convertServerTimeData(widget.task['hour'])['min'];
      tempAmPm = convertServerTimeData(widget.task['hour'])['amPm'];
    }

    temp = {'title': title, 'text': text, 'hour': convertTimeForServer(tempHrs, tempMins), 'check': false};
    super.initState();
  }

  CupertinoPicker iOSPicker(List<Text> list) {
    int getInitialItem() {
      var initialItem;
      if (widget.task != null) {
        if (list == hrs) {
          Map temp = convertServerTimeData(widget.task['hour']);
          initialItem = temp['hr'];
        } else {
          Map temp = convertServerTimeData(widget.task['hour']);
          initialItem = int.parse(temp['min']);
        }
      } else {
        initialItem = 0;
      }
      return initialItem;
    }

    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: getInitialItem()),
      itemExtent: 32.0,
      onSelectedItemChanged: (int value) {
        setState(() {
          if (list == hrs) {
            tempHrs = (value);
            (value >= 12) ? tempAmPm = 'PM' : tempAmPm = 'AM';
          } else if (list == mins) {
            // Note: .toString().padLeft(10, '0') - Adds leading zeroes to
            // single digit numbers. We want this functionality for the mins.
            tempMins = value.toString().padLeft(2, '0');
          }
        });
      },
      children: list,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Empty Space
            SizedBox(height: 12),

            ///Top Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TopBarIcon(
                icon: Icons.arrow_back_ios,
                buttonColor: kTopBarIconColor,
                onPressedFunction: () {
                  //   if = (edit mode: true)
                  // else = (add new task: true)
                  if (widget.task != null) {
                    DatabaseService().updateUserData(widget.listViewIndex, _titleController.text, _contextController.text,
                        convertTimeForServer(tempHrs, tempMins), widget.task['check']);
                  } else {
                    temp = {
                      'title': _titleController.text,
                      'text': _contextController.text,
                      'hour': convertTimeForServer(tempHrs, tempMins),
                      'check': false
                    };
                    DatabaseService().addNewTask(temp);
                  }

                  Navigator.pop(context);
                },
              ),
            ),

            ///Empty Space
            SizedBox(height: 10),

            ///Title of the note
            TextField(
              controller: _titleController,
              autofocus: true,
              keyboardType: TextInputType.multiline,
              minLines: 1, //Normal textInputField will be displayed
              maxLines: 2, // when user presses enter it will adapt to it
              style: TextStyle(color: Colors.black, fontFamily: 'KumbhSans', fontSize: 20, fontWeight: FontWeight.bold),

              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 20.0,
                ),
                hintText: 'Task',
                hintStyle: TextStyle(color: Colors.black54, fontFamily: 'KumbhSans', fontSize: 20, fontWeight: FontWeight.bold),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            ),

            ///Text of the note
            TextField(
              controller: _contextController,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              style: TextStyle(color: Colors.black, fontFamily: 'KumbhSans', fontSize: 14, fontWeight: FontWeight.normal),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                hintText: 'Details',
                hintStyle: TextStyle(color: Colors.black54, fontFamily: 'KumbhSans', fontSize: 14, fontWeight: FontWeight.normal),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            ),

            ///Empty Space
            SizedBox(height: 10),

            ///Time
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(
                              child: Container(
                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: Padding(
                              padding: EdgeInsets.all(30),
                              child: Container(
                                height: 100,
                                child: Row(
                                  children: [
                                    Expanded(flex: 1, child: Container()),
                                    Expanded(flex: 3, child: iOSPicker(hrs)),
                                    Center(child: Text(':')),
                                    Expanded(flex: 3, child: iOSPicker(mins)),
                                    Expanded(flex: 1, child: Container()),
                                  ],
                                ),
                              ),
                            ),
                          )));
                },
                child: Text(
                  '$tempHrs:$tempMins $tempAmPm',
                  style: TextStyle(color: Colors.black54, fontFamily: 'KumbhSans', fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ),
            ),

            ///Align the Bottom Bar at the bottom of the screen
            Spacer(),

            ///Bottom Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /// Trash Icon
                  TopBarIcon(
                    icon: Icons.delete_outline,
                    buttonColor: kTopBarIconColor,
                    onPressedFunction: () {
                      //   if = (edit mode: true)
                      // else = (add new task: true)
                      if (widget.task == null) {
                        Navigator.pop(context);
                      } else {
                        List tempList = widget.tasksSnapshot.data()['standard_schedule'];
                        tempList.removeAt(widget.listViewIndex);
                        DatabaseService().deleteTask(tempList);
                        Navigator.pop(context);
                      }
                    },
                  ),

                  // /// Three Dot Menu
                  // TopBarIcon(
                  //   icon: Icons.more_vert,
                  //   buttonColor: kTopBarIconColor,
                  //   onPressedFunction: () {},
                  // ),
                ],
              ),
            ),

            ///Empty Space
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
