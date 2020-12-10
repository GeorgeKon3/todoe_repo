import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoe/c_notes/custom_widgets/top_bar_icon.dart';
import 'package:todoe/constants.dart';

import 'edit_list_card_checklist_tile.dart';

final TextEditingController addNewChecklistTextEditingController = TextEditingController();

String getChecklistText() {
  String temp = addNewChecklistTextEditingController.text.toString();
  // print('===== =$temp=');
  // print('===== =${temp.length}=');
  if (temp.length != 0) addNewChecklistTextEditingController.clear();

  return temp;
}

class ListCardChecklistBuilder extends StatefulWidget {
  final String thisSpecificBoardName;
  final String thisSpecificListName;
  final String thisSpecificCardName;
  final Function onAddChecklistCallBack;
  ListCardChecklistBuilder({this.thisSpecificBoardName, this.thisSpecificListName, this.thisSpecificCardName, this.onAddChecklistCallBack});

  @override
  _ListCardChecklistBuilderState createState() => _ListCardChecklistBuilderState();
}

class _ListCardChecklistBuilderState extends State<ListCardChecklistBuilder> {
  FocusNode _focus = FocusNode();

  void _onFocusChange() {
    widget.onAddChecklistCallBack(_focus.hasFocus);
  }

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  bool getBoolForBuilder(DocumentSnapshot temp) {
    /// This method is created because, when a card was Deleted,
    /// then the "temp.data()['checklist'] != null" was called
    /// and gave the error:
    ///
    // >> The method '[]' was called on null.
    // >> Receiver: null
    // >> Tried calling: []("checklist")
    if (temp != null && temp.data() != null) {
      if (temp.data()['checklist'] != null) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot temp = Provider.of<DocumentSnapshot>(context);

    return (getBoolForBuilder(temp))
        ? Column(
            children: [
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
                    'Checklist',
                    style: kMainPageListViewTitleStyle,
                  ),
                ),
              ),
              ListView.builder(
                  padding: EdgeInsets.only(left: 10),
                  shrinkWrap: true,
                  itemCount: temp.data()['checklist'].length + 1,
                  itemBuilder: (context, checklistTileIndex) {
                    if (checklistTileIndex == temp.data()['checklist'].length) {
                      return Container(
                        child: Row(children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: TopBarIcon(
                                removePadding: true,
                                size: 27,
                                icon: Icons.add,
                                buttonColor: Colors.black54,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: TextField(
                                focusNode: _focus,
                                controller: addNewChecklistTextEditingController,
                                decoration: new InputDecoration(
                                    hintMaxLines: 1,
                                    border: InputBorder.none,
                                    // focusedBorder: UnderlineInputBorder(
                                    //   borderSide: BorderSide(color: Colors.black),
                                    // ),
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    //contentPadding: EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
                                    hintText: 'Add Checklist'),
                              ),
                            ),
                          ),
                        ]),
                      );
                    }
                    return ChecklistTile(
                      checklistTileIndex: checklistTileIndex,
                      checklistData: temp.data()['checklist'][checklistTileIndex],
                      thisSpecificCardName: widget.thisSpecificCardName,
                      thisSpecificListName: widget.thisSpecificListName,
                      thisSpecificBoardName: widget.thisSpecificBoardName,
                    );
                  }),
            ],
          )
        : (temp != null && temp.data() != null)
            ? Container()
            : Container(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(),
              );
  }
}
