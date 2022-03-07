import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/constants.dart';
import 'package:reminder_app/screens/add_food.dart';
import 'package:reminder_app/screens/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  late CollectionReference messageRef2;
  String type = 'Your Foods';
  bool ok = false;
  void initState() {
    super.initState();
    messageRef2 = fireStore.collection('${auth.currentUser!.email}');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: kDarkBlue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AddFood(uid: auth.currentUser!.uid);
                  },
                ),
              );
            },
            child: const Icon(
              Icons.add,
            ),
          ),
          backgroundColor: kWhite,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(110.0),
            child: AppBar(
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () async {
                    await auth.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.logout,
                  ),
                )
              ],
              bottom: TabBar(
                indicatorColor: Colors.white,
                // labelColor: kBlack,
                unselectedLabelColor: Colors.white,
                labelStyle:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                onTap: (index) {
                  setState(() {
                    type = "Your Foods";
                  });
                },
                tabs: const [
                  Tab(
                    text: 'Expiring',
                  ),
                  Tab(text: 'Healthy'),
                ],
              ),
              title: Column(
                children: [
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    type,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courgette',
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(children: [
            Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                StreamBuilder(
                  stream: messageRef2.orderBy('date').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      QuerySnapshot<Object?>? query = snapshot.data;
                      var now = new DateTime.now();
                      var formatter = new DateFormat('yyyy-MM-dd');
                      String formattedDate = formatter.format(now);
                      print(formattedDate);
                      if (query!.docs.length == 0) {
                        return const Center(
                            child: Text(
                          'No foods yet !',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ));
                      }
                      return Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          // physics: const NeverScrollableScrollPhysics(),

                          children: snapshot.data!.docs.map<Widget>(
                            (doc) {
                              String id = doc.id;
                              Map data = doc.data() as Map;
                              var now = new DateTime.now();
                              var formatter = new DateFormat('yyyy-MM-dd');
                              String formattedDate = formatter.format(now);
                              int nowday =
                                  int.parse(formattedDate.substring(8));
                              int nowmonth =
                                  int.parse(formattedDate.substring(5, 7));
                              int nowyear =
                                  int.parse(formattedDate.substring(0, 4));
                              String date = data["date"];
                              int day = int.parse(date.substring(8));
                              int month = int.parse(date.substring(5, 7));
                              int year = int.parse(date.substring(0, 4));
                              if ((nowday - day == 0 ||
                                      nowday - day == 1 ||
                                      nowday - day == 2 ||
                                      nowday - day == 3 ||
                                      day < nowday) &&
                                  month == nowmonth &&
                                  year == nowyear) {
                                ok = true;
                              }
                              return Visibility(
                                visible: ok,
                                child: Card(
                                    child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      onTap: () {},
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          loadData();
                                        },
                                      ),
                                      title: Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          data["food's name"],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      subtitle: Text(data["date"]),
                                    ),
                                  ],
                                )),
                              );
                            },
                          ).toList(),
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  const Text("hi"),
                ],
              ),
            ),
          ]),
        ));
  }

  loadData() {}
}
