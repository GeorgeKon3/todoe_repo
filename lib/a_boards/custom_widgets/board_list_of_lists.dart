import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoe/a_boards/custom_widgets/board_list.dart';
import 'package:todoe/utils/database.dart';

class ListOfLists extends StatelessWidget {
  final thisSpecificBoardName;
  ListOfLists({this.thisSpecificBoardName});
  @override
  Widget build(BuildContext context) {
    Color listColor = Color(0xffEA8380);

    final temp = Provider.of<QuerySnapshot>(context);
    final List<String> thisSpecificListName = [];

    if (temp != null) {
      temp.docs.forEach((element) {
        //print('(board_list_of_lists) === ${element.id}');
        thisSpecificListName.add(element.id);
      });
    }

    return (thisSpecificListName != [])
        ? Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                itemCount: thisSpecificListName.length,
                itemBuilder: (context, listIndex) {
                  // this is the data of each list: boardData[index]['data']
                  //print('(board_list_of lists) ==> ${boardData[listIndex]['data']}');
                  return Container(
                    width: (0.8) * MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      //color: Colors.black,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        /// "List Name" text + Other options
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// List text
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: Text(
                                thisSpecificListName[listIndex] ?? 'List',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(0.3, 0.3), // shadow direction: bottom right
                                      blurRadius: 4.0,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            /// Add and More Buttons
                            Row(
                              children: [
                                /// Add Card Button
                                InkWell(
                                  onTap: () {
                                    DatabaseServiceBoards().createList(thisSpecificBoardName);
                                  },
                                  child: Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: listColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(60),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4.0,
                                          spreadRadius: 0.0,
                                          offset: Offset(0.2, 0.2), // shadow direction: bottom right
                                        )
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),

                                /// Delete List Button
                                InkWell(
                                  onTap: () {
                                    DatabaseServiceBoards().deleteList(thisSpecificBoardName, thisSpecificListName[listIndex]);
                                  },
                                  child: Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: listColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(60),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4.0,
                                          spreadRadius: 0.0,
                                          offset: Offset(0.2, 0.2), // shadow direction: bottom right
                                        )
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.clear,
                                      size: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                          ],
                        ),

                        /// Main Part of the list
                        BoardList(
                          listColor: listColor,
                          thisSpecificBoardName: thisSpecificBoardName,
                          thisSpecificListName: thisSpecificListName[listIndex],
                        )
                      ],
                    ),
                  );
                }))
        : CircularProgressIndicator();
  }
}
