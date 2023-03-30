import 'package:flutter/material.dart';
import 'package:varla/Services/Notification/NotificationChannelStream.dart';
import 'package:varla/Services/Notification/NotificationChannels.dart';

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
      appBar: AppBar(centerTitle: true, title: const Text("Notification Page")),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                return Future<void>(
                  () {
                    setState(() {});
                  },
                );
              },
              child: ListView.builder(
                itemCount: NotificationChannels.channels.length,
                itemBuilder: ((context, index) {
                  NotificationChannelStream channel =
                      NotificationChannels.channels.values.elementAt(index);

                  return Column(
                    children: [
                      ListTile(
                        title: Text(channel.channelName),
                        subtitle: Text(
                            "Is Acknowledged: ${channel.isAcknowledged}\nIs Aborted: ${channel.aborted}"),
                        isThreeLine: true,
                        dense: false,
                        trailing: Text("Alive? ${channel.isAlive}"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: (() => setState(() => channel.close())),
                            child: const Text("Close"),
                          ),
                          ElevatedButton(
                            onPressed: (() =>
                                setState(() => channel.resume_reconnecting())),
                            child: const Text("Reconnect"),
                          ),
                          ElevatedButton(
                            onPressed: (() =>
                                setState(() => channel.abort_reconnecting())),
                            child: const Text("Abort"),
                          ),
                          ElevatedButton(
                            onPressed: (() => setState(
                                () => channel.send("Are you still there?"))),
                            child: const Text("Is Alive?"),
                          ),
                        ],
                      ),
                      const Divider()
                    ],
                  );
                }),
              ),
            ),
          ),
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
      ),
    );
  }
}
