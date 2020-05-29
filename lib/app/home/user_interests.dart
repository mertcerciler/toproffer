import 'package:flutter/material.dart';
import 'package:login/app/home/campaign_list_page_2.dart';
import 'package:login/app/home/restaurant_active_campaigns.dart';
import 'package:login/app/services/database.dart';
import 'package:login/common_widgets/platform_alert_dialog.dart';
import 'package:login/common_widgets/platform_exception_alert_dialog.dart';
import 'package:provider/provider.dart';

class UserInterestsPage extends StatefulWidget {

  @override
  _UserInterestsPage createState() => _UserInterestsPage();
}


class _UserInterestsPage extends State<UserInterestsPage> {
  var fastFoodSelection = false;
  var coffeeSelection = false;
  var traditionalFoodSelection = false;
  var alcoholSelection = false;
  var breakfastSelection = false;
  var bakerySelection = false;
  var internationalCuisineSelection = false;
  List<String> selectedInterests = [];

  Color _fastFoodColor = Colors.blue[200];
  Color _coffeeColor = Colors.blue[200];
  Color _traditionalFoodColor = Colors.blue[200];
  Color _alcoholColor = Colors.blue[200];
  Color _breakfastColor = Colors.blue[200];
  Color _bakeryColor = Colors.blue[200];
  Color _internationalCuisineColor = Colors.blue[200];

  Future<void> _submit() async {
    final database = Provider.of<Database>(context, listen: false);
    if (selectedInterests.isNotEmpty) {
      try{
        await database.setUserInterests(selectedInterests);
        Navigator.of(context).push(
          MaterialPageRoute(
          builder: (_) {
            return CampaignListPage(database: database);
          },
        ),
    );
      } catch (e) {
        rethrow;
      }
    }
    else {
      PlatformAlertDialog(title: 'You need to select your interests.',
        content: 'It seems you have not select your interests, please choose at least one interest.',
        defaultActionText: 'OK',
        ).show(context);
    }
    
    
  } 
  // Future<List<String>> getInterests(BuildContext context)  {
  //   final database = Provider.of<Database>(context, listen: false);
  //   List<String> userInt = [];
  //   var userInterests =  database.getUserInsterestsStream();
  //   return userInterests;
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Interests'),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Text(
            'Please select your interests.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Card(
                    color: _fastFoodColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: (SizedBox(
                      height: 150.0,
                      width: 150.0,
                      child: IconButton(
                        padding: EdgeInsets.all(2.5),
                        highlightColor: Colors.deepOrangeAccent,
                        icon: Image.asset(
                          'assets/fastfood.png',
                          fit: BoxFit.cover,
                        ),
                        onPressed: () {
                          if (fastFoodSelection == false) {
                            fastFoodSelection = true;
                            print('Fast food selected!');
                            setState(() {
                              _fastFoodColor = Colors.green;
                              selectedInterests.add('Fast Food');
                            });
                          } else {
                            fastFoodSelection = false;
                            print('Fast food unselected!');
                            setState(() {
                              _fastFoodColor = Colors.blue[200];
                              selectedInterests.removeWhere((element) => element == 'Fast Food');
                              print(selectedInterests);
                            });
                          }
                        },
                      ),
                    )),
                  ),
                  Row(
                    children: <Widget>[
                      Text('Fast Food'),
                      fastFoodSelection
                          ? Icon(Icons.check, size: 18)
                          : Text(""),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Card(
                    color: _coffeeColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: (SizedBox(
                      height: 150.0,
                      width: 150.0,
                      child: IconButton(
                        padding: EdgeInsets.all(2.5),
                        highlightColor: Colors.deepOrangeAccent,
                        icon: Image.asset(
                          'assets/coffee.jpg',
                          fit: BoxFit.cover,
                        ),
                        onPressed: () {
                          if (coffeeSelection == false) {
                            coffeeSelection = true;
                            print('Coffee selected!');
                            setState(() {
                              _coffeeColor = Colors.green;
                              selectedInterests.add('Coffee');
                            });
                          } else {
                            coffeeSelection = false;
                            print('Coffee unselected!');
                            setState(() {
                              _coffeeColor = Colors.blue[200];
                              selectedInterests.removeWhere((element) => element == 'Fast Food');
                            });
                          }
                        },
                      ),
                    )),
                  ),
                  Row(
                    children: <Widget>[
                      Text('Coffee'),
                      coffeeSelection ? Icon(Icons.check, size: 18) : Text(""),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Card(
                    color: _traditionalFoodColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: (SizedBox(
                      height: 150.0,
                      width: 150.0,
                      child: IconButton(
                        padding: EdgeInsets.all(2.5),
                        highlightColor: Colors.deepOrangeAccent,
                        icon: Image.asset(
                          'assets/traditional.jpg',
                          fit: BoxFit.cover,
                        ),
                        onPressed: () {
                          if (traditionalFoodSelection == false) {
                            traditionalFoodSelection = true;
                            print('Traditional food selected!');
                            setState(() {
                              _traditionalFoodColor = Colors.green;
                              selectedInterests.add('Traditional Food');
                            });
                          } else {
                            traditionalFoodSelection = false;
                            print('Traditional food unselected!');
                            setState(() {
                              _traditionalFoodColor = Colors.blue[200];
                              selectedInterests.removeWhere((element) => element == 'Traditional Food');
                            });
                          }
                        },
                      ),
                    )),
                  ),
                  Row(
                    children: <Widget>[
                      Text('Traditional Food'),
                      traditionalFoodSelection
                          ? Icon(Icons.check, size: 18)
                          : Text(""),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Card(
                    color: _alcoholColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: (SizedBox(
                      height: 150.0,
                      width: 150.0,
                      child: IconButton(
                        padding: EdgeInsets.all(2.5),
                        highlightColor: Colors.deepOrangeAccent,
                        icon: Image.asset(
                          'assets/beer.jpg',
                          fit: BoxFit.cover,
                        ),
                        onPressed: () {
                          if (alcoholSelection == false) {
                            alcoholSelection = true;
                            print('Alcohol selected!');
                            setState(() {
                              _alcoholColor = Colors.green;
                              selectedInterests.add('Alcohol');
                            });
                          } else {
                            alcoholSelection = false;
                            print('Alcohol unselected!');
                            setState(() {
                              _alcoholColor = Colors.blue[200];
                              selectedInterests.removeWhere((element) => element == 'Alcohol');
                            });
                          }
                        },
                      ),
                    )),
                  ),
                  Row(
                    children: <Widget>[
                      Text('Alcohol'),
                      alcoholSelection ? Icon(Icons.check, size: 18) : Text(""),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Card(
                    color: _breakfastColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: (SizedBox(
                      height: 150.0,
                      width: 150.0,
                      child: IconButton(
                        padding: EdgeInsets.all(2.5),
                        highlightColor: Colors.deepOrangeAccent,
                        icon: Image.asset(
                          'assets/breakfast.jpg',
                          fit: BoxFit.cover,
                        ),
                        onPressed: () {
                          if (breakfastSelection == false) {
                            breakfastSelection = true;
                            print('Breakfast selected!');
                            setState(() {
                              _breakfastColor = Colors.green;
                              selectedInterests.add('Breakfast');
                            });
                          } else {
                            breakfastSelection = false;
                            print('Breakfast unselected!');
                            setState(() {
                              _breakfastColor = Colors.blue[200];
                              selectedInterests.removeWhere((element) => element == 'Breakfast');
                            });
                          }
                        },
                      ),
                    )),
                  ),
                  Row(
                    children: <Widget>[
                      Text('Breakfast'),
                      breakfastSelection
                          ? Icon(Icons.check, size: 18)
                          : Text(""),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Card(
                    color: _bakeryColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: (SizedBox(
                      height: 150.0,
                      width: 150.0,
                      child: IconButton(
                        padding: EdgeInsets.all(2.5),
                        highlightColor: Colors.deepOrangeAccent,
                        icon: Image.asset(
                          'assets/bakery.jpg',
                          fit: BoxFit.cover,
                        ),
                        onPressed: () {
                          if (bakerySelection == false) {
                            bakerySelection = true;
                            print('Bakery selected!');
                            setState(() {
                              _bakeryColor = Colors.green;
                              selectedInterests.add('Bakery');
                            });
                          } else {
                            bakerySelection = false;
                            print('Bakery unselected!');
                            setState(() {
                              _bakeryColor = Colors.blue[200];
                              selectedInterests.removeWhere((element) => element == 'Bakery');
                            });
                          }
                        },
                      ),
                    )),
                  ),
                  Row(
                    children: <Widget>[
                      Text('Bakery'),
                      bakerySelection ? Icon(Icons.check, size: 18) : Text(""),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Card(
                    color: _internationalCuisineColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: (SizedBox(
                      height: 150.0,
                      width: 150.0,
                      child: IconButton(
                        padding: EdgeInsets.all(2.5),
                        highlightColor: Colors.deepOrangeAccent,
                        icon: Image.asset(
                          'assets/international.jpg',
                          fit: BoxFit.cover,
                        ),
                        onPressed: () {
                          if (internationalCuisineSelection == false) {
                            internationalCuisineSelection = true;
                            print('International cuisine selected!');
                            setState(() {
                              _internationalCuisineColor = Colors.green;
                              selectedInterests.add('International Cousine');
                            });
                          } else {
                            internationalCuisineSelection = false;
                            print('International cuisine unselected!');
                            setState(() {
                              _internationalCuisineColor = Colors.blue[200];
                              selectedInterests.removeWhere((element) => element == 'International Cousine');
                            });
                          }
                        },
                      ),
                    )),
                  ),
                  Row(
                    children: <Widget>[
                      Text('International Cuisine'),
                      internationalCuisineSelection
                          ? Icon(Icons.check, size: 18)
                          : Text(""),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: FlatButton(
              child: Text(
                'SUBMIT',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              textColor: Colors.blue,
              onPressed: () {
                print('Fastfood selection: ${fastFoodSelection}');
                print('Coffee selection: ${coffeeSelection}');
                print('Traditional selection: ${traditionalFoodSelection}');
                print('Alcohol selection: ${alcoholSelection}');
                print('Breakfast selection: ${breakfastSelection}');
                print('Bakery selection: ${bakerySelection}');
                print('International cuisine selection: ${internationalCuisineSelection}');
                print('SUBMITTED');
                _submit();
              },
            ),
          ),
          SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}
