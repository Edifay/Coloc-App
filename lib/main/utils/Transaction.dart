import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:layout/main.dart';

import 'Person.dart';

class Transaction {
  String object;
  Person actor;
  Person recipient;

  num amount;

  String? id;
  int? creationDate;

  Transaction(this.object, this.amount, this.actor, this.recipient, this.id);
  Transaction.withCreationDate(this.object, this.amount, this.actor, this.recipient, this.id, this.creationDate);

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction.withCreationDate(json["object"], json["amount"], getPersonFromString(json["actor"]), getPersonFromString(json["recipient"]), json["id"], json["creationDate"]);
  }

  Map<String, dynamic> toJson() =>{
    'object': object,
    'actor': getStringFromPerson(actor),
    'recipient': getStringFromPerson(recipient),
    'id': id,
    'amount': amount,
    'creationDate': creationDate
  };

  @override
  String toString() {
    return 'Transaction{object: $object, actor: $actor, recipient: $recipient, id: $id, amount: $amount}';
  }

  Widget buildCard(BuildContext context, Function setStates) {
    return InkWell(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: const Color.fromARGB(20, 20, 20, 10),
        ),
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Row(
          children: getTransactionComponentConfiguration(),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/transaction-manager', arguments: json.encode(this)).then((value) {
          setStates();
        });
      },
    );
  }

  List<Widget> getTransactionComponentConfiguration() {
    List<Widget> widgets = [];
    widgets.add(Text(getStringFromPerson(actor)));
    if (recipient != Person.EMPTY) {
      widgets.add(Expanded(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Text("Transfer"), Icon(Icons.arrow_forward_rounded)],
          ),
          Text("${getRelativeAmount()} €", style: TextStyle(color: Color(getAmountColor())))
        ],
      )));
      widgets.add(Text(getStringFromPerson(recipient)));
    } else {
      widgets.add(Expanded(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Text("Dépenses"), Icon(Icons.add_circle_outline)],
          ),
          Text("${getRelativeAmount()} €", style: TextStyle(color: Color(getAmountColor())))
        ],
      )));
    }
    return widgets;
  }

  int getAmountColor() {
    if (amount > 0 || (amount < 0 && recipient != Person.EMPTY && recipient == you)) {
      return Colors.green.value;
    } else {
      return Colors.red.value;
    }
  }

  num getRelativeAmount() {
    if (recipient != Person.EMPTY && recipient == you) {
      return -amount;
    } else {
      return amount;
    }
  }
}
