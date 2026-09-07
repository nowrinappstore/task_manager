import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/task_manager/models/user_model.dart';

class AuthController {
  static String? userToken;
  static UserModel? userData;

  // ================= SAVE USER DATA =================

  static Future<void> saveUserData(UserModel model, String token) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    // Save token
    await sharedPreferences.setString('token', token);

    // Save user data
    await sharedPreferences.setString('user_data', jsonEncode(model.toJson()));

    // Update static variables
    userToken = token;
    userData = model;
  }

  static Future<void> updateUserData(UserModel model) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();



    // Save user data
    await sharedPreferences.setString('user_data', jsonEncode(model.toJson()));

    // Update static variables

    userData = model;
  }

  // ================= GET USER DATA =================

  static Future<void> getUserData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    // Get token
    final String? savedToken = sharedPreferences.getString('token');

    if (savedToken != null && savedToken.isNotEmpty) {
      userToken = savedToken;
    }

    // Get user data
    final String? savedUserData = sharedPreferences.getString('user_data');

    if (savedUserData != null && savedUserData.isNotEmpty) {
      try {
        userData = UserModel.fromJson(jsonDecode(savedUserData));
      } catch (e) {
        userData = null;
      }
    }
  }

  // ================= CHECK LOGIN =================

  static Future<bool> isUserLogin() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final String? token = sharedPreferences.getString('token');

    return token != null && token.isNotEmpty;
  }

  // ================= LOGOUT =================

  static Future<void> clearUserData(BuildContext context) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

 await sharedPreferences.clear();


  }



}
