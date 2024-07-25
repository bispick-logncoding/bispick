import 'package:bispick/lostitemCRUD/CRUD.dart';
import 'package:bispick/pages/itemsdetail.dart';
import 'package:bispick/styles/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  CRUD crud = new CRUD();
  Stream? lostthingstream;
  int? num_lostthings;

  @override
  void initState() {
    // TODO: implement initState
    crud.getallLostthings().then((value) {
      setState(() {
        lostthingstream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                flex: 2,
                child: Container(
                    color: AppColors.primary,
                  child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child:Image.asset(
                              'assets/bispick-white.png',

                            )
                        ),
                        Expanded(
                            flex: 1,
                            child: Row(

                              children: [
                                Container(
                                  height: 56,
                                  width: MediaQuery.of(context).size.width / 3,
                                  margin: EdgeInsets.symmetric(vertical: 16),
                                  color: AppColors.primary,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed('allLostItemsView');
                                    },
                                    child: Text(
                                      "Lost",
                                      style: TextStyle(color: Colors.white, fontFamily: "Quicksand", fontSize: 17, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 56,
                                  width: MediaQuery.of(context).size.width / 3,
                                  margin: EdgeInsets.symmetric(vertical: 16),
                                  color: AppColors.primary,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed('cameraView');
                                    },
                                    child: Text(
                                      "Found",
                                      style: TextStyle(color: Colors.white, fontFamily: "Quicksand", fontSize: 17, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 56,
                                  width: MediaQuery.of(context).size.width / 3,
                                  margin: EdgeInsets.symmetric(vertical: 16),
                                  color: AppColors.primary,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed('requestView');
                                    },
                                    child: Text(
                                      "Request",
                                      style: TextStyle(color: Colors.white, fontFamily: "Quicksand", fontSize: 17, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            )
                        )

                      ]
                  )
                )

            ),
            Expanded(
              flex: 9,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Categories",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: "Quicksand", color: AppColors.primary),
                    ),
                    margin: EdgeInsets.only(top: 25),
                    padding: EdgeInsets.only(left: 10, bottom: 10),
                  ),
                  Stack(
                    children: [
                      Positioned(
                        top:0,
                          bottom: 0,
                          left: MediaQuery.of(context).size.width / 3,
                          child: Container(
                            height: 40,
                            width: 2,
                            color: AppColors.primary,
                          )
                      ),
                      Row(
                        children: [

                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('edeviceView');
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 56,
                              width: MediaQuery.of(context).size.width / 4,
                              color: AppColors.secondary,
                              child: Text(
                                "E-Device",
                                style: TextStyle(color: AppColors.primary, fontFamily: "Quicksand"),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('clothingView');
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 56,
                              width: MediaQuery.of(context).size.width / 4,
                              color: AppColors.secondary,
                              child: Text(
                                "Clothing",
                                style: TextStyle(color: AppColors.primary, fontFamily: "Quicksand"),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('stationaryView');
                            },
                            child: Container(
                                alignment: Alignment.center,
                                height: 56,
                                width: MediaQuery.of(context).size.width / 4,
                                color: AppColors.secondary,
                                child: Text(
                                  "Stationary",
                                  style: TextStyle(color: AppColors.primary, fontFamily: "Quicksand"),
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('othersView');
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 56,
                              width: MediaQuery.of(context).size.width / 4,
                              color: AppColors.secondary,
                              child: Text(
                                "Others",
                                style: TextStyle(color: AppColors.primary, fontFamily: "Quicksand"),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 15),
                      child: Text(
                        "Lost Items",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      padding: EdgeInsets.only(left: 10, bottom: 10, top: 10)),
                  StreamBuilder<QuerySnapshot>(
                      stream: lostthingstream as Stream<QuerySnapshot>,
                      builder: (context, snapshot) {
                        if (snapshot.data!.size == 0) {
                          return Center(
                            child: Text(
                              'There are no lost items yet.',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.orange,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          print(snapshot.connectionState);
                          return Center(
                            child: Text('ERROR HAS HAPPENED'),
                          );
                        }
                        return ListView.builder(
                            padding: EdgeInsets.all(8),
                            itemCount: (snapshot.data!.size < 5 &&
                                    snapshot.data!.size > 0)
                                ? snapshot.data!.size
                                : 5,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final lostThing = snapshot.data!.docs[index];
                              final photoUrl = lostThing.get('photourl');
                              final description = lostThing.get('description');
                              final box_num = lostThing.get('box_number');
                              final lostthingid = lostThing.id;
                              return Container(
                                margin: EdgeInsets.all(8),
                                child: ListTile(
                                  leading: Container(
                                    width: 100,
                                    child: Image.network(
                                      photoUrl,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  title: Text("Found Item: ${description}"),
                                  subtitle: Text("Location: ${box_num}"),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.black, width: 1.5),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LostThingDetailView(
                                                  username: snapshot
                                                      .data!.docs[index]
                                                      .get('username'),
                                                  box_number: box_num,
                                                  photourl: photoUrl,
                                                  description: description,
                                                  time: snapshot
                                                      .data!.docs[index]
                                                      .get('time'),
                                                  id: lostthingid,
                                                )));
                                  },
                                ),
                              );
                            });
                      }),
                ],
              ),
            ),
          ])),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  // TODO: implement searchFieldLabel
  String get searchFieldLabel => "Search your lost item";

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Lostthings')
          .orderBy('time')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text('Please Search for your lost item.');
        }
        final results = snapshot.data!.docs.where((DocumentSnapshot s) =>
            s['description'].toString().contains(query));
        return ListView(
          children: results
              .map<Widget>((DocumentSnapshot e) => Card(
                    margin: EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LostThingDetailView(
                                      username: e['username'],
                                      box_number: e['box_number'],
                                      photourl: e['photourl'],
                                      description: e['description'],
                                      time: e['time'],
                                      id: e.id,
                                    )));
                      },
                      child: Stack(
                        children: [
                          Opacity(
                            opacity: 0.5,
                            child: Container(
                              height:
                                  (MediaQuery.of(context).size.height - 56) / 3,
                              padding: const EdgeInsets.all(15),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                                image: DecorationImage(
                                  opacity: 0.5,
                                  image: NetworkImage(e['photourl']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height:
                                (MediaQuery.of(context).size.height - 56) / 3,
                            padding: const EdgeInsets.all(15),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e['description'],
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    e['box_number'],
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Center(
      child: Text(
        query,
        style: TextStyle(
            color: Colors.blue, fontWeight: FontWeight.w900, fontSize: 30),
      ),
    );
  }
}
