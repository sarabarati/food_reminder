import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/constants.dart';
import 'package:reminder_app/screens/add_food.dart';
import 'package:reminder_app/screens/signup.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kDarkBlue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context){
                return AddFood(uid: auth.currentUser!.uid);
              },
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
      backgroundColor: kWhite,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SignUp(),
                ),
              );
            },
            icon: Icon(
              Icons.logout,
            ),
          )
        ],
        title: Text(
          'Home page',
        ),
      ),
    );
  }
}
