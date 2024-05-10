import 'package:diatom/controller/bottom_nav_bar_controller.dart';
import 'package:diatom/pages/AddDevice.dart';
import 'package:diatom/pages/Profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class nav extends StatefulWidget {
  const nav({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<nav> {
  @override
  Widget build(BuildContext context) {
    BottomNavigationBarController controller =
        Get.put(BottomNavigationBarController());

    return Scaffold(
        // Bottom Navigation Bar
        bottomNavigationBar: Container(
          color: const Color.fromARGB(255, 0, 0, 0),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: const Color.fromARGB(255, 0, 0, 0),
              child: SafeArea(
                child: GNav(
                  tabBackgroundGradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 14, 64, 105),
                      Color.fromARGB(255, 252, 157, 157),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  tabMargin: const EdgeInsets.symmetric(vertical: 10),
                  gap: 8,
                  onTabChange: (value) => {
                    controller.index.value = value,
                  },
                  tabs: const [
                    GButton(
                      icon: Icons.home,
                      text: "Home",
                      iconColor: Colors.white,
                    ),
                    GButton(
                      icon: Icons.folder,
                      text: "About Us",
                      iconColor: Colors.white,
                    ),
                    GButton(
                      icon: Icons.device_hub_rounded,
                      text: "Products",
                      iconColor: Colors.white,
                    ),
                    GButton(
                      icon: Icons.person_2,
                      text: "Profile",
                      iconColor: Colors.white,
                    ),
                  ],
                  iconSize: 20,
                  activeColor: const Color.fromARGB(255, 189, 226, 255),
                ),
              ),
            ),
          ),
        ),
        body: Obx(
          () => controller.pages[controller.index.value],
        ));
  }
}
