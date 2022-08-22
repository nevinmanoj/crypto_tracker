import 'package:crypto_tracker/services/database.dart';
import 'package:crypto_tracker/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;

class DeleteItem extends StatefulWidget {
  String id;
  String market;
  DeleteItem({required this.id, required this.market});
  @override
  State<DeleteItem> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DeleteItem> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Center(
                    child: SizedBox(
                  width: wt * 0.9,
                  height: ht * 0.35,
                  child: AlertDialog(
                      insetPadding: EdgeInsets.fromLTRB(
                        0,
                        0,
                        0,
                        ht * 0.1,
                      ),
                      title: Center(
                          child: Text(
                        "Delete Item",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      content: Column(children: [
                        Text("Press Confirm to delete this item."),
                        SizedBox(
                          height: ht * 0.04,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: ht * 0.05,
                              width: wt * 0.3,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    String msg =
                                        await DatabaseService(uid: user!.uid)
                                            .deleteItem(
                                                id: widget.id,
                                                market: widget.market);
                                    _showToast(context: context, msg: msg);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Confirm',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              primaryAppColor))),
                            ),
                            SizedBox(
                              width: wt * 0.025,
                            ),
                            SizedBox(
                              height: ht * 0.05,
                              width: wt * 0.3,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: primaryAppColor, fontSize: 16),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color.fromARGB(
                                                  236, 255, 255, 255)))),
                            ),
                          ],
                        ),
                      ])),
                ));
              });
        },
        icon: Icon(
          Icons.delete,
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
