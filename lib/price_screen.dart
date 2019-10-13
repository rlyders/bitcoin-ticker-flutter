import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = currenciesList[0];
  List<TickerData> tickerList;

  initData() {
    tickerList = cryptoList.map((crypto) => TickerData(crypto, null)).toList();
  }

  CupertinoPicker iOSPicker() {
    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {
          getData(currenciesList[selectedIndex]);
        },
        children: currenciesList.map((c) => Text(c)).toList());
  }

  DropdownButton<String> androidDropdown() {
    return DropdownButton<String>(
      value: selectedCurrency,
      items: currenciesList
          .map((c) => DropdownMenuItem(
                child: Text(c),
                value: c,
              ))
          .toList(),
      onChanged: (currency) {
        getData(currency);
      },
    );
  }

  void getData(String currency) async {
    try {
      setState(() {
        initData();
        selectedCurrency = currency;
      });
      List<TickerData> tickers =
          await CoinData().getCoinData(cryptoList, currency);
      setState(() {
        tickerList = tickers;
      });
    } catch (e) {
      throw 'Failed to get coin data: $e';
    }
  }

  Widget getTickerSymbolWidget(TickerData ticker) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 ${ticker.symbol} = ${ticker.price == null ? '?' : ticker.price} $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getData(selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                getTickerSymbolWidget(tickerList[0]),
                getTickerSymbolWidget(tickerList[1]),
                getTickerSymbolWidget(tickerList[2]),
              ],
            ),
            Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? iOSPicker() : androidDropdown(),
            )
          ]),
    );
  }
}
