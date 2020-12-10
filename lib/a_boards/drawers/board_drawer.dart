import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoe/a_boards/screens/edit_board_screen.dart';
import 'package:todoe/c_notes/custom_widgets/top_bar_icon.dart';
import 'package:todoe/utils/database.dart';
import 'package:todoe/z_cross_app_widgets/drawer_logo.dart';
import 'package:todoe/z_cross_app_widgets/settings_and_logout.dart';

class BoardDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    QuerySnapshot temp = Provider.of<QuerySnapshot>(context);
    List<Widget> listOfBoardNames = [];
    if (temp != null) {
      temp.docs.forEach((element) {
        //print(' ==== == === ${element.id}');
        listOfBoardNames.add(InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditBoardScreen(thisSpecificBoardName: element.id.toString() ?? 'name error'),
              ),
            );
          },
          child: Row(
            children: [
              SizedBox(width: 15),
              TopBarIcon(icon: Icons.arrow_forward_ios),
              SizedBox(width: 5),
              Text(element.id.toString()),
            ],
          ),
        ));
      });
    }
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            SizedBox(height: 15),
            //Title / Logo
            drawerLogo('Boards'),
            SizedBox(height: 7),

            ListView.builder(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: listOfBoardNames.length,
                itemBuilder: (context, index) {
                  return listOfBoardNames[index];
                }),
            // SizedBox(height: 7),

            InkWell(
              onTap: () {
                Navigator.pop(context);
                DatabaseServiceBoards().createBoard();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 3),
                child: Row(
                  children: [TopBarIcon(icon: Icons.add), SizedBox(width: 5), Text('Board')],
                ),
              ),
            ),
            //Add Label
            settingsAndLogout(),
          ],
        ),
      ),
    );
  }
}
