import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:layout/main/handlers/ShoppingListHandler.dart';
import '../../../main.dart';
import '../../container/classification/ItemType.dart';
import '../../container/ShoppingItem.dart';
import '../../container/builder/ShoppingItemBuilder.dart';

class ShoppingItemEditor extends StatefulWidget {
  const ShoppingItemEditor({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ShoppingItemEditorState();
}

class ShoppingItemEditorState extends State<ShoppingItemEditor> {
  ShoppingItemBuilder? shoppingItemBuilder;
  bool sending = false;

  @override
  Widget build(BuildContext context) {
    if (shoppingItemBuilder == null && ModalRoute.of(context)!.settings.arguments != null) {
      shoppingItemBuilder = ShoppingItemBuilder.import(ShoppingItem.fromJson(json.decode(ModalRoute.of(context)!.settings.arguments.toString())));
    }
    shoppingItemBuilder ??= ShoppingItemBuilder();

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Item")),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Center(
          child: Column(
            children: [
              const Text("Gérer un produit", textAlign: TextAlign.center, style: TextStyle(fontSize: 30)),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: TextFormField(
                        initialValue: shoppingItemBuilder!.name,
                        onChanged: (text) {
                          print(text);
                          shoppingItemBuilder?.name = text;
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Nom du produit',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: CustomNumberPicker(
                      customMinusButton: const Icon(Icons.remove),
                      customAddButton: const Icon(Icons.add),
                      valueTextStyle: const TextStyle(fontSize: 22),
                      initialValue: shoppingItemBuilder?.count,
                      maxValue: 15,
                      minValue: 1,
                      step: 1,
                      onValue: (value) {
                        shoppingItemBuilder?.count = value;
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: TextFormField(
                  initialValue: shoppingItemBuilder!.description,
                  onChanged: (text) {
                    print(text);
                    shoppingItemBuilder?.description = text;
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
                  value: getStringFromItemType(shoppingItemBuilder!.type!),
                  items: const [
                    DropdownMenuItem(
                      value: "ALIMENTAIRE",
                      child: Icon(Icons.no_food_sharp),
                    ),
                    DropdownMenuItem(value: "MENAGE", child: Icon(Icons.wash_outlined)),
                    DropdownMenuItem(value: "AUTRES", child: Icon(Icons.auto_awesome)),
                  ],
                  onChanged: (value) {
                    setState(() {
                      shoppingItemBuilder?.type = getItemTypeFromString(value.toString());
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
    client.post("$DOMAIN_NAME/add-item?code=$password", data: json.encode(shoppingItemBuilder?.build())).then(
      (value) {
        needShoppingList();
        Navigator.pop(context);
      },
    );
  }
}
