import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:layout/main/handlers/ExpensesHandler.dart';
import 'package:layout/main/handlers/TransactionHandler.dart';
import 'package:layout/main.dart';
import 'package:layout/main/utils/Transaction.dart';

import '../utils/Utils.dart';
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
            const Padding(
              padding: EdgeInsets.fromLTRB(5, 30, 5, 15),
              child: Text(
                "Les transactions",
                style: TextStyle(fontSize: 22),
              ),
            ),
            getListTransaction(() {
              setState(() {});
            })
          ],
        ),
      ),
      floatingActionButton: ExpandableFab(
        distance: 105.0,
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
              needEquilibrate();
              showDialog<void>(
                context: context,
                builder: (context) =>
                    AlertDialog(
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
            icon: const Icon(Icons.query_stats),
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
              Navigator.pushNamed(context, '/settings').then((value) {
                if (!kIsWeb) {
                  saveSettings(CONFIG_FILE_NAME);
                }else{
                  saveWebSettings();
                }
                setState(() {
                  needTransactions();
                  needExpenses();
                });
              });
            },
            icon: const Icon(Icons.settings),
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
