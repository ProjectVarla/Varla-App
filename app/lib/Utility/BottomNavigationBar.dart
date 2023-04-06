import 'package:flutter/material.dart';

import 'package:varla/View/Home/HomePage.dart';
import 'package:varla/View/Notification/NotificationPage.dart';
import 'package:varla/View/Orchestrator/OrchestratorPage.dart';
import 'package:varla/View/Tasks/TasksPage.dart';

class BottomNavigationBarHelper extends StatefulWidget {
  const BottomNavigationBarHelper({super.key});

  @override
  State<BottomNavigationBarHelper> createState() =>
      _BottomNavigationBarHelperState();
}

class _BottomNavigationBarHelperState extends State<BottomNavigationBarHelper> {
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    OrchestratorPage(),
    HomePage(),
    NotificationPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigationBar nav = BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.precision_manufacturing_sharp),
          label: 'Services',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.edit_notifications),
          label: 'Notification',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: nav,
    );
  }
}
