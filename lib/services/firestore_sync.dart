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

  getUnsyncDeletedNotes() async {
    print('getUnsyncDeletedNotes');
    MemoDbProvider memoDb = new MemoDbProvider();
    return await memoDb.getUnsyncDeletedNoteList();
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

  // NEW ALGORITHM
  deleteUnsyncDeletedNotesFromFirestore() async {
    print('deleteUnsyncDeletedNotesFromFirestore');
    MemoDbProvider memoDb = new MemoDbProvider();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User CurrUser = auth.currentUser;
    final String currUserId = CurrUser.uid;
    CollectionReference ref = FirebaseFirestore.instance.collection('data');
    List unsyncDeletedNotesList = await memoDb.getUnsyncDeletedNoteList();
    print('before Firestore Delete Loop LIST ::: ');
    print(unsyncDeletedNotesList);
    await unsyncDeletedNotesList.forEach((unsyncDeleted) {
      print('inside loop');
      ref.doc(currUserId).collection('notes').get().then((snapshot) {

        for (DocumentSnapshot ds in snapshot.docs) {
          // print(ds.data()['id'] + '- ---- -- --' + unsyncDeleted['id']);
          if (unsyncDeleted['id'] == ds.data()['id'])
            ds.reference.delete();
        }
      }).then((value) {
        // addingIntoDatabase(currUserId);
      });
    });
    print('after Firestore Delete Loop');
  }

  // NEW ALGORITHM
  addUnsyncDeletedNotesToFirestore() async {
    print('addUnsyncDeletedNotesToFirestore');
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User CurrUser = auth.currentUser;
    final String currUserId = CurrUser.uid;
    MemoDbProvider memoDb = new MemoDbProvider();
    CollectionReference ref = FirebaseFirestore.instance.collection('data');
    List unsyncDeletedNotesList = await getUnsyncDeletedNotes();
    await unsyncDeletedNotesList.forEach((unsyncDeleted) {
      ref.doc(currUserId).collection('deletedNoteId').add(
        {'id' : unsyncDeleted['id']}
      );
    });

    // await memoDb.emptyUnsyncDeletedNotesTable();
  }

  _removeSymbolsFromDate(str) {
    String strNew = str.replaceAll("-", "");
    strNew = strNew.replaceAll(":", "");
    strNew = strNew.replaceAll(" ", "");
    return strNew;
  }

  List newNoteList = [];

  setNotesWithDateGreaterThanLastSync() async {
    print('getNotesWithDateGreaterThanLastSync');
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User CurrUser = auth.currentUser;
    final String currUserId = CurrUser.uid;
    final prefs = await SharedPreferences.getInstance();
    int lastSyncDate = int.parse(_removeSymbolsFromDate(prefs.getString('lastSyncDate')));
    print('last Sync date' + lastSyncDate.toString());
    CollectionReference ref = FirebaseFirestore.instance.collection('data');
    List localDatabaseList = await getLocalDatabase();
    localDatabaseList.forEach((element) {
      if(int.parse(_removeSymbolsFromDate(element['date'])) > lastSyncDate) {
        ref.doc(currUserId).collection('notes').add(
          element
        );
      }
    });

    await ref.doc(currUserId).collection('notes').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        print(ds.data()['date']);
        if(lastSyncDate < int.parse(_removeSymbolsFromDate(ds.data()['date'])))
          newNoteList.insert(0, ds.data());
      }
      print('Local List : ');
      print(newNoteList);
      print(newNoteList.length);
    });
  }

  getNotesWithDateGreaterThanLastSync() async {
    print('getNotesWithDateGreaterThanLastSync');
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User CurrUser = auth.currentUser;
    final String currUserId = CurrUser.uid;
    final prefs = await SharedPreferences.getInstance();
    int lastSyncDate = int.parse(_removeSymbolsFromDate(prefs.getString('lastSyncDate')));
    print('last Sync date' + lastSyncDate.toString());
    CollectionReference ref = FirebaseFirestore.instance.collection('data');
    List unsyncDeletedNotesList = await getUnsyncDeletedNotes();
    await ref.doc(currUserId).collection('notes').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        print(ds.data()['date']);
        if(lastSyncDate < int.parse(_removeSymbolsFromDate(ds.data()['date'])))
          newNoteList.insert(0, ds.data());
      }
      print('Local List : ');
      print(newNoteList);
      print(newNoteList.length);
    });
  }

  String _dateFormatter() {
    var currDt = DateTime.now();
    String formattedDate = currDt.year.toString() + '-';
    formattedDate += currDt.month < 10 ? '0' + currDt.month.toString() + '-' : currDt.month.toString() + '-';
    formattedDate += currDt.day < 10 ? '0' + currDt.day.toString() + ' ' : currDt.day.toString() + ' ';
    formattedDate += currDt.hour < 10 ? '0' + currDt.hour.toString() + ':' : currDt.hour.toString() + ':';
    formattedDate += currDt.minute < 10 ? '0' + currDt.minute.toString() + ':' : currDt.minute.toString() + ':';
    formattedDate += currDt.second < 10 ? '0' + currDt.second.toString(): currDt.second.toString();
    return formattedDate;
  }

  storeNewlyFetchedDataToLocalDatabase() async {
    MemoDbProvider memoDb = new MemoDbProvider();
    newNoteList.forEach((element) {
      memoDb.addItem(
        Customer(
          id: element['id'],
          title: element['title'],
          note: element['note'],
          color: element['color'],
          date: _dateFormatter(),
        )
      );
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lastSyncDate', _dateFormatter());
  }

  deleteLocalNotesUsingFirebaseDeletedNoteId() async {
    print('deleteLocalNotesUsingFirebaseDeletedNoteId');
    MemoDbProvider memoDb = new MemoDbProvider();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User CurrUser = auth.currentUser;
    final String currUserId = CurrUser.uid;
    CollectionReference ref = FirebaseFirestore.instance.collection('data');
    List localNotesList = await getLocalDatabase();

    // await unsyncDeletedNotesList.forEach((unsyncDeleted) {
    //   ref.doc(currUserId).collection('deletedNoteId').get().then((snapshot) {
    //     for (DocumentSnapshot ds in snapshot.docs) {
    //       if (unsyncDeleted['id'] == ds.data()['id'])
    //         memoDb.deleteMemo(int.parse(ds.data()['id']));
    //     }
    //   }).then((value) {
    //     // addingIntoDatabase(currUserId);
    //   });
    // });

    ref.doc(currUserId).collection('deletedNoteId').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        localNotesList.forEach((element) {
          // print(element['id'].toString() + "----"  + ds.data()['id'].toString());
          if (element['id'].toString() == ds.data()['id'].toString())
            memoDb.deleteMemo(ds.data()['id']);
        });

      }
    }).then((value) {
      // addingIntoDatabase(currUserId);
    });
  }

  // for (DocumentSnapshot ds in snapshot.docs) {
  // if (unsyncDeleted['id'] == ds.data()['id'])
  // memoDb.deleteMemo(int.parse(ds.data()['id']));
  // }

  newSyncProcedure() async {
    await addUnsyncDeletedNotesToFirestore();
    await deleteUnsyncDeletedNotesFromFirestore();
    await setNotesWithDateGreaterThanLastSync();
    await deleteLocalNotesUsingFirebaseDeletedNoteId();
    await getNotesWithDateGreaterThanLastSync();
    await storeNewlyFetchedDataToLocalDatabase();
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