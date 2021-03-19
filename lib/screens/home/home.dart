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

  Widget _buildListItem(context, document) {
    return GestureDetector(
      child: Container(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
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

  // NoteList nl = NoteList();

  void testDB() async {
    MemoDbProvider memoDb = MemoDbProvider();
    List memos = await memoDb.getAllNotes();
    // print(memos[0]['title']);

    note_list = memos;
    print(note_list);
  }

  void removeList() async {
    MemoDbProvider memoDb = MemoDbProvider();

    memoDb.deleteMemo(13);


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
    print(note_list);
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
                  child: FutureBuilder(
                    future: memoDb.getAllNotes(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return ListView.builder(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
//                      itemExtent: 80.0,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) => OpenContainer(
                            closedColor: Color(0xff252525),
                            closedElevation: 0,
//                                  transitionDuration: Duration(milliseconds: 2000),
                            openColor: Color(0xff252525),
                            closedBuilder: (context, action) {
                              return _buildListItem(context, note_list[index]);
                            },
                            openBuilder: (context, action) {
                              return NoteScreen(
                                title: snapshot.data[index]['title'],
                                date: '7 March 2020',
                                note: snapshot.data[index]['note'],
                                note_id: snapshot.data[index]['id'],
                                note_color: snapshot.data[index]['color'],
                                id_in_list: index,
                              );
                              // return _awaitReturnValueFromSecondScreen();
                            },
                            tappable: true,
                          )
                      );
                    },
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
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NewNote()))
              .then((value) {
            // testDB();
          })
        },
      ),
    );
  }
}
