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
  QuoteUnit? quoteUnit;
  String low;
  String high;
  String last;
  Type? type;
  dynamic open;
  String volume;
  String sell;
  String buy;
  int at;
  String name;

  factory CoinModel.fromJson(Map<String, dynamic> json) => CoinModel(
        baseUnit: json["base_unit"],
        quoteUnit: quoteUnitValues.map[json["quote_unit"]],
        low: json["low"],
        high: json["high"],
        last: json["last"],
        type: typeValues.map[json["type"]],
        open: json["open"],
        volume: json["volume"],
        sell: json["sell"],
        buy: json["buy"],
        at: json["at"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "base_unit": baseUnit,
        "quote_unit": quoteUnitValues.reverse[quoteUnit],
        "low": low,
        "high": high,
        "last": last,
        "type": typeValues.reverse[type],
        "open": open,
        "volume": volume,
        "sell": sell,
        "buy": buy,
        "at": at,
        "name": name,
      };
}

enum QuoteUnit { INR, BTC, USDT, WRX }

final quoteUnitValues = EnumValues({
  "btc": QuoteUnit.BTC,
  "inr": QuoteUnit.INR,
  "usdt": QuoteUnit.USDT,
  "wrx": QuoteUnit.WRX
});

enum Type { SPOT }

final typeValues = EnumValues({"SPOT": Type.SPOT});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap = {};

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
