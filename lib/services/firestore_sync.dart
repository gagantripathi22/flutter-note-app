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
  int progressCounter = 0;
  bool isSyncInProgress = false;
  String currUserID;

  getLocalDatabase() async {
    print('getLocalDatabase');
    MemoDbProvider memoDb = new MemoDbProvider();
    return await memoDb.getAllNotes();
  }

  getTotalLengthOfNotes() async {
    MemoDbProvider memoDb = new MemoDbProvider();
    List toList = await memoDb.getAllNotes();
    return toList.length;
  }

  setSyncProgressStatus() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSyncInProgress', true);
  }

  addingIntoDatabase(currUserId) async {
    print('addingIntoDatabase');
    CollectionReference addRef = FirebaseFirestore.instance.collection('data');
    List localData = await getLocalDatabase();
    totalLengthOfNotes = localData.length;
    await localData.forEach((note) {
      // print(note);
      addRef.doc(currUserId).collection('notes').add(
        note
      )
      .then((value) {
        print('Note Added to firestore');
        ++progressCounter;
        isSyncInProgress = true;
        if(progressCounter == totalLengthOfNotes) {
          setSyncProgressStatus();
        }
      });

    });
  }

  storingInFirestore() async {
    print('storignInFirestore');
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User CurrUser = auth.currentUser;
    final String currUserId = CurrUser.uid;

    //Counting Notes
    CollectionReference reff = FirebaseFirestore.instance.collection('data');
    var countNotesServer = await reff.doc(currUserId).collection('notes').get().then((value) => value.size);

    if(countNotesServer != 0) {
      CollectionReference deleteRef = FirebaseFirestore.instance.collection('data');
      deleteRef.doc(currUserId).collection('notes').get().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      }).then((value) {
        addingIntoDatabase(currUserId);
      });
    }
    if(countNotesServer == 0) {
      addingIntoDatabase(currUserId);
    }
  }
}