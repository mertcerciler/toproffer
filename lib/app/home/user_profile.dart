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
import 'lists/restaurant_active_campaigns_list_2.dart';
import 'package:login/app/home/campaign_list_page_2.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key key, this.title, @required this.database}) : super(key: key);
  final String title;
  final Database database;

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => UserProfile(database: database),
      fullscreenDialog: true,
    ));
  }

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
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
              UserProfile(database: widget.database),
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
              SizedBox(
                height: 55,
              ),
              Text(
                "User Information",
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Username : username",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Name : User's name",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Surname: User's surname",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "E-mail: User's e-mail",
                style: TextStyle(
                  fontSize: 18,
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
