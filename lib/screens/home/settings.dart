import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_tracker/screens/home/Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;

    return Column(
      children: [
        InkWell(
          onTap: () async {
            final curUser = await FirebaseFirestore.instance
                .collection('UserInfo')
                .doc(user!.uid)
                .get();
            String name = curUser.data()!['Name'];
            String phoneNumber = curUser.data()!['PhoneNumber'];

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profile(
                          name: name,
                          phoneNumber: phoneNumber,
                        )));
          },
          child: Container(
            color: Colors.grey[300],
            width: wt,
            height: ht * 0.06,
            child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(wt * 0.03, 0, 0, 0),
                  child: Text(
                    "Profile",
                    style: TextStyle(fontSize: 18),
                  ),
                )),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(wt * 0.01, ht * 0.005, wt * 0.01, 0),
          child: InkWell(
            onTap: () async => await _auth.signOut(),
            child: Container(
              // decoration: ,
              color: Colors.grey[300],
              width: wt,
              height: ht * 0.06,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(wt * 0.03, 0, 0, 0),
                    child: Text(
                      "Log Out",
                      style: TextStyle(fontSize: 18),
                    ),
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
