import 'package:crypto_tracker/services/ApiCalls.dart';
import 'package:crypto_tracker/services/database.dart';
import 'package:crypto_tracker/services/other.dart';
import 'package:crypto_tracker/shared/DataModels.dart';
import 'package:crypto_tracker/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

String coinName = "";
String coinMarket = unit[0];
String coinPrice = "";
String coinquantity = "";
List<String> Coins = [];

bool test = true;

int marketIndex() {
  int index = 0;
  if (coinMarket == 'usdt') {
    index = 1;
  } else if (coinMarket == 'wrx') {
    index = 2;
  } else if (coinMarket == 'btc') {
    index = 3;
  }
  return index;
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;

class AddCoin extends StatefulWidget {
  const AddCoin({Key? key}) : super(key: key);

  @override
  State<AddCoin> createState() => _AddCoinState();
}

class _AddCoinState extends State<AddCoin> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            setState(() {
              String coinPrice = "";
              String coinquantity = "";
            });
            Navigator.pop(context);
          },
        ),
        backgroundColor: primaryAppColor,
        centerTitle: true,
        title: Text("Add Coins"),
      ),
      body: StreamBuilder<http.Response>(
          stream: getMarketStream(),
          builder: (context, Msnapshot) {
            if (!Msnapshot.hasData)
              return Center(child: CircularProgressIndicator());

            Map<String, CoinModel> Coins =
                coinModelFromJson(Msnapshot.data!.body);
            List<String> CoinId = Coins.keys.toList();

            // Map<String, List<String>> m = getCoinNames(Coins);
            List<List<String>> ans = getCoinName(Coins);

            return Container(
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(
                      //       wt * 0.05, ht * 0.005, wt * 0.05, 0),
                      //   child: Text(
                      //     "Enter Coin Details to add",
                      //     style: TextStyle(fontSize: 20),
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            wt * 0.05, ht * 0.01, wt * 0.05, 0),
                        child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "Market/Quote unit",
                              style: textStyle,
                            )),
                      ),
                      Market(),

                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            wt * 0.05, ht * 0.005, wt * 0.05, 0),
                        child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "Coin",
                              style: textStyle,
                            )),
                      ),

                      Coin(
                        names: ans[marketIndex()],
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            wt * 0.05, ht * 0.005, wt * 0.05, 0),
                        child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "Buy Price (${coinMarket})",
                              style: textStyle,
                            )),
                      ),

                      BuyPrice(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            wt * 0.05, ht * 0.005, wt * 0.05, 0),
                        child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "Buy Quantity (${coinName.split('/')[0]})",
                              style: textStyle,
                            )),
                      ),
                      BuyQuantity(),

                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 170,
                          child: ElevatedButton(
                            onPressed: () async {
                              test = !test;
                              if (_formKey.currentState!.validate()) {
                                // Navigator.pop(context);
                                var msg = await DatabaseService(uid: user!.uid)
                                    .addCoin(
                                        id: coinName
                                            .replaceAll("/", "")
                                            .toLowerCase(),
                                        //id: coinName.toLowerCase(),

                                        Coin: WalletCoinInfo(
                                            buyPrice: double.parse(coinPrice),
                                            buyQty: double.parse(coinquantity),
                                            name: coinName,
                                            market: coinMarket));
                                // print(msg);
                                _showToast(context: context, msg: msg);
                                Navigator.pop(context);
                              }
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        primaryAppColor)),
                            child: Center(
                                child: Text("Add to Wallet",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16))),
                          ),
                        ),
                      ),
                    ],
                  )),
            );
          }),
    );
  }
}

void _showToast({required BuildContext context, required String msg}) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      backgroundColor: primaryAppColor,
      content: Text(msg),
    ),
  );
}

class Market extends StatefulWidget {
  @override
  State<Market> createState() => _MarketState();
}

class _MarketState extends State<Market> {
  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.fromLTRB(wt * 0.05, 0, wt * 0.05, ht * 0.005),
      child: DropdownButtonFormField<String>(
        value: unit[0],
        validator: (value) =>
            value!.isEmpty ? ' Must select a market for item' : null,
        decoration: InputDecoration(border: InputBorder.none),
        hint: Text(
          "Market",
          style: TextStyle(color: Colors.grey.withOpacity(0.8)),
        ),
        onChanged: (Value) {
          setState(() async {
            coinMarket = Value!;
          });
        },
        items: unit.map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

class Coin extends StatefulWidget {
  List<String> names;
  Coin({required this.names});
  @override
  State<Coin> createState() => _CoinState();
}

class _CoinState extends State<Coin> {
  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.fromLTRB(wt * 0.05, 0, wt * 0.05, ht * 0.005),
      child: DropdownButtonFormField<String>(
        value: widget.names[0],
        menuMaxHeight: ht * 0.5,
        validator: (value) => value!.isEmpty ? ' Must select a Coin' : null,
        decoration: InputDecoration(border: InputBorder.none),
        hint: Text(
          "Coin name",
          style: TextStyle(color: Colors.grey.withOpacity(0.8)),
        ),
        onChanged: (Value) {
          setState(() async {
            coinName = Value!;
          });
        },
        items: widget.names.map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

class BuyQuantity extends StatefulWidget {
  const BuyQuantity({Key? key}) : super(key: key);

  @override
  State<BuyQuantity> createState() => _BuyQuantityState();
}

class _BuyQuantityState extends State<BuyQuantity> {
  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
          height: 50,
          width: 215,
          child: Padding(
            padding: EdgeInsets.fromLTRB(wt * 0.05, 0, wt * 0.05, ht * 0.005),
            child: TextFormField(
              onChanged: (value) {
                coinquantity = value;
              },
              validator: (value) =>
                  value!.isEmpty ? 'quantity must not be null' : null,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                // border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
                hintText: 'Quantity',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BuyPrice extends StatefulWidget {
  const BuyPrice({Key? key}) : super(key: key);

  @override
  State<BuyPrice> createState() => _BuyPriceState();
}

class _BuyPriceState extends State<BuyPrice> {
  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
          height: 50,
          width: 215,
          child: Padding(
            padding: EdgeInsets.fromLTRB(wt * 0.05, 0, wt * 0.05, ht * 0.005),
            child: TextFormField(
              onChanged: (value) {
                coinPrice = value;
              },
              validator: (value) =>
                  value!.isEmpty ? 'quantity must not be null' : null,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                // border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
                hintText: 'Price',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
