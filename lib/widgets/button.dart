import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  String text;
  int sizeWidth;
  Color color;
  final VoidCallback onTapped;
  MyButton(
      {Key? key,
      required this.text,
      required this.onTapped,
      required this.sizeWidth,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        padding:
            const EdgeInsets.only(left: 146, right: 150, top: 16, bottom: 16),
      ),
      onPressed: () {
        onTapped();
      },
      child: Text(text, style: const TextStyle(color: Colors.black)),
    );
  }
}
