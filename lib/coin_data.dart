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

class TickerData {
  TickerData(this.symbol, this.price);
  String symbol;
  int price;
}

class CoinData {
  Future<List<TickerData>> getCoinData(
      List<String> tickerSymbols, String currency) async {
    List<TickerData> tickers = [];
    var client = new http.Client();
    try {
      for (String tickerSymbol in tickerSymbols) {
        int lastPrice;
        String requestUrl = '$bitcoinAverageUrl/$tickerSymbol$currency';
        http.Response response = await client.get(requestUrl);
        if (response.statusCode == 200) {
          var jsonResponse = convert.jsonDecode(response.body);
          lastPrice = jsonResponse['last'].round();
          tickers.add(TickerData(tickerSymbol, lastPrice));
        } else {
          throw 'Failed to get latest price: ${response.statusCode}';
        }
      }
    } finally {
      client.close();
    }
    return tickers;
  }
}
//
//main() async {
//  CoinData()
//      .getCoinData(bitcoinSymbol, currenciesList[0])
//      .then((lastPrice) => print('Last price: $lastPrice.'));
//}
