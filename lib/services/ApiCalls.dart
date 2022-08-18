import 'package:crypto_tracker/shared/DataModels.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future getCurrencies() async {
  var apiUrl = 'https://api.wazirx.com/api/v2/tickers';
  var url = Uri.parse(apiUrl);
  var response = await http.get(url);

  //  Map <String,CoinModel> coindata = coinModelFromJson(response);
  Map<String, CoinModel> model = coinModelFromJson(response.body);
  // List _model = userModelFromJson(response.body);
  // print(model);

  return model;
}

Stream<http.Response> getMarketStream() async* {
  yield* Stream.periodic(Duration(milliseconds: 500), (_) async {
    var apiUrl = 'https://api.wazirx.com/api/v2/tickers';
    var url = Uri.parse(apiUrl);
    var response = await http.get(url);
    return response;
  }).asyncMap((event) async => await event);
}
