import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:login/app/home/models/restaurant_model.dart';
import 'package:login/app/home/models/user_model.dart';
import 'package:login/app/services/auth.dart';
import 'package:login/app/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:io';


class SignUpRestaurantBloc {
  SignUpRestaurantBloc({@required this.database, @required this.auth});
  final AuthBase auth;
  final DatabaseUser database;
  final StreamController<RestaurantModel> _modelController = StreamController<RestaurantModel>();

  Stream<RestaurantModel> get modelStream => _modelController.stream;
  RestaurantModel _model = RestaurantModel();

  void dispose(){
    _modelController.close();
  }
  
  Future<void> createRestaurant(BuildContext context) async {
    User user;
    DateTime now = DateTime.now();
    try {
      user = await auth.createUserWithEmailAndPassword(_model.email.trim(), _model.password.trim());
      RestaurantModel restaurant = RestaurantModel(
        id: user.uid,
        username: _model.username,
        restaurantName: _model.restaurantName,
        password: _model.password,
        userType: 'Restaurant',
        email: _model.email,
        restaurantAddress: _model.restaurantAddress,
        latitude: _model.latitude,
        longitude: _model.longitude,
        imageUrl: _model.imageUrl,
      );
      await database.createUserType(user.uid, 'restaurants');
      await database.createRestaurant(user.uid, restaurant);
      await database.createAllRestaurant(user.uid, restaurant);
      
    } catch(e) {
      rethrow;
    }
    Navigator.of(context).pop();
  } 

  void updateUsername(String username) => updateWith(username: username);
  void updatePassword(String password) => updateWith(password: password);
  void updateLatitude(double latitude) => updateWith(latitude: latitude);
  void updateAddress(String address) => updateWith(restaurantAddress: address);
  void updateLongitude(double longitude) => updateWith(longitude: longitude);
  void updateRestaurantName(String restaurantName) => updateWith(restaurantName: restaurantName);
  void updateEmail(String email) => updateWith(email: email);
  void updateImage(File image) => updateWith(image: image);
  void updateImageUrl(var imageUrl) => updateWith(imageUrl: imageUrl);

  void updateWith({
    String username,
    String restaurantName,
    String password,
    String email,
    String restaurantCity,
    String restaurantAddress,
    String restaurantPostalCode,
    String userType,
    double latitude,
    double longitude,
    File image,
    var imageUrl,
  }) {
    _model = _model.copyWith(
      email: email,
      password: password,
      restaurantName: restaurantName,
      username: username,
      latitude: latitude,
      longitude: longitude,
      restaurantAddress: restaurantAddress,
      userType: userType,
      image: image,
      imageUrl: imageUrl,
    );
    _modelController.add(_model); 
  } 
}