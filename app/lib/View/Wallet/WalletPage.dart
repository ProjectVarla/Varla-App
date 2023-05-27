import 'dart:math';

import 'package:flutter/material.dart';
import 'package:varla/Services/Wallet/WalletApi.dart';
import 'package:varla/Utility/Request/response.dart';
import 'package:varla/View/Wallet/WalletInvoices.dart';
import 'package:varla/View/Wallet/WalletSubscriptions.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

enum RecuringType { onDemand, daily, weekly, monthly, yearly }

var data = [
  {
    "name": "Varla Server",
    "start_date": "2023-05-10",
    "currency": "\$",
    "next_on": "2023-05-15",
    "total_paid": 220,
    "daily_deduction_amount": 0,
    "weekly_deduction_amount": 0,
    "monthly_deduction_amount": 20,
    "yearly_deduction_amount": 10,
    "id": 1
  },
  {
    "name": "Test Invoice",
    "start_date": "2023-05-10",
    "currency": "JOD",
    "next_on": "2023-06-12",
    "total_paid": 200,
    "daily_deduction_amount": 0,
    "weekly_deduction_amount": 0,
    "monthly_deduction_amount": 88,
    "yearly_deduction_amount": 0,
    "id": 2
  },
  {
    "name": "ondemand group",
    "start_date": "2023-05-13",
    "currency": null,
    "next_on": null,
    "total_paid": 0,
    "daily_deduction_amount": 0,
    "weekly_deduction_amount": 0,
    "monthly_deduction_amount": 0,
    "yearly_deduction_amount": 0,
    "id": 3
  }
];

var RecuringTypeString = {
  RecuringType.onDemand: "Once",
  RecuringType.daily: "Day",
  RecuringType.weekly: "Week",
  RecuringType.monthly: "Month",
  RecuringType.yearly: "Year"
};

class InvoiceGroup {
  final int id;
  final String name;
  final String startDate;
  final String? nextOn;
  final String? currency;
  final double totalPaid;
  final double dailyDeductionAmount;
  final double weeklyDeductionAmount;
  final double monthlyDeductionAmount;
  final double yearlyDeductionAmount;

  InvoiceGroup({
    required this.id,
    required this.name,
    required this.startDate,
    this.totalPaid = 0,
    this.currency = "JOD",
    this.nextOn,
    this.dailyDeductionAmount = 0,
    this.monthlyDeductionAmount = 0,
    this.weeklyDeductionAmount = 0,
    this.yearlyDeductionAmount = 0,
  });
}

// "name": "Varla Server",
// "next_on": "2023-05-15",
// "currency": "$",
// "total_paid": 220,
// "start_date": "2023-05-10",
// "daily_deduction_amount": 0,
// "weekly_deduction_amount": 0,
// "monthly_deduction_amount": 20,
// "yearly_deduction_amount": 10,
// "id": 1

class _WalletPageState extends State<WalletPage> {
  // late List<dynamic> services;

  // Future<List<dynamic>> listServices() async {
  //   // services = .listServices();
  //   services = [
  //     InvoiceGroup(
  //       id: 1,
  //       name: "Varla Server",
  //       currency: "\$",
  //       startDate: "2021 Aug 22",
  //       nextOn: "2023 May 22",
  //       totalPaid: 150,
  //     ),
  //     InvoiceGroup(
  //       id: 2,
  //       name: "Spendings",
  //       currency: "\$",
  //       startDate: "2023 Aug 22",
  //       totalPaid: 150,
  //     ),
  //     InvoiceGroup(
  //       id: 3,
  //       name: "title",
  //       currency: "JOD",
  //       startDate: "2023 Aug 22",
  //       totalPaid: 150,
  //     )
  //   ];

  //   // print(data);

  // InvoiceGroup(
  //     id: e!.id!,
  //     name: e!.name!,
  //     startDate: e!.start_date,
  //     totalPaid: e!.total_paid));
  //   return services;
  // }

  late Future<VarlaResponse> services;
  // OrchestratorChannelStream channel = OrchestratorChannels.connection;

  Future<dynamic> listInvoiceGroups() async {
    services = WalletApi.listInvoiceGroups();

    return services;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: const NewWalletInvoiceGroupFAB(),
        body: FutureBuilder(
          future: listInvoiceGroups(), // async work
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
                                listInvoiceGroups();
                              });
                            });
                          },
                          child: FutureBuilder(
                            future: listInvoiceGroups(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return const Center(
                                      child: Text('Loading....'));
                                default:
                                  if (snapshot.hasError ||
                                      snapshot.data.error) {
                                    return Center(
                                      child: Text(
                                          'Error: ${snapshot.data.statusCode}\n${snapshot.data.serverDetails}'),
                                    );
                                  } else {
                                    var response = snapshot.data.body;
                                    return ListView.builder(
                                      itemCount:
                                          response["body"]["data"].length,
                                      itemBuilder: ((context, index) {
                                        var group =
                                            response["body"]["data"][index];

                                        InvoiceGroup invoiceGroup =
                                            InvoiceGroup(
                                                id: group["id"],
                                                name: group["name"],
                                                startDate: group["start_date"],
                                                totalPaid: group["total_paid"],
                                                currency: group["currency"],
                                                dailyDeductionAmount: group[
                                                    "daily_deduction_amount"],
                                                monthlyDeductionAmount: group[
                                                    "monthly_deduction_amount"],
                                                nextOn: group["next_on"],
                                                weeklyDeductionAmount: group[
                                                    "weekly_deduction_amount"],
                                                yearlyDeductionAmount: group[
                                                    "yearly_deduction_amount"]);
                                        return WalletInvoiceGroup(
                                          group: invoiceGroup,
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
        ));
  }
}

class WalletInvoiceGroup extends StatelessWidget {
  final InvoiceGroup group;
  late bool onDemand;
  List<Widget> l = [];

  WalletInvoiceGroup({super.key, required this.group}) {
    onDemand = group.nextOn == null ? true : false;
    print("******");
    print(group.nextOn);
    if (group.monthlyDeductionAmount != 0) {
      l.add(Text(
        "${group.monthlyDeductionAmount}${group.currency}/${RecuringTypeString[RecuringType.monthly]}",
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ));
    }

    if (group.yearlyDeductionAmount != 0) {
      l.add(Text(
        "${group.yearlyDeductionAmount}${group.currency}/${RecuringTypeString[RecuringType.yearly]}",
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ));
    }
  }
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
        childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
        collapsedIconColor: Colors.black,
        collapsedTextColor: Colors.black,
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: onDemand ? 20.0 : 0),
          child: Text(
            group.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        subtitle: onDemand
            ? null
            : Text(
                "Next On: ${group.nextOn}",
              ),
        trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: l),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFe5e5e5),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                const Text(
                  "Starting Date: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(group.startDate),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFe5e5e5),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                const Text(
                  "Total Paid: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "${group.totalPaid.toString()} ${group.currency}",
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return WalletInvoice(
                          groupName: group.name,
                          groupId: group.id,
                        );
                      }));
                    },
                    child: const Text("Invoices"),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return WalletSubscription(
                          groupName: group.name,
                          groupId: group.id,
                        );
                      }));
                    },
                    child: const Text("Subscriptions"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewWalletInvoiceGroupFAB extends StatelessWidget {
  const NewWalletInvoiceGroupFAB({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {},
        child: IconButton(
            onPressed: () {
              TextEditingController channelNameConrtoller =
                  TextEditingController();
              showModalBottomSheet(
                  elevation: 16,
                  shape: const RoundedRectangleBorder(
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
                              onPressed: () {},
                              child: const Icon(
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
                                    const InputDecoration(hintText: 'id'),
                                controller: channelNameConrtoller,
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              TextField(
                                decoration:
                                    const InputDecoration(hintText: 'Name'),
                                controller: channelNameConrtoller,
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              TextField(
                                decoration:
                                    const InputDecoration(hintText: 'type'),
                                controller: channelNameConrtoller,
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              TextField(
                                decoration:
                                    const InputDecoration(hintText: 'amount'),
                                controller: channelNameConrtoller,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.add)));
  }
}
