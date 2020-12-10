import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoe/c_notes/custom_widgets/top_bar_icon.dart';
import 'package:todoe/c_notes/drawers/three_dot_scroll_view.dart';
import 'package:todoe/c_notes/models/note.dart';
import 'package:todoe/c_notes/providers/sqflite_notes_provider.dart';

import '../../constants.dart';

IconData starIcon = Icons.star_border;
enum NoteMode { Editing, Adding }
enum TypeOfNote { NewNote, Note, Stared, Archived, Deleted }
enum ThreeDotMenu { Delete, MakeCopy, Labels, Colors }

/// This Screen is used on 2 major parts of the app.
/// The first one is when the '+ Note' button is pressed.
/// The screen has blank two [TextField], one for the title
/// and one for the text of the [Note].
///
/// The second part, is when a [NoteTile] is edited.
/// The user taps on the existing [NoteTile] and gets again
/// on this screen where he or she can edit the cotext of the [Note].
class AddNoteScreen extends StatefulWidget {
  final NoteMode noteMode;
  final Map<String, dynamic> note;
  final TypeOfNote typeOfNote;
  final Function staredNoteAddedCallBack;
  final Function onDeleteButtonPress;
  final Function onRestoreButtonPress;
  AddNoteScreen({
    @required this.noteMode,
    this.note,
    @required this.typeOfNote,
    this.staredNoteAddedCallBack,
    @required this.onDeleteButtonPress,
    this.onRestoreButtonPress,
  });

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contextController = TextEditingController();

  double kTitleSize = 30;
  double kContextSize = 23;

  /// ----

  //If the note comes from the STARED NOTES ListView.builder,
  //it will automatically get changed during didChangeDependencies().
  bool isStared = false;
  var starButtonColor = kTopBarIconColor;
  Color _noteBackgroundColor;

  bool get hasLabel => (Provider.of<Note>(context).label != '') ? true : false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.typeOfNote != TypeOfNote.NewNote) {
      _noteBackgroundColor = notesBackgroundColors[widget.note['color']];
      _titleController.text = widget.note['title'];
      _contextController.text = widget.note['text'];
    } else {
      _noteBackgroundColor = notesBackgroundColors[0];
    }

    if (widget.typeOfNote == TypeOfNote.Stared) {
      setState(() {
        isStared = true;
        starButtonColor = kMainCustomizingColor;
        starIcon = Icons.star;
      });
    } else {
      setState(() {
        isStared = false;
        starButtonColor = Colors.black;
        starIcon = Icons.star_border;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Note>(builder: (context, noteData, child) {
      return Scaffold(
        backgroundColor: _noteBackgroundColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Empty Space
              SizedBox(height: 12),

              ///Top Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        noteData.setTitle(_titleController.text ?? '');
                        noteData.setText(_contextController.text ?? '');

                        ///-----ADDING MODE-----
                        ///----------------------
                        if (widget.noteMode == NoteMode.Adding) {
                          if (!(noteData.getText == '' && noteData.getTitle == '')) {
                            if (isStared) {
                              providerInsertNote(noteData.getTitle, noteData.getText, colorAntiMapping(_noteBackgroundColor), noteData.labelID,
                                  noteData.label, TypeOfNote.Stared);
                              //widget.staredNoteAddedCallBack();
                            } else {
                              providerInsertNote(noteData.getTitle, noteData.getText, colorAntiMapping(_noteBackgroundColor), noteData.labelID,
                                  noteData.label, TypeOfNote.Note);
                            }
                          }

                          ///-----EDITING MODE-----
                          ///----------------------
                          ///Case: Note was Note and remained as a Note
                        } else if (widget?.noteMode == NoteMode.Editing) {
                          // var tempLabelList =
                          //     await NoteProvider.getSpecificNote(
                          //         widget.note['id']);
                          // var tempLabel = tempLabelList[0]['label'];

                          if (isStared && widget.typeOfNote == TypeOfNote.Note) {
                            //Delete this note from Notes db
                            providerUpdateNote(widget.note['id'], noteData.getTitle, noteData.getText, colorAntiMapping(_noteBackgroundColor),
                                noteData.labelID, noteData.label, TypeOfNote.Stared);
                            widget.staredNoteAddedCallBack();

                            ///Case: Note was Stared but it isn't anymore
                          } else if (!(isStared) && widget.typeOfNote == TypeOfNote.Stared) {
                            providerUpdateNote(widget.note['id'], noteData.getTitle, noteData.getText, colorAntiMapping(_noteBackgroundColor),
                                noteData.labelID, noteData.label, TypeOfNote.Note);
                            widget.staredNoteAddedCallBack();

                            ///**Cases**:
                            ///Note Archived or Deleted
                            ///Note was Stared and remained Stared
                            ///Note was Note and it became Stared
                          } else {
                            providerUpdateNote(widget.note['id'], noteData.getTitle, noteData.getText, colorAntiMapping(_noteBackgroundColor),
                                noteData.labelID, noteData.label, widget.typeOfNote);
                          }
                          Provider.of<Note>(context, listen: false).closingSetNote();
                        }

                        starIcon = Icons.star_border;
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          TopBarIcon(
                            icon: Icons.arrow_back_ios,
                            buttonColor: kTopBarIconColor,
                          ),
                          Text('Save Note')
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          /// Star Icon
                          !(widget.typeOfNote == TypeOfNote.Deleted || widget.typeOfNote == TypeOfNote.Archived)
                              ? TopBarIcon(
                                  icon: starIcon,
                                  buttonColor: starButtonColor,
                                  onPressedFunction: () {
                                    setState(() {
                                      if (widget?.noteMode == NoteMode.Adding) {
                                        if (starIcon == Icons.star_border) {
                                          starIcon = Icons.star;
                                          starButtonColor = kMainCustomizingColor;
                                          isStared = true;
                                        } else {
                                          starIcon = Icons.star_border;
                                          starButtonColor = kTopBarIconColor;
                                          isStared = false;
                                        }
                                      } else if (widget?.noteMode == NoteMode.Editing) {
                                        //If Editing Mode & Press the star button:
                                        if (starIcon == Icons.star_border) {
                                          starIcon = Icons.star;
                                          starButtonColor = kMainCustomizingColor;
                                          isStared = true;
                                        } else {
                                          starIcon = Icons.star_border;
                                          starButtonColor = kTopBarIconColor;
                                          isStared = false;
                                        }
                                      }
                                    });
                                  },
                                )
                              : Container(),

                          /// Archive Icon
                          !(widget.typeOfNote == TypeOfNote.Archived || widget.typeOfNote == TypeOfNote.Deleted)
                              ? TopBarIcon(
                                  icon: Icons.archive,
                                  buttonColor: kTopBarIconColor,
                                  onPressedFunction: () async {
                                    final title = _titleController.text;
                                    final text = _contextController.text;

                                    /// ADDING - NewNote to Archive
                                    (widget.typeOfNote == TypeOfNote.NewNote)
                                        ? providerInsertNote(title, text, colorAntiMapping(_noteBackgroundColor), noteData.labelID, noteData.label,
                                            TypeOfNote.Archived)

                                        /// Else update the note and change the state to Archive
                                        : providerUpdateNote(widget.note['id'], title, text, colorAntiMapping(_noteBackgroundColor), noteData.labelID,
                                            noteData.label, TypeOfNote.Archived);

                                    widget.staredNoteAddedCallBack();
                                    Navigator.pop(context);
                                  },
                                )
                              : Container(),
                          (widget.typeOfNote == TypeOfNote.Archived)
                              ? TopBarIcon(
                                  icon: Icons.unarchive,
                                  buttonColor: Colors.black,
                                  onPressedFunction: () async {
                                    final title = _titleController.text;
                                    final text = _contextController.text;

                                    providerUpdateNote(widget.note['id'], title, text, colorAntiMapping(_noteBackgroundColor), noteData.labelID,
                                        noteData.label, widget.typeOfNote);
                                    Navigator.pop(context);
                                  },
                                )
                              : Container(),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              ///Empty Space
              SizedBox(height: 10),

              ///Title of the note
              TextField(
                controller: _titleController,
                keyboardType: TextInputType.multiline,
                minLines: 1, //Normal textInputField will be displayed
                maxLines: 2, // when user presses enter it will adapt to it
                style: TextStyle(color: Colors.black, fontFamily: 'KumbhSans', fontSize: 20, fontWeight: FontWeight.bold),

                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 0.0,
                    horizontal: 20.0,
                  ),
                  hintText: 'Title',
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
                  hintText: 'Note',
                  hintStyle: TextStyle(color: Colors.black54, fontFamily: 'KumbhSans', fontSize: 14, fontWeight: FontWeight.normal),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),

              /// Label of the Note inside a Container
              (noteData.label != null && noteData.label != '')
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(width: 1, color: Color(0x90000000)),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: Text(
                        noteData.label,
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  : Container(),

              ///Align the Bottom Bar at the bottom of the screen
              Spacer(),

              ///Bottom Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /// Trash Icon
                    !(widget.typeOfNote == TypeOfNote.Deleted)
                        ? TopBarIcon(
                            icon: Icons.delete,
                            buttonColor: kTopBarIconColor,
                            onPressedFunction: () async {
                              if (!(widget.typeOfNote == TypeOfNote.NewNote)) {
                                await widget.onDeleteButtonPress();
                              }
                              Navigator.pop(context);
                            },
                          )
                        : Container(),

                    /// Restore Icon
                    (widget.typeOfNote == TypeOfNote.Deleted)
                        ? TopBarIcon(
                            icon: Icons.restore,
                            buttonColor: kTopBarIconColor,
                            onPressedFunction: () async {
                              await widget.onRestoreButtonPress();
                              Navigator.pop(context);
                            },
                          )
                        : Container(),

                    /// Three Dot Menu
                    TopBarIcon(
                      icon: Icons.more_vert,
                      buttonColor: kTopBarIconColor,
                      onPressedFunction: () {
                        noteData.setTitle(_titleController.text ?? '');
                        noteData.setText(_contextController.text ?? '');

                        // if (widget.note == null), the typeOfNote == NewNote
                        // in which scenario, we don't need the providerUpdateNote
                        // method to be called.
                        if (!(widget.note == null))
                          providerUpdateNote(widget.note['id'], noteData.getTitle, noteData.getText, colorAntiMapping(_noteBackgroundColor),
                              noteData.labelID, noteData.label, widget.typeOfNote);

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => ThreeDotScrollView(
                            typeOfNote: widget.typeOfNote,
                            noteMode: widget.noteMode,
                            onDeleteButtonPress: () async {
                              await widget.onDeleteButtonPress();
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            onMakeACopyPress: () async {
                              providerInsertNote(noteData.getTitle, noteData.getText, colorAntiMapping(_noteBackgroundColor), noteData.labelID,
                                  noteData.label, widget.typeOfNote);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            onColorSelect: (color) {
                              setState(() {
                                _noteBackgroundColor = color;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              ///Empty Space
              SizedBox(height: 5),
            ],
          ),
        ),
      );
    });
  }
}
