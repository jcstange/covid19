
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'UIElements.dart';
import 'data.dart';
import 'http.dart';

class CountryPage extends StatefulWidget {
  CountryPage({Key key, this.country}) : super(key: key);

  final Country country;

  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  List<GraphData> graphData = [];
  var loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreshData();
  }

  Future<void> refreshData() async {
    Http().fetchGraphData(widget.country.country).then((response) {
      setState(() {
        loading = true;
      });
      graphData = response;
      loading = false;
    });
  }

  List<charts.Series<GraphData,DateTime>> createChartData() {
    return [ charts.Series<GraphData, DateTime>(
          id: 'confirmed',
          colorFn: (_,__) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (GraphData graphData, _) => DateTime.parse(graphData.date),
          measureFn: (GraphData graphData, _) => graphData.confirmed - graphData.recovered - graphData.deaths,
          data: graphData
      )
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.country.country),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              CountryItem(widget.country),
              loading ? Center(child: CircularProgressIndicator())
                  : Expanded(
                  flex: 9,
                  child: graphData.isNotEmpty
                      ? charts.TimeSeriesChart(createChartData(),animate: true)
                      : Center(child: CircularProgressIndicator()),
              ),
              loading ? Center(child: CircularProgressIndicator())
                  : Expanded(
                  flex: 1,
                  child:Container(
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blueGrey[900],
                    ),
                  child: Center(child: Text(
                      'Confirmed Cases - Solved Cases',
                      style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey[400]
                      ),
              ))
              ))
            ]
        )
    );
  }
}
