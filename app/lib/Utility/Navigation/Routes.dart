import 'package:flutter/material.dart';

enum RouteType { Normal, Settings, Core, Service, Infrastrucutre }

class Route {
  final Widget page;
  final String path;
  final String name;
  final Icon icon;
  RouteType type;

  Route(
      {required this.page,
      required this.path,
      required this.name,
      required this.icon,
      this.type = RouteType.Normal});
}
