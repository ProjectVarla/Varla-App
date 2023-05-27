import 'dart:math';

import 'package:flutter/material.dart';
import 'package:varla/Services/Notification/NotificationService.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  static const String routeName = '/NotificationPage';

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: MyWidget(),
        appBar: AppBar(
          title: const Text("Notification Page"),
        ),
        body:
            //   FutureBuilder<String>(
            // future: _fetchNetworkCall, // async work
            // builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            //    switch (snapshot.connectionState) {
            //      case ConnectionState.waiting: return Text('Loading....');
            //      default:
            //        if (snapshot.hasError)
            //           return Text('Error: ${snapshot.error}');
            //        else
            //       return Text('Result: ${snapshot.data}');
            //     }
            //   },
            // )

            FutureBuilder(
                future: NotificationConnection.init(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text('Loading....');
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else
                      // return Text('Result: ${snapshot.data}');
                      {
                        return Column(
                          children: [
                            ListTile(
                              title: const Text("data"),
                              subtitle: Text(
                                  "Connection ID:\n${NotificationConnection.connection.id}"),
                            ),
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: () {
                                  return Future<void>(
                                    () {
                                      setState(() {});
                                    },
                                  );
                                },
                                child: FutureBuilder(
                                  future: NotificationConnection.getChannels(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return Text('Loading....');
                                      default:
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          return ListView.builder(
                                              itemCount: snapshot.data.length,
                                              itemBuilder: ((context, index) {
                                                return ListTile(
                                                  title: Text(snapshot
                                                      .data[index].name),
                                                  subtitle: Text(snapshot
                                                      .data[index].verbosity
                                                      .toString()),
                                                );
                                              }));
                                        }
                                    }
                                  },
                                ),
                              ),
                            ),
                            // Expanded(
                            //   child: RefreshIndicator(
                            //     onRefresh: () {
                            //       return Future<void>(
                            //         () {
                            //           setState(() {});
                            //         },
                            //       );
                            //     },
                            //     child: ListView.builder(
                            //       itemCount: NotificationChannels.channels.length,
                            //       itemBuilder: ((context, index) {
                            //         NotificationChannelStream channel =
                            //             NotificationChannels.channels.values.elementAt(index);

                            //         return Column(
                            //           children: [
                            //             ListTile(
                            //               title: Text(channel.channelName),
                            //               subtitle: Text(
                            //                   "Is Acknowledged: ${channel.isAcknowledged}\nIs Aborted: ${channel.aborted}"),
                            //               isThreeLine: true,
                            //               dense: false,
                            //               trailing: Text("Alive? ${channel.isAlive}"),
                            //             ),
                            //             // Row(
                            //             //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //             //   children: [
                            //             //     ElevatedButton(
                            //             //       onPressed: (() => setState(() => channel.close())),
                            //             //       child: const Text("Close"),
                            //             //     ),
                            //             //     ElevatedButton(
                            //             //       onPressed: (() =>
                            //             //           setState(() => channel.resume_reconnecting())),
                            //             //       child: const Text("Reconnect"),
                            //             //     ),
                            //             //     ElevatedButton(
                            //             //       onPressed: (() =>
                            //             //           setState(() => channel.abort_reconnecting())),
                            //             //       child: const Text("Abort"),
                            //             //     ),
                            //             //     ElevatedButton(
                            //             //       onPressed: (() => setState(
                            //             //           () => channel.send("Are you still there?"))),
                            //             //       child: const Text("Is Alive?"),
                            //             //     ),
                            //             //   ],
                            //             // ),
                            //           ],
                            //         );
                            //       }),
                            //     ),
                            //   ),
                            // ),
                            const Divider(),
                            const Center(
                                child: Padding(
                              padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
                              child: Text(
                                "This List shows only the Notification Channels connected to the foreground service.",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            )),
                          ],
                        );
                      }
                  }
                }));
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  // @override
  // void initState() {
  //   verbositySelection = Verbosity.NORMAL;

  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {},
        child: IconButton(
            onPressed: () {
              if (NotificationConnection.isConnected()) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("No Connection ID was found!"),
                ));
                return;
              }
              Verbosity verbositySelection = Verbosity.NORMAL;
              TextEditingController channelNameConrtoller =
                  TextEditingController();
              showModalBottomSheet(
                  elevation: 16,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25.0))),
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topRight,
                      children: [
                        Positioned(
                          top: -20,
                          right: 16,
                          child: Tooltip(
                            message: "Subscribe",
                            child: FloatingActionButton(
                              onPressed: () {
                                if (channelNameConrtoller.text == "") {
                                  return;
                                }
                                NotificationConnection.subscribe(
                                    channelNameConrtoller.text,
                                    verbositySelection);

                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_outward_rounded,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              right: 50,
                              left: 50,
                              top: 50,
                              bottom: max(
                                  MediaQuery.of(context).viewInsets.bottom + 20,
                                  50)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextField(
                                decoration:
                                    InputDecoration(hintText: 'Channel Name'),
                                controller: channelNameConrtoller,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              DropdownButtonFormField<Verbosity>(
                                value: verbositySelection,
                                isExpanded: true,
                                hint: Text("Verbosity"),
                                onChanged: (value) {
                                  setState(() {
                                    verbositySelection = value!;
                                  });
                                },
                                items: const [
                                  DropdownMenuItem(
                                    value: Verbosity.QUITE,
                                    child: Text("Quite"),
                                  ),
                                  DropdownMenuItem(
                                    value: Verbosity.NORMAL,
                                    child: Text("Normal"),
                                  ),
                                  DropdownMenuItem(
                                    value: Verbosity.VERBOSE,
                                    child: Text("Verbose"),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  });

              // NotificationConnection.subscribe(
              //     "FileManager", Verbosity.NORMAL);
            },
            icon: const Icon(Icons.add)));
  }
}
