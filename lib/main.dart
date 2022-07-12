import 'package:fireauth/Login.dart';
import 'package:fireauth/SignUp.dart';
import 'package:fireauth/Start.dart';
import 'package:fireauth/bottomnavigationbar.dart';
import 'package:fireauth/edit_profile.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.green),
      debugShowCheckedModeBanner: false,
      home: Start(),

      routes: <String, WidgetBuilder>{
        "editprofile": (BuildContext context) => EditProfilePage(),
        "Login": (BuildContext context) => Login(),
        "SignUp": (BuildContext context) => SignUp(),
        "start": (BuildContext context) => Start(),
        "home": (BuildContext context) => Bottomnavigationbar()
      },
      //deva
    );
  }
}
