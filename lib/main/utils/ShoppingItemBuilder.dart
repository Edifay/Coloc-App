import 'ShoppingItem.dart';

class ShoppingItemBuilder {
  String? name;
  String? description;
  num? count;

  String? id;

  ShoppingItemBuilder() {
    name = "";
    description = "";
    count = 1;
  }

  ShoppingItemBuilder.import(ShoppingItem item) {
    name = item.name;
    description = item.description;
    count = item.count;

    id = item.id;
  }

  ShoppingItem build() {
    return ShoppingItem.fromAll(name!, description!, count!, id);
  }
}
