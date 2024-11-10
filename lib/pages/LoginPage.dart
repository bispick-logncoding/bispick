import 'package:bispick/services/LocalStorageService.dart';
import 'package:bispick/styles/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';

import '../models/User.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final GoogleSignInPlugin plugin = GoogleSignInPlugin();

  @override
  void initState() {
    plugin.init(
      clientId: "928844612095-7td9k8eub0039u9255qb3llib837sfv2.apps.googleusercontent.com"
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 10,
              child: Container(
                margin: EdgeInsets.only(top: 100, bottom: 50),
                child: SizedBox(
                  width: 250,
                  child: Image.asset(
                      'assets/lost_and_found.png', fit: BoxFit.fitWidth
                  )
                )
              ),
            ),
           Expanded(
              flex: 10,
              child: Column(
                children: [
                  Container(
                    height: 70,
                    margin: EdgeInsets.only(bottom: 14.0),
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () async {
                        var result = await plugin.isSignedIn();
                        if (result) {
                          Navigator.of(context).pushNamed("homeView");
                        }
                        try {
                          // var googleSignInUserData = await plugin.signInSilently();
                          // if (googleSignInUserData == null) {
                          var  googleSignInUserData = await plugin.signIn();
                          // }
                          var token = await plugin.getTokens(email: googleSignInUserData!.email);

                          bool isAllowed = _isAllowedEmail(googleSignInUserData!.email);
                          if (!isAllowed) {
                            _showDialog();
                            return;
                          }

                          User user = User(
                            id: googleSignInUserData!.id,
                            email: googleSignInUserData!.email,
                            displayName: googleSignInUserData!.displayName,
                            photoUrl: googleSignInUserData!.photoUrl,
                            idToken: googleSignInUserData!.idToken,
                            accessToken: token!.accessToken,
                            serverAuthCode: googleSignInUserData!.serverAuthCode,
                          );
                          LocalStorageService.saveUser(user);
                          Navigator.of(context).pushNamed("homeView");
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text(
                        "Log-in",
                        style: TextStyle(
                            color: Colors.white, fontFamily: "Quicksand", fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child:  Text(
                        "© 2024 BIS | Lost and Found. All rights reserved.",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Poppins",
                           ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  bool _isAllowedEmail(String email) {
    final RegExp domainRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@bisce\.net$');
    const List<String> allowedEmails = [
      'bispick.logncoding@gmail.com',
      'bispick.maintainer@gmail.com',
      'kodw4284@gmail.com'
    ];

    if (domainRegExp.hasMatch(email)) {
      return true;
    }

    if (allowedEmails.contains(email)) {
      return true;
    }

    return false;
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('External email sign-ins are not allowed.\nPlease use your BIS email.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                // 확인 버튼 클릭 시 수행할 작업
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
