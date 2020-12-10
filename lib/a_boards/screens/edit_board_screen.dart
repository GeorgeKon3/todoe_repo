import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoe/a_boards/custom_widgets/board_list_of_lists.dart';
import 'package:todoe/a_boards/custom_widgets/edit_baoard_header.dart';

class EditBoardScreen extends StatelessWidget {
  final String thisSpecificBoardName;
  EditBoardScreen({this.thisSpecificBoardName});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
      value: FirebaseFirestore.instance
          .collection('boards')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('boards')
          .doc(thisSpecificBoardName)
          .collection('lists')
          .snapshots(),
      child: Scaffold(
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              EditBoardHeader(boardName: thisSpecificBoardName ?? 'Error'),
              SizedBox(height: 10),

              /// Horizontal Parent List
              ListOfLists(thisSpecificBoardName: thisSpecificBoardName),
            ],
          ),
        ),
      ),
    );
  }
}
