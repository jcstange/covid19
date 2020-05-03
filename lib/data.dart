class CovidData {
  final Global global;
  final List<Country> countries;
  final String date;

  CovidData({this.global, this.countries, this.date});

  factory CovidData.fromJson(Map<String, dynamic> json) {
    List<Country> countriesList = [];
    for (Map i in json['Countries']) {
      Country country = Country.fromJson(i);
      countriesList.add(country);
    }
    countriesList.sort((a, b) =>
        (b.totalConfirmed - b.totalRecovered)
            .compareTo(a.totalConfirmed - a.totalRecovered));

    countriesList = countriesList
        .where((i) => i.totalConfirmed - i.totalRecovered > 10)
        .toList();

    return CovidData(
        global: Global.fromJson(json['Global']),
        countries: countriesList,
        date: json['Date']);
  }
}

class GraphData {
  final String country;
  final int confirmed;
  final int deaths;
  final int recovered;
  final int active;
  final String date;

  GraphData({
    this.country,
    this.confirmed,
    this.deaths,
    this.recovered,
    this.active,
    this.date
  });


  factory GraphData.fromJson(dynamic json) {
    return GraphData(
        country: json['Country'],
        confirmed: json['Confirmed'],
        deaths: json['Deaths'],
        recovered: json['Recovered'],
        active: json['Active'],
        date: json['Date']
    );
  }
}

class Global {
  final int newConfirmed;
  final int totalConfirmed;
  final int newDeaths;
  final int totalDeaths;
  final int newRecovered;
  final int totalRecovered;

  Global({this.newConfirmed,
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

  Country({this.country,
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