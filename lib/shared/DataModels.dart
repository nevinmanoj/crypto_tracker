// To parse this JSON data, do
//
//     final coinModel = coinModelFromJson(jsonString);

import 'dart:convert';

Map<String, CoinModel> coinModelFromJson(String str) =>
    Map.from(json.decode(str))
        .map((k, v) => MapEntry<String, CoinModel>(k, CoinModel.fromJson(v)));

String coinModelToJson(Map<String, CoinModel> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class CoinModel {
  CoinModel({
    required this.baseUnit,
    required this.quoteUnit,
    required this.low,
    required this.high,
    required this.last,
    required this.type,
    required this.open,
    required this.volume,
    required this.sell,
    required this.buy,
    required this.at,
    required this.name,
  });

  String baseUnit;
  String quoteUnit;
  String low;
  String high;
  String last;
  String type;
  dynamic open;
  String volume;
  String sell;
  String buy;
  int at;
  String name;

  factory CoinModel.fromJson(Map<String, dynamic> json) => CoinModel(
        baseUnit: json["base_unit"],
        quoteUnit: json["quote_unit"],
        low: json["low"],
        high: json["high"],
        last: json["last"],
        type: json["type"],
        open: json["open"],
        volume: json["volume"],
        sell: json["sell"],
        buy: json["buy"],
        at: json["at"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "base_unit": baseUnit,
        "quote_unit": quoteUnit,
        "low": low,
        "high": high,
        "last": last,
        "type": type,
        "open": open,
        "volume": volume,
        "sell": sell,
        "buy": buy,
        "at": at,
        "name": name,
      };
}

// enum QuoteUnit { INR, BTC, USDT, WRX }

// final quoteUnitValues = EnumValues({
//   "btc": QuoteUnit.BTC,
//   "inr": QuoteUnit.INR,
//   "usdt": QuoteUnit.USDT,
//   "wrx": QuoteUnit.WRX
// });

// enum Type { SPOT }

// final typeValues = EnumValues({"SPOT": Type.SPOT});

// class EnumValues<T> {
//   Map<String, T> map;
//   Map<T, String> reverseMap = {};

//   EnumValues(this.map);

//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
// }
//******************************Data model for wallet***************************
// To parse this JSON data, do
//
//     final SellcoinModel = SellcoinModelFromJson(jsonString);

SellCoinModel SellcoinModelFromJson(String str) =>
    SellCoinModel.fromJson(json.decode(str));

String SellcoinModelToJson(SellCoinModel data) => json.encode(data.toJson());

class SellCoinModel {
  SellCoinModel({
    required this.at,
    required this.ticker,
  });

  int at;
  Ticker ticker;

  factory SellCoinModel.fromJson(Map<String, dynamic> json) => SellCoinModel(
        at: json["at"],
        ticker: Ticker.fromJson(json["ticker"]),
      );

  Map<String, dynamic> toJson() => {
        "at": at,
        "ticker": ticker.toJson(),
      };
}

class Ticker {
  Ticker({
    required this.buy,
    required this.sell,
    required this.low,
    required this.high,
    required this.last,
    required this.vol,
  });

  String buy;
  String sell;
  String low;
  String high;
  String last;
  String vol;

  factory Ticker.fromJson(Map<String, dynamic> json) => Ticker(
        buy: json["buy"],
        sell: json["sell"],
        low: json["low"],
        high: json["high"],
        last: json["last"],
        vol: json["vol"],
      );

  Map<String, dynamic> toJson() => {
        "buy": buy,
        "sell": sell,
        "low": low,
        "high": high,
        "last": last,
        "vol": vol,
      };
}

//*************************************wallet coin**********************************
WalletCoinInfo WalletCoinInfoFromJson(String str) =>
    WalletCoinInfo.fromJson(json.decode(str));

class WalletCoinInfo {
  WalletCoinInfo({
    required this.buyQty,
    required this.market,
    required this.name,
    required this.buyPrice,
  });

  double buyPrice;
  String market;
  String name;
  double buyQty;

  factory WalletCoinInfo.fromJson(Map<String, dynamic> json) => WalletCoinInfo(
        buyPrice: json["buyPrice"],
        market: json["market"],
        name: json["name"],
        buyQty: json["buyQty"],
      );

  Map<String, dynamic> toJson() => {
        "buyPrice": buyPrice,
        "market": market,
        "name": name,
        "buyQty": buyQty,
      };
}
