import 'package:flutter/foundation.dart';
import 'package:todoe/c_notes/providers/sqflite_notes_provider.dart';
import 'package:todoe/c_notes/screens/add_note_screen.dart';

class Note extends ChangeNotifier {
  int id;
  String title;
  String text;
  String state;
  int color;
  int labelID;
  String label;
  TypeOfNote typeOfNote;

  Note({this.title, this.text, this.state, this.color, this.label});

  /// Setters
  void initialSetNote(int _id, String _title, String _text, String _state, int _color, int _labelID, String _label, TypeOfNote _typeOfNote) {
    id = _id;
    title = _title;
    text = _text;
    state = _state;
    color = _color;
    labelID = _labelID;
    label = _label;
    typeOfNote = _typeOfNote;
    //notifyListeners();
  }

  void setNoteLabel(int _noteID, int _labelID, String _label) async {
    label = _label;
    if (_noteID != null)
      await SQFLiteNotesProvider.updateNote(
          {'id': _noteID, 'title': title, 'text': text, 'state': state, 'color': color, 'labelid': _labelID, 'label': _label});
    // await NoteProvider.insertNote({
    //         'title': title,
    //         'text': text,
    //         'state': state,
    //         'color': color,
    //         'labelid': _labelID,
    //         'label': _label
    //       });
    notifyListeners();
  }

  void closingSetNote() {
    id = null;
    title = null;
    text = null;
    state = null;
    color = null;
    labelID = null;
    label = null;
    typeOfNote = null;
    notifyListeners();
  }

  void setTitle(String _title) {
    title = _title;
  }

  void setText(String _text) {
    text = _text;
  }

  void setState(String _state) {
    state = _state;
  }

  void setLabelID(int _labelID) {
    labelID = _labelID;
  }

  void setColor(int _color) {
    color = _color;
  }

  /// Getters
  int get getID {
    return id;
  }

  String get getTitle {
    return title;
  }

  String get getText {
    return text;
  }

  int get getColor {
    return color;
  }

  int get getLabelID {
    return labelID;
  }

  String get getLabel {
    return label;
  }

  // TypeOfNote get getTypeOfNote {
  //   return typeOfNote;
  // }
}
