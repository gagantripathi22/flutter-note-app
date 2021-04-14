import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/models/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:note_app/services/firestore_sync.dart';
import 'dart:async';
import 'dart:io';

class SyncScreen extends StatefulWidget {
  @override
  SyncScreenState createState() {
    return SyncScreenState();
  }
}

class SyncScreenState extends State<SyncScreen> {
  int countOfNotes = 0;
  int syncProgressCount = 40;
  FirestoreSync sService = new FirestoreSync();

  void InitState() async {
    int tempCount = await sService.getTotalLengthOfNotes();
    setState(() {
      countOfNotes = tempCount;
    });
  }

  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) => getProgressCount());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  bool isSyncProgress = false;

  var lastSyncDate;

  double syncStatus = 0.0;

  getProgressCount() async {
    final prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   lastSyncDate: prefs.getString('lastSyncDate').toString();
    // });
    bool tempStatus = prefs.getBool('isSyncInProgress');
    print(isSyncProgress);
    if(tempStatus) {
      setState(() {
        isSyncProgress = tempStatus;
      });
    }
    
    double syncProgress = prefs.getDouble('syncProgress');
    print(syncProgress);
    setState(() {
      syncStatus = syncProgress;
    });
    if(syncProgress == 7.0) {
      setState(() {
        syncTriggered = false;
      });
    }
  }

  runOnPop() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSyncInProgress', false);
    prefs.setDouble('syncProgress', 0.0);
  }

  bool syncTriggered = false;

  showPleaseWait() {
    setState(() {
      syncTriggered = true;
      isSyncProgress = false;
    });
  }

  getLastSyncDate() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lastSyncDate: prefs.getString('lastSyncDate').toString();
    });
  }

  handleSync() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('Internet connected');
        FirestoreSync sc = new FirestoreSync();
        showPleaseWait();
        sc.newSyncProcedure();
      }
    } on SocketException catch (_) {
      print('Internet not connected');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
        content: Text('No internet connection'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    InitState();
    getLastSyncDate();
    MemoDbProvider memoDb = MemoDbProvider();
    FirestoreSync syncService = new FirestoreSync();
    return WillPopScope(
      onWillPop: () async {
        // addNote();
        Navigator.pop(context, {
          'refresh': true,
        });
        runOnPop();
      },
      child: Scaffold(
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
                  children: <Widget>[
                    Positioned(
                        bottom: 7,
                        child: GestureDetector(
                          child: Container(
                            decoration: new BoxDecoration(
                              color: Color(0xff3b3b3b),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Material(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  Navigator.pop(context, {
                                    'refresh': true,
                                  });
                                  runOnPop();
                                  // readTimeStamp();
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
                              padding: EdgeInsets.only(right: 20, left: 20),
                              alignment: Alignment.center,
                              child: Text(
                                'Sync data with cloud to access your notes from anywhere',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(.85),
                                    fontSize: 22,
                                    // fontWeight: FontWeight.w500,
                                    height: 1.3
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: IntrinsicHeight(
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 100),
                                        child: Image(
                                          image: AssetImage('assets/images/icon-cloud_sync.png'),
                                          color: Colors.white.withOpacity(.1),
                                          // height: 18,
                                          // width: 26,
                                        ),
                                      ),
                                      Container(
                                        height: 2.5,
                                        width: MediaQuery.of(context).size.width - 65,
                                        color: Colors.grey,
                                        margin: EdgeInsets.only(top: 40),
                                        child: Stack(
                                          children: [
                                            Positioned(child: Container(
                                              height: 2.5,
                                              width: this.syncStatus * 47,
                                              color: this.syncStatus == 7.0 ? Colors.lightGreen : Colors.white,
                                            ))
                                          ],
                                        )
                                      ),
                                    ],
                                  ),
                                )
                              )
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 16),
                              padding: const EdgeInsets.all(16),
                              child: GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.green.withOpacity(.105),
                                  ),
                                  child: GestureDetector(
                                    onTap: ()  {
                                      print('hello');
                                      // readTimeStamp();
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          handleSync();
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

      ),
    );
  }
}
