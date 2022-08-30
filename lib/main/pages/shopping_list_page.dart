import 'package:flutter/material.dart';
import 'package:layout/main/utils/ItemType.dart';

import '../handlers/ShoppingListHandler.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ShoppingListState();
}

class ShoppingListState extends State<ShoppingList> {
  @override
  void initState() {
    super.initState();
    needShoppingList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shopping List")),
      body: Center(
        child: Column(
          children: [
            getShoppingList(() {
              setState(() {});
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/shopping-item-editor').then((value) {
            setState(() {
              needShoppingList();
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
