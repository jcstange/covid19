import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'country.dart';
import 'data.dart';

class CountriesList extends StatelessWidget {
  final List list;

  CountriesList(this.list);

  @override
  build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (BuildContext context, int i) {
        return CountryItem(list[i], true);
      },
    );
  }
}

class DataItem extends StatelessWidget {
  final String title;
  final int data;
  final int delta;

  DataItem(this.title, this.data, this.delta);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: 40,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: Text(title,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey[400])),
                ),
              ),
              Expanded(
                flex: 30,
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: Text('$data',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.green),
                        textAlign: TextAlign.end)),
              ),
              Expanded(
                flex: 10,
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: Text(' + ',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.grey[400]),
                        textAlign: TextAlign.center)),
              ),
              Expanded(
                flex: 20,
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: Text('$delta',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.red),
                        textAlign: TextAlign.start)),
              )
            ]));
  }
}

class GlobalItem extends StatelessWidget {
  final Global globalData;

  GlobalItem(this.globalData);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blueGrey[900],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              flex: 55,
              child: Container(
                child: Center(
                  child: Text('Global ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey[400])),
                ),
              ),
            ),
            Expanded(
                flex: 45,
                child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        DataItem('Confirmed: ', globalData.totalConfirmed,
                            globalData.newRecovered),
                        DataItem('Deaths: ', globalData.totalDeaths,
                            globalData.newDeaths),
                        DataItem('Recovered: ', globalData.totalRecovered,
                            globalData.newRecovered)
                      ]),
                ))
          ],
        ));
  }
}

class CountryItem extends StatelessWidget {
  final Country countryData;
  final bool isClickable;
  CountryItem(this.countryData,this.isClickable);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          if(isClickable) Navigator.push(context, MaterialPageRoute(builder: (context) =>
              CountryPage(country: countryData)
          ));
        },
        child: Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.blueGrey[900],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  flex: 55,
                  child: Container(
                    child: Center(
                      child: Text('${countryData.country} ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.grey[400])),
                    ),
                  ),
                ),
                Expanded(
                    flex: 45,
                    child: Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            DataItem('Confirmed: ', countryData.totalConfirmed,
                                countryData.newConfirmed),
                            DataItem('Deaths: ', countryData.totalDeaths,
                                countryData.newDeaths),
                            DataItem('Recovered: ', countryData.totalRecovered,
                                countryData.newRecovered)
                          ]),
                    ))
              ],
            )));
  }
}


class TimeChart extends StatelessWidget {
  final String title;
  final List<charts.Series<GraphData, DateTime>> data;

  TimeChart(this.title, this.data);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
            children: <Widget> [
              Expanded(
                  flex: 75,
                  child: charts.TimeSeriesChart(data, animate: true)
              ),  Expanded(flex: 25, child:Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blueGrey[900],
                  ), child: Center(child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey[400]
                  )
              ))
              ))]
        ));
  }
}
