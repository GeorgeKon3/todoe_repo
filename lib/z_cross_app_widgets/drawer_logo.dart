import 'package:flutter/cupertino.dart';

import '../constants.dart';

Widget drawerLogo(String text) {
  return Padding(
    padding: EdgeInsets.only(left: kDrawerPadding),
    child: Row(
      children: [
        Text(
          'Todoe',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'KumbhSans',
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'KumbhSans',
          ),
        ),
      ],
    ),
  );
}
