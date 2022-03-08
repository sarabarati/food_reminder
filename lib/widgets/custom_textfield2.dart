// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:reminder_app/constants.dart';

class CustomTextField2 extends StatelessWidget {
  CustomTextField2({
    required this.text,
    required this.initialText,
    required this.controllerText,
  });

  String initialText;

  double border = 5;

  String text;

  String updatingText = '';

  final controllerText;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: size.width,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(border),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            width: size.width,
            height: 35,
            decoration: BoxDecoration(
              color: kDarkBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(border),
                topRight: Radius.circular(border),
              ),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: TextFormField(
              controller: controllerText,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
