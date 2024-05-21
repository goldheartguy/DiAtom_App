import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  int _currentPage = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      AboutPage(
        imagePath: 'assets/images/logo.png',
        title: 'DiAtom Technologies Mission',
        description:
            'Saving lives globally by addressing critical respiratory needs, we design, produce, and distribute innovative ventilators inspired by the challenges of the COVID-19 era.',
      ),
      AboutPage(
        imagePath: 'assets/images/logo.png',
        title: 'DiAtom Technologies Vision',
        description:
            'Pioneering industry envision a future where our advanced respiratory solutions ensure universal access to life-saving care, making a lasting impact on global healthcare resilience.',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 33, 59),
        title: Text(
          'About',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Pages
            SizedBox(
              height: 500.0, // Adjust height as needed
              child: PageView.builder(
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(height: 50.0),
                      _pages[index],
                    ],
                  );
                },
              ),
            ),

            // Page indicator dots
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _pages.length; i++) {
      list.add(_indicator(i == _currentPage));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const AboutPage({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Image
        SizedBox(height: 20.0),
        Image.asset(
          imagePath,
          height: 150.0,
        ),
        SizedBox(height: 20.0),

        // Title
        Text(
          title,
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 20.0),

        // Description
        Text(
          description,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }
}
