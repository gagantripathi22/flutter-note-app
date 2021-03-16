import 'package:flutter/material.dart';
import 'package:note_app/models/database_helper.dart';
import 'package:note_app/screens/home/home.dart';
import 'package:note_app/screens/login/login.dart';
import 'package:note_app/screens/note/note.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
//import 'package:note_app/models/customer_model.dart';
//import 'package:note_app/models/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  MemoDbProvider memoDb = MemoDbProvider();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo',
      theme: ThemeData(
//        textTheme: Theme.of(context).textTheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    );
  }
}