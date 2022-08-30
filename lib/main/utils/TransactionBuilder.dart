import 'package:layout/main/utils/Transaction.dart';

import '../../main.dart';
import 'Person.dart';

class TransactionBuilder {
  String? object;
  Person? actor;
  Person? recipient;

  String? id;
  int? creationDate;

  num? amount;

  TransactionBuilder() {
    object = "";
    actor = you;
    recipient = Person.EMPTY;
    amount = 0;
  }


  TransactionBuilder.import(Transaction transaction) {
    object = transaction.object;
    actor = transaction.actor;
    amount = transaction.amount;
    recipient = transaction.recipient;
    id = transaction.id;
    creationDate = transaction.creationDate;
  }

  Transaction build() {
    return Transaction.withCreationDate(object!, amount!, actor!, recipient!, id, creationDate);
  }
}

TransactionBuilder transactionBuilderFrom(Transaction? transaction) {
  if (transaction != null) {
    return TransactionBuilder.import(transaction);
  } else {
    return TransactionBuilder();
  }
}
