import 'package:flutter/material.dart';
import 'package:varla/Services/Notification/NotificationChannelStream.dart';
import 'package:varla/Services/Notification/NotificationChannels.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text("Hello!"),
    ));
  }
}
