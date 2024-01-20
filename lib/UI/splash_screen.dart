import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_detector/UI/screens/gas_detector_id.dart';
import 'package:gas_detector/firebase_services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashServices = SplashServices();
  @override
  void initState() {
    super.initState();
    //splashServices.isLogin(context);
    Timer(
        const Duration(seconds: 1),
        () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const GasDetectorIdScreen())));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.light,
    ));
    return Scaffold(
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          child: Image.asset('images/gas_leakage_detector_logo.png'),
        ),

        //Text(
        //'Gas Leakage Detector',
        //style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        //),
      ),
    );
  }
}
