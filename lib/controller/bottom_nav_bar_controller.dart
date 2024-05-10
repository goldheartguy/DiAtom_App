// ignore: depend_on_referenced_packages
import 'package:diatom/pages/AddDevice.dart';
import 'package:diatom/pages/Device.dart';
import 'package:diatom/pages/Profile.dart';
import 'package:diatom/pages/About.dart';
import 'package:diatom/pages/hidden_drawer.dart';
import 'package:diatom/pages/home.dart';
import 'package:get/get.dart';

class BottomNavigationBarController extends GetxController {
  RxInt index = 0.obs;

  var pages = [
    HiddenDrawer(),
    About(),
    Device(),
    Profile(),
  ];
}
