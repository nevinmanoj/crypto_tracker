import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_tracker/shared/DataModels.dart';
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

  Future addCoin(
      {required String id,
      required WalletCoinInfo Coin,
      required bool isadd}) async {
    String msg = isadd
        ? "${Coin.name} added to your wallet"
        : "${Coin.name} value edited in your wallet";
    await FirebaseFirestore.instance
        .collection('UserInfo/${uid}/Wallet')
        .doc(Coin.market)
        .set({'${id}': Coin.toJson()}, SetOptions(merge: true)).then(
            (value) => {},
            onError: (e) => msg = "Error updating document $e");

    return msg;
  }

  Future deleteItem({required String id, required String market}) async {
    String msg = "${id.toUpperCase()} deleted from your wallet";
    await FirebaseFirestore.instance
        .collection('UserInfo/${uid}/Wallet')
        .doc(market)
        .update({id: FieldValue.delete()}).then((value) => {},
            onError: (e) => msg = "Error updating document $e");
    ;
    return msg;
  }
}
