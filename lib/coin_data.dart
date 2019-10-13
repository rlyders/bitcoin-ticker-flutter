import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'secret_key.dart';
import 'package:crypto/crypto.dart';

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
      String cryptoCsv = cryptoList.join(',');
      String requestUrl =
          '$bitcoinAverageUrl/short?crypto=$cryptoCsv&fiat=$currency';

      String publicKey = 'YTYzMzZlYzM0MjJjNGQzNmEzZmQwMjI4MzBhMjZkMmI';
      int timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
      String payload = '$timestamp.$publicKey';

      Hmac hmacSha256 =
          new Hmac(sha256, convert.utf8.encode(secret_key)); // HMAC-SHA256
      String hexHash =
          hmacSha256.convert(convert.utf8.encode(payload)).toString();

      String signature = '$payload.$hexHash';

      // X-ba-key: YTYzMzZlYzM0MjJjNGQzNmEzZmQwMjI4MzBhMjZkMmI
      http.Response response =
          await client.get(requestUrl, headers: {'X-Signature': signature});
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        for (String ticker in cryptoList)
          tickers.add(TickerData(
              ticker, jsonResponse['$ticker$currency']['last'].round()));
      } else {
        throw 'Failed to get latest price: ${response.statusCode}';
      }
    } finally {
      client.close();
    }
    return tickers;
  }
}

//main() async {
//  CoinData()
//      .getCoinData(cryptoList, currenciesList[0])
//      .then((data) => print('response: $data.'));
//}
