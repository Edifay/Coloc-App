import 'package:dio/dio.dart';
import 'package:layout/main/utils/Priority.dart';
import 'package:layout/main/utils/TodoAction.dart';
import 'package:layout/main/utils/Utils.dart';

import '../../main.dart';
import 'package:flutter/material.dart';

late Future<List<TodoAction>> todoActions;

void needTodoActionList() {
  todoActions = fetchTodoActions();
}

Future<List<TodoAction>> fetchTodoActions() async {
  await loadingFuture;
  Response<List<dynamic>> response = await client.get('$DOMAIN_NAME/get-todo-list?code=$password');
  if (response.statusCode == 200) {
    List<TodoAction> finalList = response.data!.map((e) => TodoAction.fromJson(e)).toList();

    return finalList;
  } else {
    throw Exception("Failed to load data !");
  }
}

Widget getActionList(Function setState) {
  return SimplifiedFuture<List<TodoAction>>().build(todoActions, (context, snapshot) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          return snapshot.data![index].name != "separator"
              ? Padding(padding: const EdgeInsets.fromLTRB(8, 2, 8, 0), child: snapshot.data![index].buildCard(context, setState))
              : Container(
                  height: 50,
                  child: Center(
                    child: Text(getStringFromPriority(snapshot.data![index].priority)),
                  ),
                );
        },
      ),
    );
  });
}

void deleteAction(String id, Function setState) async {
  Response<bool> response = await client.get('$DOMAIN_NAME/remove-action?action_id=$id&code=$password');
  setState();
  needTodoActionList();
}
