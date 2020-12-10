import 'package:flutter/material.dart';
import 'package:todoe/utils/database.dart';

class ChecklistTile extends StatelessWidget {
  final int checklistTileIndex;
  final checklistData;

  final String thisSpecificBoardName;
  final String thisSpecificListName;
  final String thisSpecificCardName;
  ChecklistTile({this.checklistTileIndex, this.checklistData, this.thisSpecificBoardName, this.thisSpecificListName, this.thisSpecificCardName});
  @override
  Widget build(BuildContext context) {
    String checklistTileName = checklistData.keys.elementAt(0);
    bool checklistTileValue = checklistData.values.elementAt(0);
    //print('(edit_list_card_checklist_tile) >>>>>> $checklistData');
    return Container(
      child: Row(children: [
        Checkbox(
          activeColor: Colors.lightBlueAccent,
          onChanged: (value) {
            DatabaseServiceBoards().checkChecklistTile(checklistTileIndex, {checklistData.keys.elementAt(0): !(checklistData.values.elementAt(0))},
                thisSpecificCardName, thisSpecificListName, thisSpecificBoardName);
          },
          value: checklistTileValue,
        ),
        Text(checklistTileName),
      ]),
    );
  }
}
