import 'package:flutter/material.dart';

class TaskFocus extends ChangeNotifier {
  // it's important to note that this variable is initialized as null.
  // we can set an initial focus of a specific task, by changing this variable.
  int taskFocus;

  onTap(int index) {
    taskFocus = index;
    notifyListeners();
  }
}
