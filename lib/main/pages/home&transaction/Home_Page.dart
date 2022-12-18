import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:layout/main/handlers/ExpensesHandler.dart';
import '../../../main.dart';
import '../../container/Transaction.dart';
import '../../container/Utils.dart';
import '../../handlers/TransactionHandler.dart';
import 'components/ExpandableFloatingButton.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    needTransactions();
    needExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion du pot commun"),
        actions: [
          IconButton(
              onPressed: () {
                needEquilibrate();
                showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Equilibrage'),
                    content: SimplifiedFuture<Transaction>().build(equilibrateTransaction, (context, snapshot) {
                      return Container(
                        height: 70,
                        child: snapshot.data!.buildCard(context, () {}),
                      );
                    }),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Ok'),
                      ),
                    ],
                  ),
                ).then((value) {
                  setState(() {
                    needTransactions();
                    needExpenses();
                  });
                });
              },
              icon: Icon(Icons.query_stats)),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings').then((value) {
                  if (!kIsWeb) {
                    saveSettings(CONFIG_FILE_NAME);
                  } else {
                    saveWebSettings();
                  }
                  setState(() {
                    needTransactions();
                    needExpenses();
                  });
                });
              },
              icon: Icon(Icons.settings)),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
                padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                child: Text(
                  "Les dépenses",
                  style: TextStyle(fontSize: 30),
                )),
            getAmountTotalWidget(),
            Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    const Text(
                      "Arnaud",
                      style: TextStyle(fontSize: 18),
                    ),
                    SimplifiedFuture<num>().build(
                      expensesArnaud,
                      (context, snapshot) {
                        return Text(
                          "${snapshot.data}€",
                          style: const TextStyle(fontSize: 18),
                        );
                      },
                    )
                  ],
                )),
                Expanded(
                    child: Column(
                  children: [
                    const Text(
                      "Darius",
                      style: TextStyle(fontSize: 18),
                    ),
                    SimplifiedFuture<num>().build(
                      expensesDarius,
                      (context, snapshot) {
                        return Text(
                          "${snapshot.data}€",
                          style: const TextStyle(fontSize: 18),
                        );
                      },
                    )
                  ],
                ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 30, 5, 0),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                const Text(
                  "Les transactions",
                  style: TextStyle(fontSize: 22),
                ),
                IconButton(
                    onPressed: () async {
                      needTransactionsListSave();
                      await showDialog(
                          context: context,
                          builder: (context) => StatefulBuilder(
                              builder: (context, setState) => AlertDialog(
                                    title: const Text("Paramètres des transactions"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          children: [const Text("Voici les transactions disponibles :"), getTransactionsListSaved()],
                                        ),
                                        Container(
                                          height: 20,
                                        ),
                                        Column(
                                          children: [
                                            const Text("Créer une sauvegarde ? "),
                                            Container(
                                              height: 20,
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                            title: const Text("Créer une save."),
                                                            content: const Text(
                                                                "Cette action est irréversible et ne peut être effectuée qu'une seule fois par jour.\n\nVous ne pourrez plus modifier les transactions de cette save."),
                                                            actions: [
                                                              ElevatedButton(
                                                                  onPressed: () {
                                                                    setState(() {
                                                                      needTransactionsListSave();
                                                                    });
                                                                    createASave();
                                                                    Navigator.pop(context);
                                                                    setState(() {
                                                                      needTransactionsListSave();
                                                                    });
                                                                  },
                                                                  child: const Text("Créer"))
                                                            ],
                                                          ));
                                                },
                                                child: const Text("Créer"))
                                          ],
                                        )
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Close"))
                                    ],
                                  )));
                      setState(() {
                        needTransactions();
                        needExpenses();
                      });
                    },
                    icon: const Icon(Icons.settings))
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: (() {
                if (save != "current") return Text(save);
              }()),
            ),
            getListTransaction(() {
              setState(() {});
            })
          ],
        ),
      ),
      floatingActionButton: ExpandableFab(
        distance: 80.0,
        children: [
          ActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/transaction-manager').then((value) {
                setState(() {});
              });
            },
            icon: const Icon(Icons.add),
          ),
          ActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/shopping-list').then((value) {
                setState(() {
                  needTransactions();
                  needExpenses();
                });
              });
            },
            icon: const Icon(Icons.list_alt),
          ),
          ActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/todo-action-list').then((value) {
                setState(() {
                  needTransactions();
                  needExpenses();
                });
              });
            },
            icon: const Icon(Icons.today_outlined),
          ),
        ],
      ),
    );
  }
}

Widget getAmountTotalWidget() {
  return SimplifiedFuture<num>().build(expensesArnaud, (contextArnaud, snapshotArnaud) {
    return SimplifiedFuture<num>().build(expensesDarius, (contextDarius, snapshotDarius) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 20),
          child: Text('${-(snapshotDarius.data! + snapshotArnaud.data!)}€', style: const TextStyle(fontSize: 30), textAlign: TextAlign.center));
    });
  });
}
