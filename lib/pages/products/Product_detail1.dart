import 'package:flutter/material.dart';

class Product1 extends StatelessWidget {
  const Product1({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[300],
        child: Center(
          child: const Text(
            'Product1 Content',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
