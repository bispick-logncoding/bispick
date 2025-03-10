import 'package:bispick/enums/found_status.dart';
import 'package:bispick/lostitemCRUD/CRUD.dart';
import 'package:bispick/pages/home.dart';
import 'package:bispick/pages/itemsdetail.dart';
import 'package:bispick/styles/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllLostThings extends StatefulWidget {
  const AllLostThings({super.key});

  @override
  State<AllLostThings> createState() => _AllLostThingsState();
}

class _AllLostThingsState extends State<AllLostThings> {
  CRUD crud = new CRUD();
  late Stream<QuerySnapshot> lostthingstream;
  bool isLoading = false;

  @override
  void initState() {
    isLoading = true;
    crud.getAllApprovedLostThings().then((value) {
      setState(() {
        isLoading = false;
        lostthingstream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
            ),
          )
        ],
        title: Text(
          'All Lost Items',
          style: TextStyle(color: Colors.white, fontFamily: "Quicksand", fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(color: Colors.black),
      )
          : StreamBuilder<QuerySnapshot>(
        stream: lostthingstream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          } else if (snapshot.hasError) {

            return Center(
              child: Text("ERROR HAS HAPPENED"),
            );
          } else if (snapshot.hasData) {
            var filteredData = snapshot.data!.docs.where((document) {
              var data = document.data() as Map<String, dynamic>;
              return data['foundStatus'] == FoundStatus.Approved.value;
            }).toList();
            return ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final lostThing = filteredData[index];
                  final photoURL = lostThing.get('photourl');
                  final description = lostThing.get("description");
                  final box_num = lostThing.get("box_number");
                  final lostthingid = lostThing.id;

                  return Card(
                      margin: EdgeInsets.all(10),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LostThingDetailView(
                                          username: filteredData[index]
                                              .get('username'),
                                          box_number: box_num,
                                          photourl: photoURL,
                                          description: description,
                                          time: snapshot.data!.docs[index]
                                              .get('time'),
                                          id: lostthingid,
                                        )));
                          },
                          child: Stack(children: [
                            Opacity(
                              opacity: 0.5,
                              child: Container(
                                height: (MediaQuery.of(context).size.height -
                                    56) /
                                    3,
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
                                      image: NetworkImage(photoURL),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            Container(
                                height: (MediaQuery.of(context).size.height -
                                    56) /
                                    3,
                                padding: const EdgeInsets.all(15),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 3,
                                  ),
                                ),
                                child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(description,
                                              style: TextStyle(
                                                  color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "Quicksand")),
                                          Text(
                                            box_num,
                                            style: TextStyle(
                                                color: Colors.black, fontWeight: FontWeight.w500, fontFamily: "Quicksand"),
                                          )
                                        ])))
                          ])));
                });
          } else {
            return Center(
              child: Text("No lost things yet"),
            );
          }
        },
      ),
    );
  }
}