import 'package:bispick/services/LocalStorageService.dart';
import 'package:bispick/styles/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';

import '../models/User.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
                  width: 400,
                  child: Image.asset(
                      'assets/bispick.png', fit: BoxFit.cover
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
                        print(result);
                        if (result) {
                          Navigator.of(context).pushNamed("homeView");
                        }
                        try {
                          var googleSignInUserData = await plugin.signInSilently();
                          if (googleSignInUserData == null) {
                            googleSignInUserData = await plugin.signIn();
                          }
                          User user = User(
                            id: googleSignInUserData!.id,
                            email: googleSignInUserData!.email,
                            displayName: googleSignInUserData!.displayName,
                            photoUrl: googleSignInUserData!.photoUrl,
                            idToken: googleSignInUserData!.idToken,
                            serverAuthCode: googleSignInUserData!
                                .serverAuthCode,
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
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, 'registerView');
                      },
                      child: Text(
                        "Can't access your account? Sign in.",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Poppins",
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  )
                  ,
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
