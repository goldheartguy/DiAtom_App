import 'package:diatom/pages/About.dart';
import 'package:flutter/material.dart';

class AddDevice extends StatelessWidget {
  const AddDevice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[300],
        child: SingleChildScrollView(
          // Wrap with SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                buildCard(
                  "Card 1",
                  "This is the content of Card 1.",
                  "assets/images/google.png",
                  About(),
                ),
                SizedBox(height: 20),
                buildCard(
                  "Card 2",
                  "This is the content of Card 2.",
                  "assets/images/google.png",
                  About(),
                ),
                SizedBox(height: 20),
                buildCard(
                  "Card 3",
                  "This is the content of Card 3.",
                  "assets/images/google.png",
                  About(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard(
      String title, String content, String imagePath, Widget nextPage) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: double.infinity,
        child: Card(
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0), // Padding for the image
                child: Image.asset(
                  imagePath,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      content,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            //Navigator.push(
                            //context ,
                            //MaterialPageRoute(
                            // builder: (context) => nextPage,
                            //),
                            //);
                          },
                          child: Text("View Details"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
