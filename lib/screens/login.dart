import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/constants.dart';
import 'package:reminder_app/screens/homepage.dart';
import 'package:reminder_app/screens/signup.dart';
import 'package:reminder_app/widgets/text_fields.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isWaitingForCode = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isActive = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (auth.currentUser != null) {
      Future.delayed(
        Duration(milliseconds: 500),
        () {
          // kNavigateScreens(context, 'Home Page');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 110,
            ),
            const Center(
              child: Text(
                'Login',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: kTextColor),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            TextFields(
              textEditingController: emailController,
              icon: Icons.email,
              hint: 'Email',
              hide: false,
            ),
            const SizedBox(
              height: 30,
            ),
            TextFields(
              textEditingController: passwordController,
              icon: Icons.lock,
              hint: 'Password',
              hide: true,
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: kDarkBlue,
                padding: const EdgeInsets.only(
                    left: 141, right: 148, top: 14, bottom: 14),
              ),
              onPressed: () {
                onButtonPressed();
              },
              child: const Text('Login',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUp()),
                );
              },
              child: const Text('I dont have an account.',
                  style: TextStyle(color: kTextColor)),
            ),
          ],
        ),
      ),
    );
  }

  onButtonPressed() async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
      reset();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showDialog(
          builder: (BuildContext context) {
            return Center(
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: 250,
                  height: 60,
                  child: const Center(
                      child: Text('No user found for that email.',
                          style: TextStyle(
                              decoration: TextDecoration.none, fontSize: 13)))),
            );
          },
          context: context,
        );
      } else if (e.code == 'wrong-password') {
        showDialog(
          builder: (BuildContext context) {
            return Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                width: 400,
                height: 60,
                child: const Center(
                  child: Text(
                    'Wrong password provided for that user.',
                    style: TextStyle(
                        decoration: TextDecoration.none, fontSize: 13),
                  ),
                ),
              ),
            );
          },
          context: context,
        );
      }
    }
  }

  reset() {
    emailController.clear();
    passwordController.clear();
  }
}
