import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoe/c_notes/screens/add_note_screen.dart';
import 'package:todoe/constants.dart';

String labelID = 'labelid';

class SQFLiteNotesProvider {
  static Database db;

  static Future open() async {
    db = await openDatabase(join(await getDatabasesPath(), 'notes.db'), version: 1, onCreate: (Database db, int version) async {
      db.execute('''
          create table notes(
            id integer primary key autoincrement,
            title text not null,
            text text not null,
            state text not null,
            color integer not null,
            labelid integer not null,
            label text not null
          );
        ''');
    });
  }

  static Future<List<Map<String, dynamic>>> getNotesWithSpecificState(String state) async {
    if (db == null) {
      await open();
    }

    final sql = '''SELECT * FROM notes
    WHERE state = ?''';

    List<dynamic> params = [state];
    return await db.rawQuery(sql, params);
  }

  static Future<List<Map<String, dynamic>>> getWholeNoteList() async {
    if (db == null) {
      await open();
    }

    return await db.query('notes');
  }

  static Future insertNote(Map<String, dynamic> note) async {
    if (db == null) {
      await open();
    }
    await db.insert('notes', note);
  }

  static Future updateNote(Map<String, dynamic> note) async {
    if (db == null) {
      await open();
    }
    await db.update(
      'notes',
      note,
      where: 'id = ?',
      whereArgs: [note['id']],
    );
  }

  static Future deleteNote(int id) async {
    if (db == null) {
      await open();
    }
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getSpecificNote(int id) async {
    if (db == null) {
      await open();
    }

    final sql = '''SELECT * FROM notes
    WHERE id = ?''';

    List<dynamic> params = [id];
    return await db.rawQuery(sql, params);
  }

  static Future updateLabelOnNotes(int _labelID, String _newLabelTitle) async {
    if (db == null) {
      await open();
    }

    final sql = ('''
    UPDATE notes 
    SET label = ?
    WHERE labelid = ?''');

    List<dynamic> params = [_newLabelTitle, _labelID];
    return await db.rawQuery(sql, params);
  }
}

/// About providerUpdateNote:
/// This is a helper function which makes changes on the SQFLite
/// data base easier to be implemented. Every time a new column
/// is added on the notes.db, we can change the inputs of the
/// providerUpdateNote function right below, and then resolve
/// all the issues that will occur all around our dart files.
///
/// If we used directly the NoteProvider.updateNote, without
/// this helper function, every time we added a new NOT NULL
/// column, no logical errors would have been detected from
/// Flutter. All changes that will be made on the inputs,
/// will cause red flags which will be easily resolvable.
void providerUpdateNote(int _id, String _title, String _text, int _noteBackgroundColor, int labelID, String _label, TypeOfNote _typeOfNote) async {
  await SQFLiteNotesProvider.updateNote({
    'id': _id,
    'title': _title,
    'text': _text,
    'state': getCategoryThroughEnum(_typeOfNote),
    'color': _noteBackgroundColor,
    'labelid': labelID,
    'label': _label,
  });
}

String getCategoryThroughEnum(TypeOfNote customNotesView) {
  if (customNotesView == TypeOfNote.Note) {
    return kNote;
  } else if (customNotesView == TypeOfNote.Stared) {
    return kStared;
  } else if (customNotesView == TypeOfNote.Archived) {
    return kArchived;
  } else if (customNotesView == TypeOfNote.Deleted) {
    return kDeleted;
  } else {
    return kNote;
  }
}
