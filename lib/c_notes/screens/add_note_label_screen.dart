import 'package:flutter/material.dart';
import 'package:todoe/c_notes/custom_widgets/label_listview_builder.dart';
import 'package:todoe/c_notes/custom_widgets/top_bar_icon.dart';
import 'package:todoe/c_notes/providers/sqflite_%20labels_provider.dart';

class AddNoteLabelScreen extends StatefulWidget {
  //This variable is used for the autoFocus attribute of the TextField.
  final bool addNewLabel;
  AddNoteLabelScreen({@required this.addNewLabel});
  @override
  _AddNoteLabelScreenState createState() => _AddNoteLabelScreenState();
}

class _AddNoteLabelScreenState extends State<AddNoteLabelScreen> {
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            //App Bar - Add & Edit Labels
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  TopBarIcon(
                    icon: Icons.arrow_back_ios,
                    size: 35,
                    onPressedFunction: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Add & Edit Labels',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            //Grey Line Around TextField
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.black26,
            ),
            //TextField - Add new label
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TopBarIcon(
                    icon: Icons.clear,
                    size: 35,
                    onPressedFunction: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      autofocus: widget.addNewLabel,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.grey[800], fontSize: 18),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                        hintText: 'Add new label',
                        hintStyle: TextStyle(color: Colors.black, fontFamily: 'KumbhSans'),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: _textEditingController,
                    ),
                  ),
                  TopBarIcon(
                    icon: Icons.check,
                    size: 35,
                    onPressedFunction: () async {
                      final noteLabel = _textEditingController.text.toString();
                      if (!(noteLabel == '' || noteLabel == ' ')) {
                        await SQFLiteLabelsProvider.insertNoteLabel({'title': noteLabel.toString()}).then((value) => setState(() {
                              _textEditingController.clear();
                            }));
                      }
                    },
                  )
                ],
              ),
            ),
            //Grey Line Around TextField
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.black26,
            ),
            //Future Builder: NoteLabelList
            LabelListBuilder(
              labelListDisplay: LabelListDisplay.edit,
            ),
          ],
        ),
      ),
    );
  }
}
