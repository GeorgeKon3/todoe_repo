import 'package:flutter/material.dart';
import 'package:todoe/c_notes/providers/sqflite_notes_provider.dart';
import 'package:todoe/c_notes/screens/add_note_screen.dart';
import 'package:todoe/constants.dart';

import 'notes_listview_builder.dart';

class CustomNotes extends StatefulWidget {
  ///enum CustomNotesView { Notes, Archived, Trash, Stared }
  final TypeOfNote typeOfNoteView;
  CustomNotes({this.typeOfNoteView});
  @override
  _CustomNotesState createState() => _CustomNotesState();
}

class _CustomNotesState extends State<CustomNotes> {
  bool staredNotesListViewBool = true;
  bool normalNotesListViewBool = true;

  @override
  void initState() {
    super.initState();
    staredNotesListView();
  }

  @override
  Widget build(BuildContext context) {
    const double kUpperPaddingCategory = 15;
    const double kLowerPaddingCategory = 5;

    return Expanded(
      child: ListView(
        padding: EdgeInsets.only(left: 16, right: 16, top: 0),
        children: [
          (staredNotesListViewBool && widget.typeOfNoteView == TypeOfNote.Note)
              ? Padding(
                  padding: const EdgeInsets.only(left: 0, top: kUpperPaddingCategory, bottom: kLowerPaddingCategory),
                  child: Text(kStared),
                )
              : Container(),
          (staredNotesListViewBool && widget.typeOfNoteView == TypeOfNote.Note)
              ? NotesListViewBuilder(
                  typeOfNote: getCategoryThroughEnum(TypeOfNote.Stared),
                  staredNotesListView: () {
                    staredNotesListView();
                  },
                  removeSetState: () {
                    setState(() {
                      // Show a snackbar. This snackbar could also contain "Undo" actions.
                    });
                  },
                  onTapSetState: () {
                    setState(() {
                      CustomNotes();
                    });
                  },
                )
              : Container(),

          /// TypeOfNoteView Text
          Padding(
            padding: const EdgeInsets.only(left: 0, top: kUpperPaddingCategory, bottom: kLowerPaddingCategory),
            child: Text(getCategoryThroughEnum(widget.typeOfNoteView)),
          ),

          /// TypeOfNoteView ListViewBuilder
          NotesListViewBuilder(
            typeOfNote: getCategoryThroughEnum(widget.typeOfNoteView),
            staredNotesListView: () {
              staredNotesListView();
            },
            onTapSetState: () {
              setState(() {
                CustomNotes();
              });
            },
            removeSetState: () {
              setState(() {
                CustomNotes();
              });
            },
          )
        ],
      ),
    );
  }

  void staredNotesListView() async {
    var staredNotesList = await SQFLiteNotesProvider.getNotesWithSpecificState(kStared);
    var normalNotesList = await SQFLiteNotesProvider.getNotesWithSpecificState(kNote);

    if (staredNotesList.length == 0) {
      setState(() {
        staredNotesListViewBool = false;
      });
    } else {
      setState(() {
        staredNotesListViewBool = true;
      });
    }

    if (normalNotesList.length == 0) {
      setState(() {
        normalNotesListViewBool = false;
      });
    } else {
      setState(() {
        normalNotesListViewBool = true;
      });
    }
  }
}
