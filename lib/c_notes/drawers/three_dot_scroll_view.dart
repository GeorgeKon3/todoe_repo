import 'package:flutter/material.dart';
import 'package:todoe/c_notes/custom_widgets/circular_color_options.dart';
import 'package:todoe/c_notes/custom_widgets/three_dot_item.dart';
import 'package:todoe/c_notes/screens/add_note_screen.dart';
import 'package:todoe/c_notes/screens/select_note_label.dart';
import '../../constants.dart';

class ThreeDotScrollView extends StatelessWidget {
  final TypeOfNote typeOfNote;
  final noteMode;
  final Function onDeleteButtonPress, onMakeACopyPress;
  final Function onColorSelect;
  ThreeDotScrollView({
    @required this.typeOfNote,
    @required this.onDeleteButtonPress,
    @required this.onMakeACopyPress,
    this.onColorSelect,
    //Todo: ---- delete the attributes below
    @required this.noteMode,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: Column(
                children: [
                  /// Delete Button
                  ThreeDotItem(
                    icon: Icons.delete_outline,
                    text: (typeOfNote == TypeOfNote.Deleted) ? 'Delete Permanently' : 'Delete',
                    colorOfButton: (typeOfNote == TypeOfNote.Deleted) ? Colors.red : null,
                    colorOfText: (typeOfNote == TypeOfNote.Deleted) ? Colors.red : null,
                    onItemPress: onDeleteButtonPress,
                  ),

                  /// Save as a copy
                  !(noteMode == TypeOfNote.NewNote)
                      ? ThreeDotItem(
                          icon: Icons.content_copy,
                          text: 'Save as a copy',
                          onItemPress: onMakeACopyPress,
                        )
                      : Container(),

                  /// Labels
                  ThreeDotItem(
                    icon: Icons.label_outline,
                    text: 'Labels',
                    onItemPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectNoteLabel(
                            typeOfNote: typeOfNote,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            /// Row with the optional colors
            Container(
              height: 50,
              width: double.infinity,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  //Todo: Complete the rest of the colors
                  InkWell(
                    child: CircularColorOptions(
                      color: notesBackgroundColors[0],
                    ),
                    onTap: () {
                      onColorSelect(notesBackgroundColors[0]);
                      Navigator.pop(context);
                    },
                  ),
                  InkWell(
                    child: CircularColorOptions(
                      color: notesBackgroundColors[1],
                    ),
                    onTap: () {
                      onColorSelect(notesBackgroundColors[1]);
                      Navigator.pop(context);
                    },
                  ),
                  InkWell(
                    child: CircularColorOptions(
                      color: notesBackgroundColors[2],
                    ),
                    onTap: () {
                      onColorSelect(notesBackgroundColors[2]);
                      Navigator.pop(context);
                    },
                  ),
                  InkWell(
                    child: CircularColorOptions(
                      color: notesBackgroundColors[3],
                    ),
                    onTap: () {
                      onColorSelect(notesBackgroundColors[3]);
                      Navigator.pop(context);
                    },
                  ),
                  InkWell(
                    child: CircularColorOptions(
                      color: notesBackgroundColors[4],
                    ),
                    onTap: () {
                      onColorSelect(notesBackgroundColors[4]);
                      Navigator.pop(context);
                    },
                  ),
                  InkWell(
                    child: CircularColorOptions(
                      color: notesBackgroundColors[5],
                    ),
                    onTap: () {
                      onColorSelect(notesBackgroundColors[5]);
                      Navigator.pop(context);
                    },
                  ),
                  InkWell(
                    child: CircularColorOptions(
                      color: notesBackgroundColors[6],
                    ),
                    onTap: () {
                      onColorSelect(notesBackgroundColors[6]);
                      Navigator.pop(context);
                    },
                  ),
                  InkWell(
                    child: CircularColorOptions(
                      color: notesBackgroundColors[7],
                    ),
                    onTap: () {
                      onColorSelect(notesBackgroundColors[7]);
                      Navigator.pop(context);
                    },
                  ),
                  InkWell(
                    child: CircularColorOptions(
                      color: notesBackgroundColors[8],
                    ),
                    onTap: () {
                      onColorSelect(notesBackgroundColors[8]);
                      Navigator.pop(context);
                    },
                  ),
                  InkWell(
                    child: CircularColorOptions(
                      color: notesBackgroundColors[9],
                    ),
                    onTap: () {
                      onColorSelect(notesBackgroundColors[9]);
                      Navigator.pop(context);
                    },
                  ),
                  InkWell(
                    child: CircularColorOptions(
                      color: notesBackgroundColors[10],
                    ),
                    onTap: () {
                      onColorSelect(notesBackgroundColors[10]);
                      Navigator.pop(context);
                    },
                  ),
                  InkWell(
                    child: CircularColorOptions(
                      color: notesBackgroundColors[11],
                    ),
                    onTap: () {
                      onColorSelect(notesBackgroundColors[11]);
                      Navigator.pop(context);
                    },
                  ),
                  InkWell(
                    child: CircularColorOptions(
                      color: notesBackgroundColors[12],
                    ),
                    onTap: () {
                      onColorSelect(notesBackgroundColors[12]);
                      Navigator.pop(context);
                    },
                  ),
                  InkWell(
                    child: CircularColorOptions(
                      color: notesBackgroundColors[13],
                    ),
                    onTap: () {
                      onColorSelect(notesBackgroundColors[13]);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
