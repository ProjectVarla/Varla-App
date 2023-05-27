import 'package:flutter/material.dart';
import 'package:varla/Utility/BottomNavigationBar.dart';
import 'package:varla/Utility/Drawer/DrawerNavigation.dart';

import 'package:varla/Utility/Navigation/Routes.dart' as VarlaRoute;
import 'package:varla/Utility/Navigation/Navigation.dart' as VarlaNavigation;

import 'package:varla/View/Home/HomePage.dart';
import 'package:varla/View/Notification/NotificationPage.dart';
import 'package:varla/View/Orchestrator/OrchestratorPage.dart';
import 'package:varla/View/Services/FileManager/FileManagerPage.dart';
import 'package:varla/View/Tasks/TasksPage.dart';
import 'package:varla/View/Wallet/WalletPage.dart';

class Navigation {
  static List<VarlaRoute.Route> routes = <VarlaRoute.Route>[
    VarlaRoute.Route(
      page: const OrchestratorPage(),
      path: "/Services",
      name: "Services",
      icon: const Icon(Icons.precision_manufacturing_sharp),
      type: VarlaRoute.RouteType.Core,
    ),
    VarlaRoute.Route(
      page: const HomePage(),
      path: "/Home",
      name: "Home",
      icon: const Icon(Icons.home),
    ),
    VarlaRoute.Route(
      page: const TasksPage(),
      path: "/Tasks",
      name: "Tasks",
      icon: const Icon(Icons.auto_awesome_sharp),
      type: VarlaRoute.RouteType.Service,
    ),
    VarlaRoute.Route(
      page: const NotificationPage(),
      path: "/Notification",
      name: "Notification",
      icon: const Icon(Icons.edit_notifications),
      type: VarlaRoute.RouteType.Settings,
    ),
    VarlaRoute.Route(
      page: const FileManagerPage(),
      path: "/FileManager",
      name: "File Manager",
      icon: const Icon(Icons.manage_history_rounded),
      type: VarlaRoute.RouteType.Service,
    ),
    VarlaRoute.Route(
      page: const WalletPage(),
      path: "/Wallet",
      name: "Wallet",
      icon: const Icon(Icons.account_balance_wallet),
      type: VarlaRoute.RouteType.Service,
    ),
  ];

  static int selectedIndex = 3;
  static String selectedRoute = "";
  static VarlaRoute.Route activeRoute = routes[(selectedIndex - 1) ~/ 2];

  static void setRouteByIndex(int index) {
    selectedIndex = index;
    print(selectedIndex);
    activeRoute = routes[(selectedIndex - 1) ~/ 2];
  }

  static void setRouteByPath(String path) {
    selectedRoute = path;
    print(selectedRoute);
    activeRoute = routes.firstWhere((element) => element.path == path);
    int tempIndex = routes.indexOf(activeRoute);
    selectedIndex = tempIndex <= 2 ? tempIndex * 2 + 1 : 0;
  }

  static VarlaRoute.Route getActiveRoute() {
    return activeRoute;
  }

  Navigation() {
    activeRoute = routes[(selectedIndex - 1) ~/ 2];
  }
}

class NavigationHelper extends StatefulWidget {
  const NavigationHelper({super.key});

  // Navigation nav = Navigation();

  @override
  State<NavigationHelper> createState() => _NavigationHelperState();
}

class _NavigationHelperState extends State<NavigationHelper> {
  void setRouteByIndex(int index) {
    setState(() {
      Navigation.setRouteByIndex(index);
    });
  }

  void setRouteByPath(String path) {
    setState(() {
      Navigation.setRouteByPath(path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true, title: Text(Navigation.getActiveRoute().name)),
        drawer: DrawerNavigation(setRouteByPath),
        body:
            Navigation.getActiveRoute().page, //_widgetOptions[_selectedIndex],
        bottomNavigationBar: BottomNavigationBarHelper(setRouteByIndex));
  }
}
