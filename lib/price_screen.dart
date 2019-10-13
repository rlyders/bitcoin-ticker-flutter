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
  double bitCountLastPrice;

  CupertinoPicker iOSPicker() {
    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {
          getData(bitcoinSymbol, currenciesList[selectedIndex]);
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
        getData(bitcoinSymbol, currency);
      },
    );
  }

  void getData(String tickerSymbol, String currency) async {
    try {
      double price = await CoinData().getCoinData(tickerSymbol, currency);
      setState(() {
        bitCountLastPrice = price;
        selectedCurrency = currency;
      });
    } catch (e) {
      throw 'Failed to get coin data: $e';
    }
  }

  @override
  void initState() {
    super.initState();
    getData(bitcoinSymbol, selectedCurrency);
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
          Padding(
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
                  '1 BTC = ${bitCountLastPrice == null ? '?' : bitCountLastPrice.toStringAsFixed(0)} $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
