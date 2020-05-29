import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:login/app/home/models/user_model.dart';
import 'package:login/app/services/auth.dart';
import 'package:login/app/services/database.dart';

class SignUpBloc {
  SignUpBloc({@required this.database, @required this.auth});
  final AuthBase auth;
  final DatabaseUser database;
  final StreamController<UserModel> _modelController = StreamController<UserModel>();

  Stream<UserModel> get modelStream => _modelController.stream;
  UserModel _model = UserModel();

  void dispose(){
    _modelController.close();
  }

  Future<void> createUser(BuildContext context) async {
    User user;
    DateTime now = DateTime.now();
    try {
      user = await auth.createUserWithEmailAndPassword(_model.email.trim(), _model.password.trim());
      await database.createUserType(user.uid,'customers');
      await database.createToken(user.uid);
      await database.createUser(user.uid, UserModel(
        id: user.uid,
        username: _model.username,
        fullName: _model.fullName,
        password: _model.password,
        userType: 'Customer',
        email: _model.email,
        birthday: _model.birthday,
        gender: _model.gender,
        interests: _model.interests,
    ));
    } catch(e) {
      rethrow;
    }
    
    
    
    Navigator.of(context).pop();
  } 

  void updateUsername(String username) => updateWith(username: username);
  void updatePassword(String password) => updateWith(password: password);
  void updateGender(String gender) => updateWith(gender: gender);
  void updateFullName(String fullName) => updateWith(fullName: fullName);
  void updateEmail(String email) => updateWith(email: email);
  void updateBirthday(DateTime birthday) => updateWith(birthday: birthday);

  void checkDate() {
    DateTime _date = new DateTime.now();
    final differenceDate = _date.difference(_model.birthday).inDays;
    if (_model.day > 31 || _model.day == null) {
      updateWith(dateCheck: false);
    } else if (_model.month > 12 || _model.month == null) {
      updateWith(dateCheck: false);
    } else if (_model.year > DateTime.now().year || _model.year == null) {
      updateWith(dateCheck: false);
    } else if (differenceDate < 0) {
      updateWith(dateCheck: false);
    } else {
      updateWith(dateCheck: false);
    }
  }



  void updateWith({
    String username,
    String fullName,
    String password,
    String email,
    DateTime birthday,
    String gender,
    bool dateCheck
  }) {
    _model = _model.copyWith(
      email: email,
      password: password,
      fullName: fullName,
      username: username,
      birthday: birthday,
      gender: gender,
      dateCheck: dateCheck
    );
    _modelController.add(_model);
    // update model
    // add updated model to _modelController 
  } 
}