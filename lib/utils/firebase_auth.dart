import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'database.dart';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Todo: Delete the lines of code below, we don't need them
  // Future<bool> signInWithEmail(String email, String password) async {
  //   try {
  //     AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
  //     FirebaseUser user = result.user;
  //     if (user != null)
  //       return true;
  //     else
  //       return false;
  //   } catch (e) {
  //     print(e.message);
  //     return false;
  //   }
  // }

  Future<void> logOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("error logging out");
    }
  }

  Future<bool> loginWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount account = await googleSignIn.signIn();
      if (account == null) return false;
      UserCredential res = await _auth.signInWithCredential(GoogleAuthProvider.credential(
        idToken: (await account.authentication).idToken,
        accessToken: (await account.authentication).accessToken,
      ));
      // if there's no user returned, then end this method.
      if (res.user == null) return false;

      // if the line of code above wasn't executed, this
      // means that we successfully retrieved the user.

      User user = res.user;
      print('>> user.id: ${user.uid}');

      DocumentReference documentReference = FirebaseFirestore.instance.collection('schedule').doc(FirebaseAuth.instance.currentUser.uid);
      DocumentSnapshot documentSnapshot = await documentReference.get();
      if (documentSnapshot.data() == null) {
        documentReference.set({
          'standard_schedule': [
            {'title': 'This is Todoe Schedule', 'text': 'You can plan your daily schedule here.', 'hour': 0, 'check': false},
            {'title': 'Get the most out of Todoe', 'text': 'Follow the instructions on the Tasks below.', 'hour': 0, 'check': false},
            {
              'title': 'Tap on this Task',
              'text': 'Now that you have tapped, click on the Edit button right here => You can customize everything about your tasks on this page.',
              'hour': 0,
              'check': false
            },
            {
              'title': 'Morning Routine',
              'text': 'Wake up right away, Water, Toilet, Morning Stretching and Finally Shower',
              'hour': 480,
              'check': false
            },
            {'title': 'Hit the road to Work', 'text': 'New day, New you. Another day to make an impact', 'hour': 560, 'check': false},
            {'title': 'Get back home', 'text': 'Work\'s done. You can focus on yourself now.', 'hour': 960, 'check': false},
            {
              'title': 'Beer with the boys',
              'text': 'Every evening that you pass way from the boys, is an evening wasted.',
              'hour': 960,
              'check': false
            },
          ]
        });
      }

      DocumentReference boardsDocumentReference = FirebaseFirestore.instance.collection('boards').doc(FirebaseAuth.instance.currentUser.uid);
      DocumentSnapshot boardsDocumentSnapshot = await boardsDocumentReference.get();
      print('=========> boardsDocumentSnapshot: ${boardsDocumentSnapshot.data()}');

      if (boardsDocumentSnapshot.data() == null) {
        print('boardsDocumentSnapshot.data() == null');
        DatabaseServiceBoards().createNewUserBoardData(FirebaseAuth.instance.currentUser.uid);
      }
      return true;
    } catch (e) {
      print(e.message);
      print(">>> firebase_auth: Error logging with google");
      return false;
    }
  }
}
