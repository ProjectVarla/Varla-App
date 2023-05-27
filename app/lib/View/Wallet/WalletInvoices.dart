import 'dart:math';

import 'package:flutter/material.dart';
import 'package:varla/Services/Wallet/WalletApi.dart';
import 'package:varla/Utility/NotificationHelp.dart';
import 'package:varla/Utility/Request/response.dart';

List<String> MonthNameString = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

enum DeductionType { manually, automatically }

Map<DeductionType, String> DeductionTypeString = {
  DeductionType.manually: "Manually",
  DeductionType.automatically: "Automatically",
};

// "group_id": 2,
// "deduction_type": 1,
// "deduction_date": "2023-05-10",
// "amount": 200,
// "currency": "$",
// "description": "test test ",
// "id": 2

class InvoiceItem {
  final int id;
  final double amount;
  final String currency;
  final DeductionType deductionType;
  final DateTime deductionDate;
  final bool confirmed;
  final String? description;

  InvoiceItem(
      {required this.id,
      required this.amount,
      required this.currency,
      required this.deductionType,
      required this.deductionDate,
      required this.confirmed,
      this.description = ""});
}

class InvoiceMonth {
  List<InvoiceItem> invoices = [];
  String date;
  double total;
  int notConfirmedCount = 0;
  String? currency;

  InvoiceMonth({this.date = "", this.total = 0, this.currency = "JOD"});
}

class WalletInvoice extends StatefulWidget {
  final int groupId;
  final String groupName;

  const WalletInvoice(
      {required this.groupId, required this.groupName, super.key});

  @override
  State<WalletInvoice> createState() => _WalletInvoiceState();
}

class _WalletInvoiceState extends State<WalletInvoice> {
  late Future<VarlaResponse> services;
  // OrchestratorChannelStream channel = OrchestratorChannels.connection;

  Future<dynamic> listServices() async {
    services = WalletApi.listInvoiceItems(widget.groupId);

    return services;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: const NewInvoiceFAB(),
        appBar: AppBar(title: Text(widget.groupName)),
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
                                    List<dynamic> response =
                                        snapshot.data.body["body"]["data"]
                                            .map((e) => InvoiceItem(
                                                  id: e["id"],
                                                  amount: e["amount"],
                                                  deductionDate: DateTime(
                                                      2021, DateTime.july, 15),
                                                  currency: e["currency"],
                                                  deductionType: DeductionType
                                                      .automatically,
                                                  description: e["description"],
                                                  confirmed: e["confirmed"],
                                                ))
                                            .toList();

                                    List<InvoiceMonth> list = [];

                                    int prevMonth = -1;
                                    int prevYear = -1;

                                    for (InvoiceItem i in response) {
                                      if (i.deductionDate.month != prevMonth ||
                                          i.deductionDate.year != prevYear) {
                                        prevMonth = i.deductionDate.month;
                                        prevYear = i.deductionDate.year;

                                        list.add(InvoiceMonth(
                                            currency: i.currency,
                                            date:
                                                "${MonthNameString[prevMonth - 1]} ${prevYear}"));
                                      }

                                      list.last.invoices.add(i);
                                      if (i.confirmed) {
                                        list.last.total += i.amount;
                                      } else {
                                        list.last.notConfirmedCount++;
                                      }
                                    }
                                    return list.isEmpty
                                        ? Center(
                                            child: Text(
                                              "${widget.groupName} Invoice Group\n Has no Invoices!",
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        : ListView.builder(
                                            itemCount: list.length,
                                            itemBuilder: ((context, index) {
                                              return WalletInvoiceMonth(
                                                month: list[index],
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

class WalletInvoiceMonth extends StatelessWidget {
  final InvoiceMonth month;
  const WalletInvoiceMonth({
    required this.month,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        childrenPadding: const EdgeInsets.only(bottom: 10),
        initiallyExpanded: true,
        title: Text(month.date),
        trailing: Text(
            "${month.notConfirmedCount != 0 ? 'Not Confirmed: ${month.notConfirmedCount}    |    ' : ''} ${month.total.toStringAsFixed(2)} ${month.currency}"),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: month.invoices.length,
            itemBuilder: ((context, index) {
              return WalletInvoiceItem(
                invoice: month.invoices[index],
              );
            }),
          )
        ]);
  }
}

class WalletInvoiceItem extends StatelessWidget {
  final InvoiceItem invoice;

  const WalletInvoiceItem({
    required this.invoice,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> actionButtons = [];

    if (!invoice.confirmed) {
      actionButtons.add(
        ElevatedButton(
          style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              padding: MaterialStateProperty.resolveWith(
                  (states) => const EdgeInsets.all(0)),
              minimumSize: MaterialStateProperty.resolveWith(
                  (states) => const Size(40, 40)),
              iconSize: MaterialStateProperty.resolveWith((states) => 20),
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.green)),
          onPressed: () {},
          child: const Icon(Icons.check),
        ),
      );
    }

    actionButtons.add(OutlinedButton(
      style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          padding: MaterialStateProperty.resolveWith(
              (states) => const EdgeInsets.all(0)),
          minimumSize:
              MaterialStateProperty.resolveWith((states) => const Size(40, 40)),
          iconSize: MaterialStateProperty.resolveWith((states) => 20)),
      onPressed: () {},
      child: const Icon(
        Icons.edit,
      ),
    ));

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
        title: Text("${invoice.amount.toStringAsFixed(2)} ${invoice.currency}"),
        subtitle: Text(DeductionTypeString[invoice.deductionType].toString()),
        trailing: SizedBox(
            width: 80,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actionButtons,
            )),
        childrenPadding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 5),
        children: [
          Text(invoice.description ?? "No Description"),
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
                Text(invoice.deductionDate.toLocal().toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewInvoiceFAB extends StatelessWidget {
  const NewInvoiceFAB({
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
                                decoration: const InputDecoration(
                                    hintText: 'Channel Name'),
                                controller: channelNameConrtoller,
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                    hintText: 'Channel Name'),
                                controller: channelNameConrtoller,
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                    hintText: 'Channel Name'),
                                controller: channelNameConrtoller,
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                    hintText: 'Channel Name'),
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