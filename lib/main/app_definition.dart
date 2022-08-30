import 'package:flutter/material.dart';
import 'package:layout/main/pages/app_settings_page.dart';
import 'package:layout/main/pages/shopping_item_editor_page.dart';
import 'package:layout/main/pages/shopping_list_page.dart';
import 'package:layout/main/pages/todo_action_editor_page.dart';
import 'package:layout/main/pages/todo_action_list_page.dart';
import 'package:layout/main/pages/transaction_editor_page.dart';
import 'package:layout/main/pages/home_page.dart';

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
