import 'package:flutter/material.dart';
import 'package:login/app/home/models/restaurant_model.dart';
import 'package:login/app/services/database.dart';
import 'package:provider/provider.dart';

import 'models/user_model.dart';


class RestaurantDetailsPage extends StatefulWidget {
  RestaurantDetailsPage({Key key, this.title, @required this.restaurant, @required this.database}) : super(key: key);
  final String title;
  final RestaurantModel restaurant;
  final Database database;

  @override
  _RestaurantDetailsPage createState() => _RestaurantDetailsPage();
}

class _RestaurantDetailsPage extends State<RestaurantDetailsPage> {
  int _selectedIndex = 2;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<UserModel> getUserModel() async {
    var user = await widget.database.getUserDetailsStream();
    return user;
  }

  Future<void> addFollowers() async {
    UserModel user = await getUserModel();
    print(widget.restaurant.id);
    print(user.id);
    await widget.database.addFollowers(user, widget.restaurant);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Details'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                  radius: 75,
                  backgroundImage: AssetImage(
                    'assets/gagamanjero.png',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  '${widget.restaurant.restaurantName}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            width: 1.0,
                            color: Colors.blue,
                          ),
                          left: BorderSide(
                            width: 1.0,
                            color: Colors.blue,
                          ),
                          right: BorderSide(
                            width: 1.0,
                            color: Colors.blue,
                          ),
                          bottom: BorderSide(
                            width: 1.0,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          ' Followers: 223 ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      child: RaisedButton(
                        color: Colors.blue,
                        onPressed: addFollowers,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.thumb_up,
                              color: Colors.white,
                            ),
                            Text(
                              '  Follow',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.all(0.0),
                  padding: const EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                  child: ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {},
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.info,
                              color: Colors.blue,
                            ),
                            Text(
                              'Info',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: () {},
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.list,
                              color: Colors.blue,
                            ),
                            Text(
                              'Active\n Campaigns',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: () {},
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.history,
                              color: Colors.blue,
                            ),
                            Text(
                              'History',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: () {},
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.photo_camera,
                              color: Colors.blue,
                            ),
                            Text(
                              'Photos',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  '${widget.restaurant.restaurantName}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[300],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(30),
                  //height: 150,
                  width: 250,
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: new Text(
                          "${widget.restaurant.restaurantAddress}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
              Icons.map,
            ),
            title: Text('Map'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
            ),
            title: Text('Notifications'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.restaurant,
            ),
            title: Text('Restaurants'),
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
