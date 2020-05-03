
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'data.dart';

class Http {
  Future<CovidData> fetchData() async {
    final response = await http.get('https://api.covid19api.com/summary');
    if (response.statusCode == 200) {
      return CovidData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load CovidData');
    }
  }

  Future<List<GraphData>> fetchGraphData(String country) async {
    final response = await http.get(
        'https://api.covid19api.com/total/dayone/country/$country'
    );
    if (response.statusCode == 200) {
      List<GraphData> graphDataList = [];
      for(Map i in json.decode(response.body)) {
        GraphData graphData = GraphData.fromJson(i);
        graphDataList.add(graphData);
      }
      return graphDataList;
    } else {
      throw Exception('Failed getting graph data');
    }
  }
}