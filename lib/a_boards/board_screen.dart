import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoe/c_notes/custom_widgets/card_main.dart';
import 'package:todoe/c_notes/custom_widgets/top_bar_icon.dart';
import '../constants.dart';
import 'custom_widgets/board_wrap_of_boards.dart';
import 'drawers/board_drawer.dart';
import 'package:todoe/utils/database.dart';

class BoardScreen extends StatefulWidget {
  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  final int numberOfTasks = 6;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return StreamProvider<QuerySnapshot>.value(
      value: FirebaseFirestore.instance.collection('boards').doc(FirebaseAuth.instance.currentUser.uid).collection('boards').snapshots(),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: BoardDrawer(),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              /// Header
              Container(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 23),
                  decoration: BoxDecoration(
                    color: topContainerColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Hamburger menu
                          Expanded(
                            flex: 7,
                            child: Align(
                              alignment: FractionalOffset.centerLeft,
                              child: TopBarIcon(
                                icon: Icons.menu,
                                onPressedFunction: () {
                                  _scaffoldKey.currentState.openDrawer();
                                },
                              ),
                            ),
                          ),

                          /// Hello, hustler! + You've 1 task
                          Expanded(
                            flex: 11,
                            child: Align(
                              alignment: FractionalOffset.center,
                              child: Column(
                                children: [
                                  Text(
                                    'Hello, hustler!',
                                    style: TextStyle(fontSize: 15, fontFamily: 'KumbhSans'),
                                  ),
                                  Row(
                                    children: [
                                      Text('Todoe', style: kMainPageHeaderStyle),
                                      Text('Boards',
                                          style: TextStyle(
                                            fontFamily: 'KumbhSans',
                                            fontWeight: FontWeight.w100,
                                            fontSize: kMainPageHeaderSize,
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          /// + Board
                          Expanded(
                            flex: 7,
                            child: Align(
                              alignment: FractionalOffset.centerRight,
                              child: InkWell(
                                onTap: () {
                                  DatabaseServiceBoards().createBoard();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: kMainCustomizingColor,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Text(
                                    '+ Board',
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 13),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      //SizedBox(height: 15),
                      //SearchBar(text: 'Search In Your Boards'),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: ListView(
                  //shrinkWrap: true,
                  padding: EdgeInsets.all(0),
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 20),
                      color: bottomContainerColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),

                          /// Static Widgets On The Screen
                          Text(
                            'Premium Options',
                            style: kMainPageListViewTitleStyle,
                          ),
                          CustomCardMain(
                            mainText: 'Create A Hybrid Board',
                            secondaryText: 'Manage everything, easier!',
                            icon: Icon(Icons.lock_outline),
                          ),
                          CustomCardMain(
                            mainText: 'Join or Create A Group Board',
                            secondaryText: 'Share with your team a classic/hybrid board!',
                            icon: Icon(Icons.lock_outline),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Boards',
                            style: kMainPageListViewTitleStyle,
                          ),
                          //SizedBox(height: 20),
                        ],
                      ),
                    ),

                    /// Dynamic Wrap Of Boards
                    BoardWrapOfBoards(screenWidth: screenWidth),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
