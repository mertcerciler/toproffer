import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:login/app/services/auth.dart';
import 'package:login/app/sign_in/e-mail_sign_in_model.dart';

class EmailSignInBloc {
  EmailSignInBloc({@required this.auth});
  final AuthBase auth;
  final StreamController<EmailSignInModel> _modelController = StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _modelController.close();
  }

  Future<void> submit(BuildContext context) async {
    updateWith(submitted: true, isLoading: true);
    try {
      await auth.signInWithEmailAndPassword(_model.email.trim(), _model.password.trim());
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
    Navigator.of(context).pop();
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String email,
    String password,
    bool isLoading,
    bool submitted,
  }) {
    _model = _model.copyWith(
      email: email,
      password: password,
      isLoading: isLoading,
      submitted: submitted,
    );
    _modelController.add(_model);
    // update model
    // add updated model to _modelController 

  }
}