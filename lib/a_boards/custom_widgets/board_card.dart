import 'package:flutter/material.dart';
import 'package:todoe/a_boards/screens/edit_board_screen.dart';
import 'package:todoe/utils/database.dart';
import '../../constants.dart';

List listsOfTheBoard = [];

class BoardCard extends StatelessWidget {
  final screenWidth;
  final String boardName;
  final String boardEmoji;

  BoardCard({@required this.screenWidth, @required this.boardName, @required this.boardEmoji});

  final DatabaseServiceBoards databaseServiceBoards = DatabaseServiceBoards();
  @override
  Widget build(BuildContext context) {
    double widthAndHeight = (screenWidth - 20 * 3) / 2;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditBoardScreen(thisSpecificBoardName: boardName ?? 'name error'),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 20,
        ),
        //margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(22),
        width: widthAndHeight,
        //height: widthAndHeight - 20,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15.0,
              spreadRadius: 2.0,
              offset: Offset(0.0, 10.0), // shadow direction: bottom right
            )
          ],
        ),
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title + Tasks
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  boardName ?? 'name error',
                  maxLines: 1,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                //Todo: Complete this feature VV
                // FutureBuilder(
                //     future: databaseServiceBoards.getChecklistNumberFromABoard(boardName),
                //     builder: (BuildContext context, AsyncSnapshot projectSnap) {
                //       if (projectSnap.data != null) {
                //         print('(board_card)====== ${projectSnap.data}');
                //         return Text(
                //           'Tasks left: ${projectSnap.data}',
                //           style: TextStyle(fontWeight: FontWeight.normal),
                //         );
                //       }
                //       return CircularProgressIndicator();
                //     }),
              ],
            ),
            Spacer(),

            /// Top Right Icon
            Align(
              alignment: Alignment.topRight,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: kMainCustomizingColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(60),
                  ),
                ),
                child: Center(
                  child: Icon(
                    getEmoji(boardEmoji),
                  ),
                ),
              ),
            ),

            /// Fill the remaining space
          ],
        ),
      ),
    );
  }
}

IconData getEmoji(boardEmoji) {
  if (boardEmoji == 'cloud_queue') {
    return Icons.cloud_queue;
  } else if (boardEmoji == 'lock_outline') {
    return Icons.lock_outline;
  } else if (boardEmoji == 'add_circle_outline') {
    return Icons.add_circle_outline;
  } else if (boardEmoji == 'content_copy') {
    return Icons.content_copy;
  } else if (boardEmoji == 'add_location_alt_outlined') {
    return Icons.add_location_alt_outlined;
  }

  return Icons.lightbulb_outline;
}
