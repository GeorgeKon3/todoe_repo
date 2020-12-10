import 'package:flutter/material.dart';

class CircularColorOptions extends StatelessWidget {
  final Color color;
  CircularColorOptions({this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 42,
      width: 42,
      decoration: BoxDecoration(
        border: Border.all(
          //Border Color
          color: Colors.black12,
        ),
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
    );
  }
}
