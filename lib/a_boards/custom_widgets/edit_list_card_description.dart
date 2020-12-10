import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final TextEditingController addNewDescriptionTextEditingController = TextEditingController();

String getDescriptionText() {
  String temp = addNewDescriptionTextEditingController.text.toString();
  print('===== =$temp=');
  print('===== =${temp.length}=');
  if (temp.length != 0) addNewDescriptionTextEditingController.clear();

  return temp;
}

class CardDescription extends StatefulWidget {
  final onAddChecklistCallBack;
  CardDescription({this.onAddChecklistCallBack});
  @override
  _CardDescriptionState createState() => _CardDescriptionState();
}

class _CardDescriptionState extends State<CardDescription> {
  FocusNode _focus = new FocusNode();
  void _onFocusChange() {
    widget.onAddChecklistCallBack(_focus.hasFocus);
  }

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot temp = Provider.of<DocumentSnapshot>(context);
    if (temp != null) {
      if (temp.data() != null) {
        if (temp.data()['description'].toString().length > 0) {
          addNewDescriptionTextEditingController.text = temp.data()['description'];
        }
      }
    }
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1.0,
            offset: Offset(0.0, 1),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
        child: TextFormField(
          focusNode: _focus,
          controller: addNewDescriptionTextEditingController,
          cursorColor: Colors.black,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: new InputDecoration(
              hintMaxLines: 10,
              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 0, bottom: -10, top: 5, right: 0),
              hintText: 'Edit card description ...'),
        ),
      ),
    );
  }
}
