import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

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

const String bitcoinAverageUrl =
    'https://apiv2.bitcoinaverage.com/indices/global/ticker';

const String bitcoinSymbol = 'BTC';

class CoinData {
  Future<double> getCoinData(String symbol, String currency) async {
    var client = new http.Client();
    double lastPrice = 0;
    try {
      String requestUrl = '$bitcoinAverageUrl/$symbol$currency';
      http.Response response = await client.get(requestUrl);
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        lastPrice = jsonResponse['last'];
      } else {
        throw 'Failed to get latest price: ${response.statusCode}';
      }
    } finally {
      client.close();
    }
    return lastPrice;
  }
}

main() async {
  CoinData()
      .getCoinData(bitcoinSymbol, currenciesList[0])
      .then((lastPrice) => print('Last price: $lastPrice.'));
}
