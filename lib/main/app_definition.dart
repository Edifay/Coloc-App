import 'package:flutter/material.dart';
import 'package:layout/main/pages/settings/AppSettings_Page.dart';
import 'package:layout/main/pages/Shopping/ShoppingItemEditor_Page.dart';
import 'package:layout/main/pages/Shopping/ShoppingList_Page.dart';
import 'package:layout/main/pages/home&transaction/Home_Page.dart';
import 'package:layout/main/pages/home&transaction/TransactionEditor_Page.dart';
import 'package:layout/main/pages/todo/TodoActionEditor_Page.dart';
import 'package:layout/main/pages/todo/TodoActionList_Page.dart';

MaterialApp getAppDefinition() {
  return MaterialApp(title: 'Navigation Basics', initialRoute: '/', routes: {
    '/': (context) => const HomePage(),
    '/transaction-manager': (context) => const TransactionEditor(),
    '/settings': (context) => const Settings(),
    '/shopping-list': (context) => const ShoppingList(),
    '/shopping-item-editor': (context) => const ShoppingItemEditor(),
    '/todo-action-list': (context) => const TodoActionList(),
    '/todo-action-editor': (context) => const TodoActionEditor(),
  });
}
