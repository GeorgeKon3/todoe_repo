import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoe/c_notes/custom_widgets/label_listview_builder.dart';
import 'package:todoe/c_notes/custom_widgets/top_bar_icon.dart';
import 'package:todoe/c_notes/models/note.dart';

import 'add_note_screen.dart';

class SelectNoteLabel extends StatefulWidget {
  final TypeOfNote typeOfNote;
  SelectNoteLabel({this.typeOfNote});

  @override
  _SelectNoteLabelState createState() => _SelectNoteLabelState();
}

class _SelectNoteLabelState extends State<SelectNoteLabel> {
  TextEditingController _textEditingController = TextEditingController();
  String _selectedLabel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _selectedLabel = Provider.of<Note>(context).label;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                TopBarIcon(
                  icon: Icons.arrow_back_ios,
                  buttonColor: Colors.black,
                  onPressedFunction: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.grey[800], fontSize: 18),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                      hintText: 'Search label name',
                      hintStyle: TextStyle(color: Colors.black, fontFamily: 'KumbhSans'),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    controller: _textEditingController,
                  ),
                ),
              ],
            ),
            LabelListBuilder(
              labelListDisplay: LabelListDisplay.select,
              selectedLabel: _selectedLabel,
              noteID: Provider.of<Note>(context).id,
            ),
          ],
        ),
      ),
    );
  }
}
