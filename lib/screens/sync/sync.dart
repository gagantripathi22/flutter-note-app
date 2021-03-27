import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animations/animations.dart';
import 'package:note_app/screens/note/note.dart';
import 'package:note_app/screens/newnote/newnote.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:note_app/models/database_helper.dart';
import 'package:note_app/models/customer_model.dart';
import 'package:note_app/services/note_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:note_app/screens/search/search.dart';
import 'package:note_app/services/firestore_sync.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SyncScreen extends StatefulWidget {
  @override
  SyncScreenState createState() {
    return SyncScreenState();
  }
}

class SyncScreenState extends State<SyncScreen> {
  readTimeStamp() async {
    FirestoreSync test = new FirestoreSync();
    test.storingInFirestore();
    // List tlist = await test.getLocalDatabase();
    // print(tlist.length);
  }
  @override
  Widget build(BuildContext context) {
    MemoDbProvider memoDb = MemoDbProvider();

    return Scaffold(
      backgroundColor: Color(0xff252525),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              height: MediaQuery.of(context).padding.top + 52,
              // color: Colors.white,
              child: Stack(
//                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Positioned(
                      bottom: 7,
//                    margin: const EdgeInsets.only(bottom: 0),
                      child: GestureDetector(
                        child: Container(
                          decoration: new BoxDecoration(
                            color: Color(0xff3b3b3b),
//                            color: Color(0xffe8e8e8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Material(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 36,
                                width: 36,
                                padding: const EdgeInsets.all(8),
                                decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/icon-back.png'),
                                  color: Colors.white,
                                  // color: Colors.black,
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            ),
                            color: Colors.transparent,
                          ),
                        ),
                      )),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20, bottom: 10, left: 15, right: 15),
                child: ScrollConfiguration(
                behavior: ScrollBehavior(),
                  child: GlowingOverscrollIndicator(
                      axisDirection: AxisDirection.down,
                      color: Colors.grey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 20),
                            child: Text(
                              'Sync data with cloud to access your notes from anywhere',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(.85),
                                  fontSize: 22,
                                  // fontWeight: FontWeight.w500,
                                  height: 1.3
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 30),
                            padding: const EdgeInsets.all(16),
                            child: GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.green.withOpacity(.105),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      readTimeStamp();
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      height: 50,
                                      padding: const EdgeInsets.only(left: 15, right: 15),
                                      decoration: new BoxDecoration(
                                        border: Border.all(color: Colors.green),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Image(
                                            image: AssetImage('assets/images/icon-sync.png'),
                                            color: Colors.white,
                                            height: 18,
                                            width: 26,
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Sync with cloud",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ),
                          ),
                        ],
                      )
                  ),
                )
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}
