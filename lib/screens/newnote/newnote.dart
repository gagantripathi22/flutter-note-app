import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/models/database_helper.dart';
import 'package:note_app/models/customer_model.dart';

class NewNote extends StatefulWidget {
  @override
  _NewNoteState createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  String title = '';
  String note = '';
  bool isColorListShown = false;
  String selectedNoteColor = '0xffa6a6a6';

  CollectionReference noteRef = FirebaseFirestore.instance.collection('test');
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Future<void> addNote() {
  //   if (title != '' || note != '') {
  //     if (title == '') {
  //       if (note.length < 20) {
  //         title = note.substring(0, note.length);
  //       } else {
  //         title = note.substring(0, 40);
  //       }
  //     }
  //     return noteRef.add(
  //         {'title': title, 'text': note, 'color': selectedNoteColor}).then((value) {
  //       noteRef.doc(value.id).update({'note_id': value.id}).then(
  //               (value) => print('ID ADDED TO NOTE'));
  //     }).catchError((error) => print("Failed to add note: $error"));
  //   }
  // }

  addNote() async {
    if (title != '' || note != '') {
      if (title == '') {
        if (note.length < 20) {
          title = note.substring(0, note.length);
        } else {
          title = note.substring(0, 40);
        }
      }
      final memo = Customer(
        // id: 2,
        title: title,
        note: note,
        color: selectedNoteColor,
      );
      MemoDbProvider memoDb = MemoDbProvider();
      await memoDb.addItem(memo);
      var memos = await memoDb.fetchMemos();
      // print(memos[0].note);
    }
  }

  Widget ColorList = new Container(
    height: 15,
    width: 27,
    margin: EdgeInsets.only(top: 4, bottom: 4),
    decoration: new BoxDecoration(
      color: Color(0xfff48fb1),
      borderRadius: BorderRadius.circular(12),
    ),
  );

  Widget _colorListItem(color) {
    return GestureDetector(
      onTap: () {
        print(color);
        setState(() {
          isColorListShown = false;
          selectedNoteColor = color;
        });
      },
      child: Container(
        height: 15,
        width: 27,
        margin: EdgeInsets.only(top: 4, bottom: 4, right: 4),
        decoration: new BoxDecoration(
          color: Color(int.parse(color)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  var color_list = [
    '0xfff48fb1',
    '0xffffcc80',
    '0xffe6ee9b',
    '0xff80deea',
    '0xffcf93d9',
    '0xff80cbc4',
    '0xffa6a6a6'
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // addNote();
        Navigator.pop(context, {
          'title': title,
          'note': note,
          'color': selectedNoteColor,
        });
        return false;
      },
      child: Scaffold(
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
                                  Navigator.pop(context, {
                                    'title': title,
                                    'note': note,
                                    'color': selectedNoteColor,
                                  });
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
                    if (isColorListShown)
                      Positioned(
                          right: 43,
                          bottom: 7,
//                    margin: const EdgeInsets.only(bottom: 0),
                          child: GestureDetector(
                            child: Container(
                              decoration: new BoxDecoration(
                                color: Color(0xff3b3b3b),
//                            color: Color(0xffe8e8e8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                height: 36,
                                width: 194,
                                padding:
                                const EdgeInsets.only(left: 7, right: 3),
                                decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: color_list.map((String color) {
                                    return _colorListItem(color);
                                  }).toList(),
                                ),
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
                                  if (isColorListShown)
                                    setState(() {
                                      isColorListShown = false;
                                    });
                                  else
                                    setState(() {
                                      isColorListShown = true;
                                    });
                                },
                                child: Container(
                                  height: 36,
                                  width: 36,
                                  padding: const EdgeInsets.all(5),
                                  decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                      color: Color(int.parse(selectedNoteColor)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
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
                child: SingleChildScrollView(
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
                              child: TextField(
                                // controller: _titleController,
                                maxLines: null,
                                onChanged: (text) {
                                  setState(() {
                                    title = text;
                                  });
                                  print(title);
                                },
                                style: TextStyle(
                                  fontSize: 35,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: new InputDecoration.collapsed(
                                  hintText: 'Title',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                              )),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(top: 9),
                            child: TextField(
                              // controller: _noteController,
                              maxLines: null,
                              onChanged: (text) {
                                setState(() {
                                  note = text;
                                });
                                print(note);
                              },
                              style: TextStyle(
                                fontSize: 17.0,
                                color: Colors.white,
                                height: 1.8,
                              ),
                              decoration: new InputDecoration.collapsed(
                                hintText: 'Type something...',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}