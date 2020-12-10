import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoe/constants.dart';

import 'custom_widgets/custom_notes.dart';
import 'custom_widgets/top_bar_icon.dart';
import 'drawers/notes_drawer.dart';
import 'models/note.dart';
import 'providers/sqflite_notes_provider.dart';
import 'screens/add_note_label_screen.dart';
import 'screens/add_note_screen.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() {
    return _NotesScreenState();
  }
}

class _NotesScreenState extends State<NotesScreen> {
  List<CustomNotes> customNotes = [];
  //We use this only to open the Drawer (on the tap of the hamburger menu)
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TypeOfNote _typeOfNoteView = TypeOfNote.Note;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Scaffold(
      key: _scaffoldKey,
      drawer: NotesDrawer(
        onTapNotes: () {
          setState(() {
            _typeOfNoteView = TypeOfNote.Note;
          });
          Navigator.pop(context);
        },
        onTapArchived: () {
          setState(() {
            _typeOfNoteView = TypeOfNote.Archived;
          });
          Navigator.pop(context);
        },
        onTapDeleted: () {
          setState(() {
            _typeOfNoteView = TypeOfNote.Deleted;
          });
          Navigator.pop(context);
        },
        onPressCallBack: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNoteLabelScreen(addNewLabel: true),
            ),
          ).then((value) {
            setState(() {});
          });
        },
        onEditLabel: (editOption) {
          //setState here refreshed the Labels.Builder and shows new Labels
          setState(() {});
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Upper Part of the Notes. The whole part below is inside
          // this Container in order to have this colored Border
          // Radius Below the Custom Search Bar.
          Container(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.only(top: 3, left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                  color: topContainerColor, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Hamburger Menu
                    Expanded(
                      flex: 7,
                      child: Align(
                        alignment: FractionalOffset.centerLeft,
                        child: TopBarIcon(
                          icon: Icons.menu,
                          onPressedFunction: () {
                            _scaffoldKey.currentState.openDrawer();
                          },
                        ),
                      ),
                    ),
                    //Icon(Icons.menu),
                    SizedBox(width: 10),

                    /// Notes
                    Expanded(
                      flex: 11,
                      child: Align(
                        alignment: FractionalOffset.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${now.day} ${monthsInYear[now.month]} ${now.year}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w300,
                                color: Colors.black54,
                              ),
                            ),
                            Row(
                              children: [
                                Text('Todoe', style: kMainPageHeaderStyle),
                                Text('Notes',
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
                    ),
                    SizedBox(width: 10),

                    /// + Note
                    Expanded(
                      flex: 7,
                      child: Align(
                        alignment: FractionalOffset.centerRight,
                        child: InkWell(
                          onTap: () {
                            /// Here's where we initialize [Provider.of<Note>]
                            /// This Provider is initialized only on 2 parts of the app.
                            /// The first one is here, for TypeOfNote == NewNote
                            /// The second part is on [notes_listview_builder.dart]
                            Provider.of<Note>(context, listen: false)
                                .initialSetNote(null, '', '', getCategoryThroughEnum(TypeOfNote.NewNote), 0, maxNoteLabelID, '', TypeOfNote.NewNote);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddNoteScreen(
                                  noteMode: NoteMode.Adding,
                                  note: null,
                                  typeOfNote: TypeOfNote.NewNote,

                                  /// When typeOfNote == TypeOfNote.NewNote, the
                                  /// delete button should only pop the context.
                                  onDeleteButtonPress: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: kMainCustomizingColor,
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Text(
                              '+ Note',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          CustomNotes(
            typeOfNoteView: _typeOfNoteView,
          ),
        ],
      ),
    );
  }
}
