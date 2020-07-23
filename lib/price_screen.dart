import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedcurrency = 'USD';
  String rate;
  String crypto;

  DropdownButton androidDropDown() {
    List<DropdownMenuItem<String>> dropdownitems = [];
    for (String currency in currenciesList) {
      var newitem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownitems.add(newitem);
    }
    return DropdownButton<String>(
      value: selectedcurrency,
      items: dropdownitems,
      onChanged: (value) {
        setState(() {
          selectedcurrency = value;
          getrate();
        });
      },
    );
  }

  CupertinoPicker iospicker() {
    List<Text> scrollitems = [];
    for (String item in currenciesList) {
      scrollitems.add(Text(item));
    }
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (selectedindex) {
        print(selectedindex);
      },
      children: scrollitems,
    );
  }

  Map<String, String> coinvalues = {};
  bool waiting = false;

  void getrate() async {
    waiting = true;
    try {
      var data = await CoinData().getcoindata(selectedcurrency);
      waiting = false;
      setState(() {
        coinvalues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getrate();
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
            child: CoinCard(
              crypto: 'BTC',
              rate: waiting ? '?' : coinvalues['BTC'],
              selectedcurrency: selectedcurrency,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: CoinCard(
              selectedcurrency: selectedcurrency,
              crypto: cryptoList[1],
              rate: waiting ? '?' : coinvalues['ETH'],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: CoinCard(
              selectedcurrency: selectedcurrency,
              crypto: cryptoList[2],
              rate: waiting ? '?' : coinvalues['LTC'],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iospicker() : androidDropDown(),
          )
        ],
      ),
    );
  }
}

class CoinCard extends StatelessWidget {
  const CoinCard({
    Key key,
    @required this.rate,
    @required this.selectedcurrency,
    @required this.crypto,
  }) : super(key: key);

  final String rate;
  final String selectedcurrency;
  final String crypto;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $crypto = $rate $selectedcurrency',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
