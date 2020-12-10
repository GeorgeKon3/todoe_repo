import 'package:flutter/material.dart';
import 'package:todoe/c_notes/custom_widgets/label_listview_builder.dart';
import 'package:todoe/c_notes/custom_widgets/top_bar_icon.dart';
import 'package:todoe/c_notes/screens/add_note_label_screen.dart';
import 'package:todoe/z_cross_app_widgets/drawer_logo.dart';
import 'package:todoe/z_cross_app_widgets/settings_and_logout.dart';
import '../../constants.dart';

class NotesDrawer extends StatelessWidget {
  final Function onPressCallBack;
  final Function onTapNotes, onTapArchived, onTapDeleted, onEditLabel;
  NotesDrawer({this.onPressCallBack, this.onTapNotes, this.onTapArchived, this.onTapDeleted, this.onEditLabel});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            SizedBox(height: 15),
            //Title / Logo
            drawerLogo('Notes'),
            SizedBox(height: 7),
            //Three Main Options
            Padding(
              padding: EdgeInsets.only(left: kDrawerPadding),
              child: Column(
                children: [
                  ///Notes menu
                  InkWell(
                    onTap: onTapNotes,
                    child: Row(children: [
                      TopBarIcon(icon: Icons.lightbulb_outline),
                      SizedBox(width: kPaddingBetweenDrawerIconAndText),
                      Text(
                        'Notes',
                        style: kDrawerElementStyle,
                      )
                    ]),
                  ),
                  SizedBox(height: kSpaceBetweenDrawerElements),

                  ///Archived menu
                  InkWell(
                    onTap: onTapArchived,
                    child: Row(children: [
                      TopBarIcon(icon: Icons.folder_open),
                      SizedBox(width: kPaddingBetweenDrawerIconAndText),
                      Text(
                        'Archive',
                        style: kDrawerElementStyle,
                      )
                    ]),
                  ),
                  SizedBox(height: kSpaceBetweenDrawerElements),

                  ///Delete menu
                  InkWell(
                    onTap: onTapDeleted,
                    child: Row(children: [
                      TopBarIcon(icon: Icons.delete_outline),
                      SizedBox(width: kPaddingBetweenDrawerIconAndText),
                      Text(
                        'Trash',
                        style: kDrawerElementStyle,
                      )
                    ]),
                  ),
                ],
              ),
            ),
            SizedBox(height: kSpaceBetweenDrawerElements + 5),
            //LABELS + EDIT
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('LABELS', style: kDrawerLabelAndEdit),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNoteLabelScreen(addNewLabel: false),
                        ),
                      ).then((value) {
                        onEditLabel(false);
                      });
                    },
                    child: Text('EDIT', style: kDrawerLabelAndEdit),
                  ),
                ],
              ),
            ),
            SizedBox(height: kSpaceBetweenDrawerElements - 5),
            //Future Builder: NoteLabelList
            LabelListBuilder(labelListDisplay: LabelListDisplay.view),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 6),
              child: InkWell(
                onTap: onPressCallBack,
                child: Row(
                  children: [TopBarIcon(icon: Icons.add), SizedBox(width: 5), Text('Label')],
                ),
              ),
            ),
            //Add Label
            settingsAndLogout(),
          ],
        ),
      ),
    );
  }
}
