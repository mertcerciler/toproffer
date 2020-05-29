

class UserModel {
  UserModel({ 
    this.id,
    this.username,  
    this.fullName, 
    this.password, 
    this.email, 
    this.day,
    this.month,
    this.year,
    this.birthday,
    this.userType, 
    this.gender,
    this.dateCheck,
    this.interests,
  });
  final String id;
  final String username;
  final String fullName;
  final String password;
  final String email;
  final int day;
  final String userType;
  final int month;
  final int year;
  final DateTime birthday;
  final String gender;
  final bool dateCheck;
  final List<String> interests;
  DateTime now = DateTime.now();

  factory UserModel.fromMap(Map<String, dynamic> data, String userId) {
    if (data == null){
      print('null');
      return null;
    }
    final String username = data['username'];
    final String fullName = data['full_name'];
    final String email =  data['email'];
    final String gender =  data['gender'];
    final String password  = data['passwprd'];
    final DateTime birthday = data['birthday'];
    final String userType = data['user type'];
    final List<String> interests = [];
    return UserModel(
      id: userId,
      username: username,
      fullName: fullName,
      password: password,
      email: email,
      birthday:  birthday,
      gender: gender,
      userType: userType,
      interests: interests,
    );
  }
  
  Map<String, dynamic> toMap(String userId) {
    return {
      'id': userId,
      'full_name': fullName,
      'username': username,
      'password': password,
      'user type': userType,
      'email': email,
      'birthday': birthday,
      'gender': gender,
      'interests': interests,
    };
  }

  UserModel copyWith({
  String username,
  String fullName,
  String password,
  String email,
  String userType,
  DateTime birthday,
  String gender,
  bool dateCheck,
  List<String> interests,
  }) {
    return UserModel(
      dateCheck: dateCheck ?? this.dateCheck,
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      userType: userType ?? this.userType,
      fullName: fullName ?? this.fullName,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      interests: interests ?? this.interests
    ); 
  }
}