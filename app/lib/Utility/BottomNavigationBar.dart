import 'package:flutter/material.dart';
import 'package:varla/Utility/Navigation/Navigation.dart' as VarlaNavigation;

class BottomNavigationBarHelper extends StatefulWidget {
  // final VarlaNavigation.Navigation nav;
  final Function setIndex;

  BottomNavigationBarHelper(this.setIndex);
  // BottomNavigationBarHelper({Key key, @required this.recordObject}) : super(key: key);

  @override
  State<BottomNavigationBarHelper> createState() =>
      _BottomNavigationBarHelperState();
}

class _BottomNavigationBarHelperState extends State<BottomNavigationBarHelper> {
  // int _selectedIndex = 3;

  //  static List<VarlaNavigation.Route> routes = <VarlaNavigation.Route>[
  //   VarlaNavigation.Route(
  //       page: const OrchestratorPage(),
  //       path: "/Services",
  //       name: "Services",
  //       icon: const Icon(Icons.precision_manufacturing_sharp)),
  //   VarlaNavigation.Route(
  //       page: const HomePage(),
  //       path: "/Home",
  //       name: "Home",
  //       icon: const Icon(Icons.home)),
  //   VarlaNavigation.Route(
  //       page: const NotificationPage(),
  //       path: "/Notification",
  //       name: "Notification",
  //       icon: const Icon(Icons.edit_notifications)),
  // ];

  // static const List<Widget> _widgetOptions = <Widget>[
  //   OrchestratorPage(),
  //   // HomePage(),
  //   FileManagerPage(),
  //   NotificationPage()
  // ];

  void _onItemTapped(int index) {
    if (index % 2 == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Hossh! 🤫\nDefiantly no shady business here!\nDon't tell anyone."),
      ));
      return;
    }

    setState(() {
      // _selectedIndex = index;

      widget.setIndex(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: SizedBox(width: 0),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: VarlaNavigation.Navigation.routes[0].icon,
          label: VarlaNavigation.Navigation.routes[0].name,
        ),
        const BottomNavigationBarItem(
          icon: SizedBox(width: 0),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: VarlaNavigation.Navigation.routes[1].icon,
          label: VarlaNavigation.Navigation.routes[1].name,
        ),
        const BottomNavigationBarItem(
          icon: SizedBox(width: 0),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: VarlaNavigation.Navigation.routes[2].icon,
          label: VarlaNavigation.Navigation.routes[2].name,
        ),
        const BottomNavigationBarItem(
          icon: SizedBox(width: 0),
          label: '',
        ),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: VarlaNavigation.Navigation.selectedIndex,
      onTap: _onItemTapped,

      // BottomNavigationBar nav =
      // return Scaffold(
      //   body: VarlaNavigation.Navigate.getRouteByIndex(
      //       _selectedIndex), //_widgetOptions[_selectedIndex],
      //   bottomNavigationBar: BottomNavigationBar(
      //     items: const <BottomNavigationBarItem>[
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.precision_manufacturing_sharp),
      //         label: 'Services',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.home),
      //         label: 'Home',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.edit_notifications),
      //         label: 'Notification',
      //       ),
      //     ],
      //     currentIndex: _selectedIndex,
      //     onTap: _onItemTapped,
      //   ),
    );
  }
}
