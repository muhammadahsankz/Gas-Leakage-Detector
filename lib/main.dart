import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:gas_detector/UI/screens/gas_detector_id.dart';
import 'package:gas_detector/UI/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.notification!.title.toString());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.deepOrange,
      statusBarBrightness: Brightness.light,
    ));
    return FutureBuilder<bool>(
      future: SharedPreferences.getInstance()
          .then((prefs) => prefs.getBool('isLoggedIn') ?? false),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool isLoggedIn = snapshot.data!;
          if (isLoggedIn) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.deepOrange,
              ),
              home: const HomePageScreen(),
            );
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.deepOrange,
              ),
              home: const GasDetectorIdScreen(),
            );
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );

    /*return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      //home: const SplashScreen(),

      home: const GasDetectorIdScreen(),
    ); */
  }
}
