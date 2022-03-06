// ignore_for_file: prefer_is_empty

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/constants.dart';
import 'package:reminder_app/screens/homepage.dart';
import 'package:reminder_app/screens/login.dart';
import 'package:reminder_app/widgets/text_fields.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpVendorsState createState() => _SignUpVendorsState();
}

class _SignUpVendorsState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  late CollectionReference messageRef;
  @override
  void initState() {
    super.initState();
    messageRef = fireStore.collection('Users_info');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: kWhite,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 90,
                ),
                const Text(
                  'Sign Up',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: kTextColor),
                ),
                const SizedBox(
                  height: 50,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFields(
                  textEditingController: nameController,
                  icon: Icons.person,
                  hint: 'Fullname',
                  hide: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFields(
                  textEditingController: emailController,
                  icon: Icons.email,
                  hint: 'Email',
                  hide: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFields(
                  textEditingController: passwordController,
                  icon: Icons.lock,
                  hint: 'Password',
                  hide: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFields(
                  textEditingController: confirmpasswordController,
                  icon: Icons.lock,
                  hint: 'Confirm password',
                  hide: true,
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: kDarkBlue,
                    padding: const EdgeInsets.only(
                        left: 132, right: 144, top: 14, bottom: 14),
                  ),
                  onPressed: () {
                    onButtonPressed();
                  },
                  child: const Text('Submit',
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
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  child: const Text('Already have an account?',
                      style: TextStyle(color: kTextColor)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onButtonPressed() async {
    if (nameController.text.length == 0) {
      showDialog(
        builder: (BuildContext context) {
          return Center(
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                width: 220,
                height: 60,
                child: const Center(
                    child: Text('Please enter your name.',
                        style: TextStyle(
                            decoration: TextDecoration.none, fontSize: 13)))),
          );
        },
        context: context,
      );
    } else if (passwordController.text != confirmpasswordController.text) {
      showDialog(
        builder: (BuildContext context) {
          return Center(
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                width: 300,
                height: 60,
                child: const Center(
                  child: Text('Your Confirm password is not correct. ',
                      style: TextStyle(
                          decoration: TextDecoration.none, fontSize: 13)),
                )),
          );
        },
        context: context,
      );
    } else {
      try {
        // ignore: unused_local_variable
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        sendInfo();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
        reset();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showDialog(
            builder: (BuildContext context) {
              return Center(
                child: Container(
                    color: Colors.white,
                    width: 400,
                    height: 60,
                    child: const Center(
                        child: Text('The password provided is too weak.',
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 13)))),
              );
            },
            context: context,
          );
        } else if (e.code == 'email-already-in-use') {
          showDialog(
            builder: (BuildContext context) {
              return Center(
                child: Container(
                    color: Colors.white,
                    width: 400,
                    height: 60,
                    child: const Center(
                        child: Text(
                            'The account already exists for that email.',
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 13)))),
              );
            },
            context: context,
          );
        }
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  sendInfo() async {
    String fullname = nameController.text;
    // ignore: prefer_collection_literals
    Map<String, dynamic> newMap = Map();
    newMap['fullname'] = fullname;
    newMap['sender'] = auth.currentUser!.uid;
    newMap['email'] = auth.currentUser!.email;

    messageRef
        .doc(auth.currentUser!.email)
        .set(newMap)
        .then((value) {})
        .whenComplete(() {});
  }

  reset() {
    nameController.clear();
    confirmpasswordController.clear();
    emailController.clear();
    passwordController.clear();
  }
}
