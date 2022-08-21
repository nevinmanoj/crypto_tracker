import 'package:crypto_tracker/services/ApiCalls.dart';
import 'package:crypto_tracker/shared/DataModels.dart';
import 'package:crypto_tracker/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

String curM = unit[0];

class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    return Column(
      children: [
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
                      decoration: BoxDecoration(
                          color:
                              unit[i] == curM ? Colors.green : primaryAppColor),
                      height: ht * 0.05,
                      width: wt * 0.185,
                      child: Center(
                          child: Text(
                        unit[i].toUpperCase(),
                        style: TextStyle(
                            fontSize: 18,
                            color: unit[i] == curM
                                ? primaryAppColor
                                : Colors.white),
                      )),
                    ),
                  ),
                );
              })),
        ),
        Expanded(
          child: StreamBuilder<http.Response>(
              stream: getMarketStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                Map<String, CoinModel> Coins =
                    coinModelFromJson(snapshot.data!.body);
                List<String> CoinId = Coins.keys.toList();

                // if (CoinId == null || Coins == null)
                //   return Center(
                //     child: Text("NO DATA"),
                //   );

                return ListView.builder(
                    itemCount: CoinId.length,
                    itemBuilder: ((context, index) {
                      if (Coins[CoinId[index]]!.quoteUnit != curM)
                        return Container();
                      return Padding(
                        padding: EdgeInsets.fromLTRB(0, ht * 0.005, 0, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: index % 2 == 0
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
                                    "${Coins[CoinId[index]]!.name} => ${Coins[CoinId[index]]!.sell} ${Coins[CoinId[index]]!.quoteUnit.toUpperCase()}"),
                              ],
                            ),
                          ),
                        ),
                      );
                    }));
              }),
        ),
      ],
    );
  }
}
