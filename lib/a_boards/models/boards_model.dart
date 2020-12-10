import 'package:flutter/foundation.dart';

class BoardModel extends ChangeNotifier {
  Map boardData;

  BoardModel({this.boardData}) {
    boardData = boardData;
  }

  get getBoardData {
    return boardData;
  }
}
