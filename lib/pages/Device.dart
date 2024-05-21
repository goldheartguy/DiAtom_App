import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Device extends StatelessWidget {
  const Device({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 33, 59),
        title: Text(
          'Device',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              color: const Color.fromARGB(255, 233, 233, 233),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 100,
                          height: 100,
                        ),
                      ],
                    ),
                    Center(
                      child: Text(
                        'VENTILATORS',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 5, 43, 76),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Ensuring Optimal Oxygen Delivery for Critical Care',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'We are dedicated to advancing respiratory care with our state-of-the-art ventilators, designed to deliver oxygen with unparalleled precision. Our aim is to support healthcare professionals in providing the highest standard of care to patients in need of respiratory support.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              color: const Color.fromARGB(255, 233, 233, 233),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 100,
                          height: 100,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        'BIO-PRINTERS',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 5, 43, 76),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Revolutionizing the Future of Healthcare',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Our cutting-edge bioprinters, designed to revolutionize the field of tissue engineering and regenerative medicine. Our commitment to technological excellence drives us to create solutions that push the boundaries of what\'s possible in healthcare.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
