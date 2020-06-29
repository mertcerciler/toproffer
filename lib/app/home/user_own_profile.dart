import 'package:flutter/material.dart';
import 'package:login/app/home/map.dart';
import 'package:login/app/home/models/campaign_model.dart';
import 'package:login/app/home/restaurant_list.dart';
import 'package:login/app/services/database.dart';
import 'package:login/app/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:login/common_widgets/platform_alert_dialog.dart';
import 'dart:ui';
import 'lists/list_item_builder.dart';
import 'package:login/app/home/campaign_list_page_2.dart';

class UserOwnProfile extends StatefulWidget {
  UserOwnProfile({Key key, this.title, @required this.database}) : super(key: key);
  final String title;
  final Database database;

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => UserOwnProfile(database: database),
      fullscreenDialog: true,
    ));
  }

  @override
  _UserOwnProfileState createState() => _UserOwnProfileState();
}

class _UserOwnProfileState extends State<UserOwnProfile> {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Widget _buildContents(BuildContext context) {
    return StreamBuilder<List<CampaignModel>>(
      stream: widget.database.allCampaignStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<CampaignModel>(
          snapshot: snapshot,
          itemBuilder: (context, campaign) =>
              UserOwnProfile(database: widget.database),
        );
      },
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
            title: 'Logout',
            content: 'Are you sure that you want to logout',
            cancelActionText: 'Cancel',
            defaultActionText: 'Logout')
        .show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  int _selectedIndex = 3;
  void selectRestaurantListPage(BuildContext ctx) {
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return RestaurantList(database: widget.database);
        },
      ),
    );
  }

  void selectMapPage(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) {
          return MapPage(database: widget.database);
        },
      ),
    );
  }

  void selectCampaignListPage(BuildContext ctx) {
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return CampaignListPage(database: widget.database);
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
        selectMapPage(context);
      } else if (_selectedIndex == 1) {
        selectCampaignListPage(context);
      } else if (_selectedIndex == 2) {
        selectRestaurantListPage(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          child: Column(
            children: <Widget>[
              Hero(
                tag: 'assets/burak.jpeg',
                child: Container(
                  height: 125.0,
                  width: 125.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(62.5),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/merdo.jpeg'))),
                ),
              ),
              SizedBox(height: 25.0),
              Text(
                'Mert Çerçiler',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.0),
              Text(
                'Antalya, Türkiye',
                style: TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '3',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'FOLLOWERS',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.grey),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '2',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'CAMPAIGNS',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.grey),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '5',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'INTERESTS',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.grey),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.table_chart)),
                    IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
           
           
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.blue,
        elevation: 2,
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