import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:diatom/pages/services/notification_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  final TextEditingController _inputController = TextEditingController();
  List<BarChartGroupData> _barChartData = [];

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
    _fetchDataPoints();
  }

  Future<void> _fetchDataPoints() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .collection("DataPoints")
          .orderBy("timestamp", descending: true)
          .limit(10)
          .get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      List<BarChartGroupData> barChartData = [];
      for (int i = 0; i < documents.length; i++) {
        double dataPoint = documents[i]['value'];
        barChartData.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: dataPoint,
                color: dataPoint <= 5 ? Colors.red : Colors.blue,
                width: 16,
              ),
            ],
          ),
        );

        // Trigger notification if the data point is below 5
        if (dataPoint < 5) {
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 1,
              channelKey: "basic_channel",
              title: "Health Notification",
              body: "Health threshold is going down",
            ),
          );
        }
      }

      setState(() {
        _barChartData = barChartData;
      });
    }
  }

  Future<void> _addDataPoint() async {
    final text = _inputController.text;
    if (text.isNotEmpty) {
      final data = double.tryParse(text);
      User? user = FirebaseAuth.instance.currentUser;
      if (data != null && user != null) {
        // Trigger notification immediately if the input value is less than or equal to 5
        if (data <= 5) {
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 1,
              channelKey: "basic_channel",
              title: "Health Notification",
              body: "Health threshold is going down",
            ),
          );
        }

        CollectionReference dataPointsRef = FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .collection("DataPoints");

        await dataPointsRef.add({
          'value': data,
          'timestamp': FieldValue.serverTimestamp(),
        });

        _inputController.clear();
        _fetchDataPoints();
      }
    }
  }

  Future<void> _deleteAllDataPoints() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .collection("DataPoints")
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      setState(() {
        _barChartData = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Health Notification',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.grey.withOpacity(0.5),
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _inputController,
                decoration: InputDecoration(
                  labelText: 'Enter Data Point',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _addDataPoint(),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _addDataPoint,
                    child: Text(
                      'Add Data Point',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 12.0),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _deleteAllDataPoints,
                    child: Text(
                      'Delete All Data Points',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 12.0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(show: true),
                    titlesData: FlTitlesData(show: true),
                    gridData: FlGridData(show: true),
                    barGroups: _barChartData,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
