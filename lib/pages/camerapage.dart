import 'dart:html';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bispick/lostitemCRUD/CRUD.dart';
import 'package:bispick/pages/camera_web_methods.dart';
import 'package:bispick/services/LocalStorageService.dart';
import 'package:bispick/styles/AppColors.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class PostPage extends StatefulWidget {
  final Uint8List? imgPath;

  const PostPage({Key? key, this.imgPath}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool isuploading = false;
  String? username = LocalStorageService.loadUser()?.displayName;
  String? useremail;
  String? box_number;
  String? category;
  String? description;
  String? photoURL;

  CRUD crud = new CRUD();
  final formKey = GlobalKey<FormState>();

  void upload() async {
    Reference rootreference = FirebaseStorage.instance
        .ref()
        .child('LostThings')
        .child("${randomAlphaNumeric(10)}.jpg");
    UploadTask uploadTask = rootreference.putData(widget.imgPath!);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    await snapshot.ref.getDownloadURL().then((url) {
      photoURL = url;
    });

    crud
        .uploadData(username, box_number, category, description,
            DateTime.now().toString(), photoURL)
        .then((value) {
      isuploading = false;
      Navigator.pop(context);
      Navigator.popAndPushNamed(context, 'myPageView');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    //getusername();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (isuploading)
        ? Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircularProgressIndicator(
                    color: Colors.black,
                  ),
                  Text('Uploading in process...\n This may take a while...')
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                'I Found This',
                style: TextStyle(
                  fontFamily: "Quicksand", color: Colors.white, fontWeight: FontWeight.bold
                ),
              ),
            ),
            body: Form(
              key: formKey,
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Username',
                            hintText: 'What is your name?'),
                        onChanged: (value) {
                          username = value;
                        },
                        initialValue: username,
                        validator: (value) {
                          // Validate if the input is empty
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username';
                          }
                          // Return null if the input is valid
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Location',
                            hintText: 'Location Item Found'),
                        onChanged: (value) {
                          box_number = value;
                        },
                    )),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: DropdownButtonFormField<String>(
                        //underline: SizedBox.shrink(),
                        decoration: InputDecoration(border: InputBorder.none),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Choose the Category';
                          }
                          return null;
                        },
                        value: category,
                        hint: Text('Category'),
                        isExpanded: true,
                        onChanged: (value) {
                          setState(() {
                            category = value!;
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: "E-Device",
                            child: Text('E-Device'),
                          ),
                          DropdownMenuItem<String>(
                            value: "Clothing",
                            child: Text('Clothing'),
                          ),
                          DropdownMenuItem<String>(
                            value: "Stationery",
                            child: Text('Stationery'),
                          ),
                          DropdownMenuItem<String>(
                            value: "Others",
                            child: Text('Others'),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 150,
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Description',
                            hintText: 'What did you find?'),
                        onChanged: (value) {
                          description = value;
                        },
                        validator: (value) {
                          // Validate if the input is empty
                          if (value == null || value.isEmpty) {
                            return 'Please describe what you found.';
                          }
                          // Return null if the input is valid
                          return null;
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        //padding: EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        child: Image.memory(
                          widget.imgPath!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 40),
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isuploading = true;
                            });
                            upload();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 15.0),
                        ),
                        child: Text(
                          'Upload',
                          style: TextStyle(color: Colors.white, fontFamily: "Quicksand", fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool? isandroid;
  bool? isios;
  //for android
  bool androidaccess = false;

  //for ios
  bool cameraAccess = false;
  String? error;
  List<CameraDescription>? cameras;

  @override
  void initState() {
    if (html.window.navigator.platform!.contains("iPhone") ||
        html.window.navigator.platform!.contains("MacIntel")) {
      getCameras_ios();
      setState(() {
        isios = true;
      });
    } else {
      getCamera_android().then((value) {
        androidaccess = value!;
      });
      setState(() {
        isios = false;
      });
    }
    super.initState();
  }

  Future<void> getCameras_ios() async {
    try {
      await html.window.navigator.mediaDevices!.getUserMedia(
          {'video': true, 'audio': false}); //get the permission to user media
      setState(() {
        cameraAccess = true;
      });
      await availableCameras().then((value) {
        setState(() {
          cameras = value;
        });
      });
      // setState(() {
      //   this.cameras = cameras;
      // });
    } on html.DomException catch (e) {
      setState(() {
        error = '${e.name}: ${e.message}';
      });
    }
  }

  Future<bool?> getCamera_android() async {
    if (initialized) {
      print('Already init');
      return true;
    }

    try {
      final mediaStream = await window.navigator.mediaDevices!.getUserMedia({
        'video': {'facingMode': 'environment'},
        'audio': false
      }); //get the permission to use media
      video.srcObject = mediaStream;
      await video.play();
      initialized = true;
      return true;
    } on DomException catch (e) {
      print('Error: ${e.message}');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (isios!) {
      if (error != null) {
        return Scaffold(
          body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: Text('Error: $error'))),
        );
      }
      if (!cameraAccess) {
        return Scaffold(
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: const Center(
                child: Text(
              'Camera access not granted yet.',
              style: TextStyle(color: Colors.black),
            )),
          ),
        );
      }
      if (cameras == null) {
        return Scaffold(
          body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                  child: Text(
                'Reading cameras',
                style: TextStyle(color: Colors.black),
              ))),
        );
      }
      return IosCameraView(cameras: cameras!);
    } else {
      return AndroidCameraView(
        success: androidaccess,
      );
    }
  }
}

//ANDROID CAMERA VIEW
class AndroidCameraView extends StatefulWidget {
  final bool success;
  const AndroidCameraView({Key? key, required this.success}) : super(key: key);

  @override
  _AndroidCameraViewState createState() => _AndroidCameraViewState();
}

class _AndroidCameraViewState extends State<AndroidCameraView> {
  Uint8List? photoBytes;

  Uint8List takePic() {
    //assert(initialized);

    final context = canvas.context2D;

    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    context.drawImage(video, 0, 0);

    final data = canvas.toDataUrl('image/png');
    final uri = Uri.parse(data);
    return uri.data!.contentAsBytes();
  }

  @override
  void initState() {
    // TODO: implement initState
    ui.platformViewRegistry
        .registerViewFactory('video-view', (int viewId) => video);
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
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: const HtmlElementView(viewType: 'video-view')),
            Align(
              //alignment: Alignment.bottomCenter,

              child: GestureDetector(
                onTap: () async {
                  final bytes = takePic();
                  setState(() {
                    photoBytes = bytes;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PostPage(
                              imgPath: photoBytes,
                            )));
                  });
                },
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//IOS CAMERA VIEW
class IosCameraView extends StatefulWidget {
  final List<CameraDescription> cameras;
  const IosCameraView({Key? key, required this.cameras}) : super(key: key);

  @override
  _IosCameraViewState createState() => _IosCameraViewState();
}

class _IosCameraViewState extends State<IosCameraView> {
  String? error;
  CameraController? controller;
  late CameraDescription cameraDescription =
      (widget.cameras.length > 1) ? widget.cameras[1] : widget.cameras[0];

  Future<void> initCam(CameraDescription description) async {
    setState(() {
      controller = CameraController(description, ResolutionPreset.max);
    });

    try {
      await controller!.initialize();
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initCam(cameraDescription);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
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
            },
          ),
        ),
        body: Center(
          child: Text('Initializing error: $error\nCamera list:'),
        ),
      );
    }
    if (controller == null) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Center(child: Text('Loading controller...')));
    }
    if (!controller!.value.isInitialized) {
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
              },
            ),
          ),
          body: Center(child: Text('Initializing camera...')));
    }

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
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: CameraPreview(controller!)),
            Align(
              //alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: controller == null
                    ? null
                    : () async {
                        final file = await controller!.takePicture();
                        await file.readAsBytes().then((value) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PostPage(
                                imgPath: value,
                              ),
                            ),
                          );
                        });
                      },
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
