import 'package:flutter/material.dart';

class product2 extends StatelessWidget {
  const product2({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[300],
        child: Center(
          child: const Text(
            'Product2 Content',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
