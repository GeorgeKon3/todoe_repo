import 'package:flutter/material.dart';
import 'package:todoe/constants.dart';

class CustomCardMain extends StatelessWidget {
  final String mainText;
  final String secondaryText;
  final Icon icon;
  CustomCardMain({this.mainText, this.secondaryText, this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 23),
      elevation: 25,
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mainText,
                  overflow: TextOverflow.ellipsis,
                  style: kCardTitleStyle,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  secondaryText,
                  overflow: TextOverflow.fade,
                  style: kCardTextStyle,
                )
              ],
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kMainCustomizingColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: icon,
            )
          ],
        ),
      ),
    );
  }
}
