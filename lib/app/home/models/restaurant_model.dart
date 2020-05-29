class RestaurantModel {
  RestaurantModel({ 
    this.id,
    this.username,  
    this.restaurantName,
    this.restaurantAddress,
    this.password, 
    this.email,
    this.userType, 
    this.longitude,
    this.latitude,
  });
  final String id;
  final String username;
  final String restaurantName;
  final String password;
  final String email;
  final String userType;
  final String restaurantAddress;
  final double longitude;
  final double latitude;
  DateTime now = DateTime.now();

  factory RestaurantModel.fromMap(Map<String, dynamic> data, String userId) {
    if (data == null){
      print('null');
      return null;
    }
    final String username = data['username'];
    final String restaurantName = data['restaurant_name'];
    final String email =  data['email'];
    final String password  = data['passwprd'];
    final String restaurantAddress = data['address'];
    final String userType = data['user type'];
    final double longitude = data['longitude'];
    final double latitude = data['latitude'];
    return RestaurantModel(
      id: userId,
      username: username,
      restaurantName: restaurantName,
      restaurantAddress: restaurantAddress,
      password: password,
      email: email,
      userType: userType,
      longitude: longitude,
      latitude: latitude
    );
  }

  Map<String, dynamic> toMap(String uid) {
    return {
      'id': uid,
      'restaurant_name': restaurantName,
      'username': username,
      'password': password,
      'address': restaurantAddress,
      'latitude': latitude,
      'longitude': longitude,
      'user type': userType,
      'email': email,
    };
  }

  RestaurantModel copyWith({
    String username,
    String restaurantName,
    String password,
    String email,
    String userType,
    String restaurantAddress,
    double latitude,
    double longitude,
  }) {
    return RestaurantModel(
      restaurantName: restaurantName ?? this.restaurantName,
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      userType: userType ?? this.userType,
      restaurantAddress: restaurantAddress ?? this.restaurantAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude
    ); 
  }
}