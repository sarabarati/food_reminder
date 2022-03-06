// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:reminder_app/constants.dart';

class CustomCalender extends StatelessWidget {
  CustomCalender({
    required this.text,
    required this.date,
    required this.setDate,
  });

  String text;

  double border = 5;

  String date;

  VoidCallback setDate;

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
          Spacer(),
          InkWell(
            onTap: setDate,
            child: Container(
              width: size.width,
              height: 65,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(border),
                bottomRight: Radius.circular(border),
              )),
              child: Center(
                child: Text(
                  date,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
