import 'package:diatom/components/button.dart';
import 'package:diatom/components/square_tile.dart';
import 'package:diatom/components/textfield.dart';
import 'package:diatom/pages/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:diatom/pages/nav.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

String? userName = null;
String? userEmail = null;
String? userPword = null;

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = '';

  Future<void> signUserIn() async {
    setState(() {
      errorMessage = '';
    });

    void showLoadingDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: SpinKitSpinningLines(
              color: Color.fromARGB(255, 217, 76, 76),
              size: 50.0,
            ),
          );
        },
      );

      Future.delayed(Duration(seconds: 10), () {
        Navigator.of(context).pop();
      });
    }

    showLoadingDialog(context);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const nav()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      setState(() {
        errorMessage = e.message ?? 'An error occurred';
      });
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        clientId:
            '291373039055-uh5jfi50kq58drtshhvs3nhi09k3pnb4.apps.googleusercontent.com', // Replace with your actual OAuth client ID
      );
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
      if (gUser == null) {
        return null;
      }
      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User user = authResult.user!;
      userName = user.displayName;
      userEmail = user.email;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const nav()),
      );
      print("Signed-in successfully with Google.");
    } catch (e) {
      print('Error during Google sign-in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(height: 50),
                const Text(
                  "Welcome Back, you've been missed!",
                  style: TextStyle(
                    color: Color.fromRGBO(97, 97, 97, 1),
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 25),
                textfield(
                  controller: emailController,
                  hintText: "Enter you email",
                  obscureText: false,
                ),
                const SizedBox(height: 25),
                textfield(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                button(onTap: signUserIn),
                const SizedBox(height: 25),
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('Or  Continue With',
                            style: TextStyle(
                                color: Color.fromRGBO(97, 97, 97, 1))),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _handleGoogleSignIn,
                      child: SquareTile(
                        imagePath: 'assets/images/google.png',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Not a member?'),
                          SizedBox(width: 4),
                          Text(
                            'Register now',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
