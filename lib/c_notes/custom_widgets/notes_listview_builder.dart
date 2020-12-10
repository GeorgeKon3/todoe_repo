import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoe/c_notes/models/note.dart';
import 'package:todoe/c_notes/providers/sqflite_notes_provider.dart';
import 'package:todoe/c_notes/screens/add_note_screen.dart';
import 'package:todoe/constants.dart';

import 'note_tile.dart';

class NotesListViewBuilder extends StatelessWidget {
  final String typeOfNote;
  final Function staredNotesListView, removeSetState, onTapSetState;
  NotesListViewBuilder({this.typeOfNote, this.staredNotesListView, this.removeSetState, this.onTapSetState});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SQFLiteNotesProvider.getNotesWithSpecificState(typeOfNote),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List notes = snapshot.data;
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  /// Here's where we initialize [Provider.of<Note>]
                  /// This Provider is initialized only on 2 parts of the app.
                  /// The first one is here, for TypeOfNote != NewNote
                  /// The second part is when the user presses the [+ Note] button
                  Provider.of<Note>(context, listen: false).initialSetNote(notes[index]['id'], notes[index]['title'], notes[index]['text'],
                      typeOfNote, notes[index]['color'], notes[index]['labelid'], notes[index]['label'], getTypeOfNoteEnum(typeOfNote));

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddNoteScreen(
                        noteMode: NoteMode.Editing,
                        note: notes[index],
                        typeOfNote: getTypeOfNoteEnum(typeOfNote),
                        staredNoteAddedCallBack: () {
                          staredNotesListView();
                        },
                        onDeleteButtonPress: () async {
                          if (typeOfNote == kDeleted) {
                            await SQFLiteNotesProvider.deleteNote(notes[index]['id']);
                          } else {
                            providerUpdateNote(notes[index]['id'], notes[index]['title'], notes[index]['text'], notes[index]['color'],
                                notes[index]['labelid'], notes[index]['label'], TypeOfNote.Deleted);
                          }

                          notes.remove(index);
                          staredNotesListView();
                        },
                        onRestoreButtonPress: () {
                          providerUpdateNote(notes[index]['id'], notes[index]['title'], notes[index]['text'], notes[index]['color'],
                              notes[index]['labelid'], notes[index]['label'], TypeOfNote.Note);
                          removeSetState();
                        },
                      ),
                    ),
                  ).then((value) {
                    onTapSetState();
                  });
                },
                child: NoteTile(
                  noteID: notes[index]['id'],
                  noteTitle: notes[index]['title'],
                  noteContext: notes[index]['text'],
                  noteColorNumber: notes[index]['color'],
                  noteLabel: notes[index]['label'],
                  //Todo: do smthing on longPress
                  longPressCallback: () {},
                  onDismissedCallback: (direction) async {
                    if (typeOfNote == kDeleted) {
                      await SQFLiteNotesProvider.deleteNote(notes[index]['id']);
                      staredNotesListView();
                    } else {
                      providerUpdateNote(notes[index]['id'], notes[index]['title'], notes[index]['text'], notes[index]['color'],
                          notes[index]['labelid'], notes[index]['label'], TypeOfNote.Deleted);
                      staredNotesListView();
                    }
                  },
                ),
              );
            },
            itemCount: notes.length,
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  TypeOfNote getTypeOfNoteEnum(String typeOfNote) {
    if (typeOfNote == kNote) {
      return TypeOfNote.Note;
    } else if (typeOfNote == kStared) {
      return TypeOfNote.Stared;
    } else if (typeOfNote == kArchived) {
      return TypeOfNote.Archived;
    } else if (typeOfNote == kDeleted) {
      return TypeOfNote.Deleted;
    } else {
      return TypeOfNote.NewNote;
    }
  }
}
