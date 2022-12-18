import 'dart:convert';

import 'package:flutter/material.dart';

import '../handlers/TodoActionListHandler.dart';
import 'classification/Priority.dart';

class TodoAction {
  String name;
  String description;

  Priority priority;

  String? id;

  TodoAction.fromAll(this.name, this.description, this.priority, this.id);

  factory TodoAction.fromJson(Map<String, dynamic> json) {
    return TodoAction.fromAll(json["name"], json["description"], getPriorityFromString(json["priority"]), json["id"]);
  }

  Map<String, dynamic> toJson() => {'name': name, 'description': description, 'priority': getStringFromPriority(priority), 'id': id};

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
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () => deleteAction(id!, setStates),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/todo-action-editor', arguments: json.encode(this)).then((value) {
          setStates();
        });
      },
    );
  }
}
