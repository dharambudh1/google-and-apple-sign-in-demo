import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_account/home_screen.dart';

enum LoginType { google, apple }

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Social account",
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 01.50,
                child: ElevatedButton.icon(
                  icon: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: FaIcon(FontAwesomeIcons.google),
                  ),
                  onPressed: () async {
                    if (Platform.isAndroid || Platform.isIOS) {
                      await onPressed(type: LoginType.google);
                    } else {
                      showSnackBar(type: LoginType.google);
                    }
                  },
                  label: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Sign-in with Google",
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 01.50,
                child: ElevatedButton.icon(
                  icon: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: FaIcon(FontAwesomeIcons.apple),
                  ),
                  onPressed: () async {
                    if (Platform.isIOS) {
                      await onPressed(type: LoginType.apple);
                    } else {
                      showSnackBar(type: LoginType.apple);
                    }
                  },
                  label: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Sign-in with Apple",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onPressed({
    required LoginType type,
  }) async {
    UserCredential? userCredential = (type == LoginType.google)
        ? await signInWithGoogle()
        : await signInWithApple();
    (userCredential != null) ? pushAndRemoveUntil() : null;
    return Future.value();
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackBar({
    required LoginType type,
  }) {
    SnackBar snackBar = SnackBar(
      content: Text(
        (type == LoginType.google)
            ? "This feature works with Android & iOS devices."
            : "This feature only works with iOS devices.",
      ),
    );
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future pushAndRemoveUntil() {
    return Future.value(
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return const HomeScreen();
          },
        ),
        (route) {
          return false;
        },
      ),
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    UserCredential? credential;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? auth = await googleUser?.authentication;
      credential = await FirebaseAuth.instance.signInWithCredential(
        GoogleAuthProvider.credential(
          accessToken: auth?.accessToken,
          idToken: auth?.idToken,
        ),
      );
    } catch (e) {
      log(
        e.toString(),
      );
      SnackBar snackBar = SnackBar(
        content: Text(
          e.toString(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return Future.value(credential);
  }

  Future<UserCredential?> signInWithApple() async {
    UserCredential? credential;
    try {
      await FirebaseAuth.instance.signInWithProvider(
        AppleAuthProvider(),
      );
    } catch (e) {
      log(
        e.toString(),
      );
      SnackBar snackBar = SnackBar(
        content: Text(
          e.toString(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return Future.value(credential);
  }
}
