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

  _updateNote(information, document, index) async {
    if (information['title'] != '' || information['note'] != '') {
      if(information['title'] == '') information['title'] = document['title'];
      if(information['note'] == '') information['note'] = document['note'];
      final memo = Customer(
        id: document['id'],
        title: information['title'],
        note: information['note'],
        color: information['color'],
      );
      MemoDbProvider memoDb = MemoDbProvider();
      memoDb.updateMemo(document['id'], memo);
      print('Returned Note Color : ' + information['color']);
      print('Returned Note Title : ' + information['title']);
      setState(() {
        note_list[index] = {
          "id": document['id'],
          "title": information['title'],
          "note": information['note'],
          "color": information['color'],
        };
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
      );
      MemoDbProvider memoDb = MemoDbProvider();
      await memoDb.addItem(memo);

      setState(() {
        note_list.insert(0,{
          "title": information['title'],
          "note": information['note'],
          "color": information['color'],
        });
      });
    }
  }

  _deleteNote(information, index) async {
    MemoDbProvider memoDb = MemoDbProvider();
    await memoDb.deleteMemo(information['id']);

    setState(() {
      note_list.removeAt(index);
    });
    print('is removed');
  }

  _navigateToNoteScreen(context, document, index) async {
    final information = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteScreen(
        title: document['title'],
        date: '7 March 2020',
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

  Widget _buildListItem(context, document, index) {
    return GestureDetector(
      child: Container(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              _navigateToNoteScreen(context, document, index);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 8, right: 10, left: 10),
              padding: const EdgeInsets.only(
                top: 15,
                left: 15,
                bottom: 11,
                right: 15,
              ),
              constraints: BoxConstraints(
//                maxHeight: 100, minHeight: 80,
              ),
              decoration: new BoxDecoration(
                color: Color(int.parse(document['color'])).withOpacity(.03),
//                border: Border.all(color: Color(0xff525252.2),
                border: Border.all(
                    color: Color(int.parse(document['color'])).withOpacity(.7)),
                borderRadius: BorderRadius.circular(10),
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
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(
                      top: 5,
                    ),
                    child: Text(
                      'March 7, 2020',
                      style: TextStyle(
                        // color: Color(0xff1b1c17).withOpacity(.5),
                          color: Color(0xffffffff).withOpacity(.5),
                          fontSize: 12,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
    // print(_returnedData);

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);

    // MemoDbProvider memoDb = MemoDbProvider();
    //
    // memoDb.deleteMemo(13);


    // setState(() {
    //   note_list.removeAt(1);
    // });
    // print('is removed');

    // setState(() {
    //   nl.note_list.insert(0,{
    //     "id": 100,
    //     "title": 'ehy',
    //     "note": "HOEHOE",
    //     "color": "0xffffffff",
    //   });
    // });


    // items[items.indexWhere((element) => element.id == 5)] = {
    //       "id": 100,
    //       "title": 'huhuihhuihuiuihuih',
    //       "note": "HOEHOE",
    //       "color": "0xffffffff",
    //     };

    // setState(() {
    //   nl.note_list[3] = {
    //     "id": 100,
    //     "title": 'newew nigaa',
    //     "note": "HOEHOE",
    //     "color": "0xffffffff",
    //   };
    // });


    // items[2].title = 'Pending';


  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    MemoDbProvider memoDb = MemoDbProvider();
    List memos = await memoDb.getAllNotes();
    // print(memos[0]['title']);
    note_list = memos;
    // print(note_list);
  }

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


  @override
  Widget build(BuildContext context) {
    MemoDbProvider memoDb = MemoDbProvider();
    return Scaffold(
      backgroundColor: Color(0xff252525),
      // backgroundColor: Colors.white,
      
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                left: 17,
                right: 17,
              ),
              height: 78,
              // color: Colors.white,
              child: Stack(
//                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Positioned(
                    bottom: 11,
                    child: Text(
                      "Notes",
                      style: TextStyle(
//                        color: Colors.white,
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 7,
                      right: 45,
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
                                // updateNote();
                                // Navigator.pop(context);
                                // testDB();
                                removeList();
                              },
                              child: Container(
                                height: 36,
                                width: 36,
                                padding: const EdgeInsets.all(8),
                                decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image(
                                  image:
                                      AssetImage('assets/images/icon-sync.png'),
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
                  Positioned(
                      bottom: 7,
                      right: 0,
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
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Search button clicked'),
                                ));
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
                                      'assets/images/icon-search.png'),
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
      drawer: Drawer(child: Text('test'),),
    );
  }
}
