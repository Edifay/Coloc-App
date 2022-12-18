import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../main.dart';
import 'package:flutter/material.dart';

import '../container/Transaction.dart';
import '../container/Utils.dart';

late Future<List<Transaction>> transactions;
late Future<List<String>> transactions_list;

void needTransactions() {
  transactions = fetchTransactions();
}

void needTransactionsListSave() {
  transactions_list = fetchSavedTransactions();
}

Future<List<Transaction>> fetchTransactions() async {
  await loadingFuture;
  Response<List<dynamic>> response;
  if (save == "current") {
    response = await client.get('$DOMAIN_NAME/get-transactions?code=$password');
  } else {
    response = await client.get('$DOMAIN_NAME/get-transactions-saved?name=$save&code=$password');
  }
  if (response.statusCode == 200) {
    List<Transaction> finalList = response.data!.map((e) => Transaction.fromJson(e)).toList();

    return finalList;
  } else {
    throw Exception("Failed to load data !");
  }
}

Widget getListTransaction(Function setState) {
  return SimplifiedFuture<List<Transaction>>().build(transactions, (context, snapshot) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          return Padding(padding: const EdgeInsets.fromLTRB(8, 2, 8, 0), child: snapshot.data![index].buildCard(context, setState));
        },
      ),
    );
  });
}

Future<List<String>> fetchSavedTransactions() async {
  await loadingFuture;
  print('$DOMAIN_NAME/get-transactions-list?code=$password');
  Response<List<dynamic>> response = await client.get('$DOMAIN_NAME/get-transactions-list?code=$password');
  if (response.statusCode == 200) {
    List<String> finalList = response.data!.map((e) => e.toString()).toList();

    return finalList;
  } else {
    throw Exception("Failed to load data !");
  }
}

Widget getTransactionsListSaved() {
  return SimplifiedFuture<List<String>>().build(transactions_list, (context, snapshot) {
    List<DropdownMenuItem<String>> items = [];
    items.add(DropdownMenuItem(value: "current", child: Text("current", style: TextStyle(fontSize: 20))));

    for (int i = 0; i < snapshot.data!.length; i++) {
      items.add(DropdownMenuItem(value: snapshot.data![i], child: Text(snapshot.data![i], style: TextStyle(fontSize: 20))));
    }

    return StatefulBuilder(builder: (context, setState) {
      return DropdownButton(
        value: save,
        items: items,
        onChanged: (value) {
          setState(() {
            save = value.toString();
            if (!kIsWeb) {
              saveSettings(CONFIG_FILE_NAME);
            } else {
              saveWebSettings();
            }
          });
        },
      );
    });
  });
}

Future<void> createASave() async {
  await loadingFuture;
  print('$DOMAIN_NAME/save-transactions?code=$password');
  Response<bool> response = await client.post('$DOMAIN_NAME/save-transactions?code=$password');
  if (response.statusCode == 200) {
  } else {
    throw Exception("Failed to load data !");
  }
}
