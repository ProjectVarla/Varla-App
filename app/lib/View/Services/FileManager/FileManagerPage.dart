import 'package:flutter/material.dart';
import 'package:varla/Services/FileManager/fileManagerApi.dart';
import 'package:varla/Utility/Request/request.dart';

class FileManagerPage extends StatefulWidget {
  const FileManagerPage({super.key});
  static const String routeName = '/FileManagerPage';

  @override
  State<FileManagerPage> createState() => _FileManagerPageState();
}

class _FileManagerPageState extends State<FileManagerPage> {
  late Future<dynamic> services;

  Future<dynamic> listServices() async {
    services = FileManagerApi.list();
    print(services);
    return services;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: const Text("FileManager Page"),
      //   actions: [
      //     IconButton(
      //       onPressed: () async {
      //         ScaffoldMessenger.of(context).showSnackBar(
      //           SnackBar(
      //             content:
      //                 Text((await FileManagerApi.backupAll()).serverMessage),
      //           ),
      //         );
      //       },
      //       icon: const Icon(Icons.backup_sharp),
      //       tooltip: "Backup all",
      //     )
      //   ],
      // ),
      body: FutureBuilder(
        future: listServices(), // async work
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: Text('Loading....'));
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
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
                                if (snapshot.hasError || snapshot.data.error) {
                                  return Center(
                                    child: Text(
                                        'Error: ${snapshot.data.statusCode}\n${snapshot.data.serverDetails}'),
                                  );
                                } else {
                                  return ListView.builder(
                                    itemCount:
                                        snapshot.data.serverMessage.length,
                                    itemBuilder: ((context, index) {
                                      return Container(
                                        margin: const EdgeInsets.only(
                                            left: 20, right: 20, top: 10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFf6f6f6),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: ListTile(
                                          title: Text(snapshot
                                              .data.serverMessage[index]),
                                          trailing: IconButton(
                                            onPressed: () async {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      (await FileManagerApi
                                                              .backup(snapshot
                                                                      .data
                                                                      .serverMessage[
                                                                  index]))
                                                          .serverDetails),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.backup_sharp,
                                              // color: Color.fromRGBO(
                                              //     255, 255, 255, 1),
                                            ),
                                            tooltip: "Backup",
                                          ),
                                        ),
                                      );
                                    }),
                                  );
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
      ),
    );
  }
}
