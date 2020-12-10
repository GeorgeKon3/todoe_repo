import 'package:flutter/material.dart';
import 'package:todoe/a_boards/drawers/three_dot_scrollview_card.dart';
import 'package:todoe/c_notes/custom_widgets/top_bar_icon.dart';
import 'package:todoe/utils/database.dart';
import '../../constants.dart';

class EditBoardHeader extends StatelessWidget {
  final String boardName;
  EditBoardHeader({this.boardName});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40, left: 20, right: 20),
      color: topContainerColor,
      child: Column(
        children: [
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TopBarIcon(
                icon: Icons.arrow_back_ios,
                onPressedFunction: () {
                  Navigator.pop(context);
                },
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Todoe',
                        style: TextStyle(fontSize: 18, fontFamily: 'KumbhSans', fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Boards',
                        style: TextStyle(fontSize: 18, fontFamily: 'KumbhSans'),
                      ),
                    ],
                  ),
                  Text(
                    boardName ?? 'asdf',
                    style: kMainPageHeaderStyle,
                  ),
                ],
              ),
              TopBarIcon(
                icon: Icons.more_vert,
                onPressedFunction: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => ThreeDotScrollviewCard(
                      usage: 'insideBoard',
                      deleteBoardCallBack: () {
                        DatabaseServiceBoards().deleteBoard(boardName);
                      },
                      addListCallBack: () {
                        DatabaseServiceBoards().createList(boardName);
                      },
                    ),
                  );
                  //Navigator.pop(context);
                },
              ),
            ],
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
