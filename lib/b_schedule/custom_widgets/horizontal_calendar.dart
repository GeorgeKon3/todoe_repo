import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'date_tile.dart';

class HorizontalCalendar extends StatefulWidget {
  final DateTime date;
  HorizontalCalendar({this.date});
  @override
  _HorizontalCalendarState createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  List<DateTile> myList;
  ScrollController _scrollController = ScrollController();
  int _currentMax = 10;

  @override
  void initState() {
    super.initState();
    myList = List.generate(10, (i) => DateTile(date: widget.date.add(Duration(days: i))));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  _getMoreData() {
    for (int i = _currentMax; i < _currentMax + 10; i++) {
      myList.add(DateTile(date: widget.date.add(Duration(days: i))));
    }

    _currentMax = _currentMax + 10;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 45,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          itemExtent: 50,
          itemBuilder: (context, i) {
            if (i == myList.length) {
              return CupertinoActivityIndicator();
            }
            return myList[i];
          },
          itemCount: myList.length + 1,
        ),
      ),
    );
  }
}
