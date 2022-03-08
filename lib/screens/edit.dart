import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/constants.dart';
import 'package:reminder_app/widgets/custom_calender.dart';
import 'package:reminder_app/widgets/custom_textfield2.dart';

class Edit extends StatefulWidget {
  Edit({
    required this.initialFoodName,
    required this.initialLocation,
    required this.id,
    required this.date,
  });

  String initialFoodName;

  String initialLocation;

  String id;

  String date;

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  double height = 25;

  late String expirationDateStr;

  late DateTime _expirationDateTime;

  late CollectionReference foodRef;

  late TextEditingController foodNameController;
  late TextEditingController locationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foodRef = fireStore.collection('${auth.currentUser!.email}');
    foodNameController = TextEditingController(text: widget.initialFoodName);
    locationController = TextEditingController(text: widget.initialLocation);
    expirationDateStr = widget.date;
  }

  @override
  Widget build(BuildContext context) {
    String initialFoodName = widget.initialFoodName;
    String initialLocation = widget.initialLocation;
    String id = widget.id;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Edit food'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            CustomTextField2(
              text: 'Food\s name',
              initialText: initialFoodName,
              controllerText: foodNameController,
            ),
            SizedBox(height: height),
            CustomTextField2(
              text: 'Location',
              initialText: initialLocation,
              controllerText: locationController,
            ),
            SizedBox(height: height),
            CustomCalender(
              text: 'Expiration Date',
              date: expirationDateStr,
              setDate: setExpirationDate,
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints.tightFor(
                  width: double.infinity,
                  height: 50,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: kDarkBlue, // Background color
                  ),
                  onPressed: () async {
                    await edit();
                  },
                  child: Text(
                    'Edit',
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  setExpirationDate() async {
    String date = widget.date;
    _expirationDateTime = (await showDatePicker(
      context: context,
      initialDate: DateTime.parse(date),
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: kDarkBlue, // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.green, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.black, // button text color
                ),
              ),
            ),
            child: child!);
      },
    ))!;

    setState(() {
      expirationDateStr = _expirationDateTime.toString().substring(0, 10);
    });
  }

  edit() async {
    String id = widget.id;
    String foodName = foodNameController.text;
    String location = locationController.text;
    String date = widget.date;

    DocumentReference doc = foodRef.doc(id);
    await doc.update({
      "food's name": foodName,
      "location": location,
      "date": expirationDateStr,
    });
    Navigator.pop(context);
  }
}
