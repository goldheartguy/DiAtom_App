import 'package:diatom/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    Future<Map<String, dynamic>> _fetchUserData() async {
      Map<String, dynamic> userData = {};

      if (user != null) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .get();
        userData = snapshot.data() as Map<String, dynamic>;
      }
      return userData;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 33, 59),
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            // If user data doesn't exist, show default profile
            return _buildDefaultProfile(user);
          } else {
            Map<String, dynamic> userData =
                snapshot.data?.data() as Map<String, dynamic>;
            return _buildUserProfile(context, user, userData);
          }
        },
      ),
    );
  }

  Widget _buildDefaultProfile(User? user) {
    return Container(
      color: Colors.grey[300],
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.person,
                  size: 160,
                  color: Color.fromARGB(255, 14, 64, 105),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.person_outline),
                    Text(
                      user?.displayName ?? 'No Name',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                  ],
                ),
                SizedBox(height: 25),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.email),
                      Text(
                        'Email: ${user?.email}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile(
      BuildContext context, User? user, Map<String, dynamic> userData) {
    return Container(
      color: Colors.grey[300],
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 160,
                    color: Color.fromARGB(255, 14, 64, 105),
                  ),
                  SizedBox(height: 10),
                  Text(
                    user?.displayName ?? 'No Name',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Email: ${user?.email}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 20,
            thickness: 2,
            color: Colors.grey,
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text(userData['Email'] ?? 'No Email'),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(userData['Phone'] ?? 'No Phone'),
            onTap: () => _showPhoneDialog(context),
          ),
          ListTile(
            leading: Icon(Icons.notes),
            title: Text(userData['Bio'] ?? 'No Bio'),
            onTap: () => _showBioDialog(context),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever),
            title: Text('Delete Account'),
            onTap: () => _deleteAccount(context),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () => signUserOut(),
          ),
        ],
      ),
    );
  }

  void _showPhoneDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 90, 181, 255),
        title: Text(
          'Update Phone',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter new phone number:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                hintText: 'New phone number',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _updatePhone(_phoneController.text);
              Navigator.pop(context);
            },
            child: Text(
              'Update',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBioDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 90, 181, 255),
        title: Text(
          'Update Bio',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter new bio:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                hintText: 'New bio',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _updateBio(_bioController.text);
              Navigator.pop(context);
            },
            child: Text(
              'Update',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updatePhone(String newPhone) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection("Users").doc(user.uid).update({
        "Phone": newPhone,
      });
    }
  }

  void _updateBio(String newBio) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection("Users").doc(user.uid).update({
        "Bio": newBio,
      });
    }
  }

  void _deleteAccount(BuildContext context) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 242, 178, 178),
          title: Text(
            'Confirm Account Deletion',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete your account? This action cannot be undone, and you will not be able to recover your data or access your account again.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Delete the user account
                  await user.delete();
                  await FirebaseFirestore.instance
                      .collection("Users")
                      .doc(user.uid)
                      .delete();
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                } catch (e) {
                  print("Error deleting account: $e");
                  // Handle error deleting account
                }
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

signUserOut() async {
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
