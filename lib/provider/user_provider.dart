import 'package:flutter/material.dart';

import '../model/user_model.dart';
import '../services/data_service.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  List<User> get users => _users;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();

    DataService dataService = DataService();
    _users = await dataService.fetchUsers();

    _isLoading = false;
    notifyListeners();
  }

  List<User> searchUsers(String query) {
    if (query.isEmpty) {
      return _users;
    }
    return _users.where((user) {
      return user.firstName.toLowerCase().contains(query.toLowerCase()) || user.lastName.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
