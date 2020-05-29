import 'package:flutter/material.dart';
import 'package:login/app/home/campaign_creator_page.dart';
import 'package:login/app/home/campaign_list_page_2.dart';
import 'package:login/app/home/lists/list_item_builder.dart';
import 'package:login/app/home/models/campaign_model.dart';
import 'package:login/app/home/restaurant_active_campaigns.dart';
import 'package:login/app/services/auth.dart';
import 'package:login/app/services/database.dart';
import 'package:login/common_widgets/platform_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'lists/restaurant_active_campaigns_list_2.dart';
import 'lists/restaurant_list_item.dart';
import 'models/restaurant_model.dart';
import 'package:login/app/home/map.dart';
import 'package:login/app/home/user_profile.dart';

class RestaurantList extends StatefulWidget {
  RestaurantList({Key key, this.title, @required this.database}) : super(key: key);
  final String title;
  final Database database;

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RestaurantList(database: database),
        fullscreenDialog: true,
      )
    );
  }
  @override
  _RestaurantList createState() => _RestaurantList();
}

class _RestaurantList extends State<RestaurantList> {
  
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();    
    }
    catch(e) {
      print(e.toString());
    }
  } 
  
  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout', 
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout'
    ).show(context);
    if (didRequestSignOut == true) {
      print('Mert');
      _signOut(context);
    }
  }
int _selectedIndex = 2;
void selectCampaignListPage(context) {
   Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return CampaignListPage(database: widget.database);
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

  void selectUserProfilePage(BuildContext ctx) {
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return UserProfile(database: widget.database);
        },
      ),
    );
  }
  
//-----------------------------------
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print("index is: $index");
      if(_selectedIndex == 1){
        selectCampaignListPage(context);
      }else if(_selectedIndex == 0){
        selectMapPage(context);
      }else if(_selectedIndex == 3){
        selectUserProfilePage(context);
      }
    });
  }

  Widget _buildContents(BuildContext context) {
     return StreamBuilder<List<RestaurantModel>>(
       stream: widget.database.restaurantStream(),
       builder: (context, snapshot) {
        return ListItemBuilder<RestaurantModel>(
          snapshot: snapshot,
          itemBuilder: (context, restaurant) => RestaurantListItem(
            restaurant: restaurant,
            database: widget.database,
          )
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("My Campaigns Page"),
        actions: <Widget>[
         FlatButton(
            child: Text(
              'Logout', 
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),],
      ),
      body:
          Container(
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => CampaignCreatorPage.show(context)
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
