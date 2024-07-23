import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  void sendSignInLinkToEmail(String email) async {
    final actionCodeSettings = ActionCodeSettings(
      // URL you want to redirect back to. The domain (www.example.com) for this
      // URL must be whitelisted in the Firebase Console.
      url: 'https://www.bispick.netlify.app/',
      // This must be true
      handleCodeInApp: true,
      // iOSBundleId: 'com.yourcompany.yourapp',
      // androidPackageName: 'com.yourcompany.yourapp',
      // androidInstallApp: true,
      // androidMinimumVersion: '12',
    );

    try {
      await _auth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );
      // Save the email in local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('emailForSignIn', email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-in link sent! Check your email.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send sign-in link: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Image.asset(
                  'assets/bispick.png',
                ),
              ),
              Expanded(
                  flex: 7,
                  child: Column(children: [
                    Container(
                        child: Text(
                            "* Put in your name, email, and password and verify your email",
                            style: TextStyle(
                              color: Colors.red,
                            ))),
                    TextFormField(
                      controller: idController,
                      decoration: InputDecoration(
                          labelText: "ID",
                          labelStyle: TextStyle(color: Colors.black)),
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.black)),
                    ),
                    TextFormField(
                      controller: pwController,
                      decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(color: Colors.black)),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      color: Colors.black,
                      child: TextButton(
                        onPressed: () {
                          sendSignInLinkToEmail(emailController.text);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color: Colors.white,
                            ),
                            Text(
                              "verify your email",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      color: Colors.black,
                      child: TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Icon(Icons.person_add, color: Colors.white),
                            Text(
                              "Register",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, "loginView");
                      },
                      child: Text(
                        "Already have an account? Login here",
                        style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ]))
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   // TODO: implement build
  //   throw UnimplementedError();
  // }
}
