import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:layout/main/utils/Utils.dart';

import '../../main.dart';
import 'package:flutter/material.dart';

import '../utils/Transaction.dart';

late Future<List<Transaction>> transactions;

void needTransactions() {
  transactions = fetchTransactions();
}

Future<List<Transaction>> fetchTransactions() async {
  await loadingFuture;
  Response<List<dynamic>> response = await client.get('$DOMAIN_NAME/get-transactions?code=$password');
  if (response.statusCode == 200) {
    //List test = json.decode(response.data);

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
  }
  );
}