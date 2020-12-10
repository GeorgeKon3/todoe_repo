import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  DocumentReference scheduleCollection;
  DatabaseService() {
    // collection reference
    scheduleCollection = FirebaseFirestore.instance.collection('schedule').doc(FirebaseAuth.instance.currentUser.uid);
  }

  //String _uid = FirebaseAuth.instance.currentUser.uid;

  /// =========================================
  /// ===========Update schedule data==========
  /// =========================================

  Future<void> updateUserData(int index, String title, String text, int hour, bool check) async {
    DocumentSnapshot documentSnapshot = await scheduleCollection.get();
    List temp = documentSnapshot.data()['standard_schedule'];
    temp[index] = {'title': title, 'text': text, 'hour': hour, 'check': check};
    temp.sort((hour1, hour2) => hour1['hour'] - hour2['hour']);
    scheduleCollection.update({'standard_schedule': temp});
  }

  /// ========================================
  /// ================Add task================
  /// ========================================

  Future<void> addNewTask(Map tempMap) async {
    DocumentSnapshot documentSnapshot = await scheduleCollection.get();
    List temp = documentSnapshot.data()['standard_schedule'];
    temp.add(tempMap);
    temp.sort((hour1, hour2) => hour1['hour'] - hour2['hour']);
    scheduleCollection.update({'standard_schedule': temp});
  }

  /// ========================================
  /// ===============Delete task==============
  /// ========================================

  Future<void> deleteTask(List tempList) async {
    scheduleCollection.update({'standard_schedule': tempList});
  }
}

/// ========================================       *      ====================================
/// =================Boards=================       *      ====================================
/// ========================================       *      ====================================

class DatabaseServiceBoards {
  CollectionReference collectionReference;
  DatabaseServiceBoards() {
    // collection reference
    collectionReference = FirebaseFirestore.instance.collection('boards').doc(FirebaseAuth.instance.currentUser.uid).collection('boards');
  }

  Future<void> checkChecklistTile(checklistTileIndex, checklistData, thisSpecificCardName, thisSpecificListName, thisSpecificBoardName) async {
    //print('(database) - (DatabaseServiceBoards) == checkChecklistTile called');
    DocumentSnapshot documentSnapshot = await collectionReference
        .doc(thisSpecificBoardName)
        .collection('lists')
        .doc(thisSpecificListName)
        .collection('cards')
        .doc(thisSpecificCardName)
        .get();
    // print('(database) - (DatabaseServiceBoards) == checkChecklistTile ${documentSnapshot.data()['checklist']}');
    // print('(database) - (DatabaseServiceBoards) == checkChecklistTile $checklistData');
    List temp = documentSnapshot.data()['checklist'];
    temp[checklistTileIndex] = checklistData;
    DocumentReference documentReference =
        collectionReference.doc(thisSpecificBoardName).collection('lists').doc(thisSpecificListName).collection('cards').doc(thisSpecificCardName);
    documentReference.update({'checklist': temp});
  }

  Future<void> addChecklistTile(thisSpecificBoardName, thisSpecificListName, thisSpecificCardName, addChecklistText) async {
    //print('(database) - (DatabaseServiceBoards) == checkChecklistTile called');
    DocumentSnapshot documentSnapshot = await collectionReference
        .doc(thisSpecificBoardName)
        .collection('lists')
        .doc(thisSpecificListName)
        .collection('cards')
        .doc(thisSpecificCardName)
        .get();
    // print('(database) - (DatabaseServiceBoards) == checkChecklistTile ${documentSnapshot.data()['checklist']}');
    // print('(database) - (DatabaseServiceBoards) == checkChecklistTile $checklistData');
    List temp = documentSnapshot.data()['checklist'];
    temp.add({addChecklistText: false});
    DocumentReference documentReference =
        collectionReference.doc(thisSpecificBoardName).collection('lists').doc(thisSpecificListName).collection('cards').doc(thisSpecificCardName);
    documentReference.update({'checklist': temp});
  }

  Future<void> deleteChecklist(thisSpecificBoardName, thisSpecificListName, thisSpecificCardName) async {
    //print('(database) - (DatabaseServiceBoards) == checkChecklistTile called');
    DocumentSnapshot documentSnapshot = await collectionReference
        .doc(thisSpecificBoardName)
        .collection('lists')
        .doc(thisSpecificListName)
        .collection('cards')
        .doc(thisSpecificCardName)
        .get();
    print('(database) - (DatabaseServiceBoards) == checkChecklistTile ${documentSnapshot.data()['checklist']}');
    // print('(database) - (DatabaseServiceBoards) == checkChecklistTile $checklistData');
    Map temp = documentSnapshot.data();
    temp.remove('checklist');
    print('(database) - (DatabaseServiceBoards) == temp $temp');
    DocumentReference documentReference =
        collectionReference.doc(thisSpecificBoardName).collection('lists').doc(thisSpecificListName).collection('cards').doc(thisSpecificCardName);
    documentReference.update({'checklist': FieldValue.delete()});
  }

  Future<void> createChecklist(thisSpecificBoardName, thisSpecificListName, thisSpecificCardName) async {
    //print('(database) - (DatabaseServiceBoards) == checkChecklistTile called');
    // DocumentSnapshot documentSnapshot = await collectionReference
    //     .doc(thisSpecificBoardName)
    //     .collection('lists')
    //     .doc(thisSpecificListName)
    //     .collection('cards')
    //     .doc(thisSpecificCardName)
    //     .get();
    DocumentReference documentReference =
        collectionReference.doc(thisSpecificBoardName).collection('lists').doc(thisSpecificListName).collection('cards').doc(thisSpecificCardName);
    documentReference.update({'checklist': []});
  }

  Future<void> updateDescription(thisSpecificBoardName, thisSpecificListName, thisSpecificCardName, description) async {
    //print('(database) - (DatabaseServiceBoards) == checkChecklistTile called');
    // DocumentSnapshot documentSnapshot = await collectionReference
    //     .doc(thisSpecificBoardName)
    //     .collection('lists')
    //     .doc(thisSpecificListName)
    //     .collection('cards')
    //     .doc(thisSpecificCardName)
    //     .get();
    DocumentReference documentReference =
        collectionReference.doc(thisSpecificBoardName).collection('lists').doc(thisSpecificListName).collection('cards').doc(thisSpecificCardName);
    documentReference.update({'description': description});
  }

  Future<void> deleteCard(thisSpecificBoardName, thisSpecificListName, thisSpecificCardName) async {
    //print('(database) - (DatabaseServiceBoards) == checkChecklistTile called');

    DocumentReference documentReference =
        collectionReference.doc(thisSpecificBoardName).collection('lists').doc(thisSpecificListName).collection('cards').doc(thisSpecificCardName);

    await documentReference.delete().then((vlaue) {
      print('Document successfully deleted!');
    });
  }

  Future<void> createBoard() async {
    int temp = await getBoardNumber();
    await collectionReference.doc('Board #${temp + 1}').set({});
    await collectionReference.doc('Board #${temp + 1}').collection('lists').doc('List #1').set({});
    await collectionReference.doc('Board #${temp + 1}').collection('lists').doc('List #1').collection('cards').doc('Card #1').set({'checklist': []});
  }

  Future<int> getBoardNumber() async {
    int temp = 0;
    QuerySnapshot querySnapshot = await collectionReference.get();
    querySnapshot.docs.forEach((element) {
      temp++;
    });
    return temp;
  }

  Future<void> createList(thisSpecificBoardName) async {
    int temp = await getListNumberInABoard(thisSpecificBoardName);
    await collectionReference.doc(thisSpecificBoardName).collection('lists').doc('List #${temp + 1}').set({});
    await collectionReference
        .doc(thisSpecificBoardName)
        .collection('lists')
        .doc('List #${temp + 1}')
        .collection('cards')
        .doc('Card #1')
        .set({'checklist': []});
  }

  Future<int> getListNumberInABoard(thisSpecificBoardName) async {
    int temp = 0;
    QuerySnapshot querySnapshot = await collectionReference.doc(thisSpecificBoardName).collection('lists').get();
    querySnapshot.docs.forEach((element) {
      temp++;
    });
    return temp;
  }

  Future<void> createCard(thisSpecificBoardName, thisSpecificListName) async {
    final int temp = await getCardNumberInAList(thisSpecificBoardName, thisSpecificListName);
    print('=========>>> temp: $temp');
    await collectionReference
        .doc(thisSpecificBoardName)
        .collection('lists')
        .doc(thisSpecificListName)
        .collection('cards')
        .doc('Card #${temp + 1}')
        .set({});
    await collectionReference
        .doc(thisSpecificBoardName)
        .collection('lists')
        .doc(thisSpecificListName)
        .collection('cards')
        .doc('Card #${temp + 1}')
        .set({'checklist': []});
  }

  Future<int> getCardNumberInAList(thisSpecificBoardName, thisSpecificListName) async {
    int temp = 0;
    QuerySnapshot querySnapshot =
        await collectionReference.doc(thisSpecificBoardName).collection('lists').doc(thisSpecificListName).collection('cards').get();
    querySnapshot.docs.forEach((element) {
      temp++;
    });
    print('getCardNumberInAList == $temp');
    return temp;
  }

  Future<void> renameCardName(thisSpecificBoardName, thisSpecificListName, thisSpecificCardName, newCardName) async {
    DocumentSnapshot documentSnapshot = await collectionReference
        .doc(thisSpecificBoardName)
        .collection('lists')
        .doc(thisSpecificListName)
        .collection('cards')
        .doc(thisSpecificCardName)
        .get();

    print('(database) - renameCardName ===== ${documentSnapshot.data()}');
    await collectionReference
        .doc(thisSpecificBoardName)
        .collection('lists')
        .doc(thisSpecificListName)
        .collection('cards')
        .doc(newCardName)
        .set(documentSnapshot.data());
    await collectionReference
        .doc(thisSpecificBoardName)
        .collection('lists')
        .doc(thisSpecificListName)
        .collection('cards')
        .doc(thisSpecificCardName)
        .delete();
  }

  Future<void> deleteList(thisSpecificBoardName, thisSpecificListName) async {
    print('(database) - (DatabaseServiceBoards) == deleteList called');

    DocumentReference documentReference = collectionReference.doc(thisSpecificBoardName).collection('lists').doc(thisSpecificListName);

    await documentReference.delete().then((vlaue) {
      print('Document successfully deleted!');
    });
  }

  Future<void> deleteBoard(thisSpecificBoardName) async {
    print('(database) - (DatabaseServiceBoards) == deleteBoard called');

    DocumentReference documentReference = collectionReference.doc(thisSpecificBoardName);

    await documentReference.delete().then((vlaue) {
      print('Board successfully deleted!');
    });
  }

  Future<void> createNewUserBoardData(uID) async {
    await collectionReference.doc('Routines').set({});
    await collectionReference.doc('Routines').collection('lists').doc('Focus List').set({});
    await collectionReference.doc('Routines').collection('lists').doc('Focus List').collection('cards').doc('Morning Routine').set({
      'description': 'A morning routine is essentially a set of actions you perform in the morning, usually before starting your day\'s main '
          'activity like going to work or to school. The actions can be anything from drinking a glass of water or brushing your teeth to doing a '
          'two-hour workout or running around the block',
      'checklist': [
        {'Wake Up.': false},
        {'Water.': false},
        {'Straight to the toilet.': false},
        {'Morning Stretching': false},
        {'Shower': false},
        {'Important Emails': false},
        {'Check Today\'s calendar': false},
      ]
    });
    await collectionReference.doc('Routines').collection('lists').doc('Focus List').collection('cards').doc('After Work Routine').set({
      'description': 'Routines That Will Make You Productive at Work and Life',
      'checklist': [
        {'Breathing Exercise': false},
        {'At least 1L of Water': false},
        {'Toilet': false},
        {'(Probably) Evening Stretching': false},
      ]
    });

    await collectionReference.doc('Routines').collection('lists').doc('Focus List').collection('cards').doc('Evening Routine').set({
      'checklist': [
        {'Avoid Randomness': true},
        {'Reflect and Pray': false},
        {'Family Time': false},
        {'Say personal convictions': false},
        {'Shower': false},
      ]
    });

    await collectionReference.doc('Routines').collection('lists').doc('Secondary List').set({});
    await collectionReference.doc('Routines').collection('lists').doc('Secondary List').collection('cards').doc('Morning Routine').set({
      'description': 'Here\'s everything secondary that you want to keep track of.',
      'checklist': [
        {'Eliminate Negativity': false},
        {'Do One Thing You Love': false},
        {'Plan Out the Next Day': false},
        {'Read Goals Before Sleeping': false},
        {'Allot a Moment of Reflection and Prayer': false},
        {'Set Things For Tomorrow': false},
        {'Set Exclusive Family Ritual Routine': false},
      ]
    });

    await collectionReference.doc('Goals').set({});
    await collectionReference.doc('Goals').collection('lists').doc('Focus Goals').set({});
    await collectionReference.doc('Goals').collection('lists').doc('Focus Goals').collection('cards').doc('Your #1 Goals').set({
      'checklist': [
        {'Daily self improvement': false},
        {'Follow your routines': false},
        {'Don\'t bring your problems at home': false},
        {'Save \$100 every month': false}
      ]
    });

    await collectionReference.doc('Goals').collection('lists').doc('Focus Goals').set({});
    await collectionReference.doc('Goals').collection('lists').doc('Focus Goals').collection('cards').doc('Secondary Goals').set({});

    await FirebaseFirestore.instance.collection('boards').doc(uID).set({});
    await collectionReference.doc('Welcome!').set({});
    await collectionReference.doc('Welcome!').collection('lists').doc('Your #1 List').set({});
    await collectionReference.doc('Welcome!').collection('lists').doc('Your #1 List').collection('cards').doc('Your #1 Card').set({
      'checklist': [
        {'Here\'s your first Checklist.': false},
        {'The Checklist made for you.': false},
        {'<- You can check & uncheck everything.': false},
        {'You can create infinite checklists!': false}
      ]
    });
  }

  // int checklistNumber = 0;
  // Future getChecklistNumberFromABoard(thisSpecificBoardName) async {
  //   var temp;
  //   QuerySnapshot querySnapshot = await collectionReference.doc(thisSpecificBoardName).collection('lists').get();
  //   querySnapshot.docs.forEach((element) async {
  //     QuerySnapshot querySnapshot2 =
  //         await collectionReference.doc(thisSpecificBoardName).collection('lists').doc(element.id).collection('cards').get();
  //     checklistNumber = 0;
  //     querySnapshot2.docs.forEach((element) {
  //       checklistNumber = checklistNumber + 1;
  //     });
  //     print('FINAL $thisSpecificBoardName = value of checklistNumber: $checklistNumber');
  //   });
  //
  //   Future.delayed(Duration(seconds: 3));
  //   return checklistNumber;
  // }
}
