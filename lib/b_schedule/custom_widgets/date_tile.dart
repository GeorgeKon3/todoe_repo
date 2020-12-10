import 'dart:core';

import 'package:flutter/material.dart';
import 'package:todoe/constants.dart';

class DateTile extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  DateTile({this.date, this.isToday});
  @override
  Widget build(BuildContext context) {
    bool _isToday = isToday ?? false;
    double textSize = 15;
    double dotSize = 6;
    return Container(
      child: Column(
        children: [
          Text(
            getDateMonth(date),
            style: _isToday
                ? TextStyle(color: kMainCustomizingColor, fontWeight: FontWeight.bold, fontSize: textSize)
                : TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
          ),
          Text(
            getDateDay(date),
            style: _isToday
                ? TextStyle(color: kMainCustomizingColor, fontWeight: FontWeight.bold, fontSize: textSize)
                : TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
          ),
          isItToday()
              ? Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(color: kMainCustomizingColor, borderRadius: BorderRadius.all(Radius.circular(90))),
                )
              : Container()
        ],
      ),
    );
  }

  bool isItToday() {
    if (DateTime.now().day == date.day && DateTime.now().month == date.month) return true;
    return false;
  }

  String getDateMonth(DateTime date) {
    var temp = date.weekday;
    if (temp == 1) {
      return 'Mon';
    } else if (temp == 2) {
      return 'Tue';
    } else if (temp == 3) {
      return 'Wed';
    } else if (temp == 4) {
      return 'Thu';
    } else if (temp == 5) {
      return 'Fri';
    } else if (temp == 6) {
      return 'Sat';
    } else if (temp == 7) {
      return 'Sun';
    }
    return 'Error';
  }

  String getDateDay(DateTime date) {
    return date.day.toString();
  }
}
