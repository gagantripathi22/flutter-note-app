import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteScreen extends StatefulWidget {
  final String title;
  final String date;
  final String note;
  final String note_id;
  final String note_color;

  const NoteScreen({Key key, this.title, this.date, this.note, this.note_id, this.note_color})
      : super(key: key);

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  String title = '';
  String note = '';
  bool isColorListShown = false;
  String selectedNoteColor = '0xffa6a6a6';

  TextEditingController _titleController;
  TextEditingController _noteController;

  CollectionReference noteRef = FirebaseFirestore.instance.collection('test');

  Future<void> updateNote() {
    if (title != '' || note != '') {
      if(title == '') title = widget.title;
      if(note == '') note = widget.note;
      return
        noteRef
          .doc(widget.note_id)
            .update({'title': title, 'text': note, 'color': selectedNoteColor,})
            .then((value) => print('ID ADDED TO NOTE'))
            .catchError((error) => print("Failed to add note: $error"));
    }
  }

  @override
  void initState() {
    super.initState();
    _titleController = new TextEditingController(text: widget.title);
    _noteController = new TextEditingController(text: widget.note);
    setState(() {
      selectedNoteColor = widget.note_color;
    });
  }

  Future<void> deleteNote() {
    return noteRef
        .doc(widget.note_id)
        .delete()
        .then((value) => print('Note Deleted'))
        .catchError((error) => print("Failed to delete note: $error"));
  }

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
        updateNote();
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
                    if (isColorListShown)
                      Positioned(
                          right: 89,
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
                                  updateNote();
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
                                    content: Text('Note Deleted'),
                                  ));
                                  deleteNote();
                                  Navigator.of(context).pop();
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
                                        'assets/images/icon-delete.png'),
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
                              padding: EdgeInsets.only(right: 10),
                              alignment: Alignment.topLeft,
                              child: TextField(
                                controller: _titleController,
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
                            margin: EdgeInsets.only(top: 19),
                            alignment: Alignment.topLeft,
                            child: Text(
                              // date == null ? 'Loading': 'Edited on ' + date,
                              widget.date,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white.withOpacity(.7),
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(top: 12),
                            child: TextField(
                              controller: _noteController,
                              maxLines: null,
                              onChanged: (text) {
                                setState(() {
                                  note = text;
                                });
                                print(title);
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
