import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/user_model.dart';
import '../services/data_service.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  List<User> get users => _users;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();

    DataService dataService = DataService();
    _users = await dataService.fetchUsers();

    _isLoading = false;
    notifyListeners();
  }

  // List<User> searchUsers(String query) {
  //   if (query.isEmpty) {
  //     return _users;
  //   }
  //   return _users.where((user) {
  //     return user.firstName.toLowerCase().contains(query.toLowerCase()) || user.lastName.toLowerCase().contains(query.toLowerCase());
  //   }).toList();
  // }

  void searchUsers(String query) {
    _isSearching = query.isNotEmpty;
    notifyListeners();
  }

  List<User> getFilteredUsers(String query) {
    if (query.isEmpty) {
      return _users;
    }
    return _users.where((user) {
      return user.firstName.toLowerCase().contains(query.toLowerCase()) || user.lastName.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  static Future<void> openInBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(emailUri)) {
      try {
        await launchUrl(emailUri);
      } catch (e) {
        // Handle any exceptions that may occur
        print('Error launching email client: $e');
      }
    } else {
      // Notify the user or log the issue
      print('No email client available');
      // Optionally, display a Toast or Alert to the user
    }
  }

  void handleMenuOption(
    int value,
  ) {
    switch (value) {
      case 0:
        openInBrowser('https://girmantech.com');
        break;
      case 1:
        UserProvider.openInBrowser('https://www.linkedin.com/company/girmantech/');
        break;
      case 2:
        sendEmail('contact@girmantech.com');
        break;
    }
  }
}
