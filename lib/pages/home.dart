import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:diatom/consts.dart';
import 'package:diatom/controller/bottom_nav_bar_controller.dart';
import 'package:diatom/models/article.dart';
import 'package:diatom/pages/Device.dart';
import 'package:diatom/pages/Profile.dart';
import 'package:diatom/pages/login_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final User? user = FirebaseAuth.instance.currentUser;
  final Dio dio = Dio();
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    _getNews();
  }

  void signUserOut() async {
    try {
      await FirebaseAuth.instance.signOut();

      final GoogleSignIn _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();

      Get.offAll(() => LoginPage());
    } catch (e, stackTrace) {
      print("Error signing out: $e");
      print("StackTrace: $stackTrace");
    }
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigationBarController controller =
        Get.put(BottomNavigationBarController());

    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 33, 59),
        title: const Text('Stay Tuned'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: buildDrawer(),*/
      body: Container(
        color: Colors.grey[300],
        child: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return Card(
              elevation: 3,
              margin: EdgeInsets.all(8),
              child: ListTile(
                onTap: () {
                  _launchUrl(Uri.parse(article.url ?? ""));
                },
                leading: buildArticleImage(article),
                title: Text(
                  article.title ?? "",
                ),
                subtitle: Text(
                  article.publishedAt ?? "",
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding:
            const EdgeInsets.only(bottom: 16.0), // Adjust the bottom margin
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 14, 64, 105),
                    Color.fromARGB(255, 252, 157, 157),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: signUserOut,
                tooltip: 'Sign Out',
                child: const Icon(Icons.logout, color: Colors.white),
                backgroundColor: Colors
                    .transparent, // Set to transparent to show the gradient
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }

  /*Drawer buildDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 14, 64, 105),
                  Color.fromARGB(255, 252, 157, 157),
                ],
              ),
            ),
            accountName: Text(user?.displayName ?? "No Name"),
            accountEmail: Text("Email: ${user?.email}"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                  ? Color.fromARGB(255, 10, 72, 119)
                  : Colors.white,
              child: const Icon(
                Icons.person,
                size: 50,
              ),
            ),
          ),
          buildListTile("Profile", Icons.person, () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile()),
            );
          }),
          buildListTile("Products", Icons.add_shopping_cart, () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Device()),
            );
          }),
          buildListTile("Add Device", Icons.add_task, () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Device()),
            );
          }),
        ],
      ),
    );
  }*/

  ListTile buildListTile(String title, IconData icon, Function() onTap) {
    return ListTile(
      onTap: onTap,
      dense: true,
      title: Text(
        title,
        style: TextStyle(fontSize: 20),
      ),
      leading: Icon(icon, size: 20.0),
    );
  }

  Widget buildArticleImage(Article article) {
    return article.urlToImage != null
        ? Image.network(
            article.urlToImage!,
            height: 250,
            width: 100,
            fit: BoxFit.cover,
          )
        : Container(
            height: 250,
            width: 100,
            color: Colors.grey, // Placeholder color
            child: const Icon(Icons.image_not_supported, color: Colors.white),
          );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _getNews() async {
    try {
      final response = await dio.get(
        'https://newsapi.org/v2/top-headlines?country=in&category=health&apiKey=${NEWS_API_KEY}',
      );

      final articlesJson = response.data["articles"] as List;
      setState(() {
        List<Article> newsArticle =
            articlesJson.map((a) => Article.fromJson(a)).toList();
        newsArticle = newsArticle.where((a) => a.title != "[Removed]").toList();
        articles = newsArticle;
      });
    } catch (e, stackTrace) {
      print("Error fetching news: $e");
      print("StackTrace: $stackTrace");
    }
  }
}
