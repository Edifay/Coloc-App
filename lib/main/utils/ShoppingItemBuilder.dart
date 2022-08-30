import 'package:layout/main/utils/ItemType.dart';

import 'ShoppingItem.dart';

class ShoppingItemBuilder {
  String? name;
  String? description;
  num? count;
  ItemType? type;

  String? id;

  ShoppingItemBuilder() {
    name = "";
    description = "";
    count = 1;
    type = ItemType.ALIMENTAIRE;
  }

  ShoppingItemBuilder.import(ShoppingItem item) {
    name = item.name;
    description = item.description;
    count = item.count;
    type = item.type;

    id = item.id;
  }

  ShoppingItem build() {
    return ShoppingItem.fromAll(name!, description!, count!, type!, id);
  }
}
