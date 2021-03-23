import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
                    top: 42,
                    height: 50,
                    width: MediaQuery.of(context).size.width - 80,
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
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
                                      AssetImage('assets/images/icon-search.png'),
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
           
          ],
        ),
      ),
    );
  }
}