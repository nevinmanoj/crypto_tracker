import 'package:crypto_tracker/shared/DataModels.dart';

// Map<String,Map<String, CoinModel>> mapBasedOnMarket(Map<String, CoinModel> Coins){
//   Map<String,Map<String, CoinModel>> ans={};
//   List Ckeys=Coins.keys.toList();
//   for(int i=0;i<Ckeys.length;i++){

//     ans[Coins[Ckeys[i]]!.quoteUnit]
//   }

//   return ans;
// }
Map<String, List<String>> getCoinNames(Map<String, CoinModel> Coins) {
  List Ckeys = Coins.keys.toList();
  Map<String, List<String>> ans = {};

  for (int i = 0; i < Ckeys.length; i++) {
    if (ans['${Coins[Ckeys[i]]!.quoteUnit}'] == null) {
      ans['${Coins[Ckeys[i]]!.quoteUnit}'] = [];
    }

    ans['${Coins[Ckeys[i]]!.quoteUnit}']?.add(Coins[Ckeys[i]]!.name);
  }

  return ans;
}

//0->inr,1->usdt,2->wrx,3->btc
List<List<String>> getCoinName(Map<String, CoinModel> Coins) {
  List Ckeys = Coins.keys.toList();
  List<List<String>> ans = [[], [], [], []];

  for (int i = 0; i < Ckeys.length; i++) {
    if (Coins[Ckeys[i]]!.quoteUnit == 'inr') {
      ans[0].add(Coins[Ckeys[i]]!.name);
    } else if (Coins[Ckeys[i]]!.quoteUnit == 'usdt') {
      ans[1].add(Coins[Ckeys[i]]!.name);
    } else if (Coins[Ckeys[i]]!.quoteUnit == 'wrx') {
      ans[2].add(Coins[Ckeys[i]]!.name);
    } else if (Coins[Ckeys[i]]!.quoteUnit == 'btc') {
      ans[3].add(Coins[Ckeys[i]]!.name);
    }
  }
  for (int i = 0; i < 4; i++) {
    ans[i].sort();
  }
  return ans;
}
