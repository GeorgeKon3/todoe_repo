import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoe/a_boards/drawers/three_dot_scrollview_card.dart';
import 'package:todoe/c_notes/custom_widgets/top_bar_icon.dart';
import 'package:todoe/constants.dart';
import 'edit_list_card_description.dart';
import 'list_card_checklist_builder.dart';
import 'package:todoe/utils/database.dart';

String cardName;

class EditListCard extends StatefulWidget {
  final String thisSpecificBoardName;
  final String thisSpecificListName;
  final String thisSpecificCardName;

  EditListCard({this.thisSpecificCardName, this.thisSpecificListName, this.thisSpecificBoardName});

  @override
  _EditListCardState createState() => _EditListCardState();
}

class _EditListCardState extends State<EditListCard> {
  Widget backAndCrossWidget;
  Widget moreOptionsAndCheckWidget;
  @override
  void initState() {
    backAndCrossWidget = EditListCardBackIcon();
    moreOptionsAndCheckWidget = EditListCardMoreOptions(
      thisSpecificCardName: widget.thisSpecificCardName,
      thisSpecificListName: widget.thisSpecificListName,
      thisSpecificBoardName: widget.thisSpecificBoardName,
    );
    cardName = widget.thisSpecificCardName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Color(0xffEA8380)

    return StreamProvider<DocumentSnapshot>.value(
      value: FirebaseFirestore.instance
          .collection('boards')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('boards')
          .doc(widget.thisSpecificBoardName)
          .collection('lists')
          .doc(widget.thisSpecificListName)
          .collection('cards')
          .doc(cardName)
          .snapshots(),
      child: Scaffold(
        body: Column(
          children: [
            /// Header Bar
            EditListCardHeader(
                thisSpecificCardName: cardName,
                thisSpecificListName: widget.thisSpecificListName,
                backAndCrossWidget: backAndCrossWidget,
                moreOptionsAndCheckWidget: moreOptionsAndCheckWidget,
                onAddChecklistCallBack: (focus) {
                  setState(() {
                    if (focus == false) {
                      backAndCrossWidget = EditListCardBackIcon();
                      moreOptionsAndCheckWidget = EditListCardMoreOptions(
                        thisSpecificCardName: cardName,
                        thisSpecificListName: widget.thisSpecificListName,
                        thisSpecificBoardName: widget.thisSpecificBoardName,
                      );
                    } else if (focus == true) {
                      backAndCrossWidget = TopBarIcon(
                        icon: Icons.clear,
                        onPressedFunction: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);

                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        },
                      );
                      moreOptionsAndCheckWidget = TopBarIcon(
                        icon: Icons.check,
                        onPressedFunction: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          String temp = getCardName().toString();
                          if (temp.length != 0) {
                            //print('(edit_list_card) ====== new cardName: $temp');
                            DatabaseServiceBoards()
                                .renameCardName(widget.thisSpecificBoardName, widget.thisSpecificListName, widget.thisSpecificCardName, temp);
                            cardName = temp;
                            Navigator.pop(context);
                          }
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        },
                      );
                    }
                  });
                }),

            Expanded(
              child: ListView(
                padding: EdgeInsets.all(0),
                children: [
                  /// Description TextField
                  CardDescription(
                    onAddChecklistCallBack: (focus) {
                      setState(() {
                        if (focus == false) {
                          backAndCrossWidget = EditListCardBackIcon();
                          moreOptionsAndCheckWidget = EditListCardMoreOptions(
                            thisSpecificCardName: cardName,
                            thisSpecificListName: widget.thisSpecificListName,
                            thisSpecificBoardName: widget.thisSpecificBoardName,
                          );
                        } else if (focus == true) {
                          backAndCrossWidget = TopBarIcon(
                            icon: Icons.clear,
                            onPressedFunction: () {
                              FocusScopeNode currentFocus = FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                          );
                          moreOptionsAndCheckWidget = TopBarIcon(
                            icon: Icons.check,
                            onPressedFunction: () {
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              String temp = getDescriptionText().toString();
                              if (temp.length != 0) {
                                DatabaseServiceBoards().updateDescription(widget.thisSpecificBoardName, widget.thisSpecificListName, cardName, temp);
                              }
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                          );
                        }
                      });
                    },
                  ),
                  SizedBox(height: 10),

                  /// Fundamental Card Options
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => CupertinoAlertDialog(
                                    title: Text(
                                      'Premium Feature',
                                    ),
                                    content: Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text('Get the full Todoe experience. Upgrade to Premium today!'),
                                    ),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        isDefaultAction: true,
                                        child: Text('Okay'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ));
                        },
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            TopBarIcon(
                              icon: Icons.label_outline,
                            ),
                            Text('Labels...')
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      GetChecklistOption(
                        thisSpecificCardName: cardName,
                        thisSpecificListName: widget.thisSpecificListName,
                        thisSpecificBoardName: widget.thisSpecificBoardName,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  /// Checklist
                  ListCardChecklistBuilder(
                      thisSpecificCardName: cardName,
                      thisSpecificListName: widget.thisSpecificListName,
                      thisSpecificBoardName: widget.thisSpecificBoardName,
                      onAddChecklistCallBack: (focus) {
                        setState(() {
                          if (focus == false) {
                            backAndCrossWidget = EditListCardBackIcon();
                            moreOptionsAndCheckWidget = EditListCardMoreOptions(
                              thisSpecificCardName: cardName,
                              thisSpecificListName: widget.thisSpecificListName,
                              thisSpecificBoardName: widget.thisSpecificBoardName,
                            );
                          } else if (focus == true) {
                            backAndCrossWidget = TopBarIcon(
                              icon: Icons.clear,
                              onPressedFunction: () {
                                FocusScopeNode currentFocus = FocusScope.of(context);

                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                              },
                            );
                            moreOptionsAndCheckWidget = TopBarIcon(
                              icon: Icons.check,
                              onPressedFunction: () {
                                FocusScopeNode currentFocus = FocusScope.of(context);
                                String temp = getChecklistText().toString();
                                if (temp.length != 0) {
                                  DatabaseServiceBoards().addChecklistTile(widget.thisSpecificBoardName, widget.thisSpecificListName, cardName, temp);
                                }
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                              },
                            );
                          }
                        });
                      }),

                  /// Activity
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(minHeight: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 3,
                          offset: Offset(0.0, 0),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Text(
                        'Activity',
                        style: kMainPageListViewTitleStyle,
                      ),
                    ),
                  ),

                  /// Add Comment
                  Row(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 5, left: 20, right: 10),
                        child: Icon(
                          Icons.cloud_queue,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width - 100,
                        constraints: BoxConstraints(minHeight: 30),
                        child: TextFormField(
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: new InputDecoration(
                              hintMaxLines: 10,
                              border: InputBorder.none,
                              // focusedBorder: UnderlineInputBorder(
                              //   borderSide: BorderSide(color: Colors.black),
                              // ),
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
                              hintText: 'This is a Premium Feature.'),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditListCardMoreOptions extends StatelessWidget {
  final String thisSpecificBoardName;
  final String thisSpecificListName;
  final String thisSpecificCardName;
  EditListCardMoreOptions({this.thisSpecificBoardName, this.thisSpecificListName, this.thisSpecificCardName});
  @override
  Widget build(BuildContext context) {
    return TopBarIcon(
        icon: Icons.more_vert,
        onPressedFunction: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => ThreeDotScrollviewCard(
              usage: 'insideList',
              deleteCardCallback: () {
                //Navigator.pop(context);
                DatabaseServiceBoards().deleteCard(thisSpecificBoardName, thisSpecificListName, thisSpecificCardName);
              },
            ),
          );
        });
  }
}

class EditListCardBackIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TopBarIcon(
        icon: Icons.arrow_back_ios,
        onPressedFunction: () {
          Navigator.pop(context);
        });
  }
}

final TextEditingController cardNameEditingController = TextEditingController();

String getCardName() {
  String temp = cardNameEditingController.text.toString();
  // print('===== =$temp=');
  // print('===== =${temp.length}=');
  if (temp.length != 0) cardNameEditingController.clear();

  return temp;
}

class EditListCardHeader extends StatefulWidget {
  final String thisSpecificCardName;
  final String thisSpecificListName;
  final Widget backAndCrossWidget;
  final Widget moreOptionsAndCheckWidget;
  final Function onAddChecklistCallBack;
  EditListCardHeader(
      {this.thisSpecificCardName, this.thisSpecificListName, this.backAndCrossWidget, this.moreOptionsAndCheckWidget, this.onAddChecklistCallBack});

  @override
  _EditListCardHeaderState createState() => _EditListCardHeaderState();
}

class _EditListCardHeaderState extends State<EditListCardHeader> {
  @override
  void initState() {
    _focus.addListener(_onFocusChange);
    super.initState();
  }

  //TextEditingController cardNameEditingController = TextEditingController();
  FocusNode _focus = FocusNode();

  void _onFocusChange() {
    widget.onAddChecklistCallBack(_focus.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    print('(_EditListCardHeaderState) == initState cardName: ${widget.thisSpecificCardName}');
    cardNameEditingController.text = widget.thisSpecificCardName;
    return Container(
      padding: EdgeInsets.only(top: 40, left: 20, right: 20),
      color: topContainerColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),

          /// Back Arrow and More Options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Back Arrow
              widget.backAndCrossWidget,

              /// More Options
              widget.moreOptionsAndCheckWidget,
            ],
          ),
          SizedBox(height: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                focusNode: _focus,
                controller: cardNameEditingController,
                style: kMainPageHeaderStyle,
                //keyboardType: inputType,
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(0),
                    hintText: 'Card Name'),
              ),
              // Text(
              //   widget.thisSpecificCardName ?? 'Card',
              //   style: kMainPageHeaderStyle,
              // ),
              SizedBox(height: 12),
              Text(
                'List: ${widget.thisSpecificListName}' ?? 'Card of a List',
                style: TextStyle(fontSize: 17, fontFamily: 'KumbhSans'),
              ),
            ],
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}

class GetChecklistOption extends StatelessWidget {
  final String thisSpecificBoardName;
  final String thisSpecificListName;
  final String thisSpecificCardName;
  GetChecklistOption({this.thisSpecificBoardName, this.thisSpecificListName, this.thisSpecificCardName});

  /// This class returns a StatelessWidget that either is a
  /// '+ Add Checklist' Row or a '- Delete Checklist' Row.

  @override
  Widget build(BuildContext context) {
    var temp = Provider.of<DocumentSnapshot>(context);
    return (temp != null && temp.data() != null)
        ? (temp.data().isEmpty || temp.data()['checklist'] == null)

            /// Add Checklist
            ? InkWell(
                onTap: () {
                  DatabaseServiceBoards().createChecklist(thisSpecificBoardName, thisSpecificListName, thisSpecificCardName);
                },
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    TopBarIcon(
                      icon: Icons.add_circle_outline,
                    ),
                    Text('Add Checklist...')
                  ],
                ),
              )

            /// Delete Checklist

            : InkWell(
                onTap: () {
                  DatabaseServiceBoards().deleteChecklist(thisSpecificBoardName, thisSpecificListName, thisSpecificCardName);
                },
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    TopBarIcon(
                      icon: Icons.delete_outline,
                    ),
                    Text('Delete Checklist...')
                  ],
                ),
              )
        : Container();
  }
}
