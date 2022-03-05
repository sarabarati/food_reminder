import 'package:flutter/material.dart';
import 'package:reminder_app/constants.dart';

// ignore: must_be_immutable
class TextFields extends StatelessWidget {
  final TextEditingController textEditingController;
  IconData icon;
  String hint;
  bool hide;
  TextFields(
      {Key? key,
      required this.textEditingController,
      required this.icon,
      required this.hint,
      required this.hide})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330.0,
      child: TextField(
          style: const TextStyle(color: kTextColor),
          cursorColor: Colors.grey,
          controller: textEditingController,
          keyboardType: TextInputType.multiline,
          obscureText: hide,
          maxLines: 1,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[500]),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(6),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.white),
            ),
            contentPadding: const EdgeInsets.only(top: 15),
            border: const OutlineInputBorder(),
            fillColor: Colors.white,
            filled: true,
            prefixIcon: Icon(icon, color: Colors.grey[500]),
          )),
    );
  }
}
