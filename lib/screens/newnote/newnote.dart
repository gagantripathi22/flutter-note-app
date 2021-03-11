import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewNote extends StatefulWidget {
  @override
  _NewNoteState createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  String title = '';
  String note = '';

  CollectionReference noteRef = FirebaseFirestore.instance.collection('test');

  Future<void> addNote() {
    if (title != '' || note != '') {
      if (title == '') {
        if (note.length < 20) {
          title = note.substring(0, note.length);
        } else {
          title = note.substring(0, 40);
        }
      }
      return noteRef.add(
          {'title': title, 'text': note, 'color': '0xff80cbc4'}).then((value) {
        noteRef.doc(value.id).update({'note_id': value.id}).then(
            (value) => print('ID ADDED TO NOTE'));
      }).catchError((error) => print("Failed to add note: $error"));
    }
  }
  int _value = 42;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        addNote();
        Navigator.of(context).pop();
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
                                  addNote();
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
                    Positioned(
                      bottom: 7,
                      right: 0,
//                    margin: const EdgeInsets.only(bottom: 0),
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
                            ),
                          ),
                          color: Colors.transparent,
                        ),
                      ),
                    )
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
                          new Positioned(
                              left: 30.0,
                              top: 30.0,
                              child: new Container(
                                width: 100.0,
                                height: 80.0,
                                decoration: new BoxDecoration(color: Colors.red),
                                child: new Text('hello'),
                              )
                          ),
                          Container(
                              alignment: Alignment.topLeft,
                              child: Stack(
                                children: <Widget>[
                                  Positioned(child: TextField(
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
                                ],
                              )
                          ),
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
