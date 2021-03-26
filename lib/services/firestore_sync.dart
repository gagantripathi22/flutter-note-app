import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/models/database_helper.dart';

class FirestoreSync {
  getLocalDatabase() async {
    MemoDbProvider memoDb = new MemoDbProvider();
    return await memoDb.getAllNotes();
  }
}