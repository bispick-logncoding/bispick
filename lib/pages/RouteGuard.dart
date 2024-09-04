import 'package:bispick/auth.dart';
import 'package:bispick/pages/LoginPage.dart';
import 'package:flutter/material.dart';

class RouteGuard extends StatelessWidget {
  final Widget child;

  const RouteGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Auth.isUserSignedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError || !(snapshot.data ?? false)) {
          return const LoginPage(); // Redirect to login if not signed in
        } else {
          return child;
        }
      },
    );
  }
}