import 'package:flutter/material.dart';
import 'package:login/app/home/map.dart';
import 'package:login/app/home/models/campaign_model.dart';
import 'package:login/app/home/restaurant_list.dart';
import 'package:login/app/services/database.dart';
import 'package:login/app/services/auth.dart';
import 'package:login/app/sign_in/signin_page.dart';
import 'package:provider/provider.dart';
import 'package:login/common_widgets/platform_alert_dialog.dart';
import 'dart:ui';
import 'lists/list_item_builder.dart';
import 'lists/restaurant_active_campaigns_list_2.dart';
import 'user_profile.dart';


class CampaignListPage extends StatefulWidget {
  CampaignListPage({Key key, this.title, @required this.database}) : super(key: key);
  final String title;
  final Database database;
  
  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CampaignListPage(database: database),
        fullscreenDialog: true,
      )
    );
  }

  @override
  _CampaignListPage createState() => _CampaignListPage();
}

class _CampaignListPage extends State<CampaignListPage> {

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();    
    }
    catch(e) {
      print(e.toString());
    }
  } 

  Widget _buildContents(BuildContext context) {
    return StreamBuilder<List<CampaignModel>>(
      stream: widget.database.allCampaignStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<CampaignModel>(
          snapshot: snapshot,
          itemBuilder: (context, campaign) => RestaurantCampaignList(campaign:campaign, database: widget.database)
        );
      },
    );
  }
  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout', 
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout'
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  int _selectedIndex = 1;
  void selectRestaurantListPage(BuildContext ctx) {
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return RestaurantList(database: widget.database);
        },
      ),
    );
  }

  void selectUserProfilePage(BuildContext ctx) {
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return UserProfile(database: widget.database);
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
//-----------------------------------
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print("index is: $index");
      if(_selectedIndex == 0){
        selectMapPage(context);
      }else if(_selectedIndex == 2){
        selectRestaurantListPage(context);
      }else if(_selectedIndex == 3){
        selectUserProfilePage(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Campaign Lists"),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(
          //     Icons.add,
          //   ),
          //   onPressed: () => _startAddNewTransaction(context),
          // ),
          FlatButton(
            child: Text(
              'Logout', 
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      body:
          /* Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              startTimer();
            },
            child: Text("start"),
          ),
          Text('Hour: $_hour Minute: $_minute Second: $_second')
        ],
      ), */

          Container(
        //height: 600,
        //width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildContents(context),
            ],
          ),
        ),
      ),

/*       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        //backgroundColor: Colors.purple,
        onPressed: () => _startAddNewTransaction(context),
      ), */
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
