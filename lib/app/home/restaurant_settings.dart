import 'package:flutter/material.dart';
import 'package:login/app/home/campaign_creator_page.dart';
import 'package:login/app/services/auth.dart';
import 'package:login/common_widgets/platform_alert_dialog.dart';
import './edit_description.dart';
import './change_profile_photo.dart';
import './edit_restaurant_photos.dart';
import './change_mail.dart';
import './change_password.dart';
import 'package:provider/provider.dart';



class RestaurantSettingsPage extends StatefulWidget {
  RestaurantSettingsPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _RestaurantSettingsPage createState() => _RestaurantSettingsPage();
}

class _RestaurantSettingsPage extends State<RestaurantSettingsPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // void _navigorToCampaignCreatorPage(BuildContext context) {
  //   Navigator.of(context).push(
  //     MaterialPageRoute<void>(
  //       fullscreenDialog: true,
  //       builder: (context) => CampaignCreatorPage.show()
  //     ),  
  //   );
  // }

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

  void selectEditDescription(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) {
          return EditDescription();
        },
      ),
    );
  }

  void selectChangeProfilePhoto(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) {
          return ChangeProfilePhoto();
        },
      ),
    );
  }

  void selectEditRestaurantPhotos(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) {
          return EditRestaurantPhotos();
        },
      ),
    );
  }

  

  void selectChangeMail(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) {
          return ChangeMail();
        },
      ),
    );
  }

  void selectChangePassword(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) {
          return ChangePassword();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Settings'),
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
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/federal3.jpg',
                  ),
                  radius: 75,
                ),
                SizedBox(
                  height: 15,
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
                        onPressed: null,
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.format_list_bulleted,
                              color: Colors.blue,
                            ),
                            Text(
                              'Campaigns',
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
                              Icons.attach_money,
                              color: Colors.blue,
                            ),
                            Text(
                              'Sold\n Product',
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
                              Icons.photo_camera,
                              color: Colors.blue,
                            ),
                            Text(
                              'Restaurant\n Photos',
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
                              Icons.settings,
                              color: Colors.blue,
                            ),
                            Text(
                              'Settings',
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
                RaisedButton(
                  onPressed: () => selectEditDescription(context),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Colors.lightBlue,
                          Colors.lightBlueAccent,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: const Text('Edit Description',
                        style: TextStyle(fontSize: 20)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () => selectChangeProfilePhoto(context),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Colors.lightBlue,
                          Colors.lightBlueAccent,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: const Text('Change Profile Photo',
                        style: TextStyle(fontSize: 20)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () => selectEditRestaurantPhotos(context),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Colors.lightBlue,
                          Colors.lightBlueAccent,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: const Text('Edit Restaurant Photos',
                        style: TextStyle(fontSize: 20)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () => selectChangeMail(context),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Colors.lightBlue,
                          Colors.lightBlueAccent,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: const Text('Change E-mail',
                        style: TextStyle(fontSize: 20)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () => selectChangePassword(context),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Colors.lightBlue,
                          Colors.lightBlueAccent,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: const Text('Change Password',
                        style: TextStyle(fontSize: 20)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => CampaignCreatorPage.show(context)
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
              Icons.done_all,
            ),
            title: Text('Confirmation'),
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
