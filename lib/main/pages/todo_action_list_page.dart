import 'package:flutter/material.dart';
import 'package:layout/main/handlers/TodoActionListHandler.dart';

import '../handlers/ShoppingListHandler.dart';

class TodoActionList extends StatefulWidget {
  const TodoActionList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TodoActionListState();
}

class TodoActionListState extends State<TodoActionList> {
  @override
  void initState() {
    super.initState();
    needTodoActionList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todo List")),
      body: Center(
        child: Column(
          children: [
            getActionList(() {
              setState(() {});
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/todo-action-editor').then((value) {
            setState(() {
              needTodoActionList();
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
