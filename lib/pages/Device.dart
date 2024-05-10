import 'package:flutter/material.dart';

class Device extends StatelessWidget {
  const Device({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 33, 59),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: const Text('Products', style: TextStyle(color: Colors.white)),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.grey[300],
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to the Device Page',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              // Add any additional welcome content here
            ],
          ),
        ),
      ),
    );
  }
}
