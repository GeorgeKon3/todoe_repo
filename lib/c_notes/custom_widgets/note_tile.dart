import 'package:flutter/material.dart';
import '../../constants.dart';

class NoteTile extends StatelessWidget {
  final bool isStared;
  final String noteTitle;
  final String noteContext;
  final int noteColorNumber;
  final String noteLabel;
  final Function longPressCallback;
  final Function onDismissedCallback;
  final int index;
  final noteID;

  NoteTile(
      {@required this.noteTitle,
      @required this.noteContext,
      @required this.noteColorNumber,
      @required this.noteLabel,
      this.longPressCallback,
      this.isStared,
      this.onDismissedCallback,
      this.index,
      this.noteID});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        padding: EdgeInsets.only(top: 8),
        margin: EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: Colors.red[800],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 30,
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
            )
          ],
        ),
      ),
      onDismissed: onDismissedCallback,
      direction: DismissDirection.startToEnd,
      child: InkWell(
        //Todo: Implement onLongPress method
        //onLongPress: onSelectPressed,
        /// There's also another InkWell widget as a parent of the NoteTile class
        /// It is on the CustomNotes class and it has already a functionality
        child: Container(
          margin: EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11.0),
            color: notesBackgroundColors[noteColorNumber],
            border: Border.all(color: Colors.grey[400], width: 1.0),
          ),
          child: Container(
            width: double.infinity,
            color: Colors.transparent,
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                getTitle,
                getSizedBox,
                getContext,
                hasLabel
                    ? Container(
                        margin: EdgeInsets.only(top: 9),
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(width: 1, color: Colors.grey[400]),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Text(
                          noteLabel,
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool get hasLabel => (noteLabel != '') ? true : false;

  Widget get getTitle {
    if (noteTitle != null && noteTitle != '') {
      return Text(
        noteTitle,
        maxLines: 1,
        //If the text reaches maxLines, then add "..." at the end of it
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget get getSizedBox {
    if (noteTitle != null &&
        noteContext != null &&
        noteTitle != '' &&
        noteContext != '') {
      return SizedBox(
        height: 5,
      );
    } else {
      return Container();
    }
  }

  Widget get getContext {
    if (noteContext != null && noteContext != '') {
      return Text(
        noteContext,
        maxLines: 4,
        //If the text reaches maxLines, then add "..." at the end of it
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      );
    } else {
      return Container();
    }
  }
}
