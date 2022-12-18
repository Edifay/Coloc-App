import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:layout/main/handlers/TodoActionListHandler.dart';
import '../../container/TodoAction.dart';
import '../../container/builder/TodoActionBuilder.dart';
import '../../container/classification/Priority.dart';
import 'package:layout/main.dart';

class TodoActionEditor extends StatefulWidget {
  const TodoActionEditor({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TodoActionEditorState();
}

class TodoActionEditorState extends State<TodoActionEditor> {
  TodoActionBuilder? todoActionBuilder;
  bool sending = false;

  @override
  Widget build(BuildContext context) {
    if (todoActionBuilder == null && ModalRoute.of(context)!.settings.arguments != null) {
      todoActionBuilder = TodoActionBuilder.import(TodoAction.fromJson(json.decode(ModalRoute.of(context)!.settings.arguments.toString())));
    }
    todoActionBuilder ??= TodoActionBuilder();

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Todo Action")),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Center(
          child: Column(
            children: [
              const Text("Gérer une Action", textAlign: TextAlign.center, style: TextStyle(fontSize: 30)),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: TextFormField(
                        initialValue: todoActionBuilder!.name,
                        onChanged: (text) {
                          print(text);
                          todoActionBuilder?.name = text;
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: "Nom de l'action",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: TextFormField(
                  initialValue: todoActionBuilder!.description,
                  onChanged: (text) {
                    print(text);
                    todoActionBuilder?.description = text;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: DropdownButton(
                  value: getStringFromPriority(todoActionBuilder!.priority!),
                  items: const [
                    DropdownMenuItem(
                      value: "URGENT",
                      child: Text("Urgent"),
                    ),
                    DropdownMenuItem(value: "IMPORTANT", child: Text("Important")),
                    DropdownMenuItem(value: "A_FAIRE", child: Text("A faire")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      todoActionBuilder?.priority = getPriorityFromString(value.toString());
                    });
                  },
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: ElevatedButton(
                    onPressed: !sending ? () => closeAndSave() : null,
                    child: const Icon(
                      Icons.save,
                      size: 30,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void closeAndSave() {
    setState(() {
      sending = true;
    });
    client.post("$DOMAIN_NAME/add-action?code=$password", data: json.encode(todoActionBuilder?.build())).then(
      (value) {
        needTodoActionList();
        Navigator.pop(context);
      },
    );
  }
}
