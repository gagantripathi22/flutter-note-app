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
import 'dart:async';
import 'package:note_app/screens/fetchnote/fetchnote.dart';
import 'package:simple_animations/simple_animations.dart';

import '../home/home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isSignInSucess;
  Timer timer;
  bool isLoggedIn = false;

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
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);//Title 1
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  _getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getBool('isLoggedIn'));
  }

  GoogleSignInProvider provider = new GoogleSignInProvider();

  void checkLoginStatus() {
    if(provider.isSigningIn == true) {
      dispose();
      Navigator.pushReplacement (
          context,
          MaterialPageRoute(builder: (context) => FetchNoteScreen()
          ));
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => checkLoginStatus());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  handleLogin() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('Internet connected');
        provider.login();
        if(provider.isSigningIn == true) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FetchNoteScreen()
              ));
        }
      }
    } on SocketException catch (_) {
      print('Internet not connected');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
        content: Text('No internet connection'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252525),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xff252627),
          backgroundBlendMode: BlendMode.srcOver,
        ),
        child: PlasmaRenderer(
          type: PlasmaType.bubbles,
          particles: 12,
          color: Color(0x441c1c1c),
          blur: 0.16,
          size: 0.51,
          speed: 0.33,
          offset: 0,
          blendMode: BlendMode.screen,
          particleType: ParticleType.atlas,
          variation1: 0.31,
          variation2: 0.3,
          variation3: 0.13,
          rotation: 1.04,
          child: Container(
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
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 50,
                        child: Container(
                          child: Image(
                            image: AssetImage('assets/images/app-icon.png'),
                            height: 75,
                            width: 75,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 150.0),
                            child: Text(
                              "Welcome",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 12.0),
                            padding: const EdgeInsets.only(right: 50),
                            child: Text(
                              "Continue with Google account so we can sync your notes",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.5,
                                height: 1.4
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Container(

                    )
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 30, bottom: 5),
                  padding: const EdgeInsets.all(20),
//              color: Colors.lightBlue,
                  child: GestureDetector(
                    child: InkWell(
                      onTap: () {
                        handleLogin();
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        decoration: new BoxDecoration(
                          color: Color(0xff000000).withOpacity(.15),
                          border: Border.all(color: Color(0xff4f4f4f).withOpacity(.8)),
                          borderRadius: BorderRadius.circular(15),
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
                                "Continue with Google",
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
              ],
            ),
          ),
        ),
      )
    );
  }
}
