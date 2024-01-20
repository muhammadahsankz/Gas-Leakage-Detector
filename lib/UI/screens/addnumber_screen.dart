import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gas_detector/utils/utils.dart';

class AddNumberScreen extends StatefulWidget {
  const AddNumberScreen({super.key});

  @override
  State<AddNumberScreen> createState() => _AddNumberScreenState();
}

class _AddNumberScreenState extends State<AddNumberScreen> {
  final numberController = TextEditingController();
  final databaseReference =
      FirebaseDatabase.instance.ref('Gas Leakage Detector/112233');
  final phoneNumberRef =
      FirebaseDatabase.instance.ref('Gas Leakage Detector/112233/Phone Number');

  bool numExist = false;
  String currentNum = '';

  @override
  void initState() {
    super.initState();
    _checkNumberExists();
  }

  Future<void> _checkNumberExists() async {
    final snapshot = await phoneNumberRef.child('Number').get();
    currentNum = snapshot.value.toString();
    setState(() {
      numExist = (snapshot.value != null && snapshot.value != '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add Phone Number'),
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
                child: Icon(
                  Icons.phone_in_talk,
                  size: 150,
                  color: Colors.deepOrange,
                ),
                // child: Image.asset('images/gas_leakage_detector_logo.png'),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                child: Text(
                  numExist
                      ? 'Current Number: ' + '0' + currentNum
                      : 'No Number Added',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: numberController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: '03XX-XXXXXXX',
                    prefixIcon: Icon(Icons.phone)),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(330, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  if (numberController.text.length != 11) {
                    Utils().toastMessage('Enter a 11 digit number');
                  } else if (numberController.text.length >= 3 &&
                      numberController.text.substring(0, 2) != '03') {
                    Utils().toastMessage('Number is not correct');
                  } else {
                    Utils().toastMessage('Number Added');
                    databaseReference.child('Phone Number').set({
                      'Number': int.parse(numberController.text),
                    }).then((_) async {
                      final snapshot =
                          await phoneNumberRef.child('Number').get();
                      setState(() {
                        currentNum = snapshot.value.toString();
                        numExist =
                            (snapshot.value != null && snapshot.value != '');
                      });
                    });
                    numberController.text = "";
                    setState(() {});
                  }
                },
                child: Text(
                  numExist ? 'Update Number' : 'Add Number',
                ),
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
}
