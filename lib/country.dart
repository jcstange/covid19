
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

  List<charts.Series<GraphData, DateTime>> createActiveChartData() {
    return [ charts.Series<GraphData, DateTime>(
        id: 'confirmed',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (GraphData graphData, _) => DateTime.parse(graphData.date),
        measureFn: (GraphData graphData, _) =>
        graphData.confirmed - graphData.recovered - graphData.deaths,
        data: graphData
    )
    ];
  }

  List<charts.Series<GraphData, DateTime>> createConfimedChartData() {
    return [ charts.Series<GraphData, DateTime>(
        id: 'confirmed',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (GraphData graphData, _) => DateTime.parse(graphData.date),
        measureFn: (GraphData graphData, _) => graphData.confirmed,
        data: graphData
    )
    ];
  }

  List<charts.Series<GraphData, DateTime>> createDeathChartData() {
    return [ charts.Series<GraphData, DateTime>(
        id: 'confirmed',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (GraphData graphData, _) => DateTime.parse(graphData.date),
        measureFn: (GraphData graphData, _) => graphData.deaths,
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
              CountryItem(widget.country, false),
              loading || graphData.isEmpty
                  ? Expanded(child: Center(child: CircularProgressIndicator()))
                  : Expanded(child: Column(
                children: <Widget>[
                  TimeChart('Active Cases',createActiveChartData()),
                  TimeChart('Confirmed Cases',createConfimedChartData()),
                  TimeChart('Deaths',createDeathChartData()),
                ],
              ))
            ]
        )
    );
  }
}