import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  //collection reference
  final CollectionReference Usercollection =
      FirebaseFirestore.instance.collection('UserInfo');

  Future updateUserName(String Name) async {
    return await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(uid)
        .set({
      'Name': Name,
    }, SetOptions(merge: true));
  }

  Future updateUserPhone(String PhoneNumber) async {
    return await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(uid)
        .set({
      'PhoneNumber': PhoneNumber,
    }, SetOptions(merge: true));
  }

  Future createFavoritesAndHistory() async {
    await FirebaseFirestore.instance.collection('UserInfo').doc(uid).update({
      'Favorites': [],
    });

    await FirebaseFirestore.instance.collection('UserInfo').doc(uid).update({
      'history': {},
    });
  }
}
