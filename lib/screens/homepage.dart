import 'package:flutter/material.dart';
import 'package:reminder_app/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kDarkBlue,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
          automaticallyImplyLeading: false, title: const Text("Your Foods")),
    );
  }
}
