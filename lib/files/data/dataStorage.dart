import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bonap/files/drawerItems/ingredients.dart';
import 'package:bonap/files/drawerItems/meal.dart';
import 'package:bonap/files/drawerItems/shoppingList.dart';
import 'package:bonap/files/tools.dart';
import 'package:bonap/files/widgets/dayMenu.dart';
import 'package:bonap/files/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class DataStorage {
  static bool debug = false;

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFileIngredients async {
    final path = await _localPath;
    return File('$path/ingredients.json');
  }

  static Future<File> get _localFileRepas async {
    final path = await _localPath;
    return File('$path/repas.json');
  }

// Weeks
  static Future<File> get _localFileWeek_1 async {
    final path = await _localPath;
    return File('$path/week_1.json');
  }

  static Future<File> get _localFileWeek0 async {
    final path = await _localPath;
    return File('$path/week0.json');
  }

  static Future<File> get _localFileWeek1 async {
    final path = await _localPath;
    return File('$path/week1.json');
  }

  static Future<File> get _localFileWeek2 async {
    final path = await _localPath;
    return File('$path/week2.json');
  }

  static Future<File> get _localFileWeekNumber async {
    final path = await _localPath;
    return File('$path/weekNumber.json');
  }

  static Future<File> get _localFileShopping async {
    final path = await _localPath;
    return File('$path/shopping.json');
  }

  static Future<File> get _localFileTheme async {
    final path = await _localPath;
    return File('$path/theme.json');
  }

  static Future<File> get _localFileVege async {
    final path = await _localPath;
    return File('$path/vege.json');
  }

  // Ingredients

  static Future<int> loadIngredients() async {
    // Load from the device
    try {
      final file = await _localFileIngredients;

      // Read the file
      String content = await file.readAsString();
      List collection = json.decode(content);
      Ingredient.listIngredients =
          collection.map((json) => Ingredient.fromJson(json)).toList();
      if (debug) print("LOADING INGR : " + collection.toString());

      return 1;
    } catch (e) {
      // If there is an error

      return 0;
    }
  }

  static Future<File> saveIngredients() async {
    // Save to the device
    final file = await _localFileIngredients;
    String json = jsonEncode(Ingredient.listIngredients);
    if (debug) print("SAVING INGR : " + json);

    return file.writeAsString(json);
  }

  static Future<File> saveVege() async {
    // Save to the device
    final file = await _localFileVege;
    String json = jsonEncode(LoginTools.vege);
    if (debug) print("VEGE MODE : " + json);
    return file.writeAsString(json);
  }

  static Future<int> loadVege() async {
    try {
      final file = await _localFileVege;
      // Read the file
      String content = await file.readAsString();
      LoginTools.vege = json.decode(content);
      if (debug) print("VEGE MODE : " + LoginTools.vege.toString());

      return 1;
    } catch (e) {
      // If there is an error
      if (debug) print(e.toString());
      print("oupsi");
      return 0;
    }
  }

  static Future<File> saveTheme() async {
    // Save to the device
    final file = await _localFileTheme;
    String json = jsonEncode(LoginTools.darkMode);
    if (debug) print("DARK MODE : " + json);
    return file.writeAsString(json);
  }

  static Future<int> loadTheme(BuildContext newContext) async {
    try {
      final file = await _localFileTheme;
      ThemeChanger _themeChanger = Provider.of<ThemeChanger>(newContext);
      // Read the file
      String content = await file.readAsString();
      LoginTools.darkMode = json.decode(content);
      
      if (LoginTools.darkMode)
        _themeChanger.setTheme(ThemeData.dark());  
      else {
        _themeChanger.setTheme(ThemeData.light());  
      }
      if (debug) print("DARK MODE : " + LoginTools.darkMode.toString());

      return 1;
    } catch (e) {
      // If there is an error
      if (debug) print(e.toString());
      return 0;
    }
  }

  // Meals

  static Future<int> loadRepas() async {
    try {
      final file = await _localFileRepas;

      // Read the file
      String content = await file.readAsString();
      List collection = json.decode(content);
      Meal.listMeal = collection.map((json) => Meal.fromJson(json)).toList();
      if (debug) print("LOADING REPAS : " + collection.toString());

      return 1;
    } catch (e) {
      // If there is an error
      if (debug) print(e.toString());
      return 0;
    }
  }

  static Future<File> saveRepas() async {
    final file = await _localFileRepas;
    String json = jsonEncode(Meal.listMeal);
    if (debug) print("SAVING REPAS : " + json);

    return file.writeAsString(json);
  }

  // Weeks

  static Future<int> loadWeek() async {
    try {
      final file_1 = await _localFileWeek_1;
      final file0 = await _localFileWeek0;
      final file1 = await _localFileWeek1;
      final file2 = await _localFileWeek2;

      // Read the file -1
      String content = await file_1.readAsString();
      List collection = json.decode(content);
      Weeks.week_1 = collection
          .map((json) => (json != null) ? Day.fromJson(json) : null)
          .toList();
      if (debug) print("LOADING WEEK -1 : " + collection.toString());

      // Read the file 0
      content = await file0.readAsString();
      collection = json.decode(content);
      Weeks.week0 = collection
          .map((json) => (json != null) ? Day.fromJson(json) : null)
          .toList();
      if (debug) print("LOADING WEEK 0 : " + collection.toString());

      // Read the file 1
      content = await file1.readAsString();
      collection = json.decode(content);
      Weeks.week1 = collection
          .map((json) => (json != null) ? Day.fromJson(json) : null)
          .toList();
      if (debug) print("LOADING WEEK 1 : " + collection.toString());

      // Read the file 2
      content = await file2.readAsString();
      collection = json.decode(content);
      Weeks.week2 = collection
          .map((json) => (json != null) ? Day.fromJson(json) : null)
          .toList();
      if (debug) print("LOADING WEEK 2 : " + collection.toString());

      return 1;
    } catch (e) {
      // If there is an error
      if (debug) print(e.toString());
      return 0;
    }
  }

  static Future<File> saveWeek() async {
    final file_1 = await _localFileWeek_1;
    final file0 = await _localFileWeek0;
    final file1 = await _localFileWeek1;
    final file2 = await _localFileWeek2;

    String json_1 = jsonEncode(Weeks.week_1);
    if (debug) print("SAVING WEEK -1 : " + json_1);
    String json0 = jsonEncode(Weeks.week0);
    if (debug) print("SAVING WEEK 0 : " + json0);
    String json1 = jsonEncode(Weeks.week1);
    if (debug) print("SAVING WEEK 1 : " + json1);
    String json2 = jsonEncode(Weeks.week2);
    if (debug) print("SAVING WEEK 2 : " + json2);

    file0.writeAsStringSync(json0);
    file1.writeAsStringSync(json1);
    file2.writeAsStringSync(json2);

    DataStorage.saveWeekNumber();

    return file_1.writeAsString(json_1);
  }

  // Shopping List

  static Future<int> loadShopping() async {
    try {
      final file = await _localFileShopping;

      // Read the file
      String content = await file.readAsString();
      List collection = json.decode(content);
      ShoppingList.liste = collection
          .map((json) => IngredientShoppingList.fromJson(json))
          .toList();
      if (debug) print("LOADING SHOPPING : " + collection.toString());

      return 1;
    } catch (e) {
      // If there is an error
      if (debug) print(e.toString());
      return 0;
    }
  }

  static Future<File> saveShopping() async {
    final file = await _localFileShopping;
    String json = jsonEncode(ShoppingList.liste);
    if (debug) print("SAVING SHOPPING : " + json);
    return file.writeAsString(json);
  }

  // Week Number

  static Future<int> loadWeekNumber() async {
    try {
      final file = await _localFileWeekNumber;

      // Read the file
      String content = await file.readAsString();
      int collection = json.decode(content);
      Weeks.weekNumber = collection;

      if (debug) print("LOADING SHOPPING : " + collection.toString());

      return 1;
    } catch (e) {
      // If there is an error
      if (debug) print(e.toString());
      return 0;
    }
  }

  static Future<File> saveWeekNumber() async {
    final file = await _localFileWeekNumber;
    String json = jsonEncode(Weeks.weekNumber);
    if (debug) print("SAVING WEEK NUMBER : " + json);

    return file.writeAsString(json);
  }
}

/*
* pb ingredients
* pb de save ?
* sinon reste ok
* */
