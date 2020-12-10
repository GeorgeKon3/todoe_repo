import 'package:flutter/material.dart';
import 'edit_list_card.dart';

class BoardListCard extends StatelessWidget {
  final String thisSpecificBoardName;
  final String thisSpecificListName;
  final String thisSpecificCardName;

  BoardListCard({this.thisSpecificCardName, this.thisSpecificListName, this.thisSpecificBoardName});
  @override
  Widget build(BuildContext context) {
    Color listColor = Color(0xffEA8380);
    //print('(board_list_card) =====> ${cardData}');
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditListCard(
              thisSpecificCardName: thisSpecificCardName,
              thisSpecificListName: thisSpecificListName,
              thisSpecificBoardName: thisSpecificBoardName,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          // Here's where the elevation of the Container comes from.
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: Offset(0.2, 0.2), // shadow direction: bottom right
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                /// Example Label
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  height: 10,
                  width: 60,
                  decoration: BoxDecoration(
                    color: listColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                )
              ],
            ),

            /// Title of the Card
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                thisSpecificCardName ?? 'Card',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
