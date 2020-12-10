import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:todoe/c_notes/models/note.dart';
import 'package:todoe/c_notes/providers/sqflite_%20labels_provider.dart';
import 'package:todoe/constants.dart';

import 'label_listview_builder.dart';
import 'top_bar_icon.dart';

class LabelTile extends StatefulWidget {
  final int labelID;
  final labelTitle;
  final LabelListDisplay labelListDisplay;
  final String selectedLabel;
  final int noteID;
  final Function onDeleteButtonPress;
  final Function onCheckBoxChecked;
  LabelTile({
    this.labelID,
    @required this.labelTitle,
    @required this.labelListDisplay,
    @required this.selectedLabel,
    this.noteID,
    this.onDeleteButtonPress,
    this.onCheckBoxChecked,
  });

  @override
  _LabelTileState createState() => _LabelTileState();
}

bool checkBoxIsChecked = false;

class _LabelTileState extends State<LabelTile> {
  bool editMode = false;

  TextEditingController _controller = TextEditingController();
  FocusNode _nodeFocusListener = FocusNode();

  var noteProvider;

  @override
  void initState() {
    //----
    _controller.text = widget.labelTitle.toString();
    _nodeFocusListener.addListener(_handleFocusChange);
    super.initState();
  }

  void _handleFocusChange() {
    if (_nodeFocusListener.hasFocus == true) {
      setState(() {
        editMode = true;
      });
    } else {
      setState(() {
        editMode = false;
      });
    }
  }

  get isTheSelectedLabel {
    return (widget.selectedLabel == widget.labelTitle) ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.labelListDisplay == LabelListDisplay.select) noteProvider = Provider.of<Note>(context);
    return Container(
      padding: EdgeInsets.only(top: (widget.labelListDisplay == LabelListDisplay.view) ? 10 : 6),
      child: Container(
        color: isTheSelectedLabel ? kMainCustomizingColor : Colors.transparent,
        child: Row(
          children: [
            /// If View, then create some more space
            (widget.labelListDisplay == LabelListDisplay.view) ? SizedBox(width: kDrawerPadding) : Container(),

            /// Label Outline and Delete (editMode only)
            editMode
                ? TopBarIcon(
                    icon: Icons.delete_outline,
                    size: (widget.labelListDisplay == LabelListDisplay.view) ? 35 : 30,
                    onPressedFunction: widget.onDeleteButtonPress,
                  )
                : TopBarIcon(
                    icon: Icons.label_outline,
                    size: !(widget.labelListDisplay == LabelListDisplay.view) ? 30 : null,
                  ),

            /// If Edit, then create some more space
            (widget.labelListDisplay == LabelListDisplay.edit) ? SizedBox(width: 10) : SizedBox(width: kPaddingBetweenDrawerIconAndText),

            /// Text (view) and TextField (edit)
            (widget.labelListDisplay == LabelListDisplay.view)
                ? Text(
                    widget.labelTitle.toString(),
                    style: TextStyle(fontSize: (widget.labelListDisplay == LabelListDisplay.view) ? 15 : 12),
                  )
                : Expanded(
                    child: TextField(
                      //Changes are saved in the app as the user writes
                      onChanged: (newNoteTitle) {
                        SQFLiteLabelsProvider.updateNoteLabel({'id': widget.labelID, 'title': newNoteTitle});
                      },
                      focusNode: _nodeFocusListener,
                      controller: _controller,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.grey[800], fontSize: 18),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                        //hintText: widget.labelTitle.toString(),
                        hintStyle: TextStyle(color: Colors.black, fontFamily: 'KumbhSans'),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      //controller: _textEditingController,
                    ),
                  ),

            /// Edit or Save Icon (only for Edit)
            (widget.labelListDisplay == LabelListDisplay.edit)
                ? editMode
                    // Check Icon
                    ? TopBarIcon(
                        icon: Icons.check,
                        size: (widget.labelListDisplay == LabelListDisplay.view) ? 35 : 30,
                        onPressedFunction: () {
                          final noteLabel = _controller.text.toString();
                          if (!(noteLabel == '' || noteLabel == ' ')) {
                            SQFLiteLabelsProvider.updateNoteLabel({'id': widget.labelID, 'title': noteLabel});
                            _nodeFocusListener.unfocus();
                          }
                        },
                      )
                    // Edit Icon
                    : TopBarIcon(
                        icon: Icons.edit,
                        size: (widget.labelListDisplay == LabelListDisplay.edit) ? 35 : 30,
                        onPressedFunction: () {
                          final noteLabel = _controller.text.toString();
                          if (!(noteLabel == '' || noteLabel == ' ')) {
                            SQFLiteLabelsProvider.updateNoteLabel({'id': widget.labelID, 'title': noteLabel});

                            _nodeFocusListener.requestFocus();
                          }
                        },
                      )
                : Container(),

            /// CheckBox (only for Select)
            (widget.labelListDisplay == LabelListDisplay.select)
                ? Checkbox(
                    activeColor: kMainCustomizingColor,
                    value: isTheSelectedLabel,
                    onChanged: (boolValue) {
                      print('label_tile CHECKBOX labelListDisplay: ${widget.labelListDisplay}');
                      print('label_tile CHECKBOX LABELID: ${widget.labelID}');

                      /// widget.noteID is used only for NoteProvider.setNoteLabel
                      noteProvider.setNoteLabel(widget.noteID, widget.labelID, widget.labelTitle);
                      Provider.of<Note>(context, listen: false).setLabelID(widget.labelID);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
