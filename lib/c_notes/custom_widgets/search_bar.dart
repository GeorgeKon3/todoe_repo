import 'package:flutter/material.dart';
import 'package:todoe/c_notes/custom_widgets/top_bar_icon.dart';

class SearchBar extends StatelessWidget {
  final String text;
  SearchBar({this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        children: [
          TopBarIcon(
            icon: Icons.search,
            removePadding: true,
            size: 20,
          ),
          Expanded(
            child: TextField(
              textAlign: TextAlign.start,
              //This style should be the same as the InputDecoration style.
              style: TextStyle(color: Colors.black, fontFamily: 'KumbhSans', fontSize: 12),
              decoration: InputDecoration(
                hintText: text,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                //This style should be the same as the TextField style.
                hintStyle: TextStyle(color: Colors.black, fontFamily: 'KumbhSans', fontSize: 12),
              ),
              onChanged: (value) {
                //print(value);
              },
            ),
          )
        ],
      ),
    );
  }
}
