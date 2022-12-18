import 'dart:convert';

import 'package:flutter/material.dart';

import '../handlers/ShoppingListHandler.dart';
import 'classification/ItemType.dart';

class ShoppingItem {
  String name;
  String description;
  num count;
  ItemType type;

  String? id;

  ShoppingItem.fromAll(this.name, this.description, this.count, this.type, this.id);

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem.fromAll(json["name"], json["description"], json["count"], getItemTypeFromString(json["type"]), json["id"]);
  }

  Map<String, dynamic> toJson() => {'name': name, 'description': description, 'count': count, 'type': getStringFromItemType(type), 'id': id};

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
          children: [
            Expanded(child: Text(name)),
            Text("x$count"),
            IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () => deleteItem(id!, setStates),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/shopping-item-editor', arguments: json.encode(this)).then((value) {
          setStates();
        });
      },
    );
  }
}
