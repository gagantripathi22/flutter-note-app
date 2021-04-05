import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/models/database_helper.dart';

class GoogleSignInProvider extends ChangeNotifier {

  final googleSignIn = GoogleSignIn();
  bool _isSigningIn;

  GoogleSignInProvider() {
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  Future login() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    // isSigningIn = true;

    final user = await googleSignIn.signIn();
    if(user == null) {
      prefs.setBool('isLoggedIn', false);
      isSigningIn = false;
      return;
    } else {
      final googleAuth = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      isSigningIn = true;
      prefs.setBool('isLoggedIn', true);

      final FirebaseAuth auth = FirebaseAuth.instance;
      final User CurrUser = auth.currentUser;
      final uid = CurrUser.uid;
      final email = CurrUser.email;
      final name = CurrUser.displayName;



      CollectionReference noteRef = FirebaseFirestore.instance.collection('users');

      bool isUserDataExists = false;
      noteRef.doc(uid).get().then((value) {
        isUserDataExists = true;
      });

      if(isUserDataExists) {
        print('User Data Exists Already');
      } else {
        noteRef.doc(uid).set(
            {'display_name': name, 'email': email, 'uid': uid})..then(
                  (value) => print('User Added Into Firestore Database'))
        .catchError((error) => print("Failed to add user in database: $error"));
      }

      MemoDbProvider memoDb = MemoDbProvider();
      memoDb.init();
    }
  }

  void logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    MemoDbProvider memoDb = MemoDbProvider();
    memoDb.deleteDatabase();
  }
}