import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Color(0xff252525),
//      backgroundColor: Color(0xffffffff),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
//              color: Colors.lightBlue,
              padding: const EdgeInsets.only(
                left: 17,
                right: 17,
//                bottom: 20,
//                top: 20,
              ),
              height: 95,
              child: Stack(
//                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Positioned(
                    bottom: 15,
//                    margin: const EdgeInsets.only(bottom: 0),
                    child: Text(
                      "Notes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 0,
//                    margin: const EdgeInsets.only(bottom: 0),
                    child: GestureDetector(
                      child: Container(
                        decoration: new BoxDecoration(
                          color: Color(0xff3b3b3b),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Material(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Search button clicked'),
                              ));
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              padding: const EdgeInsets.all(6),
                              decoration: new BoxDecoration(
//                            color: Color(0xff3b3b3b),
//                        border: Border.all(color: Color(0xffe8e8e8)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image(
                                image: AssetImage('assets/images/icon-search.png'),
                                color: Colors.white,
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
                child: ListView(
                  padding: const EdgeInsets.only(

                    left: 10,
                    right: 10,
                  ),
                  children: <Widget>[
                    Container(
                      height: 100,
                      color: Colors.amber[600],
                      child: const Center(child: Text('Entry A')),
                    ),
                    Container(
                      height: 100,
                      color: Colors.amber[500],
                      child: const Center(child: Text('Entry B')),
                    ),
                    Container(
                      height: 100,
                      color: Colors.amber[100],
                      child: const Center(child: Text('Entry C')),
                    ),
                    Container(
                      height: 100,
                      color: Colors.amber[600],
                      child: const Center(child: Text('Entry A')),
                    ),
                    Container(
                      height: 100,
                      color: Colors.amber[500],
                      child: const Center(child: Text('Entry B')),
                    ),
                    Container(
                      height: 100,
                      color: Colors.amber[100],
                      child: const Center(child: Text('Entry C')),
                    ),
                    Container(
                      height: 100,
                      color: Colors.amber[600],
                      child: const Center(child: Text('Entry A')),
                    ),
                    Container(
                      height: 100,
                      color: Colors.amber[500],
                      child: const Center(child: Text('Entry B')),
                    ),
                    Container(
                      height: 100,
                      color: Colors.amber[100],
                      child: const Center(child: Text('Entry C')),
                    ),
                    Container(
                      height: 100,
                      color: Colors.amber[600],
                      child: const Center(child: Text('Entry A')),
                    ),
                    Container(
                      height: 100,
                      color: Colors.amber[500],
                      child: const Center(child: Text('Entry B')),
                    ),
                    Container(
                      height: 100,
                      color: Colors.amber[100],
                      child: const Center(child: Text('Entry C')),
                    ),
                  ],
                ),
//                color: Color(0xff000000),
              ),
            ),
          ],
        ),
      ),
    );
  }
}