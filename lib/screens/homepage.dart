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

  bool expiring = false;
  bool healthy = false;
  bool expired = false;
  bool hurrry = false;
  @override
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

                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),

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

                      if (query!.docs.isEmpty) {

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
                          children: snapshot.data!.docs.map<Widget>(
                            (doc) {
                              String id = doc.id;
                              Map data = doc.data() as Map;

                              var now = DateTime.now();
                              String date = data["date"];
                              DateTime othertime = DateTime.parse(date);
                              // final yesterday = DateTime.now()
                              //     .subtract(const Duration(days: 1));
                              bool valDate = now.isAfter(othertime);
                              if (othertime.day == now.day) {
                                hurrry = true;
                              } else {
                                hurrry = false;
                              }
                              if (othertime.day - now.day == 1 ||
                                  othertime.day == now.day ||
                                  othertime.day - now.day == 2 ||
                                  valDate) {
                                expiring = true;
                              } else {
                                expiring = false;
                              }
                              return Visibility(
                                visible: expiring,

                                child: Card(
                                    child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      onTap: () {},

                                      trailing: SizedBox(
                                        width: 96,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                size: 21,
                                              ),
                                              onPressed: () {},
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                size: 21,
                                              ),
                                              onPressed: () {
                                                onDelete(data, id);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      title: Container(
                                        margin: const EdgeInsets.only(
                                            top: 5, left: 5),
                                        child: Text(
                                          data["food's name"],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      subtitle: Container(
                                        margin: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          data["date"],
                                          style: TextStyle(
                                              color: (hurrry)
                                                  ? kOrange
                                                  : (valDate)
                                                      ? Colors.red
                                                      : kYellow,
                                              fontSize: 17),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                              );
                            },
                          ).toList(),
                        ),
                      );
                    } else {
                      return Column(
                        children: const [
                          SizedBox(
                            height: 170,
                          ),
                          Center(
                            child: CircularProgressIndicator(
                              color: kDarkBlue,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
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
                      if (query!.docs.isEmpty) {
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
                          children: snapshot.data!.docs.map<Widget>(
                            (doc) {
                              String id = doc.id;
                              Map data = doc.data() as Map;
                              var now = DateTime.now();
                              String date = data["date"];
                              DateTime othertime = DateTime.parse(date);
                              final after =
                                  DateTime.now().add(const Duration(days: 3));
                              bool valok = after.isBefore(othertime);

                              return Visibility(
                                visible: valok,
                                child: Card(
                                    child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      onTap: () {},
                                      trailing: SizedBox(
                                        width: 96,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                size: 21,
                                              ),
                                              onPressed: () {},
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                size: 21,
                                              ),
                                              onPressed: () {
                                                onDelete(data, id);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      title: Container(
                                        margin: const EdgeInsets.only(
                                            top: 5, left: 5),
                                        child: Text(
                                          data["food's name"],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      subtitle: Container(
                                        margin: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          data["date"],
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 17),
                                        ),
                                      ),

                                    ),
                                  ],
                                )),
                              );
                            },
                          ).toList(),
                        ),
                      );
                    } else {

                      return Column(
                        children: const [
                          SizedBox(
                            height: 170,
                          ),
                          Center(
                            child: CircularProgressIndicator(
                              color: kDarkBlue,
                            ),
                          ),
                        ],

                      );
                    }
                  },
                ),
              ],
            ),

          ]),
        ));
  }

  onDelete(Map data, String id) {
    messageRef2.doc(id).delete();
  }
}
