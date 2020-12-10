import 'package:flutter/material.dart';
import 'package:todoe/c_notes/custom_widgets/three_dot_item.dart';

class ThreeDotScrollviewCard extends StatelessWidget {
  final Function deleteCardCallback;
  final Function deleteBoardCallBack;
  final Function addListCallBack;
  final String usage;
  ThreeDotScrollviewCard({this.deleteCardCallback, this.deleteBoardCallBack, this.addListCallBack, @required this.usage});

  getColumn(usage, context) {
    if (usage == 'insideList') {
      return Column(
        children: [
          SizedBox(height: 15),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              children: [
                ThreeDotItem(
                  icon: Icons.edit,
                  text: 'Rename Card',
                  onItemPress: null,
                ),
                Spacer(),
                Text('(Premium Feature)'),
                SizedBox(width: 30),
              ],
            ),
          ),
          ThreeDotItem(
            icon: Icons.delete_outline,
            text: 'Delete Card',
            onItemPress: () {
              Navigator.pop(context);
              Navigator.pop(context);

              deleteCardCallback();
            },
          ),
        ],
      );
    } else if (usage == 'insideBoard') {
      return Column(
        children: [
          SizedBox(height: 12),
          ThreeDotItem(
            icon: Icons.delete_outline,
            text: 'Delete Board',
            onItemPress: () {
              Navigator.pop(context);
              Navigator.pop(context);

              deleteBoardCallBack();
            },
          ),
          ThreeDotItem(
            icon: Icons.add,
            text: 'Add List',
            onItemPress: () {
              Navigator.pop(context);
              addListCallBack();
            },
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SafeArea(child: getColumn(usage, context)),
    );
  }
}
