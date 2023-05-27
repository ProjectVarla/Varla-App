import 'dart:math';

import 'package:flutter/material.dart';
import 'package:varla/Services/Orchestrator/Orchestrator.dart';
import 'package:varla/Services/Orchestrator/OrchestratorService.dart';
import 'package:varla/Utility/Drawer/DrawerNavigation.dart';

class OrchestratorPage extends StatefulWidget {
  const OrchestratorPage({super.key});
  static const String routeName = '/OrchestratorPage';

  @override
  State<OrchestratorPage> createState() => _OrchestratorPageState();
}

class _OrchestratorPageState extends State<OrchestratorPage> {
  late Future<List<dynamic>> services;
  // OrchestratorChannelStream channel = OrchestratorChannels.connection;

  Future<List<dynamic>> listServices() async {
    services = OrchestratorService.listServices();
    return services;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: listServices(), // async work
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: Text('Loading....'));
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else {
              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () {
                        return Future<void>(() async {
                          setState(() {
                            listServices();
                          });
                        });
                      },
                      child: FutureBuilder(
                        future: listServices(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return const Center(child: Text('Loading....'));
                            default:
                              if (snapshot.hasError)
                                return Text('Error: ${snapshot.error}');
                              else {
                                return ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: ((context, index) => Column(
                                          children: [
                                            OrchestratorServiceTile(
                                                service: OrchestartorEntry(
                                                    name:
                                                        snapshot.data[index])),
                                          ],
                                        )));
                              }
                          }
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
        }
      },
    );
  }
}

class OrchestratorServiceTile extends StatefulWidget {
  final OrchestartorEntry service;
  const OrchestratorServiceTile({required this.service, super.key});

  @override
  State<OrchestratorServiceTile> createState() =>
      _OrchestratorServiceTileState();
}

class _OrchestratorServiceTileState extends State<OrchestratorServiceTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFf6f6f6),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
      ),
      child: ExpansionTile(
        // collapsedIconColor: Colors.black,
        // collapsedTextColor: Colors.black,
        // textColor: Color.fromARGB(255, 0, 0, 0),
        title: Text(
          widget.service.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: SizedBox(
          width: 55,
          height: 20,
          child: Row(
            children: [
              Text(
                "● ",
                style: TextStyle(
                    color: widget.service.status
                        ? const Color.fromRGBO(0, 255, 0, 1)
                        : const Color.fromRGBO(255, 0, 0, 1)),
              ),
              Text(
                widget.service.status ? "Online" : "Offline",
              ),
            ],
          ),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  tooltip: "Start",
                  icon: const Icon(Icons.rocket_launch),
                  onPressed: () {
                    widget.service.start().then((value) {
                      setState(() {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(value[0]),
                        ));
                        widget.service.status = true;
                      });
                    });
                  }),
              IconButton(
                tooltip: "Restart",
                icon: const Icon(Icons.restart_alt),
                onPressed: () {
                  setState(() {
                    widget.service.status = false;
                  });
                  widget.service.restart().then(
                        (value) => setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(value[0]),
                          ));
                          widget.service.status = true;
                        }),
                      );
                },
              ),
              IconButton(
                tooltip: "Stop",
                icon: const Icon(Icons.stop_circle_rounded),
                onPressed: () => {
                  widget.service.stop().then(
                        (value) => setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(value[0]),
                          ));
                          widget.service.status = false;
                        }),
                      )
                },
              ),
            ],
          )
        ],
      ),
    );
    ;
  }
}
