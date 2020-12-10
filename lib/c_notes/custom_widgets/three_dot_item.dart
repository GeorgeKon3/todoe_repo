import 'package:flutter/material.dart';
import 'package:todoe/c_notes/custom_widgets/top_bar_icon.dart';

class ThreeDotItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onItemPress;
  final Color colorOfButton;
  final Color colorOfText;
  ThreeDotItem({this.text, this.icon, @required this.onItemPress, this.colorOfButton, this.colorOfText});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onItemPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            TopBarIcon(
              icon: icon,
              buttonColor: colorOfButton ?? Colors.black,
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 20, color: colorOfText ?? Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
