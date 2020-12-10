import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoe/a_boards/custom_widgets/board_card.dart';

class BoardWrapOfBoards extends StatelessWidget {
  final double screenWidth;

  BoardWrapOfBoards({@required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    QuerySnapshot temp = Provider.of<QuerySnapshot>(context);
    List<Widget> listOfBoardNames = [];
    if (temp != null) {
      temp.docs.forEach((element) {
        //print(' ==== == === ${element.id}');
        listOfBoardNames.add(BoardCard(
          screenWidth: screenWidth,
          boardName: element.id.toString(),
          //boardEmoji: (element.data().containsKey('emoji') == true) ? element['emoji'] : null,
          boardEmoji: getRandomEmoji(),
        ));
      });
    }
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(left: 10, right: 10, top: 15),
      child: Wrap(
        direction: Axis.horizontal,
        children: listOfBoardNames,
      ),
    );
  }
}

getRandomEmoji() {
  List<String> emojiList = ['cloud_queue', 'lock_outline', 'add_circle_outline', 'content_copy', 'add_location_alt_outlined'];
  int temp = Random().nextInt(emojiList.length - 1);
  return emojiList[temp];
}

IconData getEmoji(boardEmoji) {
  if (boardEmoji == 'lightbulb_outline') {
    return Icons.lightbulb_outline;
  } else if (boardEmoji == 'lock_outline') {
    return Icons.lock_outline;
  } else if (boardEmoji == 'add_circle_outline') {
    return Icons.add_circle_outline;
  } else if (boardEmoji == 'content_copy') {
    return Icons.content_copy;
  } else if (boardEmoji == 'add_location_alt_outlined') {
    return Icons.add_location_alt_outlined;
  } else if (boardEmoji == 'cloud_queue') {
    return Icons.cloud_queue;
  }

  return Icons.lightbulb_outline;
}
