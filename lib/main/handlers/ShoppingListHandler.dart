import 'package:dio/dio.dart';
import 'package:layout/main/utils/ItemType.dart';
import 'package:layout/main/utils/ShoppingItem.dart';
import 'package:layout/main/utils/Utils.dart';

import '../../main.dart';
import 'package:flutter/material.dart';

late Future<List<ShoppingItem>> shoppingItems;

void needShoppingList() {
  shoppingItems = fetchShoppingItems();
}

Future<List<ShoppingItem>> fetchShoppingItems() async {
  await loadingFuture;
  Response<List<dynamic>> response = await client.get('$DOMAIN_NAME/get-shopping-list?code=$password');
  if (response.statusCode == 200) {
    List<ShoppingItem> finalList = response.data!.map((e) => ShoppingItem.fromJson(e)).toList();

    return finalList;
  } else {
    throw Exception("Failed to load data !");
  }
}

Widget getShoppingList(Function setState) {
  return SimplifiedFuture<List<ShoppingItem>>().build(shoppingItems, (context, snapshot) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          return snapshot.data![index].name != "separator"
              ? Padding(padding: const EdgeInsets.fromLTRB(8, 2, 8, 0), child: snapshot.data![index].buildCard(context, setState))
              :  Container(
                  height: 50,
                  child: Center(
                    child: Text(getStringFromItemType(snapshot.data![index].type)),
                  ),
                );
        },
      ),
    );
  });
}

void deleteItem(String id, Function setState) async {
  Response<bool> response = await client.get('$DOMAIN_NAME/remove-item?item_id=$id&code=$password');
  setState();
  needShoppingList();
}
