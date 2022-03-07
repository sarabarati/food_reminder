import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/constants.dart';
import 'package:reminder_app/widgets/custom_calender.dart';
import 'package:reminder_app/widgets/custom_textfield.dart';

class AddFood extends StatefulWidget {
  @override
  State<AddFood> createState() => _AddFoodState();
  AddFood({required this.uid});
  String uid;
}

class _AddFoodState extends State<AddFood> {
  late DateTime _expirationDateTime;

  String expirationDateStr = DateTime.now().toString().substring(0, 10);

  double height = 25;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  late CollectionReference food;

  TextEditingController foodNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    String uID = widget.uid.toString();
    food = fireStore.collection('${auth.currentUser!.email}');
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Add Food'),
      ),
      backgroundColor: kWhite,
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 20),
            CustomTextField(
              text: "Food's Name",
              hintText: 'enter food\'s name...',
              controllerText: foodNameController,
            ),
            SizedBox(height: height),
            CustomTextField(
              text: 'Location',
              hintText: 'enter the location...',
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
                  onPressed: () {
                    if (foodNameController.text == '' ||
                        locationController.text == '') {
                      final snackBar = SnackBar(
                        content: Text(
                          'Please fill all fields',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    addToFireStore();
                  },
                  child: Text(
                    'Add to your list',
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
    _expirationDateTime = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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

  addToFireStore() async {
    Map<String, dynamic> map = new Map();
    map["food's name"] = foodNameController.text;
    map["location"] = locationController.text;
    map['date'] = expirationDateStr;

    await food.add(map).then((value) => print(value)).whenComplete(
      () {
        print('done');
        Navigator.pop(context);
      },
    );
  }
}
