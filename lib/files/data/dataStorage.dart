import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bonap/files/drawerItems/ingredients.dart';
import 'package:bonap/files/drawerItems/meal.dart';
import 'package:bonap/files/drawerItems/shoppingList.dart';
import 'package:bonap/files/tools.dart';
import 'package:bonap/files/widgets/dayMenu.dart';
import 'package:bonap/files/widgets/theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

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
    // Locally
    final file = await _localFileIngredients;
    String json = jsonEncode(Ingredient.listIngredients);
    if (debug) print("SAVING INGR : " + json);
    file.writeAsString(json);
    await file.exists();
    // Firebase
    if (!LoginTools.guestMode) {
      
      StorageReference storageReference;
      String userID = LoginTools.uid;
      String users = "users";
      String filename = "ingredients";
      
      storageReference =
          FirebaseStorage.instance.ref().child("$users/$userID/$filename");

      
     storageReference.putFile(file);
      
    }

    return file.writeAsString(json);
  }


  static Future<File> saveVege() async {
    // Locally
    final file = await _localFileVege;
    String json = jsonEncode(LoginTools.vege);
    if (debug) print("VEGE MODE : " + json);
    file.writeAsString(json);
    await file.exists();
    // Firebase
    if (!LoginTools.guestMode) {
      StorageReference storageReference;
      String userID = LoginTools.uid;
      String users = "users";
      String filename = "vege";
      storageReference =
          FirebaseStorage.instance.ref().child("$users/$userID/$filename");
      storageReference.putFile(file);
    }
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
    // Locally
    final file = await _localFileTheme;
    String json = jsonEncode(LoginTools.darkMode);
    if (debug) print("DARK MODE : " + json);
    file.writeAsString(json);
    await file.exists();
    // Firebase
    if (!LoginTools.guestMode) {
      StorageReference storageReference;
      String userID = LoginTools.uid;
      String users = "users";
      String filename = "theme";
      storageReference =
          FirebaseStorage.instance.ref().child("$users/$userID/$filename");
      storageReference.putFile(file);
    }
    return file.writeAsString(json);
  }

  static Future<int> loadTheme() async {
    try {
      final file = await _localFileTheme;
      ThemeChanger _themeChanger = Provider.of<ThemeChanger>(Constant.context);
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
    // Locally
    final file = await _localFileRepas;
    
    String json = jsonEncode(Meal.listMeal);
    if (debug) print("SAVING REPAS : " + json);
    file.writeAsString(json);
    await file.exists();

    // Firebase
    if (!LoginTools.guestMode) {
      StorageReference storageReference;
      String userID = LoginTools.uid;
      String users = "users";
      String filename = "repas";
      storageReference =
          FirebaseStorage.instance.ref().child("$users/$userID/$filename");
      storageReference.putFile(file);
    }

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
    // Locally
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
    file_1.writeAsStringSync(json_1);
    file0.writeAsStringSync(json0);
    file1.writeAsStringSync(json1);
    file2.writeAsStringSync(json2);

    DataStorage.saveWeekNumber();

    
    await file_1.exists();
    await file0.exists();
    await file1.exists();
    await file2.exists();

    // Firebase
    if (!LoginTools.guestMode) {
      StorageReference storageReference;
      String userID = LoginTools.uid;
      String users = "users";
      String filename = "week_1";
      storageReference =
          FirebaseStorage.instance.ref().child("$users/$userID/$filename");
      storageReference.putFile(file_1);
      filename = "week0";
      storageReference =
          FirebaseStorage.instance.ref().child("$users/$userID/$filename");
      storageReference.putFile(file0);
      filename = "week1";
      storageReference =
          FirebaseStorage.instance.ref().child("$users/$userID/$filename");
      storageReference.putFile(file1);
      filename = "week2";
      storageReference =
          FirebaseStorage.instance.ref().child("$users/$userID/$filename");
      storageReference.putFile(file2);
    }

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
    // Locally
    final file = await _localFileShopping;
    String json = jsonEncode(ShoppingList.liste);
    if (debug) print("SAVING SHOPPING : " + json);
    file.writeAsString(json);
    await file.exists();

    // Firebase
    if (!LoginTools.guestMode) {
      StorageReference storageReference;
      String userID = LoginTools.uid;
      String users = "users";
      String filename = "shopping";
      storageReference =
          FirebaseStorage.instance.ref().child("$users/$userID/$filename");
      storageReference.putFile(file);
    }

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
    // Locally
    final file = await _localFileWeekNumber;
    String json = jsonEncode(Weeks.weekNumber);
    if (debug) print("SAVING WEEK NUMBER : " + json);
    file.writeAsString(json);
    await file.exists();
    // Firebase
    if (!LoginTools.guestMode) {
      StorageReference storageReference;
      String userID = LoginTools.uid;
      String users = "users";
      String filename = "week";
      storageReference =
          FirebaseStorage.instance.ref().child("$users/$userID/$filename");
      storageReference.putFile(file);
    }

    return file.writeAsString(json);
  }

  static Future<void> downloadFile() async {
    String userID = LoginTools.uid;
    String users = "users";
    String filename;
    String url;
    http.Response downloadData;
    List collection;

    try {
      // Liste Meals
      filename = "repas";
      url = await FirebaseStorage.instance
          .ref()
          .child("$users/$userID/$filename")
          .getDownloadURL();
      downloadData = await http.get(url);
      collection = json.decode(downloadData.body);
      Meal.listMeal = collection.map((json) => Meal.fromJson(json)).toList();
    } catch (exception) {
      print(exception);
    }

    try {
      // Liste Ingredients
      filename = "ingredients";
      url = await FirebaseStorage.instance
          .ref()
          .child("$users/$userID/$filename")
          .getDownloadURL();
      downloadData = await http.get(url);
      collection = json.decode(downloadData.body);
      Ingredient.listIngredients =
          collection.map((json) => Ingredient.fromJson(json)).toList();
    } catch (exception) {
      // print(exception);
    }

    // Theme
    try {
      ThemeChanger themeChanger = Provider.of<ThemeChanger>(Constant.context);
      filename = "theme";
      url = await FirebaseStorage.instance
          .ref()
          .child("$users/$userID/$filename")
          .getDownloadURL();
      downloadData = await http.get(url);
      LoginTools.darkMode = json.decode(downloadData.body);
      if (LoginTools.darkMode)
        themeChanger.setTheme(ThemeData.dark());
      else {
        themeChanger.setTheme(ThemeData.light());
      }
    } catch (exception) {
      // print(exception);
    }
    try {
      // Vege
      filename = "vege";
      url = await FirebaseStorage.instance
          .ref()
          .child("$users/$userID/$filename")
          .getDownloadURL();
      downloadData = await http.get(url);
      LoginTools.vege = json.decode(downloadData.body);
    } catch (exception) {
      // print(exception);
    }

    try {
      // Weeks
      // Read the file -1
      filename = "week_1";
      url = await FirebaseStorage.instance
          .ref()
          .child("$users/$userID/$filename")
          .getDownloadURL();
      downloadData = await http.get(url);
      collection = json.decode(downloadData.body);
      Weeks.week_1 = collection
          .map((json) => (json != null) ? Day.fromJson(json) : null)
          .toList();

      // Read the file 0
      filename = "week0";
      url = await FirebaseStorage.instance
          .ref()
          .child("$users/$userID/$filename")
          .getDownloadURL();
      downloadData = await http.get(url);
      collection = json.decode(downloadData.body);
      Weeks.week0 = collection
          .map((json) => (json != null) ? Day.fromJson(json) : null)
          .toList();

      // Read the file 1
      filename = "week1";
      url = await FirebaseStorage.instance
          .ref()
          .child("$users/$userID/$filename")
          .getDownloadURL();
      downloadData = await http.get(url);
      collection = json.decode(downloadData.body);
      Weeks.week1 = collection
          .map((json) => (json != null) ? Day.fromJson(json) : null)
          .toList();

      // Read the file 2
      filename = "week2";
      url = await FirebaseStorage.instance
          .ref()
          .child("$users/$userID/$filename")
          .getDownloadURL();
      downloadData = await http.get(url);
      collection = json.decode(downloadData.body);
      Weeks.week2 = collection
          .map((json) => (json != null) ? Day.fromJson(json) : null)
          .toList();
    } catch (exception) {
      // print(exception);
    }
    try {
      // WeekNumber
      filename = "week";
      url = await FirebaseStorage.instance
          .ref()
          .child("$users/$userID/$filename")
          .getDownloadURL();
      downloadData = await http.get(url);
      Weeks.weekNumber = json.decode(downloadData.body);
    } catch (exception) {
      // print(exception);
    }
    try {
      // Shopping
      filename = "shopping";
      collection = json.decode(downloadData.body);
      ShoppingList.liste = collection
          .map((json) => IngredientShoppingList.fromJson(json))
          .toList();
    } catch (exception) {
      // print(exception);
    }
  }
}
