import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:varla/View/Home/HomePage.dart';
import 'package:varla/View/Tasks/TasksPage.dart';

class BottomNavigationBarHelper extends StatefulWidget {
  const BottomNavigationBarHelper({super.key});

  @override
  State<BottomNavigationBarHelper> createState() =>
      _BottomNavigationBarHelperState();
}

class _BottomNavigationBarHelperState extends State<BottomNavigationBarHelper> {
  int _selectedIndex = 1;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    TasksPage(),
    HomePage(),
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
          icon: Icon(Icons.auto_awesome_sharp),
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.lightbulb),
        //   label: 'School',
        // ),
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
