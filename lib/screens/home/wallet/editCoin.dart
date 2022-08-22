import 'package:crypto_tracker/services/database.dart';
import 'package:crypto_tracker/shared/DataModels.dart';
import 'package:crypto_tracker/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String buyQty = "";
String buyPrice = "";

final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;

class EditItem extends StatefulWidget {
  Map<String, dynamic> coin;

  EditItem({required this.coin});
  @override
  State<EditItem> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<EditItem> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                var textStyle = TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                );
                return Center(
                    child: SizedBox(
                  height: ht * 0.9,
                  child: AlertDialog(
                    insetPadding: EdgeInsets.fromLTRB(
                      0,
                      0,
                      0,
                      ht * 0.1,
                    ),
                    title: Center(child: Text("Enter New Quantity ")),
                    content: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
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
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      wt * 0.05, ht * 0.005, wt * 0.05, 0),
                                  child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        "Coin: ${widget.coin['name'].toString().split("/")[0]}  Market:${widget.coin['name'].toString().split("/")[1]}",
                                        style: textStyle,
                                      )),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    wt * 0.05, ht * 0.005, wt * 0.05, 0),
                                child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "Buy Price (${widget.coin['name'].toString().split("/")[1]})",
                                      style: textStyle,
                                    )),
                              ),

                              newBuyPrice(),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    wt * 0.05, ht * 0.005, wt * 0.05, 0),
                                child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "Buy Quantity (${widget.coin['name'].toString().split("/")[0]})",
                                      style: textStyle,
                                    )),
                              ),
                              newBuyQuantity(),
                              SizedBox(
                                height: 5,
                              ),

                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 150,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        // Navigator.pop(context);
                                        var msg = await DatabaseService(
                                                uid: user!.uid)
                                            .addCoin(
                                                isadd: false,
                                                id: widget.coin['name']
                                                    .toString()
                                                    .replaceAll("/", "")
                                                    .toLowerCase(),
                                                //id: coinName.toLowerCase(),

                                                Coin: WalletCoinInfo(
                                                    buyPrice:
                                                        double.parse(buyPrice),
                                                    buyQty:
                                                        double.parse(buyQty),
                                                    name: widget.coin['name']
                                                        .toString(),
                                                    market: widget.coin['name']
                                                        .toString()
                                                        .split("/")[1]
                                                        .toLowerCase()));
                                        // print(msg);
                                        _showToast(context: context, msg: msg);

                                        Navigator.pop(context);
                                      }
                                    },
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
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
                          ),
                        )),
                  ),
                ));
              });
        },
        icon: Icon(
          color: primaryAppColor,
          Icons.edit,
        ));
  }
}

void _showToast({required BuildContext context, required String msg}) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      duration: Duration(seconds: 2),
      backgroundColor: primaryAppColor,
      content: Text(msg),
    ),
  );
}

class newBuyQuantity extends StatefulWidget {
  const newBuyQuantity({Key? key}) : super(key: key);

  @override
  State<newBuyQuantity> createState() => _newBuyQuantityState();
}

class _newBuyQuantityState extends State<newBuyQuantity> {
  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    return Container(
      // height: 50,
      // width: 215,
      child: Padding(
        padding: EdgeInsets.fromLTRB(wt * 0.05, 0, wt * 0.05, ht * 0.005),
        child: TextFormField(
          onChanged: (value) {
            buyQty = value;
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
    );
  }
}

class newBuyPrice extends StatefulWidget {
  @override
  State<newBuyPrice> createState() => _newBuyPriceState();
}

class _newBuyPriceState extends State<newBuyPrice> {
  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    return Container(
      // height: 50,
      // width: 220,
      child: Padding(
        padding: EdgeInsets.fromLTRB(wt * 0.05, 0, wt * 0.05, ht * 0.005),
        child: TextFormField(
          onChanged: (value) {
            buyPrice = value;
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
    );
  }
}
