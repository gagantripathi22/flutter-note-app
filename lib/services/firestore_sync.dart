import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/models/database_helper.dart';
import 'package:note_app/models/database_helper.dart';
import 'package:note_app/models/customer_model.dart';

class FirestoreSync {

  int totalLengthOfNotes = 0;
  String currUserID;
  getLocalDatabase() async {
    MemoDbProvider memoDb = new MemoDbProvider();
    return await memoDb.getAllNotes();
  }
  CollectionReference deleteRef = FirebaseFirestore.instance.collection('data');
  CollectionReference addRef = FirebaseFirestore.instance.collection('data');
  storingInFirestore() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User CurrUser = auth.currentUser;
    final String currUserId = CurrUser.uid;


    // try {
    //   await deleteRef.doc(currUserId).collection('notes').snapshots().forEach((element) {
    //     for (QueryDocumentSnapshot snapshot in element.docs) {
    //       snapshot.reference.delete();
    //     }
    //   })
    //       .then((value) {
    //
    //   });
    // } on Exception catch (_) {
    //   print('never reached');
    // }


    List localData = await getLocalDatabase();
    totalLengthOfNotes = localData.length;
    await localData.forEach((note) {
      // print(note);
      addRef.doc(currUserId).collection('notes').add(
        note
      )
      .then((value) {
        print('Note Added to firestore');
      });
    });
  }
}