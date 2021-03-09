import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animations/animations.dart';
import 'package:note_app/screens/note/note.dart';

class NoteScreen extends StatefulWidget {
  @override
  NoteScreenState createState() {
    return NoteScreenState();
  }
}

class NoteScreenState extends State<NoteScreen> {
  String id;
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;

  @override
  Widget build(BuildContext context) {
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
                      )
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
                      )
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Beautiful weather app UI concepts we wish existed',
                        style: TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'March 7, 2020',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withOpacity(.7),
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
//                    Expanded(
//                      flex: 1,
//                      child: new SingleChildScrollView(
//                        scrollDirection: Axis.vertical,//.horizontal
//                        child: new Text(
//                          "1 Description that is too long in text format(Here Data is coming from API) jdlksaf j klkjjflkdsjfkddfdfsdfds " +
//                              "2 Description that is too long in text format(Here Data is coming from API) d fsdfdsfsdfd dfdsfdsf sdfdsfsd d " +
//                              "3 Description that is too long in text format(Here Data is coming from API)  adfsfdsfdfsdfdsf   dsf dfd fds fs" +
//                              "4 Description that is too long in text format(Here Data is coming from API) dsaf dsafdfdfsd dfdsfsda fdas dsad" +
//                              "5 Description that is too long in text format(Here Data is coming from API) dsfdsfd fdsfds fds fdsf dsfds fds " +
//                              "6 Description that is too long in text format(Here Data is coming from API) asdfsdfdsf fsdf sdfsdfdsf sd dfdsf" +
//                              "7 Description that is too long in text format(Here Data is coming from API) df dsfdsfdsfdsfds df dsfds fds fsd" +
//                              "8 Description that is too long in text format(Here Data is coming from API)" +
//                              "9 Description that is too long in text format(Here Data is coming from API)" +
//                              "10 Description that is too long in text format(Here Data is coming from API)"
//                                  "6 Description that is too long in text format(Here Data is coming from API) asdfsdfdsf fsdf sdfsdfdsf sd dfdsf" +
//                              "7 Description that is too long in text format(Here Data is coming from API) df dsfdsfdsfdsfds df dsfds fds fsd" +
//                              "8 Description that is too long in text format(Here Data is coming from API)" +
//                              "9 Description that is too long in text format(Here Data is coming from API)" +
//                              "10 Description that is too long in text format(Here Data is coming from API)"
//                                  "6 Description that is too long in text format(Here Data is coming from API) asdfsdfdsf fsdf sdfsdfdsf sd dfdsf" +
//                              "7 Description that is too long in text format(Here Data is coming from API) df dsfdsfdsfdsfds df dsfds fds fsd" +
//                              "8 Description that is too long in text format(Here Data is coming from API)" +
//                              "9 Description that is too long in text format(Here Data is coming from API)" +
//                              "10 Description that is too long in text format(Here Data is coming from API)",
//                          style: new TextStyle(
//                            fontSize: 16.0, color: Colors.white,
//                          ),
//                        ),
//                      ),
//
//                    )
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

