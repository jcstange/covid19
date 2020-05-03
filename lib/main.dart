
import 'package:flutter/material.dart';

import 'UIElements.dart';
import 'country.dart';
import 'data.dart';
import 'http.dart';

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
          primaryColor: Colors.blueGrey[800]),
      home: MyHomePage(title: 'COVID-19 Updates'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
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
    refreshData();
  }

  Future<void> refreshData() async {
    Http().fetchData().then((response) {
      setState(() {
        loading = true;
      });
      print('${response.global.totalConfirmed}');
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
      appBar: AppBar(title: Text(widget.title), actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () =>
              showSearch(context: context, delegate: DataSearch(countries)),
        )
      ]),
      body: Column(children: <Widget>[
        loading
            ? Center(child: CircularProgressIndicator())
            : Container(
            child: globalData != null ? GlobalItem(globalData) : null),
        loading
            ? Center(child: CircularProgressIndicator())
            : Expanded(child: RefreshIndicator(
            child: CountriesList(countries),
            onRefresh: () => refreshData()
        )
        )
      ]),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final List<Country> countries;

  DataSearch(this.countries);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = "",)];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () => close(context, null)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
        child: Text(query)
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? countries
        : countries.where((country) =>
        country.country.toLowerCase().startsWith(query.toLowerCase())).toList();
    return CountriesList(suggestionList);
  }
}