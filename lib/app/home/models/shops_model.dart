import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Shop {
  String shopName;
  String address;
  String description;
  String thumbNail;
  LatLng locationCoords;
  Timer time;
  String color;

  Shop(
      {this.shopName,
      this.address,
      this.description,
      this.thumbNail,
      this.locationCoords,
      this.time,  
      this.color});
}

final List<Shop> shops = [
  Shop(
      shopName: 'Stumptown Coffee Roasters',
      //Time related to campaign
      address: '18 W 29th St',
      //campaign description
      description:
          'Coffee bar chain offering house-roasted direct-trade coffee, along with brewing gear & whole beans',
      locationCoords: LatLng(39.9434, 32.8497),
      //Restaurant inage from firebase
      thumbNail: 'https://lh5.googleusercontent.com/p/AF1QipNNzoa4RVMeOisc0vQ5m3Z7aKet5353lu0Aah0a=w90-h90-n-k-no'
      ),
      /*
  Shop(
      shopName: 'Andrews Coffee Shop',
      address: '463 7th Ave',
      description:
          'All-day American comfort eats in a basic diner-style setting',
      locationCoords: LatLng(39.9834, 32.8897),
      thumbNail: 'https://lh5.googleusercontent.com/p/AF1QipOfv3DSTkjsgvwCsUe_flDr4DBXneEVR1hWQCvR=w90-h90-n-k-no'
      ),
  Shop(
      shopName: 'Third Rail Coffee',
      address: '240 Sullivan St',
      description:
          'Small spot draws serious caffeine lovers with wide selection of brews & baked goods.',
      locationCoords: LatLng(39.9834, 32.8497),
      thumbNail: 'https://lh5.googleusercontent.com/p/AF1QipPGoxAP7eK6C44vSIx4SdhXdp78qiZz2qKp8-o1=w90-h90-n-k-no'
      ),
  Shop(
      shopName: 'Hi-Collar',
      address: '214 E 10th St',
      description:
          'Snazzy, compact Japanese cafe showcasing high-end coffee & sandwiches, plus sake & beer at night.',
      locationCoords: LatLng(39.9434, 32.8897),
      thumbNail: 'https://lh5.googleusercontent.com/p/AF1QipNhygtMc1wNzN4n6txZLzIhgJ-QZ044R4axyFZX=w90-h90-n-k-no'
      ),
      */
  Shop(
      shopName: 'Everyman Espresso',
      address: '301 W Broadway',
      description:
          'Compact coffee & espresso bar turning out drinks made from direct-trade beans in a low-key setting.',
      locationCoords: LatLng(39.9534, 32.8597),
      thumbNail: 'https://lh5.googleusercontent.com/p/AF1QipOMNvnrTlesBJwUcVVFBqVF-KnMVlJMi7_uU6lZ=w90-h90-n-k-no'
      )
];