import 'dart:io';
import 'package:flutter/material.dart';
import 'package:note_app/models/test_model.dart';
import 'package:note_app/screens/home/home.dart';
import 'package:note_app/models/customer_model.dart';
import 'package:note_app/models/database_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:note_app/services/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void initializeDatabase() async {
    final memo = Customer(
      id: 1,
      title: 'Title 1',
      note: 'Note 1',
      color: '0xffffffff',
    );

    MemoDbProvider memoDb = MemoDbProvider();
    await memoDb.addItem(memo);
  }

  void insertIntoDatabase() async {
    MemoDbProvider memoDb = MemoDbProvider();
    var memos = await memoDb.fetchMemos();
    print(memos[0].note); //Title 1
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  bool isLoggedIn = false;

  _getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getBool('isLoggedIn'));
  }

  GoogleSignInProvider provider = new GoogleSignInProvider();


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
                            color: Colors.white,
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
                            color: Colors.white,
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
//                    initializeDatabase();
//                     _logIn();
//                     final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
//                     provider.login();
                      provider.login();
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    decoration: new BoxDecoration(
//                  color: Color(0xffe8e8e8),
                      border: Border.all(color: Color(0xff4f4f4f)),
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
                              color: Colors.white,
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
            GestureDetector(
              child: InkWell(
                onTap: () {
//                  insertIntoDatabase();
//                   _logOut();
//                   print(provider.isSigningIn);
                  _getLoginStatus();
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  decoration: new BoxDecoration(
//                  color: Color(0xffe8e8e8),
                    border: Border.all(color: Color(0xff4f4f4f)),
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
                            color: Colors.white,
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
            GestureDetector(
              child: InkWell(
                onTap: () {
//                  insertIntoDatabase();
//                   _logOut();
                  provider.logout();
//                   print(provider.isSigningIn);

                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  decoration: new BoxDecoration(
//                  color: Color(0xffe8e8e8),
                    border: Border.all(color: Color(0xff4f4f4f)),
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
                            color: Colors.white,
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
          ],
        ),
      ),
    );
  }
}

//
//class LoginScreen extends StatelessWidget {
//
//}
