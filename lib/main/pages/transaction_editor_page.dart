import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:layout/main/handlers/TransactionHandler.dart';
import 'package:layout/main/utils/Person.dart';
import 'package:layout/main/utils/Transaction.dart';
import 'package:layout/main/utils/TransactionBuilder.dart';

import '../handlers/ExpensesHandler.dart';
import '../../main.dart';

class TransactionEditor extends StatefulWidget {
  const TransactionEditor({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TransactionEditorState();
}

class TransactionEditorState extends State<TransactionEditor> {
  TransactionBuilder? transactionBuilder;
  bool editing = false;
  bool isPriceGood = true;
  bool sending = false;

  @override
  Widget build(BuildContext context) {
    if (transactionBuilder == null && ModalRoute.of(context)!.settings.arguments != null) {
      transactionBuilder = TransactionBuilder.import(Transaction.fromJson(json.decode(ModalRoute.of(context)!.settings.arguments.toString())));
      transactionBuilder?.recipient ??= Person.EMPTY;
      setState(() {
        editing = true;
      });
    } else if (transactionBuilder == null) {
      transactionBuilder = TransactionBuilder();
      transactionBuilder?.actor = you;
      transactionBuilder?.recipient = Person.EMPTY;
      transactionBuilder?.creationDate = DateTime.now().millisecondsSinceEpoch;
      setState(() {
        editing = false;
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Transaction Manager"), actions: [
        (sending || !editing)
            ? Container(
                height: 0,
              )
            : IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  bool? response = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Supprimer cette transaction ?'),
                      content: const Text('Attention cette action est irréverssible vous ne pourrez plus retrouver cette transaction !'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Supprimer'),
                        ),
                      ],
                    ),
                  );
                  if (response!) {
                    closeAndDelete();
                  }
                },
              ),
      ]),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text(
                "Gérer des transactions",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                initialValue: transactionBuilder!.object,
                onChanged: (text) {
                  print(text);
                  transactionBuilder?.object = text;
                },
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Objet de la transaction',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton(
                        value: getStringFromPerson(transactionBuilder!.actor!),
                        items: const [
                          DropdownMenuItem(
                              value: "ARNAUD",
                              child: Text(
                                "Arnaud",
                                style: TextStyle(fontSize: 20),
                              )),
                          DropdownMenuItem(value: "DARIUS", child: Text("Darius", style: TextStyle(fontSize: 20))),
                        ],
                        onChanged: (value) {
                          setState(() {
                            transactionBuilder?.actor = getPersonFromString(value.toString());
                            if (transactionBuilder?.recipient == transactionBuilder?.actor) {
                              transactionBuilder?.recipient = Person.EMPTY;
                            }
                          });
                        },
                      ),
                      const Icon(Icons.remove_circle_outline_outlined, size: 15),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    width: 80,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: "${-(transactionBuilder!.amount)!}",
                      onChanged: (text) {
                        print(text);
                        try {
                          var myInt = num.parse(text);
                          transactionBuilder?.amount = -myInt;
                          setState(() {
                            isPriceGood = true;
                          });
                        } catch (e) {
                          setState(() {
                            isPriceGood = false;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Prix',
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add_circle_outline,
                        size: 15,
                      ),
                      DropdownButton(
                        value: getStringFromPerson(transactionBuilder!.recipient!),
                        items: getRecipientItems,
                        onChanged: (value) {
                          setState(() {
                            transactionBuilder?.recipient = getPersonFromString(value.toString());
                          });
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_right_alt,
              size: 30,
            ),
            (!isPriceGood
                ? const Text(
                    "Le prix n'est pas valide !",
                    style: TextStyle(color: Colors.red),
                  )
                : Container(height: 0)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 70,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: (isPriceGood && !sending ? () => closeAndSave() : null),
                      child: const Icon(
                        Icons.save,
                        size: 30,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 10, 10),
                      child: Text("Fait le ${DateFormat("HH:mm dd/MM/yyyy").format(DateTime.fromMillisecondsSinceEpoch(getSafeCreationDate()))}"),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void closeAndDelete() {
    setState(() {
      sending = true;
    });
    client.get("$DOMAIN_NAME/delete-transaction?transaction_id=${transactionBuilder?.id}&code=$password").then((value) {
      needTransactions();
      needExpenses();
      Navigator.pop(context);
    });
  }

  void closeAndSave() {
    setState(() {
      sending = true;
    });
    if (editing) {
      client
          .post("$DOMAIN_NAME/edit-transaction?transaction_id=${transactionBuilder?.id}&code=$password",
              data: json.encode(transactionBuilder?.build()))
          .then(
        (value) {
          needTransactions();
          needExpenses();
          Navigator.pop(context);
        },
      );
    } else {
      client
          .post("$DOMAIN_NAME/create-transaction?code=$password",
              data: json.encode(transactionBuilder?.build()))
          .then(
        (value) {
          needTransactions();
          needExpenses();
          Navigator.pop(context);
        },
      );
    }
  }

  int getSafeCreationDate() {
    if (transactionBuilder!.creationDate == null) {
      return 0;
    } else {
      return transactionBuilder!.creationDate!;
    }
  }

  List<DropdownMenuItem<String>> get getRecipientItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "EMPTY", child: Text("Aucun", style: TextStyle(fontSize: 20))),
    ];

    if (transactionBuilder!.actor == Person.DARIUS) {
      menuItems.add(const DropdownMenuItem(value: "ARNAUD", child: Text("Arnaud", style: TextStyle(fontSize: 20))));
    } else if (transactionBuilder!.actor == Person.ARNAUD) {
      menuItems.add(const DropdownMenuItem(value: "DARIUS", child: Text("Darius", style: TextStyle(fontSize: 20))));
    }
    return menuItems;
  }
}
