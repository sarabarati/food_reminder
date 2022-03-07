import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/screens/add_food.dart';
import 'package:reminder_app/screens/homepage.dart';
import 'package:reminder_app/screens/login.dart';

import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: kDarkBlue,
        ),
      ),
      home: const Login(),
    );
  }
}
