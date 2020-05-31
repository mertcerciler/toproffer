import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:login/app/home/models/restaurant_model.dart';
import 'package:login/app/home/models/shops_model.dart';
import 'package:location/location.dart';
import 'dart:async';

import 'package:login/app/services/database.dart';

import 'models/campaign_model.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key key, @required this.database}) : super(key: key);
  final Database database;

  @override
  _MapPage createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  int sacounter = 0;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  Location _location = Location();
  var currentLocation = LocationData;
  final Location location = Location();
  Map<String, double> userLocation;
  GoogleMapController _controller;
  List<Marker> allMarkers = [];
  PageController _pageController;
  int prevPage;
  String id = "";
  bool check = false;

  GoogleMapController mapController;
  Location locationgeo = Location();
  Marker marker;

  Future _ifEnabled() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print('Please enable the gps service');
        return;
      }
    }
  }

  Future _ifPermissioned() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('Please give permission to gps location');
        return;
      }
    }
  }

  @override
  void initState() {
    print('initState');
    super.initState();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
  }

  var lati = 39.9334;
  var longi = 32.8597;

  StreamSubscription _getPositionSubscription;
  @override
  void dispose() {
    _getPositionSubscription?.cancel();
    super.dispose();
  }

  Future _getLocation() async {
    location.onLocationChanged.listen((LocationData currentLocation) {
      print('Latitude:${currentLocation.latitude}');
      print('Longitude:${currentLocation.longitude}');
      setState(() {
        lati = currentLocation.latitude;
        longi = currentLocation.longitude;
      });
      print('Lati:${lati}');
      print('Longi:${longi}');
      log(sacounter.toString());
      sacounter = sacounter + 1;
    });
  }

  _displayCampaigns(BuildContext context, String id) {
    print(id);
    return StreamBuilder<List<CampaignModel>>(
        stream: widget.database.campaignStreamMap(id),
        builder: (context, snapshot) {
          print('length is ${snapshot.data.length}');
          return Positioned(
            bottom: 20.0,
            child: Container(
              height: 200.0,
              width: MediaQuery.of(context).size.width,
              child: PageView.builder(
                controller: _pageController,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return _shopList(snapshot.data, index);
                },
              ),
            ),
          );
        });
  }

  void _changeCheck(String id_1) {
    setState(() {
      check = true;
      id = id_1;
    });
    print('check is $check');
  }

  void _onMapCreated(GoogleMapController _cntrl) async {
    _controller = _cntrl;
    _ifEnabled();
    _ifPermissioned();
    var cord = await widget.database.getCoordinates();
    setState(() {
      cord.forEach((element) {
        if (element['lat'] != null) {
          var cords = LatLng(element['lat'], element['long']);
          print('onmapcreated');
          allMarkers.add(Marker(
              markerId: MarkerId(element['address']),
              draggable: false,
              onTap: () => _changeCheck(element['id']),
              infoWindow: InfoWindow(
                  title: element['name'], snippet: element['address']),
              position: cords));
        }
      });
    });
    print(check);
    LocationData sa = await location.getLocation();
    log('locations' + sa.toString());
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(sa.latitude, sa.longitude), zoom: 15),
      ),
    );
  }

  void _onScroll() {
    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();
      print('_onScroll');
    }
  }

  _shopList(List<CampaignModel> campaigns, index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
          onTap: () {
            // moveCamera();
          },
          child: Stack(children: [
            Center(
                child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    height: 125.0,
                    width: 275.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            offset: Offset(0.0, 4.0),
                            blurRadius: 10.0,
                          ),
                        ]),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white),
                        child: Row(children: [
                          Container(
                              height: 90.0,
                              width: 90.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0)),
                                  image: DecorationImage(
                                      image: ExactAssetImage(
                                          'assets/federal3.jpg'),
                                      fit: BoxFit.cover))),
                          SizedBox(width: 5.0),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  campaigns[index].title,
                                  style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      campaigns[index].content,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 170.0,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "₺ ${campaigns[index].oldPrice.toStringAsFixed(2)}",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      Text(
                                        " -> ₺ ${campaigns[index].newPrice.toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                )
                              ])
                        ]))))
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('TOPROFFER'),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 50.0,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                myLocationEnabled: true,
                compassEnabled: true,
                initialCameraPosition:
                    CameraPosition(target: LatLng(lati, longi), zoom: 17),
                mapType: MapType.terrain,
                onMapCreated: _onMapCreated,
                markers: Set.from(allMarkers),
              ),
            ),
            check ? _displayCampaigns(context, id) : Container()
            // Positioned(
            //   bottom: 20.0,
            //   child: Container(
            //     height: 200.0,
            //     width: MediaQuery.of(context).size.width,
            //     child: PageView.builder(
            //       controller: _pageController,
            //       itemCount: shops.length,
            //       itemBuilder: (BuildContext context, int index) {
            //         return _shopList(index);
            //       },
            //     ),
            //   ),
            // )
          ],
        ));
  }

  void mapCreated(controller) {
    setState(() {
      print('mapCreated');
      _controller = controller;
    });
  }
}
