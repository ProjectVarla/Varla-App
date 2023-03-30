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
        appBar: AppBar(centerTitle: true, title: const Text("HomePage")),
        body: Center(
          child: Text("Hello!"),
        ));
  }
}
