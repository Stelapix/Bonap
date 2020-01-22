import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import '../ingredients.dart';
import '../repas.dart';

class DataStorage {
  DataStorage();
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

  // static Future<File> get _localFileWeek async {
  //   final path = await _localPath;
  //   return File('$path/week.json');
  // }

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

}


/*
* pb ingredients
* pb de save ?
* sinon reste ok
* */
