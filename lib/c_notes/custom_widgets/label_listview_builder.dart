import 'package:flutter/material.dart';
import 'package:todoe/c_notes/providers/sqflite_%20labels_provider.dart';

import 'label_tile.dart';

enum LabelListDisplay { edit, view, select }

class LabelListBuilder extends StatefulWidget {
  final LabelListDisplay labelListDisplay;
  final Function setStateCallBack;
  final String selectedLabel;
  final int noteID;
  LabelListBuilder({@required this.labelListDisplay, this.setStateCallBack, this.selectedLabel, this.noteID});

  @override
  _LabelListBuilderState createState() => _LabelListBuilderState();
}

class _LabelListBuilderState extends State<LabelListBuilder> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SQFLiteLabelsProvider.getNoteLabelList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final noteLabels = snapshot.data;
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return LabelTile(
                  labelListDisplay: widget.labelListDisplay,
                  selectedLabel: (widget.labelListDisplay == LabelListDisplay.select) ? widget.selectedLabel : null,
                  //noteID is used only for NoteProvider.setNoteLabel
                  noteID: widget.noteID,
                  labelID: noteLabels[index]['id'],
                  labelTitle: noteLabels[index]['title'],
                  onDeleteButtonPress: () async {
                    await SQFLiteLabelsProvider.deleteNoteLabel(noteLabels[index]['id']);
                    setState(() {
                      noteLabels.remove(index);
                    });
                  });
              // onCheckBoxChecked: () {
              //   LabelListBuilder().rebuild;
              // });
            },
            itemCount: noteLabels.length,
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
