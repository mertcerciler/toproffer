import 'package:flutter/material.dart';
import 'package:login/app/home/models/data_model.dart';
import 'package:login/app/services/database.dart';
import './models/sales_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'restaurant_active_campaigns.dart';

import 'campaign_creator_page.dart';

class RestaurantStatistics extends StatefulWidget {
  const RestaurantStatistics({Key key, @required this.database})
      : super(key: key);
  final Database database;

  @override
  _RestaurantStatistics createState() => _RestaurantStatistics();
}

class _RestaurantStatistics extends State<RestaurantStatistics> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
  bool monSelected;
  bool tueSelected;
  bool wedSelected;
  bool thuSelected;
  bool friSelected;
  bool satSelected;
  bool sunSelected;

  @override
  void initState() {
    monSelected = true;
    tueSelected = false;
    wedSelected = false;
    thuSelected = false;
    friSelected = false;
    satSelected = false;
    sunSelected = false;
  } 

  int _selectedIndex = 2;
  void selectGenerator(BuildContext ctx) {
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return CampaignCreatorPage(database: widget.database);
        },
      ),
    );
  }

  void selectMyCampaigns(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return RestaurantsActiveCampaigns(
            database: widget.database,
          );
        },
      ),
    );
  }

//-----------------------------------
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print("index is: $index");
      if (_selectedIndex == 1) {
        selectGenerator(context);
      } else if (_selectedIndex == 2) {
      } else if (_selectedIndex == 0) {
        selectMyCampaigns(context);
      }
    });
  }

  
  String group = '';
  int selectedDay = 1;
  String day = "Monday";
  Container _daySelectionDropdown() {
    return Container(
      alignment: Alignment(0.0, 0.0),
      child: DropdownButton<String>(
        value: day,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 35,
        elevation: 16,
        style: TextStyle(color: Colors.black87),
        underline: Container(
          height: 2,
          color: Colors.blue[200],
        ),
        onChanged: (String newDay) {
          setState(() {
            day = newDay;
            if (day == "Monday") {
              monSelected = true;
              tueSelected = false;
              wedSelected = false;
              thuSelected = false;
              friSelected = false;
              satSelected = false;
              sunSelected = false;
            }
            if (day == "Tuesday") {
              monSelected = false;
              tueSelected = true;
              wedSelected = false;
              thuSelected = false;
              friSelected = false;
              satSelected = false;
              sunSelected = false;
            }
            if (day == "Wednesday") {
              monSelected = false;
              tueSelected = false;
              wedSelected = true;
              thuSelected = false;
              friSelected = false;
              satSelected = false;
              sunSelected = false;
            }
            if (day == "Thursday") {
              monSelected = false;
              tueSelected = false;
              wedSelected = false;
              thuSelected = true;
              friSelected = false;
              satSelected = false;
              sunSelected = false;
            }
            if (day == "Friday") {
              monSelected = false;
              tueSelected = false;
              wedSelected = false;
              thuSelected = false;
              friSelected = true;
              satSelected = false;
              sunSelected = false;
            }
            if (day == "Saturday") {
              monSelected = false;
              tueSelected = false;
              wedSelected = false;
              thuSelected = false;
              friSelected = false;
              satSelected = true;
              sunSelected = false;
            }
            if (day == "Sunday") {
              monSelected = false;
              tueSelected = false;
              wedSelected = false;
              thuSelected = false;
              friSelected = false;
              satSelected = false;
              sunSelected = true;
            }
          });
        },
        items: <String>[
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
          'Sunday',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  List<String> types = [
    'Alcohol',
    'Fast Food',
    'Traditional Food',
    'International Cousine',
    'Bakery',
    'Coffee'
  ];
  List<String> hours = [
    '01:00 - 09:00',
    '09:00 - 11:00',
    '11:00 - 13:00',
    '13:00 - 15:00',
    '15:00 - 17:00',
    '17:00 - 19:00',
    '19:00 - 21:00',
    '21:00 - 23:00',
    '23:00 - 01:00'
  ];
  static DataModel d1 = new DataModel(0, 0);
  static List<DataModel> alc = [d1, d1, d1, d1, d1, d1, d1, d1, d1];
  static List<DataModel> fastFood = [d1, d1, d1, d1, d1, d1, d1, d1, d1];
  static List<DataModel> coffee = [d1, d1, d1, d1, d1, d1, d1, d1, d1];
  static List<DataModel> bakery = [d1, d1, d1, d1, d1, d1, d1, d1, d1];
  static List<DataModel> traditionalFood = [d1, d1, d1, d1, d1, d1, d1, d1, d1];
  static List<DataModel> internationalCousine = [
    d1,
    d1,
    d1,
    d1,
    d1,
    d1,
    d1,
    d1,
    d1
  ];
  static List<DataModel> breakfast = [d1, d1, d1, d1, d1, d1, d1, d1, d1];

  _getData(int day) async {
    int index = 0;
    for (var hour in hours) {
      var count = await widget.database.getUsedCampaigns(day, 'Alcohol', hour);
      DataModel d =
          new DataModel(int.parse(hour.substring(0, 2)), int.parse(count));
      alc[index] = d;
      index += 1;
    }
    index = 0;
    for (var hour in hours) {
      var count =
          await widget.database.getUsedCampaigns(day, 'Fast Food', hour);
      DataModel d =
          new DataModel(int.parse(hour.substring(0, 2)), int.parse(count));
      fastFood[index] = d;
      index += 1;
    }
    index = 0;
    for (var hour in hours) {
      var count = await widget.database.getUsedCampaigns(day, 'Coffee', hour);
      DataModel d =
          new DataModel(int.parse(hour.substring(0, 2)), int.parse(count));
      coffee[index] = d;
      index += 1;
    }
    index = 0;
    for (var hour in hours) {
      var count = await widget.database.getUsedCampaigns(day, 'Bakery', hour);
      DataModel d =
          new DataModel(int.parse(hour.substring(0, 2)), int.parse(count));
      bakery[index] = d;
      index += 1;
    }
    index = 0;
    for (var hour in hours) {
      var count =
          await widget.database.getUsedCampaigns(day, 'Traditional Food', hour);
      DataModel d =
          new DataModel(int.parse(hour.substring(0, 2)), int.parse(count));
      traditionalFood[index] = d;
      index += 1;
    }
    index = 0;
    for (var hour in hours) {
      var count = await widget.database
          .getUsedCampaigns(day, 'International Cousine', hour);
      DataModel d =
          new DataModel(int.parse(hour.substring(0, 2)), int.parse(count));
      internationalCousine[index] = d;
      index += 1;
    }
    index = 0;
    for (var hour in hours) {
      var count =
          await widget.database.getUsedCampaigns(day, 'Breakfast', hour);
      DataModel d =
          new DataModel(int.parse(hour.substring(0, 2)), int.parse(count));
      breakfast[index] = d;
      index += 1;
    }
  }

  _displayData(int day) {
    _getData(day);

    print(alc[0].count);
    List<charts.Series<DataModel, int>> series = [
      charts.Series(
          id: "Alcohol",
          data: alc,
          domainFn: (DataModel series, _) => series.hour,
          measureFn: (DataModel series, _) => series.count,
          colorFn: (DataModel series, _) =>
              charts.MaterialPalette.blue.shadeDefault),
      charts.Series(
          id: "Breakfast",
          data: breakfast,
          domainFn: (DataModel series, _) => series.hour,
          measureFn: (DataModel series, _) => series.count,
          colorFn: (DataModel series, _) =>
              charts.MaterialPalette.red.shadeDefault),
      charts.Series(
          id: "Coffee",
          data: coffee,
          domainFn: (DataModel series, _) => series.hour,
          measureFn: (DataModel series, _) => series.count,
          colorFn: (DataModel series, _) =>
              charts.MaterialPalette.green.shadeDefault),
      charts.Series(
          id: "Fast Food",
          data: fastFood,
          domainFn: (DataModel series, _) => series.hour,
          measureFn: (DataModel series, _) => series.count,
          colorFn: (DataModel series, _) =>
              charts.MaterialPalette.yellow.shadeDefault),
      charts.Series(
          id: "Trad. Food",
          data: traditionalFood,
          domainFn: (DataModel series, _) => series.hour,
          measureFn: (DataModel series, _) => series.count,
          colorFn: (DataModel series, _) =>
              charts.MaterialPalette.gray.shadeDefault),
      charts.Series(
          id: "Bakery",
          data: bakery,
          domainFn: (DataModel series, _) => series.hour,
          measureFn: (DataModel series, _) => series.count,
          colorFn: (DataModel series, _) =>
              charts.MaterialPalette.pink.shadeDefault),
      charts.Series(
          id: "Int. Cousine",
          data: internationalCousine,
          domainFn: (DataModel series, _) => series.hour,
          measureFn: (DataModel series, _) => series.count,
          colorFn: (DataModel series, _) =>
              charts.MaterialPalette.purple.shadeDefault),
    ];
    return series;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Line Chart'),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Select Day: ',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 20,
                ),
                _daySelectionDropdown(),
              ],
            ),
            Center(
              child: Container(
                height: 550,
                padding: EdgeInsets.all(10),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Sales of a company over the years",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: new charts.LineChart(
                            monSelected ?
                            _displayData(1):
                            tueSelected ? 
                            _displayData(2):
                            wedSelected ?
                            _displayData(3):
                            thuSelected ? 
                            _displayData(4):
                            friSelected ?
                            _displayData(5) :
                            satSelected ? 
                            _displayData(6):
                            sunSelected ?
                            _displayData(7):
                            _displayData(1),
                            animate: true,
                            behaviors: [
                              new charts.SeriesLegend(
                                  position: charts.BehaviorPosition.top,
                                  desiredMaxColumns: 4,
                                  entryTextStyle:
                                      charts.TextStyleSpec(fontSize: 10)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.blue,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.format_list_bulleted,
            ),
            title: Text('Campaigns'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.extension,
            ),
            title: Text('Generator'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.insert_chart,
            ),
            title: Text('Statistics'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
            ),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black54,
        onTap: _onItemTapped,
      ),
    );
  }
}
