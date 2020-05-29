import 'package:flutter/material.dart';
import 'package:login/app/services/auth.dart';
import 'package:login/app/services/database.dart';
import 'package:login/app/sign_in/signin_page.dart';
import 'package:login/app/user_type.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
       stream: auth.onAuthStateChanged,
       builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
        }
         return Provider<Database>(
           create: (_) => FirestoreDatabase(uid: user.uid),
           child: UserTypePage(),
          );
       }
        else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator(),
            ),
          );
        }
      }  
    );
  }
} 