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
import 'package:note_app/screens/sync/sync.dart';
import 'package:note_app/services/google_sign_in.dart';
import 'package:note_app/screens/login/login.dart';
import 'package:note_app/screens/fetchnote/fetchnote.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  String id;
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;

  String _returnedData;



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

  String _getCurrDay() {
    var currDt = DateTime.now();
    String currDay = currDt.day < 10 ? '0' + currDt.day.toString() : currDt.day.toString();
    return currDay;
  }

  String _getCurrMonth() {
    var currDt = DateTime.now();
    String currMonth = currDt.month < 10 ? '0' + currDt.month.toString() : currDt.month.toString();
    return currMonth;
  }

  String _getCurrYear() {
    var currDt = DateTime.now();
    String currYear = currDt.year < 10 ? '0' + currDt.year.toString() : currDt.year.toString();
    return currYear;
  }

  _numMonthToWord(monthNumber) {
    if(monthNumber == 1) return "Jan";
    else if(monthNumber == 2) return "Feb";
    else if(monthNumber == 3) return "Mar";
    else if(monthNumber == 4) return "Apr";
    else if(monthNumber == 5) return "May";
    else if(monthNumber == 6) return "June";
    else if(monthNumber == 7) return "July";
    else if(monthNumber == 8) return "Aug";
    else if(monthNumber == 9) return "Sept";
    else if(monthNumber == 10) return "Oct";
    else if(monthNumber == 11) return "Nov";
    else if(monthNumber == 12) return "Dec";
  }

  _getAmPmFormatTime(hour, minute) {
    String formattedTime;
    if(hour == 0) {
      formattedTime = (12).toString() + ':' + minute + ' am';
    } else
    if(hour > 12) {
      formattedTime = (hour-12).toString() + ':' + minute + ' pm';
    } else {
      formattedTime = (hour).toString() + ':' + minute + ' am';
    }
    return formattedTime;
  }

  _getFormatDDMonthYYYY(dateTimeFormat) {
    var currDt = DateTime.now();
    String temp = dateTimeFormat;
    String year = temp.substring(0, 4);
    String month = temp.substring(5, 7);
    String day = temp.substring(8, 10);
    if(int.parse(day) < 10) {
      day = day.substring(1, 2);
    }
    String month2 = int.parse(month) < 10 ? '0' + month : month ;
    String day2 = day;
    String hour = temp.substring(11, 13);
    String minute = temp.substring(14, 16);
    String sec = temp.substring(17, 19);
    String formattedDate = 'haha';
    print(year + ' ' + currDt.year.toString());
    print(month2 + ' ' + currDt.month.toString());
    print(day2 + ' ' + currDt.day.toString());
    if(int.parse(year) == currDt.year) {
      if (int.parse(month2) == currDt.month && int.parse(day2) == currDt.day) {
        formattedDate = _getAmPmFormatTime(int.parse(hour), minute);
      } else {
        formattedDate = day2 + ' ' + _numMonthToWord(int.parse(month2));
      }
    } else {
      formattedDate = day2 + ' ' + _numMonthToWord(int.parse(month2)) + ' ' + year;
    }
    return formattedDate;
  }

  _updateNote(information, document, index) async {
    if (information['title'] != '' || information['note'] != '' || information['color'] != document['color']) {
      if(information['title'] == '') information['title'] = document['title'];
      if(information['note'] == '') information['note'] = document['note'];
      MemoDbProvider memoDb = new MemoDbProvider();
      _deleteNote(document, index);
      await _addNewNote({
        'title': information['title'],
        'note': information['note'],
        'color': information['color'],
      });
    }
  }

  _addNewNote(information) async {
    if (information['title'] != '' || information['note'] != '') {
      if (information['title'] == '') {
        if (information['note'].length < 20) {
          information['title'] = information['note'].substring(0, information['note'].length);
        } else {
          information['title'] = information['note'].substring(0, 40);
        }
      }
      final memo = Customer(
        // id: 2,
        title: information['title'],
        note: information['note'],
        color: information['color'],
        date: _dateFormatter(),
      );
      MemoDbProvider memoDb = MemoDbProvider();
      await memoDb.addItem(memo);
    }
    testDB();
  }

  _deleteNote(information, index) async {
    MemoDbProvider memoDb = MemoDbProvider();
    await memoDb.deleteMemo(information['id']);
    await memoDb.setUnsyncDeletedNoteId(information['id'].toString(), information['date'].toString());

    setState(() {
      note_list.removeAt(index);
    });
    print('is removed');
    testDB();
  }

  _removeSymbolsFromDate(str) {
    String strNew = str.replaceAll("-", "");
    strNew = strNew.replaceAll(":", "");
    strNew = strNew.replaceAll(" ", "");
    return strNew;
  }

  _navigateToNoteScreen(context, document, index) async {
    final information = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteScreen(
        title: document['title'],
        date: _getFormatDDMonthYYYY(document['date']),
        note: document['note'],
        note_id: document['id'],
        note_color: document['color'],
        id_in_list: index,
      )),
    );

    if(information['isDelete'] == true)
      _deleteNote(information, index);
    else
      _updateNote(information, document, index);
  }

  _navigateToNewNoteScreen(context) async {
    final information = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewNote()),
    );
    _addNewNote(information);
  }

  _navigateToSyncScreen(context) async {
    final information = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SyncScreen()),
    );
    if(information['refresh'] == true)
      testDB();
  }

  showLogoutAlertDialog(context) async {
    Widget cancelButton = FlatButton(
      child: Text(
        "Cancel",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget syncButton = FlatButton(
      child: Text(
        "Sync",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed:  () {
        // Navigator.pop(context);
        _navigateToSyncScreen(context);
      },
    );
    Widget deleteButton = FlatButton(
      child: Text(
        "Log out",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed:  () {
        handleLogOut(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Log out",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      content: Text(
        "Are you sure you want to log out? All unsynced note will be deleted permanently.",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      actions: [
        cancelButton,
        syncButton,
        deleteButton,
      ],
      elevation: 24.0,
      backgroundColor: Color(0xff252525),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );

    // show the dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _buildListItem(context, document, index) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(bottom: 8, right: 10, left: 10),
        decoration: new BoxDecoration(
          color: Color(int.parse(document['color'])).withOpacity(.03),
          border: Border.all(color: Color(int.parse(document['color'])).withOpacity(.7)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
                onTap: () {
                  _navigateToNoteScreen(context, document, index);
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 12,
                    left: 15,
                    bottom: 11,
                    right: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          document['title'],
                          style: TextStyle(
                            // color: Color(0xff1b1c17),
                              color: Colors.white,
                              fontSize: 17,
                              height: 1.4
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(
                          top: 5,
                        ),
                        child: Text(
                          _getFormatDDMonthYYYY(document['date']),
                          style: TextStyle(
                            // color: Color(0xff1b1c17).withOpacity(.5),
                              color: Color(0xffffffff).withOpacity(.5),
                              fontSize: 12,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                  ),
                )
            ),
          )
        ),
      ),
    );
  }

  List items;

  @override
  void initState()  {
    // TODO: implement initState
    testDB();
  }

  bool isNotesLoaded = false;

  // NoteList nl = NoteList();

  Future<void> testDB() async {
    MemoDbProvider memoDb = MemoDbProvider();
    List memos = await memoDb.getAllNotes();
    setState(() {
      isNotesLoaded = true;
    });
    // print(memos[0]['title']);

    note_list = memos;
    print(note_list);
  }

  void removeList() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
  }

  // @override
  // void didChangeDependencies() async {
  //   super.didChangeDependencies();
  //   MemoDbProvider memoDb = MemoDbProvider();
  //   List memos = await memoDb.getAllNotes();
  //   // print(memos[0]['title']);
  //   note_list = memos;
  //   // print(note_list);
  // }

  String text;

  void _awaitReturnValueFromSecondScreen(BuildContext context) async {

    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NoteScreen(),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      text = result;
    });
  }
  // List temp_list;
  handleSync() async {
    FirestoreSync sync = new FirestoreSync();
    // print(sync.getLocalDatabase());
    List temp_list = await sync.getLocalDatabase();

    print(temp_list[1]);
    print(temp_list.length);
  }

  handleLogOut(context) async {
    // final prefs = await SharedPreferences.getInstance();
    // // prefs.setString('lastSyncDate', '2021-04-07 00:31:43');
    // print(prefs.getString('lastSyncDate'));
    // // int temp = int.parse(_removeSymbolsFromDate("2021-04-07 00:31:43"));
    // // print(temp);
    //
    // MemoDbProvider memoDb = MemoDbProvider();
    // await memoDb.deleteDeletedNotesTableOnLogout();
    // await memoDb.deleteNotesTableOnLogout();
    // List temp = await memoDb.getUnsyncDeletedNoteList();
    // print(temp);

    GoogleSignInProvider provider = new GoogleSignInProvider();
    await provider.logout();
    Navigator.pushReplacement (
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()
        ));
  }

  final user = FirebaseAuth.instance.currentUser;

  Widget _drawer(context) {
    return Container(
      color: Color(0xff252525),
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 30, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 19, right: 19, bottom: 20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          maxRadius: 32,
                          backgroundImage: NetworkImage(user.photoURL),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          // padding: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.displayName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  user.email,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(.6),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(top: 17),
              child: Material(
                color: Color(0xff252525),
                child: InkWell(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => SyncScreen()),
                    // );
                    _navigateToSyncScreen(context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                    width:  double.infinity,
                    decoration: new BoxDecoration(
                      // color: Color(0xff252525),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 16),
                          child: Image(
                            image:
                            AssetImage('assets/images/icon-sync.png'),
                            color: Colors.white,
                            // color: Colors.black,
                            height: 22,
                            width: 23,
                          ),
                        ),
                        Text(
                          'Sync notes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        )
                      ],
                    )
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: .5,
            color: Color(0xff575757),
            margin: EdgeInsets.only(left: 19, right: 29),
          ),
          GestureDetector(
            child: Container(
              child: Material(
                color: Color(0xff252525),
                child: InkWell(
                  onTap: () {
                    showLogoutAlertDialog(context);
                  },
                  child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                      width:  double.infinity,
                      decoration: new BoxDecoration(
                        // color: Color(0xff252525),
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 16),
                            child: Image(
                              image:
                              AssetImage('assets/images/icon-logout.png'),
                              color: Colors.white,
                              // color: Colors.black,
                              height: 24,
                              width: 25,
                            ),
                          ),
                          Text(
                            'Log out',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          )
                        ],
                      )
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    MemoDbProvider memoDb = MemoDbProvider();

    return Scaffold(
      key: _scaffoldKey,
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
                      left: -2,
//                    margin: const EdgeInsets.only(bottom: 0),
                      child: GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState.openDrawer();
                        },
                        child: Container(
                          height: 42,
                          width: 22,

                          padding: const EdgeInsets.only(top: 6, ),
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            // color: Colors.pink,
                          ),
                          child: Image(
                            image:
                            AssetImage('assets/images/icon-drawer.png'),
                            color: Colors.white,
                            // color: Colors.black,
                            height: 25,
                            width: 22,
                          ),
                        ),
                      )),
                  Positioned(
                    bottom: 11,
                    // bottom: 14,
                    left: 27,
                    // left: 29,
                    child: GestureDetector(
                      onTap: () {
                        // print(_dateFormatter());
                        // print(_getFormatDDMonthYYYY());
                      },
                      child: Text(
                        "Notes",
                        style: TextStyle(
//                        color: Colors.white,
                          color: Colors.white,
                          fontSize: 23,
                          // fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ),
//                   Positioned(
//                       bottom: 7,
//                       right: 45,
// //                    margin: const EdgeInsets.only(bottom: 0),
//                       child: GestureDetector(
//                         child: Container(
//                           decoration: new BoxDecoration(
//                             color: Color(0xff3b3b3b),
// //                            color: Color(0xffe8e8e8),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Material(
//                             child: InkWell(
//                               borderRadius: BorderRadius.circular(12),
//                               onTap: () {
//                                 handleSync();
//                               },
//                               child: Container(
//                                 height: 36,
//                                 width: 36,
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: new BoxDecoration(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: Image(
//                                   image:
//                                       AssetImage('assets/images/icon-sync.png'),
//                                   color: Colors.white,
//                                   // color: Colors.black,
//                                   height: 20,
//                                   width: 20,
//                                 ),
//                               ),
//                             ),
//                             color: Colors.transparent,
//                           ),
//                         ),
//                       )),
                  Positioned(
                      bottom: 7,
                      right: 0,
                      child: OpenContainer(
                                  closedColor: Color(0xff252525),
                                  closedElevation: 0,
                                  transitionDuration: Duration(milliseconds: 350),

                                  openColor: Color(0xff252525),
                                  closedBuilder: (context, action) {
                                    return Container(
                                      decoration: new BoxDecoration(
                                        color: Color(0xff3b3b3b),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Container(
                                        height: 36,
                                        width: 36,
                                        padding: const EdgeInsets.all(8),
                                        decoration: new BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Image(
                                          image: AssetImage(
                                              'assets/images/icon-search.png'),
                                          color: Colors.white,
                                          // color: Colors.black,
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                    );
                                  },
                                  openBuilder: (context, action) {
                                    return Search(
                                      note_list: items,
                                      deleteNote: _deleteNote,
                                      updateNote: _updateNote,
                                      list_length: note_list.length,
                                    );
                                  },
                                  tappable: true,
                                )
                    )

                ],
              ),
            ),
            Expanded(
              child: Container(
                  child: ScrollConfiguration(
                behavior: ScrollBehavior(),
                child: GlowingOverscrollIndicator(
                  axisDirection: AxisDirection.down,
                  color: Colors.grey,
                  child: ListView.builder(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
    //                      itemExtent: 80.0,
                          itemCount: note_list.length,
                          itemBuilder: (context, index) => _buildListItem(context, note_list[index], index)
                        )
                ),
              )),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('New Note'),
        icon: Icon(Icons.add),
        backgroundColor: Color(0xff3b3b3b),
        foregroundColor: Colors.white,
        // tooltip: 'Upload',
        onPressed: () => {
          _navigateToNewNoteScreen(context)
        },
      ),
      drawer: Drawer(child: _drawer(context),),
    );
  }
}
