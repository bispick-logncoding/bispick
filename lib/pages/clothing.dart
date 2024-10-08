import 'package:bispick/lostitemCRUD/CRUD.dart';
import 'package:bispick/pages/home.dart';
import 'package:bispick/pages/itemsdetail.dart';
import 'package:bispick/styles/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Clothing extends StatefulWidget {
  const Clothing({Key? key}) : super(key: key);

  @override
  _ClothingState createState() => _ClothingState();
}

class _ClothingState extends State<Clothing> {
  CRUD crud = new CRUD();
  Stream? clothing;

  @override
  void initState() {
    crud.getClothings().then((value) {
      setState(() {
        clothing = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        title: Text(
          'Lost Clothings',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
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
          ),
        ],
      ),
      body: Container(
        child: clothing != null ? StreamBuilder<QuerySnapshot>(
          stream: clothing as Stream<QuerySnapshot>,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              print(snapshot.connectionState);
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data!.size != 0) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final lostThing = snapshot.data!.docs[index];
                    final photoUrl = lostThing.get('photourl');
                    final description = lostThing.get('description');
                    final box_num = lostThing.get('box_number');
                    final lostthingid = lostThing.id;
                    final String dateString = lostThing.get('time');
                    final DateTime dataTime = DateFormat("yyyy-dd-mm hh:mm").parse(dateString);
                    String formattedTime = DateFormat('MM-dd-yyyy HH:mm').format(dataTime);
                    // final DateTime formattedTime = DateFormat('MM-dd-yyyy HH:mm').parse(dateString);
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LostThingDetailView(
                                        username: snapshot.data!.docs[index]
                                            .get('username'),
                                        box_number: box_num,
                                        photourl: photoUrl,
                                        description: description,
                                        time: snapshot.data!.docs[index]
                                            .get('time'),
                                        id: lostthingid,
                                      )));
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Container(
                                    height:
                                        (MediaQuery.of(context).size.height -
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
                                        image: NetworkImage(photoUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
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
                                        Text(
                                          description,
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          box_num,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          formattedTime,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text('No Lost Clothings yet.'),
                  ),
                );
              }
            } else {
              return Center(child: Text('No lost things yet'));
            }
          },
        ) : Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
