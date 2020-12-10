import 'package:flutter/material.dart';
import 'package:todoe/c_notes/custom_widgets/top_bar_icon.dart';
import 'package:todoe/utils/firebase_auth.dart';

import '../constants.dart';

Widget settingsAndLogout() {
  const double paddingOfLine = 15;
  return Column(
    //crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SizedBox(height: paddingOfLine - 5),
      Container(
        height: 1,
        width: double.infinity,
        color: Colors.black12,
      ),
      SizedBox(height: paddingOfLine),
      Padding(
        padding: EdgeInsets.only(left: kDrawerPadding),
        child: Row(
          children: [
            TopBarIcon(
              icon: Icons.help_outline,
            ),
            SizedBox(width: kPaddingBetweenDrawerIconAndText),
            Text('Help & Feedback'),
            Spacer(),
            Column(
              children: [
                Text(
                  'Premium',
                  style: TextStyle(fontSize: 10),
                ),
                Text(
                  'Feature',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
            SizedBox(width: 20),
          ],
        ),
      ),
      SizedBox(height: kSpaceBetweenDrawerElements),
      InkWell(
        onTap: () {
          AuthProvider().logOut();
        },
        child: Padding(
          padding: EdgeInsets.only(left: kDrawerPadding),
          child: Row(
            children: [
              TopBarIcon(
                icon: Icons.lock_outline,
              ),
              SizedBox(width: kPaddingBetweenDrawerIconAndText),
              Text('Log out')
            ],
          ),
        ),
      )
    ],
  );
}
