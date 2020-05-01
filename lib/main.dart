import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COVID-19',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'COVID-19 Updates'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Global globalData;
  List<Country> countries = [];

  var loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Http().fetchData().then((response) {
      setState(() {
        loading = true;
      });
      globalData = response.global;
      countries = response.countries;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(children: <Widget>[
          loading
              ? Center(child: CircularProgressIndicator())
              : GlobalItem(globalData),
          loading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: countries.length,
                      itemBuilder: (BuildContext context, int i) {
                        return CountryItem(countries[i]);
                      })),
        ]),
      ),
    );
  }
}

/*
* Data Elements
* */
class Http {
  Future<CovidData> fetchData() async {
    final response = await http.get('https://api.covid19api.com/summary');
    print('httpResponse: ${response.statusCode}');
    if (response.statusCode == 200) {
      return CovidData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load CovidData');
    }
  }
}

class CovidData {
  final Global global;
  final List<Country> countries;
  final String date;

  CovidData({this.global, this.countries, this.date});

  factory CovidData.fromJson(Map<String, dynamic> json) {
    List<Country> countriesList = [];
    for (Map i in json['Countries']) {
      Country country = Country.fromJson(i);
      print("Country: ${country.country}");
      countriesList.add(country);
    }
    //countriesList.sort((a,b) =>
    //    (a.totalConfirmed-a.totalRecovered).compareTo(b.totalConfirmed-b.totalRecovered)
    //);
    return CovidData(
        global: Global.fromJson(json['Global']),
        countries: countriesList,
        date: json['Date']);
  }
}

class Global {
  final int newConfirmed;
  final int totalConfirmed;
  final int newDeaths;
  final int totalDeaths;
  final int newRecovered;
  final int totalRecovered;

  Global(
      {this.newConfirmed,
      this.totalConfirmed,
      this.newDeaths,
      this.totalDeaths,
      this.newRecovered,
      this.totalRecovered});

  factory Global.fromJson(Map<String, dynamic> json) {
    return Global(
      newConfirmed: json['NewConfirmed'],
      totalConfirmed: json['TotalConfirmed'],
      newDeaths: json['NewDeaths'],
      totalDeaths: json['TotalDeaths'],
      newRecovered: json['NewRecovered'],
      totalRecovered: json['TotalRecovered'],
    );
  }
}

class Country {
  final String country;
  final String countryCode;
  final String slug;
  final int newConfirmed;
  final int totalConfirmed;
  final int newDeaths;
  final int totalDeaths;
  final int newRecovered;
  final int totalRecovered;
  final String date;

  Country(
      {this.country,
      this.countryCode,
      this.slug,
      this.newConfirmed,
      this.totalConfirmed,
      this.newDeaths,
      this.totalDeaths,
      this.newRecovered,
      this.totalRecovered,
      this.date});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
        country: json['Country'],
        countryCode: json['CountryCode'],
        slug: json['Slug'],
        newConfirmed: json['NewConfirmed'],
        totalConfirmed: json['TotalConfirmed'],
        newDeaths: json['NewDeaths'],
        totalDeaths: json['TotalDeaths'],
        newRecovered: json['NewRecovered'],
        totalRecovered: json['TotalRecovered'],
        date: json['Date']);
  }
}

/*
* End Data Elements
* */

/*
* Ui Elements
* */
class DataItem extends StatelessWidget {
  final String title;
  final int data;

  DataItem(this.title, this.data);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        SizedBox(
          width: 0.25 * MediaQuery.of(context).size.width,
          child: Container(
            color: Colors.blueGrey[200],
            child: Text(title,
                style: TextStyle(fontSize: 12, color: Colors.white)),
          ),
        ),
        SizedBox(
          width: 0.25 * MediaQuery.of(context).size.width,
          child: Container(
              color: Colors.blueGrey[200],
              child: Text('$data',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                  textAlign: TextAlign.end)),
        )
      ],
    );
  }
}

class GlobalItem extends StatelessWidget {
  final Global globalData;

  GlobalItem(this.globalData);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        SizedBox(
          width: 0.5 * MediaQuery.of(context).size.width,
          height: (84).toDouble(),
          child: Container(
            color: Colors.blueGrey[200],
            child: Center(
              child: Text('Global ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ),
        Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              DataItem('New Confirmed: ', globalData.newConfirmed),
              DataItem('Total Confirmed: ', globalData.totalConfirmed),
              DataItem('New Deaths: ', globalData.newDeaths),
              DataItem('Total Deaths: ', globalData.totalDeaths),
              DataItem('New Recovered: ', globalData.newRecovered),
              DataItem('Total Recovered: ', globalData.totalRecovered)
            ]),
      ],
    );
  }
}

class CountryItem extends StatelessWidget {
  final Country countryData;

  CountryItem(this.countryData);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          width: 0.5 * MediaQuery.of(context).size.width,
          height: (84).toDouble(),
          child: Container(
            color: Colors.blueGrey[200],
            child: Center(
              child: Text('${countryData.country} ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.red[300])),
            ),
          ),
        ),
        Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              DataItem('New Confirmed: ', countryData.newConfirmed),
              DataItem('Total Confirmed: ', countryData.totalConfirmed),
              DataItem('New Deaths: ', countryData.newDeaths),
              DataItem('Total Deaths: ', countryData.totalDeaths),
              DataItem('New Recovered: ', countryData.newRecovered),
              DataItem('Total Recovered: ', countryData.totalRecovered)
            ]),
      ],
    );
  }
}

/*
* End Ui Elements
* */
