import 'dart:convert';
import 'package:search_app/model/user_model.dart';
import 'package:flutter/services.dart';

class DataService {
  Future<List<User>> fetchUsers() async {
    final String response = await rootBundle.loadString('assets/json/user_list.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => User.fromJson(json)).toList();
  }
}
