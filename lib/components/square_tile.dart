import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;

  const SquareTile({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Color.fromARGB(255, 167, 222, 246),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 40,
          ),
          SizedBox(width: 8),
          Text(
            "Signing In with Google",
            style: TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 0, 153, 255),
            ),
          ),
        ],
      ),
    );
  }
}
