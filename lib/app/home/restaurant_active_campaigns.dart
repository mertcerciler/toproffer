import 'package:flutter/material.dart';
import 'package:login/app/home/campaign_creator_page.dart';
import 'package:login/app/home/lists/list_item_builder.dart';
import 'package:login/app/home/models/campaign_model.dart';
import 'package:login/app/home/restaurant_list.dart';
import 'package:login/app/home/restuarant_history_campaigns.dart';
import 'package:login/app/services/auth.dart';
import 'package:login/app/services/database.dart';
import 'package:login/common_widgets/platform_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'lists/restaurant_active_campaigns_list_2.dart';
import 'lists/restaurant_history_campaigns_list.dart';

class RestaurantsActiveCampaigns extends StatefulWidget {
  RestaurantsActiveCampaigns({Key key, this.title, @required this.database})
      : super(key: key);
  final String title;
  final Database database;

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => RestaurantsActiveCampaigns(database: database),
      fullscreenDialog: true,
    ));
  }

  @override
  _RestaurantsActiveCampaigns createState() => _RestaurantsActiveCampaigns();
}

class _RestaurantsActiveCampaigns extends State<RestaurantsActiveCampaigns> {
  // List<CampaignModel> get _recentTransactions {
  //   return _userTransactions.where((tx) {
  //     return tx.campaignStarted.isAfter(
  //       DateTime.now().subtract(
  //         Duration(days: 7),
  //       ),
  //     );
  //   }).toList();
  // }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
            title: 'Logout',
            content: 'Are you sure that you want to logout',
            cancelActionText: 'Cancel',
            defaultActionText: 'Logout')
        .show(context);
    if (didRequestSignOut == true) {
      print('Mert');
      _signOut(context);
    }
  }

  int _selectedIndex = 0;
  void selectGenerator(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) {
          return CampaignCreatorPage(database: widget.database);
        },
      ),
    );
  }

  void selectHistory(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return RestaurantHistoryCampaigns(database: widget.database);
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

  bool selectedView = true;

  void selectActiveCampaigns() {
    setState(() {
      selectedView = true;
    });
  }

  void selectOldCampaigns() {
    setState(() {
      selectedView = false;
    });
  }

  Widget _buildContents(BuildContext context) {
    return StreamBuilder<List<CampaignModel>>(
      stream: widget.database.campaignStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<CampaignModel>(
            snapshot: snapshot,
            itemBuilder: (context, campaign) => RestaurantCampaignList(
                  campaign: campaign,
                  database: widget.database,
                ));
      },
    );
  }

  Widget _buildHistoryContents(BuildContext context) {
    return StreamBuilder<List<CampaignModel>>(
      stream: widget.database.campaignHistoryStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<CampaignModel>(
            snapshot: snapshot,
            itemBuilder: (context, campaign) => RestaurantHistoryCampaignList(
                  campaign: campaign,
                  database: widget.database,
                ));
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
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(0.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      onPressed: selectActiveCampaigns,
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.format_list_bulleted,
                            color: Colors.blue,
                          ),
                          Text(
                            'Active Campaigns',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FlatButton(
                      onPressed: selectOldCampaigns,
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.history,
                            color: Colors.blue,
                          ),
                          Text(
                            'Old Campaigns',
                            textAlign: TextAlign.center,
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
                height: 15,
              ),
              selectedView
                  ? _buildContents(context)
                  : _buildHistoryContents(context),
            ],
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
              Icons.history,
            ),
            title: Text('History'),
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
