import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.grey.shade400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: 200,
              width: 330,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  textAlign: TextAlign.justify,
                  'This Application is developed by the students of Shaheed Benazir Bhutto University,' +
                      ' Information Technology department, 20 Batch for Final Year Project ' +
                      '"Intelligent Gas Leakage Detection System Using Arduino" ' +
                      'under the supervision of Mr. Imran Asif Memon.' +
                      'The application is integrated with a hardware consist of different sensors.' +
                      'These sensors send real time gas levels data to Firebase Real Time Database ' +
                      'and then that data is shown in this Application.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.green,
              thickness: 3,
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 12),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      width: 330,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.asset('images/SirImran.png'),
                            ),
                          ),
                          Text(
                            'Project Supervisor: Mr. Imran Asif Memon',
                            style: TextStyle(
                              //fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      width: 330,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.asset('images/ahsan.png'),
                            ),
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            'Group Leader: Mr. Muhammad Ahsan\nRoll No: 20BSIT-33',
                            style: TextStyle(
                              //fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      width: 330,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.asset('images/amjad.png'),
                            ),
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            'Group Member: Mr. Amjad Ali\nRoll No: 20BSIT-10',
                            style: TextStyle(
                              //fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Container(
                      width: 330,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.asset('images/bahawal.png'),
                            ),
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            'Group Member: Mr. Bahawal U Din\nRoll No: 20BSIT-82',
                            style: TextStyle(
                              //fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
