import 'package:flutter/material.dart';
import 'package:varla/Utility/Navigation/Navigation.dart' as VarlaNavigation;
import 'package:varla/Utility/Navigation/Routes.dart' as VarlaRoute;

class DrawerNavigation extends StatefulWidget {
  final Function setRoute;

  const DrawerNavigation(this.setRoute, {super.key});

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: expanded ? 300 : 60,
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: ListView(
                  // mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Padding(
                    //   padding: EdgeInsets.only(top: 24.0, left: 5),
                    // ),
                    Tooltip(
                      message: "Expand",
                      child: ListTile(
                        iconColor: Colors.purple,
                        leading: const Padding(
                          padding: EdgeInsets.only(left: 2.0),
                          child: Icon(Icons.menu),
                        ),
                        title: expanded ? const Text("Collapse") : null,
                        onTap: () {
                          setState(() {
                            expanded = !expanded;
                          });
                        },
                      ),
                    ),
                    Tooltip(
                      message: "Cores",
                      child: ExpansionTile(
                          leading: const Padding(
                            padding: EdgeInsets.only(left: 2.0),
                            child: Icon(Icons.account_tree_sharp),
                          ),
                          title: Text(expanded ? "Cores" : ""),
                          trailing: expanded ? null : const SizedBox(),
                          children: [
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount:
                                  VarlaNavigation.Navigation.routes.length,
                              itemBuilder: (context, index) {
                                if (VarlaNavigation
                                        .Navigation.routes[index].type !=
                                    VarlaRoute.RouteType.Core) {
                                  return Container();
                                }
                                return Tooltip(
                                  // height: 50,
                                  // textAlign: TextAlign.right,
                                  message: VarlaNavigation
                                      .Navigation.routes[index].name,
                                  child: ListTile(
                                    iconColor: Colors.purple,
                                    leading: Padding(
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: VarlaNavigation
                                          .Navigation.routes[index].icon,
                                    ),
                                    title: expanded
                                        ? Text(VarlaNavigation
                                            .Navigation.routes[index].name)
                                        : null,
                                    onTap: () {
                                      Navigator.pop(context);
                                      widget.setRoute(VarlaNavigation
                                          .Navigation.routes[index].path);
                                    },
                                  ),
                                );
                              },
                            )
                          ]),
                    ),
                    Tooltip(
                      message: "Services",
                      child: ExpansionTile(
                          initiallyExpanded: true,
                          leading: const Padding(
                            padding: EdgeInsets.only(left: 2.0),
                            child: Icon(Icons.widgets_rounded),
                          ),
                          title: Text(expanded ? "Services" : ""),
                          trailing: expanded ? null : const SizedBox(),
                          children: [
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount:
                                  VarlaNavigation.Navigation.routes.length,
                              itemBuilder: (context, index) {
                                if (VarlaNavigation
                                        .Navigation.routes[index].type !=
                                    VarlaRoute.RouteType.Service) {
                                  return Container();
                                }
                                return Tooltip(
                                  // height: 50,
                                  // textAlign: TextAlign.right,
                                  message: VarlaNavigation
                                      .Navigation.routes[index].name,
                                  child: ListTile(
                                    iconColor: Colors.purple,
                                    leading: Padding(
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: VarlaNavigation
                                          .Navigation.routes[index].icon,
                                    ),
                                    title: expanded
                                        ? Text(VarlaNavigation
                                            .Navigation.routes[index].name)
                                        : null,
                                    onTap: () {
                                      Navigator.pop(context);
                                      widget.setRoute(VarlaNavigation
                                          .Navigation.routes[index].path);
                                    },
                                  ),
                                );
                              },
                            )
                          ]),
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 1,
                  child: ListView.builder(
                    reverse: true,
                    itemCount: VarlaNavigation.Navigation.routes.length,
                    itemBuilder: (context, index) {
                      if (VarlaNavigation.Navigation.routes[index].type !=
                          VarlaRoute.RouteType.Settings) return Container();
                      return Tooltip(
                        message: VarlaNavigation.Navigation.routes[index].name,
                        child: ListTile(
                          iconColor: Colors.purple,
                          leading: Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child:
                                VarlaNavigation.Navigation.routes[index].icon,
                          ),
                          title: expanded
                              ? Text(
                                  VarlaNavigation.Navigation.routes[index].name)
                              : null,
                          onTap: () {
                            Navigator.pop(context);
                            widget.setRoute(
                                VarlaNavigation.Navigation.routes[index].path);
                          },
                        ),
                      );
                    },
                  )),
              const Padding(
                padding: EdgeInsets.only(left: 5),
              ),
              Tooltip(
                message: "Settings",
                child: ListTile(
                  iconColor: Colors.purple,
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 2.0),
                    child: Icon(Icons.settings),
                  ),
                  title: expanded ? const Text("Settings") : null,
                  onTap: () {
                    setState(() {
                      // expanded = !expanded;
                    });
                  },
                ),
              ),
            ])
        // ListView(
        //   padding: EdgeInsets.zero,
        //   children: [
        //     const DrawerHeader(
        //       decoration: BoxDecoration(
        //         color: Colors.purple,
        //       ),
        //       child: Text('Drawer Header'),
        //     ),
        //     ListTile(
        //       iconColor: Colors.purple,
        //       leading: const Icon(
        //         Icons.account_balance_wallet,
        //       ),
        //       title: const Text('Wallet'),
        //       onTap: () {},
        //     ),
        //     ListTile(
        //       iconColor: Colors.purple,
        //       leading: const Icon(Icons.precision_manufacturing_sharp),
        //       title: const Text('Services'),
        //       onTap: () {},
        //     ),
        //     ListTile(
        //       iconColor: Colors.purple,
        //       leading: const Icon(Icons.home),
        //       title: const Text('Home'),
        //       onTap: () {},
        //     ),
        //     ListTile(
        //       iconColor: Colors.purple,
        //       leading: const Icon(Icons.edit_notifications),
        //       title: const Text('Notification'),
        //       onTap: () {},
        //     ),
        //   ],
        // ),
        );
  }
}
