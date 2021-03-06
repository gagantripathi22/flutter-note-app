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
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: new BoxDecoration(
                        color: Color(0xff3b3b3b),
//                        border: Border.all(color: Color(0xffe8e8e8)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image(
                        image: AssetImage('assets/images/app-icon.png'),
                        color: Colors.red,
                        height: 26,
                        width: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(

//                color: Color(0xff000000),
              ),
            ),
          ],
        ),
      ),
    );
  }
}