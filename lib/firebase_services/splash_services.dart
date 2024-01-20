import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_detector/UI/auth/login_screen.dart';
import 'package:gas_detector/UI/screens/home_screen.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;

    if (user != null) {
      Timer(
          const Duration(seconds: 1),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomePageScreen())));
    } else {
      Timer(
          const Duration(seconds: 2),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen())));
    }
  }
}
