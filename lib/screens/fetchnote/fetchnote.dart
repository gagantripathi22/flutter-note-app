import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/models/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/services/firestore_sync.dart';
import 'package:note_app/screens/home/home.dart';
import 'package:note_app/models/customer_model.dart';
import 'dart:async';

class FetchNoteScreen extends StatefulWidget {
  @override
  FetchNoteScreenState createState() {
    return FetchNoteScreenState();
  }
}

class FetchNoteScreenState extends State<FetchNoteScreen> {
  int totalNoteCount = 0;
  int currentFetchedNoteCount = 0;
  bool settingUpEnvironmentOpacity = true;
  bool fetchingNotesOpacity = false;
  bool storingLocallyOpacity = false;
  List firestoreNoteList = [];

  final FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference dataRef = FirebaseFirestore.instance.collection('data');

  @override
  void initState() {
    super.initState();
    storeNotesLocal();
  }

  countUserNotes() async {
    final User CurrUser = auth.currentUser;
    final String currUserId = CurrUser.uid;
    int countNotesServer = await dataRef.doc(currUserId).collection('notes').get().then((value) => value.size);
    print(countNotesServer);
    return countNotesServer;
  }

  fetchNotesFromServer() async {
    final User CurrUser = auth.currentUser;
    final String currUserId = CurrUser.uid;
    print('Fetching Notes from server');
    setState(() {
      settingUpEnvironmentOpacity = false;
      fetchingNotesOpacity = true;
    });
    await dataRef.doc(currUserId).collection('notes').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        setState(() {
          firestoreNoteList.insert(0, ds.data());
        });
      }
      print('Local List : ');
      print(firestoreNoteList);
    });
  }

  MemoDbProvider memoDb = MemoDbProvider();

  storeNotesLocal() async {
    print('local boi');
    int localNoteSaveCount = 0;
    int noteCount = await countUserNotes();
    if ( await noteCount <= 0 ) {
      navigateToHomeScreen();
    } else {
      await fetchNotesFromServer();
      setState(() {
        fetchingNotesOpacity = false;
        storingLocallyOpacity = true;
      });
      await firestoreNoteList.forEach((note) {
        final memo = Customer(
          title: note['title'],
          note: note['note'],
          color: note['color'],
          date: note['date'],
        );
        memoDb.addItem(memo).then((value) { print('l0000cal added'); ++localNoteSaveCount; }).then((value) {
          print('Server Notes : ' + noteCount.toString());
          print('Local Notes : ' + localNoteSaveCount.toString());
          if(noteCount == localNoteSaveCount) {
            Future.delayed(const Duration(milliseconds: 1500), () {
              navigateToHomeScreen();
            });
          }
        });
      });

    }
  }

  navigateToHomeScreen() {
    Navigator.pushReplacement (
        context,
        MaterialPageRoute(builder: (context) => HomeScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    MemoDbProvider memoDb = MemoDbProvider();
    FirestoreSync syncService = new FirestoreSync();
    return Scaffold(
      backgroundColor: Color(0xff252525),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Center(
                              child: IntrinsicHeight(
                                child: Column(
                                  children: [
                                    Image(
                                      image: AssetImage('assets/images/gif-sync.gif'),
                                      color: Colors.white.withOpacity(.1),
                                      height: 150,
                                    ),
                                    AnimatedOpacity(
                                      opacity: settingUpEnvironmentOpacity ? 1.0 : 0.3,
                                      duration: Duration(milliseconds: 500),
                                      child: Text(
                                        'Setting up the environment',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(.95),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    AnimatedOpacity(
                                      opacity: fetchingNotesOpacity ? 1.0 : 0.3,
                                      duration: Duration(milliseconds: 500),
                                      child: Container(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          'Fetching your notes from cloud',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(.95),
                                            fontSize: 16,
                                          ),
                                        ),
                                      )
                                    ),
                                    AnimatedOpacity(
                                        opacity: storingLocallyOpacity ? 1.0 : 0.3,
                                        duration: Duration(milliseconds: 500),
                                        child: Container(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(
                                            'Storing notes locally',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(.95),
                                              fontSize: 16,
                                            ),
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              )
                          )
                      ),
                    ],
                  )
              ),
            ),
          ],
        ),
      ),

    );
  }
}
