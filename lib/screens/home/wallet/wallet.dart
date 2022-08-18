import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_tracker/services/ApiCalls.dart';
import 'package:crypto_tracker/shared/DataModels.dart';
import 'package:crypto_tracker/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

String curM = unit[0];
double walletValue = 3000;
final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(wt * 0.02, ht * 0.01, wt * 0.02, 0),
          child: Container(
            height: ht * 0.1,
            padding: EdgeInsets.fromLTRB(0, ht * 0.01, 0, 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[300]),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    wt * 0.05, ht * 0.01, wt * 0.005, ht * 0.001),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Total Portfolio Value",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[700]),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    wt * 0.05, ht * 0.001, wt * 0.005, ht * 0.01),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "${walletValue} Rs",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ]),
          ),
        ),
        SizedBox(
          width: wt,
          height: ht * 0.06,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: unit.length,
              itemBuilder: ((context, i) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                      wt * 0.05, ht * 0.01, wt * 0.005, ht * 0.01),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        curM = unit[i];
                      });
                    },
                    child: Container(
                      child: Center(
                          child: Text(
                        unit[i].toUpperCase(),
                        style: TextStyle(
                            fontSize: 18,
                            color: unit[i] == curM
                                ? primaryAppColor
                                : Colors.white),
                      )),
                      decoration: BoxDecoration(
                          color:
                              unit[i] == curM ? Colors.green : primaryAppColor),
                      height: ht * 0.05,
                      width: wt * 0.185,
                    ),
                  ),
                );
              })),
        ),
        StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('UserInfo/${user!.uid}/Wallet')
                .doc(curM)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              dynamic Coins = snapshot.data!.data() as Map<String, dynamic>;

              return Container();
            })
      ],
    );
  }
}
