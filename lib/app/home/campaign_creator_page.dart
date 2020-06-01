import 'package:flutter/material.dart';
import 'package:login/app/home/models/campaign_model.dart';
import 'package:login/app/home/restaurant_active_campaigns.dart';
import 'package:login/app/home/restaurant_statistics.dart';
import 'dart:async';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:login/app/services/database.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class CampaignCreatorPage extends StatefulWidget {
  const CampaignCreatorPage({Key key, @required this.database})
      : super(key: key);
  final Database database;

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CampaignCreatorPage(database: database),
      fullscreenDialog: true,
    ));
  }

  @override
  _CampaignCreatorPage createState() => _CampaignCreatorPage();
}

class _CampaignCreatorPage extends State<CampaignCreatorPage> {
  final contentController = TextEditingController();
  final oldPriceController = TextEditingController();
  final newPriceController = TextEditingController();
  final durationController = TextEditingController();
  TimeOfDay startingHour = TimeOfDay.now();
  TimeOfDay endingHour = TimeOfDay.now();
  static int selectedDurationHour = 0;
  static int selectedDurationMinutes = 0;
  List<String> campaignDays;
  Duration duration = new Duration(
      hours: selectedDurationHour, minutes: selectedDurationMinutes);
  Timer _timerCampaign;

  String dropdownValue = 'Permanent Campaign';
  String campaignCategory1 = 'Fast Food';
  String campaignCategory2 = 'Not Selected(Optional)';
  bool selection = true;

  void startCampaignTime() {
    {
      const oneSec = const Duration(seconds: 1);
      _timerCampaign = new Timer.periodic(
          oneSec,
          (Timer timer) => setState(() {
                if ((duration - oneSec).inSeconds < 1) {
                  _timerCampaign.cancel();
                } else {
                  duration = duration - oneSec;
                }
              }));
    }
  }

  TimeOfDay _now = TimeOfDay.now();
  TimeOfDay picked;

  selectStartingHour(BuildContext context) async {
    picked = await showTimePicker(context: context, initialTime: _now);
    changeStartingHour(); 
  }
  changeStartingHour(){
    setState(() {
      startingHour = picked;
    });
  }

  TimeOfDay pickedEnding;

  selectEndingHour(BuildContext context) async {
    pickedEnding = await showTimePicker(context: context, initialTime: _now);
    changeEndingHour(); 
  }
  changeEndingHour(){
    setState(() {
      endingHour = pickedEnding;
    });
  }

  _showPickerNumber(BuildContext context) async {
    new Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 0, end: 23),
          NumberPickerColumn(begin: 0, end: 59),
        ]),
        delimiter: [
          PickerDelimiter(
              child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ))
        ],
        footer: new Row(
          children:[ 
            SizedBox(width: 35),
            SizedBox(height: 10),
            Text('hours                 minutes')]),
        hideHeader: true,
        title: new Text("Please Select"),
        onConfirm: (Picker picker, List value) {
          setState(() {
            selectedDurationHour = value[0];
            selectedDurationMinutes = value[1];
            duration = new Duration(
                hours: selectedDurationHour, minutes: selectedDurationMinutes);
          });
        }).showDialog(context);
  }

  _showPickerStartingTime(BuildContext context) async {
    new Picker(
        
        adapter: NumberPickerAdapter(
          data: [
          NumberPickerColumn(begin: 0, end: 23, suffix: Text('hours')),
          NumberPickerColumn(begin: 0, end: 59, suffix: Text('minutes')),
        ]),
        delimiter: [
          PickerDelimiter(
              child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ))
        ],
        hideHeader: true,
        
        title: new Text("Please Select"),
        onConfirm: (Picker picker, List value) {
          setState(() {
            selectedDurationHour = value[0];
            selectedDurationMinutes = value[1];
            duration = new Duration(
                hours: selectedDurationHour, minutes: selectedDurationMinutes);
          });
        }).showDialog(context);
  }

  Future<String> getRestaurantName() async {
    var restaurantName = await widget.database.getRestaurantNameStream();
    return restaurantName['restaurant_name'];
  }

  Future<String> getRestaurantAddress() async {
    var restaurantName = await widget.database.getRestaurantNameStream();
    return restaurantName['restaurant_address'];
  }

  Future<dynamic> getRestaurantUrl() async {
    var restaurantUrl = await widget.database.getRestaurantNameStream();
    return restaurantUrl['restaurantUrl'];
  }

  String createRandomInteger() {
    var rng = new Random();
    int rand =  rng.nextInt(99999);
    return rand.toString();
  }

  Future<void> submitData() async {
    final enteredContent = contentController.text;
    final enteredOldPrice = double.parse(oldPriceController.text);
    final enteredNewPrice = double.parse(newPriceController.text);
    DateTime now = DateTime.now();
    DateTime campaignFinished = now.add(duration);

    String restaurantName = await getRestaurantName();
    String restaurantAddress = await getRestaurantAddress();
    var imageUrl = await getRestaurantUrl();

    String code = createRandomInteger();
    print(dropdownValue);

    if (dropdownValue == 'Permanent Campaign') {
     
      if (enteredContent.isEmpty ||
          enteredOldPrice <= 0 ||
          enteredNewPrice <= 0){
        return;
      }
    }

    if (dropdownValue == 'Momentarily Campaign') {
      if (enteredContent.isEmpty ||
          enteredOldPrice <= 0 ||
          enteredNewPrice <= 0) {
        return;
      }
    }

    if (dropdownValue == 'Permanent Campaign') {
      CampaignModel campaign = CampaignModel(
        id: now.toIso8601String(),
        title: restaurantName,
        restaurantAddress: restaurantAddress,
        content: enteredContent,
        oldPrice: enteredOldPrice,
        newPrice: enteredNewPrice,
        campaignType: 'Permanent',
        campaignDays: campaignDays,
        campaignCategory1: campaignCategory1,
        campaignCategory2: campaignCategory2,
        startingHour: startingHour.toString(),
        endingHour: endingHour.toString(),
        code: code,
        imageUrl: imageUrl,
      );
      try {
        await widget.database.createCampaign(campaign);
        await widget.database
            .createAllCampaigns(campaign, now.toIso8601String());
      } catch (e) {
        rethrow;
      }
      selectRestaurantActiveCampaigns(context);
    } else {
      CampaignModel campaign = CampaignModel(
        id: now.toIso8601String(),
        title: restaurantName,
        restaurantAddress: restaurantAddress,
        content: enteredContent,
        oldPrice: enteredOldPrice,
        newPrice: enteredNewPrice,
        campaignType: 'Momentarily',
        campaignCategory1: campaignCategory1,
        campaignCategory2: campaignCategory2,
        campaignFinished: campaignFinished,
        campaignStarted: now,
        code: code,
        imageUrl: imageUrl
      );
      try {
        await widget.database.createCampaign(campaign);
        await widget.database
            .createAllCampaigns(campaign, now.toIso8601String());
      } catch (e) {
        rethrow;
      }
      selectRestaurantActiveCampaigns(context);
    }
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  int _selectedIndex = 1;
  void selectRestaurantActiveCampaigns(BuildContext ctx) {
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return RestaurantsActiveCampaigns(database: widget.database);
        },
      ),
    );
  }

  void selectStatistics(BuildContext ctx) {
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return RestaurantStatistics(database: widget.database);
        },
      ),
    );
  }

//-----------------------------------
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print("index is: $index");
      if (_selectedIndex == 0) {
        selectRestaurantActiveCampaigns(context);
      } else if (_selectedIndex == 2) {
        selectStatistics(context);
      } else if (_selectedIndex == 3) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campaign Creator'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: ListView(
          children: <Widget>[
            Card(
              elevation: 0,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    TextField(
                      decoration:
                          InputDecoration(labelText: 'Campaign Content'),
                      controller: contentController,
                      onSubmitted: (_) => submitData(),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Campaign Categories",
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment(0.0, 0.0),
                      child: DropdownButton<String>(
                        value: campaignCategory1,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 35,
                        elevation: 16,
                        style: TextStyle(color: Colors.black87),
                        underline: Container(
                          height: 2,
                          color: Colors.blue[200],
                        ),
                        onChanged: (String newValueCategory1) {
                          setState(() {
                            campaignCategory1 = newValueCategory1;
                            print(campaignCategory1);
                          });
                        },
                        items: <String>[
                          'Fast Food',
                          'Coffee',
                          'Traditional Food',
                          'Alcohol',
                          'Breakfast',
                          'Bakery',
                          'International Cousine',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    Container(
                      alignment: Alignment(0.0, 0.0),
                      child: DropdownButton<String>(
                        value: campaignCategory2,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 35,
                        elevation: 16,
                        style: TextStyle(color: Colors.black87),
                        underline: Container(
                          height: 2,
                          color: Colors.blue[200],
                        ),
                        onChanged: (String newValueCategory2) {
                          setState(() {
                            campaignCategory2 = newValueCategory2;
                            print(campaignCategory2);
                          });
                        },
                        items: <String>[
                          'Not Selected(Optional)',
                          'Fast Food',
                          'Coffee',
                          'Traditional Food',
                          'Alcohol',
                          'Breakfast',
                          'Bakery',
                          'International Cousine',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Old Price'),
                      controller: oldPriceController,
                      onSubmitted: (_) => submitData(),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'New Price'),
                      controller: newPriceController,
                      onSubmitted: (_) => submitData(),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      alignment: Alignment(0.0, 0.0),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 35,
                        elevation: 16,
                        style: TextStyle(color: Colors.black87),
                        underline: Container(
                          height: 2,
                          color: Colors.blue[200],
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                            if (dropdownValue == 'Permanent Campaign') {
                              selection = true;
                            }
                            if (dropdownValue == 'Momentarily Campaign') {
                              selection = false;
                            }
                          });
                        },
                        items: <String>[
                          'Permanent Campaign',
                          'Momentarily Campaign'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    selection
                        ? Column(
                            children: <Widget>[
                              CheckboxGroup(
                                  labels: <String>[
                                    "Sun",
                                    "Mon",
                                    "Tue",
                                    "Wed",
                                    "Thu",
                                    "Fri",
                                    "Sat",
                                  ],
                                  onSelected: (List<String> checked) {setState(() {
                                    campaignDays = checked;
                                  });}
                                      ),
                              SizedBox(
                                height: 12,
                              ),
                              ListTile(
                                title: Text('Select Starting Hour'),
                                subtitle: Text('You selected ${startingHour.hour}:${startingHour.minute}'),
                                trailing: Icon(Icons.keyboard_arrow_down),
                                onTap: () => selectStartingHour(context),
                          ),
                              ListTile(
                                title: Text('Select Ending Hour'),
                                subtitle: Text('You selected ${endingHour.hour}:${endingHour.minute}'),
                                trailing: Icon(Icons.keyboard_arrow_down),
                                onTap: () => selectEndingHour(context),
                          ),
                            ],
                          )
                        : ListTile(
                            title: Text('Select Duration'),
                            subtitle: Text('You selected $selectedDurationHour hour(s) $selectedDurationMinutes minutes'),
                            trailing: Icon(Icons.keyboard_arrow_down),
                            onTap: () => _showPickerNumber(context),
                          ),
                    FlatButton(
                      child: Text(
                        'CREATE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      textColor: Colors.blueAccent,
                      onPressed: submitData,
                    ),
                  ],
                ),
              ),
            ),
          ],
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
