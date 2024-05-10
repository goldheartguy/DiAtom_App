import 'package:diatom/pages/login_page.dart';
import 'package:diatom/pages/nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('User is authenticated'); // Add this line for debugging
            return nav();
          } else {
            print('User is not authenticated'); // Add this line for debugging
            return LoginPage();
          }
        },
      ),
    );
  }
}
