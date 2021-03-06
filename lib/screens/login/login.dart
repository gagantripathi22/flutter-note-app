import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
                top: 20,
              ),
              decoration: BoxDecoration(
//                color: Colors.red,
//                image: DecorationImage(
//                  image: AssetImage('assets/images/login_banner.jpg'),
//                  fit: BoxFit.fill
//                )
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 50,
                    child: Container(
                      child: Image(
                        image: AssetImage('assets/images/app-icon.png'),
                        height: 90,
                        width: 90,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 170.0),
                        child: Text(
                          "Welcome",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        padding: const EdgeInsets.only(right: 50),
                        child: Text(
                          "Sign up with Google account so we can sync your notes",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),








            ),

            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.all(20),
//              color: Colors.lightBlue,
              child: GestureDetector(
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Welcome to Paper Note'),
                    ));
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    decoration: new BoxDecoration(
//                  color: Color(0xffe8e8e8),
                      border: Border.all(color: Color(0xffe8e8e8)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          image: AssetImage('assets/images/google-logo.png'),
                          height: 26,
                          width: 26,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            "Sign up with Google",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}