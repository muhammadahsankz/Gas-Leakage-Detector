import 'dart:async';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:gas_detector/UI/screens/about_screen.dart';
import 'package:gas_detector/UI/screens/addnumber_screen.dart';
import 'package:gas_detector/UI/screens/gas_detector_id.dart';
import 'package:gas_detector/firebase_services/notification_services.dart';
import 'package:gas_detector/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final _auth = FirebaseAuth.instance;
  final gasLeakRef = FirebaseDatabase.instance
      .ref('Gas Leakage Detector/112233/Gas Leak Detected');
  NotificationServices notificationServices = NotificationServices();
  final phoneNumberRef =
      FirebaseDatabase.instance.ref('Gas Leakage Detector/112233/Phone Number');
  final tokenRef = FirebaseDatabase.instance.ref('Gas Leakage Detector/112233');

  bool numExist = false;
  String currentNum = '';

  String _lastAddedData = "0";
  int gasLevel = 0;
  Timer? _timer;
  Color greenColorIndicator = Colors.grey;
  Color redColorIndicator = Colors.grey;

  @override
  void initState() {
    super.initState();
    _getLastAddedData();
    _checkNumberExists();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    //notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      print('Device token: ' + value);
      tokenRef.child('FCM Token').set({
        value: {
          'token': value,
        }
      }).then((_) {
        print('Token Not Set');
      });
    });

    // Create a Timer object.
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Update the pointer's value.
      gasLevel = int.parse(_lastAddedData);
      if (gasLevel < 500) {
        greenColorIndicator = Colors.green;
      } else {
        greenColorIndicator = Colors.grey;
      }
      if (gasLevel > 500) {
        redColorIndicator = Colors.red;
      } else {
        redColorIndicator = Colors.grey;
      }

      // Force the widget to rebuild.
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Cancel the Timer object.
    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.deepOrange,
      statusBarBrightness: Brightness.light,
    ));
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  'Gas Leakage Detector',
                  style: TextStyle(fontSize: 20),
                ),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Image.asset('images/gas_leakage_detector_logo.png'),
                  ),
                ),
                // decoration: BoxDecoration(
                //  image: DecorationImage(
                //    image: AssetImage('images/drawerbackground.jpg'),
                //    fit: BoxFit.fill,
                //  ),
                // ),
                accountEmail: Text(''),
              ),
              ListTile(
                leading: Icon(Icons.home_outlined),
                title: Text(
                  'Home',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text(
                  'About',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AboutScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text(
                  'Exit App',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  SystemNavigator.pop();
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text("Gas Leakage Detector"),
          actions: [
            IconButton(
              onPressed: () async {
                SharedPreferences sp = await SharedPreferences.getInstance();
                sp.setBool('isLoggedIn', false);
                // _auth.signOut().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GasDetectorIdScreen()));
                Utils().toastMessage('Logout');
                // }).onError((error, stackTrace) {
                //   Utils().toastMessage(error.toString());
                // });
              },
              icon: Icon(Icons.logout),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomePageScreen()));
          },
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: greenColorIndicator,
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  Container(
                    child: Text(
                      textAlign: TextAlign.center,
                      numExist
                          ? 'Current Number: \n' + '0' + currentNum
                          : 'No Number Added',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: redColorIndicator,
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 240,
              width: 240,
              // padding: EdgeInsets.all(10),
              //
              child: SfRadialGauge(
                enableLoadingAnimation: true,
                animationDuration: 2000,
                axes: [
                  RadialAxis(
                    minimum: 0,
                    maximum: 1000,
                    interval: 150,
                    pointers: [
                      NeedlePointer(
                        value: gasLevel.toDouble(),
                        enableAnimation: true,
                      ),
                    ],
                    ranges: [
                      GaugeRange(
                        startValue: 0,
                        endValue: 250,
                        color: Colors.green,
                      ),
                      GaugeRange(
                        startValue: 250,
                        endValue: 500,
                        color: Colors.orange,
                      ),
                      GaugeRange(
                        startValue: 500,
                        endValue: 1000,
                        color: Colors.red,
                      ),
                    ],
                    annotations: [
                      GaugeAnnotation(
                        widget: Column(
                          children: [
                            Text(
                              gasLevel.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Gas Level',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        positionFactor: 1.5,
                        angle: 90,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 60,
                  child: Text(
                    'Normal',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 60,
                  child: Text(
                    'Moderate',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 60,
                  child: Text(
                    'Critical',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 10,
                  width: 60,
                  color: Colors.green,
                ),
                Container(
                  height: 10,
                  width: 60,
                  color: Colors.orange,
                ),
                Container(
                  height: 10,
                  width: 60,
                  color: Colors.red,
                ),
              ],
            ),
            Divider(
              thickness: 2,
              color: Colors.green,
            ),
            Expanded(
              child: FirebaseAnimatedList(
                query: gasLeakRef.orderByKey().limitToLast(10),
                // reverse: true,
                defaultChild: Text(
                  'Loading...',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.white),
                ),
                itemBuilder: (context, snapshot, animation, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Card(
                      elevation: 0,
                      color: Colors.grey.shade200,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(
                          leading: Icon(
                            Icons.gas_meter_outlined,
                            size: 30,
                            color: Colors.red,
                          ),
                          title: Text('Gas Leakage Detected'),
                          subtitle: Text('Date: ' +
                              snapshot.child('date').value.toString() +
                              '\nGas Level: ' +
                              snapshot.child('gasLevel').value.toString()),
                          /*trailing: Icon(
                            Icons.fireplace_outlined,
                            color: Colors.blue,
                          ), */
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddNumberScreen()));
          },
          child: Text(
            textAlign: TextAlign.center,
            'Add\nNumber',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Future<void> _checkNumberExists() async {
    final snapshot = await phoneNumberRef.child('Number').get();

    setState(() {
      currentNum = snapshot.value.toString();
      numExist = (snapshot.value != null && snapshot.value != '');
    });
  }

  void _getLastAddedData() async {
    final DatabaseReference reference =
        FirebaseDatabase.instance.ref('Gas Leakage Detector/112233/Gas Level');
    reference.orderByKey().limitToLast(1).onChildAdded.listen((event) {
      setState(() {
        _lastAddedData = event.snapshot.value.toString();
      });
    });
  }
}
