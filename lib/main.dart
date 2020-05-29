import 'package:flutter/material.dart';
import 'package:login/app/landing_page.dart';
import 'package:login/app/services/auth.dart';
import 'package:login/app/services/database.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<DatabaseUser>(
          create: (context) => FirestoreUser(),
          child: Provider<AuthBase>(
            create:(context) => Auth(), 
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Toprofffer',
              theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: LandingPage(),
          ),
      ),
    );
  }
}

