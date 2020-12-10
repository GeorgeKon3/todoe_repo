import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'board_list_card.dart';

class ListBuilder extends StatelessWidget {
  final String thisSpecificBoardName;
  final String thisSpecificListName;
  ListBuilder({this.thisSpecificBoardName, this.thisSpecificListName});
  @override
  Widget build(BuildContext context) {
    QuerySnapshot temp = Provider.of<QuerySnapshot>(context);
    List<String> thisSpecificCardName = [];

    if (temp != null) {
      temp.docs.forEach((element) {
        // print('(board_list_builder) === id ${element.id}');
        // print('(board_list_builder) === id ${element.data()}');
        thisSpecificCardName.add(element.id);
      });
    }

    return (thisSpecificCardName != [])
        ? Expanded(
            child: ListView.builder(
                // For an unknown reason, ListView comes with a default padding.
                // We have to set padding as 0 to achieve the desirable result.
                padding: EdgeInsets.all(0),
                // ShrinkWrap solves the error "Vertical viewport was given unbounded height."
                //shrinkWrap: true,
                itemCount: thisSpecificCardName.length,
                itemBuilder: (context, cardIndex) {
                  /// Card
                  return BoardListCard(
                    thisSpecificCardName: thisSpecificCardName[cardIndex],
                    thisSpecificListName: thisSpecificListName,
                    thisSpecificBoardName: thisSpecificBoardName,
                  );
                }),
          )
        : CircularProgressIndicator();
  }
}
