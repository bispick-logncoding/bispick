import 'package:bispick/lostitemCRUD/CRUD.dart';
import 'package:bispick/pages/home.dart';
import 'package:bispick/pages/itemsdetail.dart';
import 'package:bispick/styles/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Edevice extends StatefulWidget {
  const Edevice({Key? key}) : super(key: key);

  @override
  _EdeviceState createState() => _EdeviceState();
}

class _EdeviceState extends State<Edevice> {
  CRUD crud = new CRUD();
  late Stream<QuerySnapshot> edevices;
  bool isLoading = false;

  @override
  void initState() {
    isLoading = true;
    crud.getEdevices().then((value) {
      setState(() {
        isLoading = false;
        edevices = value;
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
          'Lost E-devices',
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
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(color: Colors.black),
      )
          : Container(
        child: edevices != null ? StreamBuilder<QuerySnapshot>(
          stream: edevices,
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

                    return Card(
                      margin: EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LostThingDetailView(
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
                        child: Stack(
                          children: [
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
                                    image: NetworkImage(photoUrl),
                                    fit: BoxFit.cover,
                                  ),
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
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
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
                    child: Text('No Lost E-Devices yet.'),
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