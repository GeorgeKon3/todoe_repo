import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoe/utils/database.dart';
import 'board_list_builder.dart';

class BoardList extends StatelessWidget {
  final listColor;
  final String thisSpecificListName;
  final thisSpecificBoardName;
  BoardList({this.listColor, @required this.thisSpecificBoardName, this.thisSpecificListName});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
      value: FirebaseFirestore.instance
          .collection('boards')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('boards')
          .doc(thisSpecificBoardName)
          .collection('lists')
          .doc(thisSpecificListName)
          .collection('cards')
          .snapshots(),
      child: Expanded(
        child: Container(
          //height: double.infinity,
          decoration: BoxDecoration(
            color: listColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
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
          child: Column(children: [
            SizedBox(height: 15),

            /// ListView Of Cards
            ListBuilder(
              thisSpecificBoardName: thisSpecificBoardName,
              thisSpecificListName: thisSpecificListName,
            ),
            SizedBox(height: 10),

            /// Add Card Button (+)
            InkWell(
              onTap: () {},
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(90),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 4.0,
                      spreadRadius: 0.0,
                      offset: Offset(0.2, 0.2), // shadow direction: bottom right
                    )
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    DatabaseServiceBoards().createCard(thisSpecificBoardName, thisSpecificListName);
                  },
                  child: Icon(
                    Icons.add,
                    color: listColor,
                    size: 20,
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
          ]),
        ),
      ),
    );
  }
}
