import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_account/sign_in_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          "Home Screen",
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () async {
                NavigatorState navigatorState = Navigator.of(context);
                await FirebaseAuth.instance.signOut();
                navigatorState.pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const SignInScreen();
                    },
                  ),
                  (route) {
                    return false;
                  },
                );
              },
              icon: const Icon(
                Icons.logout,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.network(
                      FirebaseAuth.instance.currentUser?.photoURL ??
                          "https://cdn.vectorstock.com/i/1000x1000/99/13/default-avatar-photo-placeholder-icon-grey-vector-38519913.webp",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Unique Identifier: ${FirebaseAuth.instance.currentUser?.uid ?? "Not available"}",
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Display Name: ${FirebaseAuth.instance.currentUser?.displayName ?? "Not available"}",
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Email Address: ${FirebaseAuth.instance.currentUser?.email ?? "Not available"}",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
