import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_detector/UI/screens/home_screen.dart';
import 'package:gas_detector/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/round_button.dart';

class GasDetectorIdScreen extends StatefulWidget {
  const GasDetectorIdScreen({super.key});

  @override
  State<GasDetectorIdScreen> createState() => _GasDetectorIdScreenState();
}

class _GasDetectorIdScreenState extends State<GasDetectorIdScreen> {
  final idController = TextEditingController();
  String idNodeName = "";
  Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    //gettingNodeName();
    // checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.deepOrange,
      statusBarBrightness: Brightness.light,
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Gas Leakage Detector'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Container(
                width: 200,
                height: 200,
                child: Image.asset('images/login.png'),
              ),
              SizedBox(
                height: 50,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: idController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: 'Enter 6 digits ID',
                    prefixIcon: Icon(Icons.perm_identity)),
              ),
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                title: 'Login',
                onTap: () async {
                  final DatabaseReference reference =
                      FirebaseDatabase.instance.ref('Gas Leakage Detector');
                  final event = await reference.once();

                  for (final childSnapshot in event.snapshot.children) {
                    final tempNodeName = childSnapshot.key.toString();
                    if (idController.text.toString() == tempNodeName) {
                      idNodeName = tempNodeName;
                    }
                  }
                  checkConnectivity();
                },
              ),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom)),
            ],
          ),
        ),
      ),
    );
  }

  void checkConnectivity() async {
    var connectionResult = await _connectivity.checkConnectivity();

    if ((connectionResult == ConnectivityResult.mobile ||
        connectionResult == ConnectivityResult.wifi)) {
      if (idController.text.toString() == "") {
        Utils().toastMessage('Enter a 6 digits ID');
      } else if (idController.text.toString() != idNodeName) {
        Utils().toastMessage('Invalid ID');
      } else if (idController.text.toString() == idNodeName) {
        print("id = " + idNodeName);
        Utils().toastMessage('Login Successful');
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setBool('isLoggedIn', true);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomePageScreen()));
      }
    } else if (connectionResult != ConnectivityResult.mobile ||
        connectionResult != ConnectivityResult.wifi) {
      Utils().toastMessage('Connect to Internet');
    }

    setState(() {});
  }
}
