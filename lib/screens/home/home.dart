import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animations/animations.dart';
import 'package:note_app/screens/note/note.dart';

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

  Function _navigateToNote() {
    ;
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
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
                border: Border.all(color: Color(int.parse(document['color'])).withOpacity(.7)),
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
                    margin: EdgeInsets.only(top: 5,),
                    child: Text(
                      'March 7, 2020',
                      style: TextStyle(
                        // color: Color(0xff1b1c17).withOpacity(.5),
                        color: Color(0xffffffff).withOpacity(.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w300
                      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Text('New Note'),
        icon: Icon(Icons.add),
        backgroundColor: Color(0xff252525),
        foregroundColor: Colors.white,
        // tooltip: 'Upload',
        onPressed: () => {},
      ),
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
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('test').snapshots(),
                        builder: (context, snapshot) {
                          if(!snapshot.hasData) return const Text('Loading...');
                          return ListView.builder(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
//                      itemExtent: 80.0,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) =>
                                OpenContainer(
//                                  closedBuilder: (context, action) (
//                                    _buildListItem(context, snapshot.data.docs[index]),
//                                  ),
                                  closedColor: Color(0xff252525),
                                  closedElevation: 0,
//                                  transitionDuration: Duration(milliseconds: 2000),

                                  openColor: Color(0xff252525),
                                  closedBuilder: (context, action) {
                                    return _buildListItem(context, snapshot.data.docs[index]);
                                  },
                                  openBuilder: (context, action) {
                                    return NoteScreen(
                                      title: snapshot.data.docs[index]['title'],
                                      date: '7 March 2020',
                                      note: snapshot.data.docs[index]['text']
                                    );
                                  },
                                  tappable: true,
                                )
                          );
                        }
                    ),
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