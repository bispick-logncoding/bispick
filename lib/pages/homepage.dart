import 'package:bispick/styles/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

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
              flex: 4,
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                            color: Colors.grey, fontFamily: "Poppins")),
                  ),
                  TextField(
                      controller: pwController,
                      decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                              color: Colors.grey, fontFamily: "Poppins"))),
                ],
              ),
            ),
            Expanded(
              flex: 10,
              child: Column(
                children: [
                  Container(
                    height: 50,
                    margin: EdgeInsets.only(bottom: 14.0),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {},
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
