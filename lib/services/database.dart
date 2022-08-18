import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_tracker/shared/constants.dart';
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

  Future createWallet() async {
    // await FirebaseFirestore.instance.collection('userInfo/inventory').doc(uid).set({categories[i]:{},},SetOptions(merge: true));
    for (int i = 0; i < unit.length; i++) {
      await FirebaseFirestore.instance
          .collection('UserInfo/${uid}/Wallet')
          .doc(unit[i])
          .set({}, SetOptions(merge: true));
    }
  }
}
