import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_tracker/services/ApiCalls.dart';
import 'package:crypto_tracker/shared/DataModels.dart';
// import 'package:crypto_tracker/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;

class TotalWallet extends StatefulWidget {
  const TotalWallet({Key? key}) : super(key: key);

  @override
  State<TotalWallet> createState() => _TotalWalletState();
}

class _TotalWalletState extends State<TotalWallet> {
  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.fromLTRB(wt * 0.02, ht * 0.01, wt * 0.02, 0),
      child: Container(
        height: ht * 0.1,
        padding: EdgeInsets.fromLTRB(0, ht * 0.01, 0, 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.grey[300]),
        child: Column(children: [
          Row(
            children: [
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
              Spacer(),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    wt * 0.005, ht * 0.01, wt * 0.05, ht * 0.001),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Total P/L",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[700]),
                  ),
                ),
              ),
            ],
          ),
          WalletValue(),
        ]),
      ),
    );
  }
}

class WalletValue extends StatefulWidget {
  const WalletValue({Key? key}) : super(key: key);

  @override
  State<WalletValue> createState() => _WalletValueState();
}

class _WalletValueState extends State<WalletValue> {
  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("UserInfo/${user!.uid}/Wallet")
            .snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            print('Something went wrong with document stream');
            return Container();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          Map<String, Map<String, dynamic>> wCoins = {};
          for (int i = 0; i < 4; i++) {
            wCoins['${snapshot.data!.docs[i].id}'] =
                snapshot.data!.docs[i].data() as Map<String, dynamic>;
          }
          List<String> Markets = wCoins.keys.toList();

          return StreamBuilder<http.Response>(
              stream: getMarketStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                double liveWalletValue = 0;
                double plValue = 0;
                Map<String, CoinModel> MCoins =
                    coinModelFromJson(snapshot.data!.body);
                List<String> MCoinId = MCoins.keys.toList();
                for (int i = 0; i < Markets.length; i++) {
                  List wCoinId = wCoins[Markets[i]]!.keys.toList();
                  for (int k = 0; k < wCoinId.length; k++) {
                    plValue += wCoins[Markets[i]]![wCoinId[k]]['buyQty'] *
                        wCoins[Markets[i]]![wCoinId[k]]['buyPrice'];

                    liveWalletValue += double.parse(MCoins[wCoinId[k]]!.last) *
                        wCoins[Markets[i]]![wCoinId[k]]['buyQty'];
                  }
                }

                liveWalletValue =
                    double.parse(liveWalletValue.toStringAsFixed(3));

                plValue = liveWalletValue - plValue;
                plValue = double.parse(plValue.toStringAsFixed(3));
                return Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          wt * 0.05, ht * 0.001, wt * 0.005, ht * 0.01),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "${liveWalletValue} Rs",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          wt * 0.005, ht * 0.001, wt * 0.05, ht * 0.01),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "${plValue} Rs",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: plValue < 0 ? Colors.red : Colors.green),
                        ),
                      ),
                    ),
                  ],
                );

                ;
              });
        }));
  }
}
