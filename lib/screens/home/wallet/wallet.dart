import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_tracker/screens/home/Profile.dart';
import 'package:crypto_tracker/screens/home/wallet/addPage.dart';
import 'package:crypto_tracker/screens/home/wallet/components/totalWallet.dart';
import 'package:crypto_tracker/screens/home/wallet/deleteCoin.dart';
import 'package:crypto_tracker/screens/home/wallet/editCoin.dart';
import 'package:crypto_tracker/services/ApiCalls.dart';
import 'package:crypto_tracker/services/database.dart';
import 'package:crypto_tracker/shared/DataModels.dart';
import 'package:crypto_tracker/shared/constants.dart';
import 'package:crypto_tracker/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

List<double> curValues = [];
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
    bool test = true;
    return Column(
      children: [
        TotalWallet(),
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
            builder: (context, Wsnapshot) {
              if (Wsnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Center(child: CircularProgressIndicator()),
                );
                // return Container();
              }
              walletValue = 0;
              Map<String, dynamic> wC =
                  Wsnapshot.data!.data() as Map<String, dynamic>;
              // print(Wsnapshot.data);
              // WalletCoinInfo walletCoin = WalletCoinInfo(buyQty: , market: market, name: name, buyPrice: buyPrice);

              List wCoinId = wC.keys.toList();

              return Expanded(
                child: ListView.builder(
                    // shrinkWrap: true,
                    itemCount: wCoinId.length,
                    itemBuilder: ((context, j) {
                      return StreamBuilder<http.Response>(
                          stream: getCoinStream(id: wCoinId[j]),
                          builder: (context, Msnapshot) {
                            if (!Msnapshot.hasData) {
                              // return Center(child: CircularProgressIndicator());
                              if (test) {
                                test = false;
                                return Center(child: WalletLoading());
                              }
                              return Container();
                            }

                            SellCoinModel liveCoin =
                                SellcoinModelFromJson(Msnapshot.data!.body);

                            return Padding(
                              padding: EdgeInsets.fromLTRB(0, ht * 0.005, 0, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: j % 2 == 0
                                      ? Colors.grey[100]
                                      : Colors.grey[200],
                                  // borderRadius: BorderRadius.circular(10)
                                ),
                                height: ht * 0.1,
                                width: wt,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      wt * 0.05, ht * 0.005, wt * 0.05, 0),
                                  child: Row(
                                    children: [
                                      Text(
                                          "${wC[wCoinId[j]]['name']}: ${wC[wCoinId[j]]['buyQty']} at ${liveCoin.ticker.last} ${wC[wCoinId[0]]['name'].toString().split("/")[1]}"),
                                      Spacer(),
                                      EditItem(coin: wC[wCoinId[j]]),
                                      DeleteItem(id: wCoinId[j], market: curM),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    })),
              );
            })
      ],
    );
  }
}

class CustomFABwindow extends StatelessWidget {
  const CustomFABwindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: Duration(milliseconds: 500),
      closedShape: CircleBorder(),
      transitionType: ContainerTransitionType.fadeThrough,
      closedBuilder: (context, OpenContainer) => Container(
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: primaryAppColor),
        height: 50,
        width: 50,
        child: Icon(
          Icons.add,
          color: secondaryAppColor,
        ),
      ),
      openBuilder: (context, action) => AddCoin(),
    );
  }
}
