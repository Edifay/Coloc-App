import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:layout/main/app_definition.dart';

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main/container/classification/Person.dart';

const String CONFIG_FILE_NAME = "settings.txt";

String DOMAIN_NAME = "";

String password = "";

late Future<void> loadingFuture;

Person you = Person.ARNAUD;

String save = "current";

Dio client = Dio();

void main() {
  runApp(getAppDefinition());

  if (!kIsWeb) {
    loadingFuture = loadSettings();
  } else {
    loadingFuture = loadWebSettings();
  }
}

Future<void> loadWebSettings() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getString("DOMAIN_NAME") != null) {
    DOMAIN_NAME = prefs.getString("DOMAIN_NAME")!;
  } else {
    DOMAIN_NAME = "http://localhost:9999";
  }
  if (prefs.getString("password") != null) {
    password = prefs.getString("password")!;
  } else {
    password = "default";
  }
  if (prefs.getString("you") != null) {
    you = getPersonFromString(prefs.getString("you")!);
  } else {
    you = Person.ARNAUD;
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> _localFile(String fileName) async {
  final path = await _localPath;
  return File('$path/$fileName');
}

Future<void> saveWebSettings() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("DOMAIN_NAME", DOMAIN_NAME);
  await prefs.setString("password", password);
  await prefs.setString("you", getStringFromPerson(you));
}

Future<File> saveSettings(String fileName) async {
  print("Saving !");
  final file = await _localFile(fileName);
  print("${json.encode(SettingsToJSON())}");
  return file.writeAsString(json.encode(SettingsToJSON()));
}

Future<Map<String, dynamic>> readSettings(String fileName) async {
  try {
    final file = await _localFile(fileName);

    final contents = await file.readAsString();

    return json.decode(contents);
  } catch (e) {
    print("IMPOSSIBLE DE CHARGER LES FICHIERS : $e");
    return {"DOMAIN_NAME": "http://locahost:9999", "person": "ARNAUD", "password": "default", "save": "current"};
  }
}

Future<void> loadSettings() async {
  Map<String, dynamic> json = await readSettings(CONFIG_FILE_NAME);

  DOMAIN_NAME = json["DOMAIN_NAME"];
  you = getPersonFromString(json["person"]);
  password = json["password"];
  if (json["save"] == null) {
    save = "current";
  } else {
    save = json["save"];
  }
}

Map<String, dynamic> SettingsToJSON() {
  return {"DOMAIN_NAME": DOMAIN_NAME, "person": getStringFromPerson(you), "password": password, "save": save};
}
