import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/app/home/models/campaign_model.dart';
import 'package:login/app/home/models/restaurant_model.dart';
import 'package:login/app/home/models/user_model.dart';
import 'package:login/app/services/api_path.dart';
import 'firestore_service.dart';
import 'dart:convert';
import 'dart:math';


abstract class Database {
  Future<void> createCampaign(CampaignModel campaign);
  Stream<String> getUserTypeStream();
  Future<Map<String, dynamic>> getRestaurantNameStream();
  Stream<List<CampaignModel>> showActiveCampaignsStream();
  Stream<List<CampaignModel>> campaignStreamMap(String id);
  Stream<List<CampaignModel>> campaignStream();
  Stream<List<CampaignModel>> campaignStreamInfo(RestaurantModel restaurant);
  Stream<List<CampaignModel>> campaignHistoryStream();
  Stream<List<CampaignModel>> campaignHistoryStreamInfo(RestaurantModel restaurantModel);
  Future<void> createAllCampaigns(CampaignModel campaign, String campaignId);
  Stream<String>  getUserInsterestsStream();
  Future<void> setUserInterests(List<String> interests); 
  Stream<List<CampaignModel>> allCampaignStream();
  Stream<String> getCode(CampaignModel campaign);
  Future<String> getCodeFuture(CampaignModel campaign);
  Future<void> addUsedCampaigns(Map<String, dynamic> data);
  Stream<List<RestaurantModel>> restaurantStream();
  Future<UserModel> getUserDetailsStream();
  Future<void> addFollowers(UserModel user, RestaurantModel restaurant);
  Future<void> deleteCampaign(CampaignModel campaign);
  Future<List<Map<String, dynamic>>> getCoordinates(); 
  Future<String> getUsedCampaigns(int day, String category, String hour);
  Future<Map<String, dynamic>> getUsedCampaignsDay(int day, String category);
  Future<void> deleteAllCampaign(CampaignModel campaign);
  Future<bool> checkFollowers(RestaurantModel restaurant);
  Future<int> followersLength(RestaurantModel restaurant);
}

abstract class DatabaseUser {
  Future<void> createUser(String uid, UserModel user);
  Future<void> createUserType(String uid, String userType);
  Future<void> createRestaurant(String uid, RestaurantModel restaurant);
  Future<void> createAllRestaurant(String uid, RestaurantModel restaurant);
  Future<void> createToken(String uid);
}


class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  Stream<String> getUserTypeStream() {
    final path = APIPath.user_type(uid);
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents.map(
      (snapshot) => snapshot.data['user_type']
    ).toString());
  }

  Future<UserModel> getUserDetailsStream() async {
    var user;
    final path = APIPath.get_customer_details(uid);
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    final map = snapshots.map((snapshot)  => snapshot.documents.map(
      (snapshot) => UserModel(
        id: snapshot.data['id'],
        username: snapshot.data['username'],
        fullName: snapshot.data['full_name'],
        email: snapshot.data['email'],
        gender: snapshot.data['gender'],
        interests: snapshot.data['interests'],
        birthday: snapshot.data['birthday'],
      ),
    ).toList());
    user = await map.first;
    return user[0];
  }

  Future<Map<String, dynamic>> getRestaurantNameStream() async {
    var restaurantName;
    final path = APIPath.get_restaurant_details(uid);
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    final map = snapshots.map((snapshot) => snapshot.documents.map(
      (snapshot)  =>  { 
        'restaurant_name': snapshot['restaurant_name'],
        'restaurant_address':  snapshot['address'],
        'restaurantUrl': snapshot['imageUrl'],
      }
    ).toList());
    restaurantName = await map.first;
    return restaurantName[0];
  }

  Stream<String> getUserInsterestsStream(){
    final path = APIPath.get_customer_details(uid);
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents.map(
      (snapshot) { 
        return snapshot.data['interests']; 
      }
    ).toString()); 
  }

  Future<bool> checkFollowers(RestaurantModel restaurant) async {
    final path = APIPath.get_restaurant_followers(restaurant.id);
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    final map = snapshots.map((snapshot) => snapshot.documents.map(
      (snapshot) {
        return snapshot.data['id'].toString();
    }).toList());
    var list = await map.first;
    return list.contains(uid);
  }

  Future<int> followersLength(RestaurantModel restaurant) async {
    final path = APIPath.get_restaurant_followers(restaurant.id);
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    final map = snapshots.map((snapshot) => snapshot.documents.map(
      (snapshot) {
        return snapshot.data['id'];
    }).toList());
    
    var list =  await map.first;
    return list.length;
  }

  Future<void> setUserInterests(List<String> interests) async {
    await _service.updateData(
      data: {'interests': interests},
      path: APIPath.customer_details(uid)
    );
  }

  Stream<String> getCode(CampaignModel campaign) {
    var code;
    print(campaign.id);
    final path = APIPath.delete_active_campaigns(uid, campaign.id);
    final reference = Firestore.instance.document(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.data['code']);
  }

  Future<String> getCodeFuture(CampaignModel campaign) async {
    var code;
    final path = APIPath.total_active_campaigns(campaign.id);
    final reference = Firestore.instance.document(path);
    final snapshots = reference.snapshots();
    final map =  snapshots.map((snapshot) => snapshot.data['code']);
    code = await map.first;
    return code;
  }

  final Random _random = Random.secure();
  String createCryptoRandomString(int length) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return base64Url.encode(values);
  }

  Future<void> updateCampaignCode(CampaignModel campaign) async {
    String code = createCryptoRandomString(5);
    await _service.updateData(
      data: {'code': code},
      path: APIPath.campaign_details_active(uid, campaign.id)
    );
    await _service.updateData(
      data: {'code': code},
      path: APIPath.total_active_campaigns(campaign.id),
    );
  }

  Future<void> addUsedCampaigns(Map<String, dynamic> data) async {
    await _service.setData(
      data: {'count': data['count']},
      path: APIPath.total_used_campaigns(data['day'], data['campaign_category'], data['hour'])
    );
  }
  
  Future<void> addFollowers(UserModel user, RestaurantModel restaurant) async {
    await _service.setData(
      path: APIPath.following_restaurants(uid, restaurant.id),
      data: restaurant.toMap(restaurant.id),
    );
    await _service.setData(
      path: APIPath.restaurant_followers(restaurant.id, user.id),
      data: user.toMap(user.id)
    );
  }

  Future<void> createCampaign(CampaignModel campaign) async{
      await _service.setData(
        data: campaign.toMap(),
        path: APIPath.campaign_details_active(uid, campaign.id),
      );
      const oneSec = Duration(seconds: 1);
      // Duration duration_code = Duration(seconds: 300);
      // Timer _timerCode = new Timer.periodic(oneSec, (Timer timer) async { 
      //     if((duration_code - oneSec).inSeconds == 1) {
      //       await updateCampaignCode(campaign);
      //       timer.cancel();
      //     }
      //     else {
      //       duration_code = duration_code - oneSec;
      //       print(duration_code);
      //     }
      //   }
      // );
      if (campaign.campaignType == "Momentarily"){
        Duration duration = campaign.campaignFinished.difference(campaign.campaignStarted);
        Timer _timerCampaign = new Timer.periodic(oneSec, (Timer timer) async { 
          if((duration - oneSec).inSeconds == 1) {
            await _service.removeData(
              path: APIPath.delete_active_campaigns(uid, campaign.id)
            );
            timer.cancel();
          }
          else {
            duration = duration - oneSec;
            print(duration);
          }
        }
      );
    }
  }

  Future<void> deleteCampaign(CampaignModel campaign) async {
    await _service.setData(
      data: campaign.toMap(),
      path: APIPath.old_campaigns(uid, campaign.id)
    );
    await _service.removeData(
      path: APIPath.delete_active_campaigns(uid, campaign.id)
    );
  }

  Future<void> deleteAllCampaign(CampaignModel campaign) async {
    await _service.removeData(
      path: APIPath.total_active_campaigns(campaign.id)
    );
  }

  Future<void> createAllCampaigns(CampaignModel campaign, String campaignId) async {
    await _service.setData(
        data: campaign.toMap(),
        path: APIPath.total_active_campaigns(campaignId),
      );
      if (campaign.campaignType == "Momentarily"){
        const oneSec = Duration(seconds: 1);
        Duration duration = campaign.campaignFinished.difference(campaign.campaignStarted);
        Timer _timerCampaign = new Timer.periodic(oneSec, (Timer timer) async { 
          if((duration - oneSec).inSeconds == 1) {
            await _service.setData(
              data: campaign.toMap(),
              path: APIPath.old_campaigns(uid, campaign.id)
            );
            await _service.removeData(
              path: APIPath.delete_active_campaigns(uid, campaign.id)
            );
            timer.cancel();
          }
          else {
            duration = duration - oneSec;
          }
        }
      );
    }
  }

  Future<String> getUsedCampaigns(int day, String category, String hour) async {
    final path = APIPath.get_total_used_campaigns(day, category, hour);
    final reference = Firestore.instance.document(path);
    final snapshots = reference.snapshots();
    final map = snapshots.map((snapshot) => snapshot.data['count'].toString());
    var list = await map.first;
    return list;
  }

  Future<Map<String, dynamic>> getUsedCampaignsDay(int day, String category) async {
    final path = APIPath.get_total_used_campaigns_2(day, category);
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    final map = snapshots.map((snapshot) => {});
  }

  Future<List<Map<String, dynamic>>> getCoordinates() async {
    final path = APIPath.get_all_restaurants();
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    List<Map<String, dynamic>> cordList = [];
    final map = snapshots.map((snapshot) => snapshot.documents.map(
      (snapshot) =>
          {'id': snapshot.data['id']}  
    ).toList());
    var id = await map.first; 
    int index = 0;
    while (index < id.length) {
      var id_1 = id[index]['id'];
      final path_2 = APIPath.active_campaigns(id_1);
      final reference_2 = Firestore.instance.collection(path_2);
      final snapshots_2 = reference_2.snapshots();
      final map_2 = snapshots_2.map((snapshot) => snapshot.documents.map(
        (snapshot) =>snapshot.exists 
      ).toString());
      final isExist = await map_2.first;
      if (isExist.contains('true')) {
        final path = APIPath.get_restaurant_details(id_1);
        final reference = Firestore.instance.collection(path);
        final snapshots = reference.snapshots();
        final map = snapshots.map((snapshot) => snapshot.documents.map(
          (snapshot) =>
          {'lat': snapshot.data['latitude'], 'long': snapshot.data['longitude'], 'address': snapshot.data['address'], 'name': snapshot.data['restaurant_name'], 'id': snapshot.data['id']}  
        ).toList());
        var cord = await map.first;
        cordList.add(cord[0]);
        print(cordList);
      }
      index = index +1;
    }
    return cordList;
  } 

  Stream<List<CampaignModel>> allCampaignStream() {
    final path = APIPath.get_total_active_campaigns();
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents.map(
      (snapshot) {
        if (snapshot.data['campaign_type'] == "Momentarily"){ 
          return CampaignModel(
            id: snapshot.data['id'],
            title: snapshot.data['title'],
            content: snapshot.data['content'],
            campaignCategory1: snapshot.data['campaign_category_1'],
            campaignCategory2: snapshot.data['campaign_category_2'],
            newPrice: snapshot.data['newPrice'],
            oldPrice: snapshot.data['oldPrice'],
            imageUrl: snapshot.data['imageUrl'], 
            restaurantAddress: snapshot.data['restaurant_address'],
            campaignFinished: snapshot.data['campaign_finished'].toDate(),
            campaignStarted: snapshot.data['campaign_started'].toDate(),
            campaignType: snapshot.data['campaign_type'], 
          );
        } else {
          return CampaignModel(
            id: snapshot.data['id'],
            title: snapshot.data['title'],
            content: snapshot.data['content'],
            campaignCategory1: snapshot.data['campaign_category_1'],
            campaignCategory2: snapshot.data['campaign_category_2'],
            newPrice: snapshot.data['newPrice'],
            oldPrice: snapshot.data['oldPrice'], 
            imageUrl: snapshot.data['imageUrl'],
            campaignDays: snapshot.data['campaign_days'],
            restaurantAddress: snapshot.data['restaurant_address'],
            endingHour: snapshot.data['ending_hour'],
            startingHour: snapshot.data['starting_hour'],
            campaignType: snapshot.data['campaign_type'], 
          );
        }
      }
    ).toList());
  }

   Stream<List<CampaignModel>> campaignStreamMap(String id) {
    final path = APIPath.active_campaigns(id);
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents.map(
      (snapshot) {
        if (snapshot.data['campaign_type'] == "Momentarily"){ 
          return CampaignModel(
            title: snapshot.data['title'],
            content: snapshot.data['content'],
            campaignCategory1: snapshot.data['campaign_category_1'],
            campaignCategory2: snapshot.data['campaign_category_2'],
            newPrice: snapshot.data['newPrice'],
            oldPrice: snapshot.data['oldPrice'], 
            imageUrl: snapshot.data['imageUrl'],
            campaignFinished: snapshot.data['campaign_finished'].toDate(),
            campaignStarted: snapshot.data['campaign_started'].toDate(),
            campaignType: snapshot.data['campaign_type'], 
          );
        } else {
          print(snapshot.data.length);
          return CampaignModel(
            title: snapshot.data['title'],
            content: snapshot.data['content'],
            campaignCategory1: snapshot.data['campaign_category_1'],
            campaignCategory2: snapshot.data['campaign_category_2'],
            newPrice: snapshot.data['newPrice'],
            oldPrice: snapshot.data['oldPrice'], 
            imageUrl: snapshot.data['imageUrl'],
            campaignDays: snapshot.data['campaign_days'],
            endingHour: snapshot.data['ending_hour'],
            startingHour: snapshot.data['starting_hour'],
            campaignType: snapshot.data['campaign_type'], 
          );
        }
      }
    ).toList());
  }

  Stream<List<CampaignModel>> campaignStream() {
    final path = APIPath.active_campaigns(uid);
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents.map(
      (snapshot) {
        if (snapshot.data['campaign_type'] == "Momentarily"){ 
          return CampaignModel(
            id: snapshot.data['id'],
            title: snapshot.data['title'],
            content: snapshot.data['content'],
            campaignCategory1: snapshot.data['campaign_category_1'],
            campaignCategory2: snapshot.data['campaign_category_2'],
            newPrice: snapshot.data['newPrice'],
            oldPrice: snapshot.data['oldPrice'], 
            imageUrl: snapshot.data['imageUrl'],
            campaignFinished: snapshot.data['campaign_finished'].toDate(),
            campaignStarted: snapshot.data['campaign_started'].toDate(),
            campaignType: snapshot.data['campaign_type'], 
          );
        } else {
          return CampaignModel(
            id: snapshot.data['id'],
            title: snapshot.data['title'],
            content: snapshot.data['content'],
            campaignCategory1: snapshot.data['campaign_category_1'],
            campaignCategory2: snapshot.data['campaign_category_2'],
            newPrice: snapshot.data['newPrice'],
            oldPrice: snapshot.data['oldPrice'],
            imageUrl: snapshot.data['imageUrl'], 
            campaignDays: snapshot.data['campaign_days'],
            endingHour: snapshot.data['ending_hour'],
            startingHour: snapshot.data['starting_hour'],
            campaignType: snapshot.data['campaign_type'], 
          );
        }
      }
    ).toList());
  }

  Stream<List<CampaignModel>> campaignStreamInfo(RestaurantModel restaurant){
    final path = APIPath.active_campaigns(restaurant.id);
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents.map(
      (snapshot) {
        if (snapshot.data['campaign_type'] == "Momentarily"){ 
          return CampaignModel(
            id: snapshot.data['id'],
            title: snapshot.data['title'],
            content: snapshot.data['content'],
            campaignCategory1: snapshot.data['campaign_category_1'],
            campaignCategory2: snapshot.data['campaign_category_2'],
            newPrice: snapshot.data['newPrice'],
            oldPrice: snapshot.data['oldPrice'], 
            imageUrl: snapshot.data['imageUrl'],
            campaignFinished: snapshot.data['campaign_finished'].toDate(),
            campaignStarted: snapshot.data['campaign_started'].toDate(),
            campaignType: snapshot.data['campaign_type'], 
          );
        } else {
          return CampaignModel(
            id: snapshot.data['id'],
            title: snapshot.data['title'],
            content: snapshot.data['content'],
            campaignCategory1: snapshot.data['campaign_category_1'],
            campaignCategory2: snapshot.data['campaign_category_2'],
            newPrice: snapshot.data['newPrice'],
            oldPrice: snapshot.data['oldPrice'], 
            imageUrl: snapshot.data['imageUrl'],
            campaignDays: snapshot.data['campaign_days'],
            endingHour: snapshot.data['ending_hour'],
            startingHour: snapshot.data['starting_hour'],
            campaignType: snapshot.data['campaign_type'], 
          );
        }
      }
    ).toList());
  }  

  Stream<List<CampaignModel>> campaignHistoryStream() {
    final path = APIPath.get_old_campaigns(uid);
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents.map(
      (snapshot) {
        if (snapshot.data['campaign_type'] == "Momentarily"){ 
          return CampaignModel(
            title: snapshot.data['title'],
            content: snapshot.data['content'],
            campaignCategory1: snapshot.data['campaign_category_1'],
            campaignCategory2: snapshot.data['campaign_category_2'],
            newPrice: snapshot.data['newPrice'],
            oldPrice: snapshot.data['oldPrice'], 
            imageUrl: snapshot.data['imageUrl'],
            campaignType: snapshot.data['campaign_type'], 
          );
        } else {
          return CampaignModel(
            title: snapshot.data['title'],
            content: snapshot.data['content'],
            campaignCategory1: snapshot.data['campaign_category_1'],
            campaignCategory2: snapshot.data['campaign_category_2'],
            newPrice: snapshot.data['newPrice'],
            oldPrice: snapshot.data['oldPrice'], 
            imageUrl: snapshot.data['imageUrl'],
            endingHour: snapshot.data['ending_hour'],
            startingHour: snapshot.data['starting_hour'],
            campaignType: snapshot.data['campaign_type'], 
          );
        }
      }
    ).toList());
  }

  Stream<List<CampaignModel>> campaignHistoryStreamInfo(RestaurantModel restaurant) {
    final path = APIPath.get_old_campaigns(restaurant.id);
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents.map(
      (snapshot) {
        if (snapshot.data['campaign_type'] == "Momentarily"){ 
          return CampaignModel(
            title: snapshot.data['title'],
            content: snapshot.data['content'],
            campaignCategory1: snapshot.data['campaign_category_1'],
            campaignCategory2: snapshot.data['campaign_category_2'],
            newPrice: snapshot.data['newPrice'],
            imageUrl: snapshot.data['imageUrl'],
            oldPrice: snapshot.data['oldPrice'], 
            campaignType: snapshot.data['campaign_type'], 
          );
        } else {
          return CampaignModel(
            title: snapshot.data['title'],
            content: snapshot.data['content'],
            campaignCategory1: snapshot.data['campaign_category_1'],
            campaignCategory2: snapshot.data['campaign_category_2'],
            newPrice: snapshot.data['newPrice'],
            oldPrice: snapshot.data['oldPrice'],
            imageUrl: snapshot.data['imageUrl'], 
            endingHour: snapshot.data['ending_hour'],
            startingHour: snapshot.data['starting_hour'],
            campaignType: snapshot.data['campaign_type'], 
          );
        }
      }
    ).toList());
  }

  Stream<List<RestaurantModel>> restaurantStream() {
    final path = APIPath.get_all_restaurants();
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents.map(
      (snapshot) {
          return RestaurantModel(
            id: snapshot.data['id'],
            restaurantName: snapshot.data['restaurant_name'],
            restaurantAddress: snapshot.data['address'],
            email: snapshot.data['email'],
            imageUrl: snapshot.data['imageUrl'],
          );
      }
    ).toList());
  }
  
  Stream<List<CampaignModel>> showActiveCampaignsStream() => _service.collectionStream(
    path: APIPath.active_campaigns(uid), 
    builder: (data, campaignId) => CampaignModel.fromMap(data, campaignId),
  );
}

String userIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreUser implements DatabaseUser {

  final _service = FirestoreService.instance;

  Future<void> createUser(String uid, UserModel user) async => await _service.setData (
    path: APIPath.customer_details(uid),
    data: user.toMap(uid)
  );

  Future<void> createToken(String uid) async {
    final path = APIPath.token(uid);
    //String fcmToken = await _fcm.getToken();
  }

  Future<void> createUserType(String uid, String userType) async {
    final path = APIPath.user_type(uid);
    final reference = Firestore.instance.collection(path);
    reference.add({'user_type': userType});
  }

  Future<void> createRestaurant(String uid, RestaurantModel restaurant) async => await _service.setData (
    path: APIPath.restaurant_details(uid),
    data: restaurant.toMap(uid),
  );

  Future<void> createAllRestaurant(String uid, RestaurantModel restaurant) async => await _service.setData (
    path: APIPath.all_restaurants(uid),
    data: restaurant.toMap(uid),
  );
}