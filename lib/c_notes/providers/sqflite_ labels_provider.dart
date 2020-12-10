import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoe/c_notes/providers/sqflite_notes_provider.dart';

class SQFLiteLabelsProvider {
  static Database dbNoteLabel;

  static Future open() async {
    dbNoteLabel = await openDatabase(join(await getDatabasesPath(), 'noteslabel.db'), version: 1, onCreate: (Database dbNoteLabel, int version) async {
      dbNoteLabel.execute('''
          create table NotesLabel(
            id integer primary key autoincrement,
            title title not null
          );
        ''');
    });
  }

  static Future<List<Map<String, dynamic>>> getNoteLabelList() async {
    if (dbNoteLabel == null) {
      await open();
    }
    return await dbNoteLabel.query('NotesLabel');
  }

  static Future insertNoteLabel(Map<String, dynamic> note) async {
    if (dbNoteLabel == null) {
      await open();
    }
    await dbNoteLabel.insert('NotesLabel', note);
  }

  static Future updateNoteLabel(Map<String, dynamic> label) async {
    if (dbNoteLabel == null) {
      await open();
    }
    await dbNoteLabel.update(
      'NotesLabel',
      label,
      where: 'id = ?',
      whereArgs: [label['id']],
    );

    SQFLiteNotesProvider.updateLabelOnNotes(label['id'], label['title']);
  }

  static Future deleteNoteLabel(int id) async {
    if (dbNoteLabel == null) {
      await open();
    }
    await dbNoteLabel.delete('NotesLabel', where: 'id = ?', whereArgs: [id]);
  }
}
