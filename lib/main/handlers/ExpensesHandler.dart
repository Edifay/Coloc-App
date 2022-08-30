import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../main.dart';

import '../utils/Person.dart';
import '../utils/Transaction.dart';

late Future<num> expensesArnaud;
late Future<num> expensesDarius;

late Future<Transaction> equilibrateTransaction;

void needEquilibrate() {
  equilibrateTransaction = fetchEquilibrateTransaction();
}

void needExpenses() {
  expensesArnaud = fetchExpenses(Person.ARNAUD);
  expensesDarius = fetchExpenses(Person.DARIUS);
}

Future<num> fetchExpenses(Person person) async {
  await loadingFuture;
  Response<num> response = await client.get('$DOMAIN_NAME/get-expenses?person=${getStringFromPerson(person)}&code=$password');
  if (response.statusCode == 200) {
    //num test = json.decode(response.data);
    print("Loaded expenses for : ${getStringFromPerson(person)} -> ${response.data!} €");
    return response.data!;
  } else {
    throw Exception("Failed to load data !");
  }
}

Future<Transaction> fetchEquilibrateTransaction() async {
  await loadingFuture;
  Response<Map<String, dynamic>> response = await client.get("$DOMAIN_NAME/get-equilibrate-transaction?code=$password");
  if (response.statusCode == 200) {
    return Transaction.fromJson(response.data!);
  } else {
    throw Exception("Failed to load data !");
  }
}
