import 'package:flutter/material.dart';
import 'package:note_app/models/database_helper.dart';
import 'package:note_app/models/customer_model.dart';
import 'package:note_app/services/note_list.dart';
import 'package:note_app/screens/note/note.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Search extends StatefulWidget {
  final List note_list;
  final Function deleteNote;
  final Function updateNote;
  final int list_length;

  const Search({Key key, this.note_list, this.deleteNote, this.updateNote, this.list_length})
      : super(key: key);
  @override
  _SearchState createState() => _SearchState();
}

bool isNotesLoaded = false;

class _SearchState extends State<Search> {
  // List list_copy;
  //
  List _notes = [];
  List _searchResult;

  Future<Null> getNotes() async {
    setState(() {
      _notes = widget.note_list;
    });
    print('List');
    print(widget.note_list);
  }

  Future<void> getSearchResult(keyword) async {
    print(keyword.length);
    if(keyword.length == 0) {
      setState(() {
        _notes = [];
      });
    } else {
      MemoDbProvider memoDb = MemoDbProvider();
      List memos = await memoDb.getSearchResult(keyword);
      setState(() {
        isNotesLoaded = true;
      });
      _notes = memos;
      print(_notes);
    }
  }

  @override
  void initState() {
    super.initState();

    // testDB();
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _notes.forEach((userDetail) {
      if (userDetail.title.contains(text) || userDetail.title.contains(text))
        _searchResult.add(userDetail);
    });

    setState(() {});
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
      widget.deleteNote(information, index);
    else
      widget.updateNote(information, document, index);
  }

  Widget _buildListItem(context, document, index) {
    return GestureDetector(
      child: Container(
        child: Container(
          margin: const EdgeInsets.only(bottom: 8, right: 10, left: 10),
          constraints: BoxConstraints(
//                maxHeight: 100, minHeight: 80,
          ),
          decoration: new BoxDecoration(
            color: Color(int.parse(document['color'])).withOpacity(.03),
            border: Border.all(color: Color(int.parse(document['color'])).withOpacity(.7)),
//                 color: Color(int.parse(document['color'])).withOpacity(1),
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
                              document['date'],
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
      ),
    );
  }

  String searchText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252525),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                left: 17,
                right: 17,
              ),
              height: MediaQuery.of(context).padding.top + 53,
              color: Color(0xff3b3b3b),
              child: Stack(
//                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Positioned(
                    // bottom: 0,
                    bottom: -14,
                    height: 50,
                    width: MediaQuery.of(context).size.width - 80,
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      textAlignVertical: TextAlignVertical.center,
                      onChanged: ((value) {
                        // onSearchTextChanged(value);
                        getSearchResult(value);
                        // setState(() {
                        //   searchText = value;
                        // });
                      }),
                      style: TextStyle(
                        fontSize: 15.2,
                        color: Colors.white,
                        
                      ),
                      decoration: new InputDecoration.collapsed(
                        hintText: 'Search here',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    )
                  ),
                  Positioned(
                      bottom: 9,
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
                                final FirebaseAuth auth = FirebaseAuth.instance;
                                final User CurrUser = auth.currentUser;
                                final uid = CurrUser.uid;
                                print(uid);
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
                                  image:
                                      AssetImage('assets/images/icon-close.png'),
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
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            //                      itemExtent: 80.0,
                            itemCount: _notes.length,
                            itemBuilder: (context, index) => _buildListItem(context, _notes[index], index)
                        )
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}