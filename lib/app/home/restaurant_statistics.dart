import 'package:flutter/material.dart';
import 'package:login/app/services/database.dart';
import './models/sales_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'campaign_creator_page.dart';

class RestaurantStatistics extends StatefulWidget {
  const RestaurantStatistics({Key key, this.database}) : super(key: key);
  final Database database;

  @override
  _RestaurantStatistics createState() => _RestaurantStatistics();
}

class _RestaurantStatistics extends State<RestaurantStatistics> {
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

  void selectHistory(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return RestaurantStatistics();
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
        selectHistory(context);
      } else if (_selectedIndex == 3) {}
    });
  }

  // Defining the data
  final data = [
    new SalesData(0, 1500000),
    new SalesData(1, 1735000),
    new SalesData(2, 1678000),
    new SalesData(3, 1890000),
    new SalesData(4, 1907000),
    new SalesData(5, 2300000),
    new SalesData(6, 2360000),
    new SalesData(7, 1980000),
    new SalesData(8, 2654000),
    new SalesData(9, 2789070),
    new SalesData(10, 3020000),
    new SalesData(11, 3245900),
    new SalesData(12, 4098500),
    new SalesData(13, 4500000),
    new SalesData(14, 4456500),
    new SalesData(15, 3900500),
    new SalesData(16, 5123400),
    new SalesData(17, 5589000),
    new SalesData(18, 5940000),
    new SalesData(19, 6367000),
  ];
  final data1 = [
    new SalesData(0, 1500000),
    new SalesData(3, 1907000),
    new SalesData(5, 2789070),
    new SalesData(10, 4456500),
    new SalesData(13, 5589000),
    new SalesData(18, 1980000),
    new SalesData(19, 4456500),
  ];

  getData() async {
    var data = await widget.database.getUsedCampaigns();
  }

   _getSeriesData() {
    List<charts.Series<SalesData, int>> series = [
      charts.Series(
          id: "Sales",
          data: data,
          domainFn: (SalesData series, _) => series.year,
          measureFn: (SalesData series, _) => series.sales,
          colorFn: (SalesData series, _) =>
              charts.MaterialPalette.blue.shadeDefault),
      charts.Series(
          id: "Sales",
          data: data1,
          domainFn: (SalesData series, _) => series.year,
          measureFn: (SalesData series, _) => series.sales,
          colorFn: (SalesData series, _) =>
              charts.MaterialPalette.red.shadeDefault)
    ];
    return series;
  }

  String group = '';
  bool monSelected = false;
  bool tueSelected = false;
  bool wedSelected = false;
  bool thurSelected = false;
  bool friSelected = false;
  bool satSelected = false;
  bool sunSelected = false;

  Container _daySelection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(2, 15, 50, 00),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Text(
              'Select Day',
              style: TextStyle(
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Mon',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                  )),
              Radio(
                value: 'Mon',
                groupValue: group,
                onChanged: (T) {
                  print(T);
                  getData();
                  setState(() {
                    monSelected = true;
                    tueSelected = false;
                    wedSelected = false;
                    thurSelected = false;
                    friSelected = false;
                    satSelected = false;
                    sunSelected = false;
                    group = T;
                  });
                },
              ),
              Text('Tue',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                  )),
              Radio(
                  value: 'Tue',
                  groupValue: group,
                  onChanged: (T) {
                    setState(() {
                      monSelected = false;
                      tueSelected = true;
                      wedSelected = false;
                      thurSelected = false;
                      friSelected = false;
                      satSelected = false;
                      sunSelected = false;
                      group = T;
                    });
                  }),
              Text('Wed',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                  )),
              Radio(
                  value: 'Wed',
                  groupValue: group,
                  onChanged: (T) {
                    setState(() {
                      monSelected = false;
                      tueSelected = false;
                      wedSelected = true;
                      thurSelected = false;
                      friSelected = false;
                      satSelected = false;
                      sunSelected = false;
                      group = T;
                    });
                  }),
              Text('Thu',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                  )),
              Radio(
                  value: 'Thu',
                  groupValue: group,
                  onChanged: (T) {
                    setState(() {
                      monSelected = false;
                      tueSelected = false;
                      wedSelected = false;
                      thurSelected = true;
                      friSelected = false;
                      satSelected = false;
                      sunSelected = false;
                      group = T;
                    });
                  }),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              Text('Fri',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                  )),
              Radio(
                  value: 'Fri',
                  groupValue: group,
                  onChanged: (T) {
                    setState(() {
                      monSelected = false;
                      tueSelected = false;
                      wedSelected = false;
                      thurSelected = false;
                      friSelected = true;
                      satSelected = false;
                      sunSelected = false;
                      group = T;
                    });
                  }),
              Text('Sat',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                  )),
              Radio(
                  value: 'Sat',
                  groupValue: group,
                  onChanged: (T) {
                    setState(() {
                      monSelected = false;
                      tueSelected = false;
                      wedSelected = false;
                      thurSelected = false;
                      friSelected = false;
                      satSelected = true;
                      sunSelected = false;
                      group = T;
                    });
                  }),
              Text('Sun',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                  )),
              Radio(
                  value: 'Sun',
                  groupValue: group,
                  onChanged: (T) {
                    setState(() {
                      monSelected = false;
                      tueSelected = false;
                      wedSelected = false;
                      thurSelected = false;
                      friSelected = false;
                      satSelected = false;
                      sunSelected = true;
                      group = T;
                    });
                  })
            ],
          ),
        ],
      ),
    );
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Line Chart'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          height: 550,
          padding: EdgeInsets.all(10),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  _daySelection(),
                  Text(
                    "Sales of a company over the years",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: new charts.LineChart(
                      _getSeriesData(),
                      animate: true,
                    ),
                  )
                ],
              ),
            ),
          ),
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
            title: Text('My Campaigns'),
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
