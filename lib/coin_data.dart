import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];
const url = 'https://rest.coinapi.io/v1/exchangerate';
const apikey = '6691DF79-19D3-426E-943C-E6757A541CE3';

class CoinData {
  Future getcoindata(String currency) async {
    Map<String, String> cryptoprices = {};
    for (String crypto in cryptoList) {
      String finalurl = '$url/$crypto/$currency?apikey=$apikey';
      http.Response response = await http.get(finalurl);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        double rate = data['rate'];
        cryptoprices[crypto] = rate.toStringAsFixed(0);
      } else
        print(response.statusCode);
    }
    return cryptoprices;
  }
}
