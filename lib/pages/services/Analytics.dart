import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:diatom/pages/services/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
    super.initState();
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
        appBar: AppBar(
          title: Text('Analytics Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Line Graph',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Expanded(
                child: LineChart(
                  LineChartData(
                    borderData: FlBorderData(show: true),
                    titlesData: FlTitlesData(show: true),
                    gridData: FlGridData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 3),
                          FlSpot(1, 1),
                          FlSpot(2, 4),
                          FlSpot(3, 3),
                          FlSpot(4, 2),
                          FlSpot(5, 5),
                          FlSpot(6, 6),
                        ],
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: 1,
                  channelKey: "basic_channel",
                  title: "Health Notification",
                  body: "Health threshold is going down"),
            );
          },
          child: Icon(
            Icons.notification_add,
          ),
        ),
      ),
    );
  }
}
