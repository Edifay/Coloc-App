import 'package:flutter/material.dart';

import '../../main.dart';
import '../utils/Person.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 30, 8, 15),
              child: TextFormField(
                initialValue: DOMAIN_NAME,
                onChanged: (text) {
                  DOMAIN_NAME = text;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "DOMAIN_NAME",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 5, 8, 15),
              child: TextFormField(
                initialValue: password,
                onChanged: (text) {
                  password = text;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                ),
              ),
            ),
            DropdownButton(
              value: getStringFromPerson(you),
              items: const [
                DropdownMenuItem(
                    value: "ARNAUD",
                    child: Text(
                      "Arnaud",
                      style: TextStyle(fontSize: 20),
                    )),
                DropdownMenuItem(value: "DARIUS", child: Text("Darius", style: TextStyle(fontSize: 20))),
              ],
              onChanged: (value) {
                setState(() {
                  you = getPersonFromString(value.toString());
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
